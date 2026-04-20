-- =========================================================
-- CREATE TABLE: comentarios para blog posts
-- Pegar en: Supabase > SQL Editor > New query > Run
-- =========================================================

CREATE TABLE IF NOT EXISTS comentarios (
  id         uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  post_id    uuid NOT NULL,
  nombre     text NOT NULL,
  mensaje    text NOT NULL,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE comentarios ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Lectura pública comentarios"
  ON comentarios FOR SELECT USING (true);

CREATE POLICY "Inserción pública comentarios"
  ON comentarios FOR INSERT WITH CHECK (true);

CREATE POLICY "Eliminación pública comentarios"
  ON comentarios FOR DELETE USING (true);
