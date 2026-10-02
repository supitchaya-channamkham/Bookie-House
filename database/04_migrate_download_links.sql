-- ====================================================================
-- Bookie House - Migration Script for download_links
-- File: database/04_migrate_download_links.sql
-- Description: Creates or updates the download_links table to the correct
--              schema, sets up RLS permissions & Realtime publication,
--              and automatically backfills seed download links for all
--              confirmed orders in the database.
-- ====================================================================

-- 1. Re-create download_links with the correct schema
DROP TABLE IF EXISTS download_links CASCADE;

CREATE TABLE download_links (
    link_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL,
    ebook_id INT NOT NULL,
    user_id INT NOT NULL,
    download_url TEXT NOT NULL,
    download_token VARCHAR(100) NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_download_links_order FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    CONSTRAINT fk_download_links_ebook FOREIGN KEY (ebook_id) REFERENCES ebooks(ebook_id) ON DELETE RESTRICT,
    CONSTRAINT fk_download_links_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- 2. Configure permissions & Realtime
ALTER TABLE download_links DISABLE ROW LEVEL SECURITY;
GRANT ALL ON TABLE download_links TO anon, authenticated, service_role;
GRANT ALL ON SEQUENCE download_links_link_id_seq TO anon, authenticated, service_role;

DO $$
BEGIN
    BEGIN
        ALTER PUBLICATION supabase_realtime ADD TABLE download_links;
    EXCEPTION WHEN duplicate_object THEN
        NULL;
    END;
END $$;

-- 3. Automatically backfill download links for all existing confirmed orders
INSERT INTO download_links (order_id, ebook_id, user_id, download_url, download_token, is_active)
SELECT 
    oi.order_id,
    oi.ebook_id,
    o.user_id,
    COALESCE(e.file_download_url, 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf') AS download_url,
    'tok_dl_' || oi.order_id || '_' || oi.ebook_id || '_' || SUBSTRING(MD5(RANDOM()::TEXT), 1, 8) AS download_token,
    TRUE AS is_active
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
LEFT JOIN ebooks e ON oi.ebook_id = e.ebook_id
WHERE o.order_status = 'confirmed'
ON CONFLICT DO NOTHING;

-- 4. Re-sync sequence
SELECT setval('download_links_link_id_seq', (SELECT COALESCE(MAX(link_id), 1) FROM download_links));

-- Verification query
SELECT COUNT(*) AS total_generated_download_links FROM download_links;
