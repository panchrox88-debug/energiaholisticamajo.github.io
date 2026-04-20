-- ── TABLA PROMOCIONES ───────────────────────────────────────────────────────
-- Ejecutar en Supabase SQL Editor

CREATE TABLE IF NOT EXISTS promociones (
  id               uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  titulo           text NOT NULL,
  descripcion      text,
  imagen           text,
  color_tema       text DEFAULT '#c9858a',
  items            jsonb DEFAULT '[]'::jsonb,
  precio_referencial integer,
  precio_combo     integer,
  link_pago        text,
  activo           boolean DEFAULT true,
  orden            integer DEFAULT 0,
  created_at       timestamptz DEFAULT now()
);

-- Comentarios de columnas
COMMENT ON COLUMN promociones.items IS
  'Array de {tipo: "servicio"|"curso", id: uuid, nombre: string, emoji: string, precio_ref: integer}';
COMMENT ON COLUMN promociones.precio_referencial IS
  'Precio tachado (suma de items o valor manual)';
COMMENT ON COLUMN promociones.precio_combo IS
  'Precio real del combo';
COMMENT ON COLUMN promociones.link_pago IS
  'URL de pago (opcional, para uso futuro)';

-- Índice por orden y activo
CREATE INDEX IF NOT EXISTS promociones_orden_idx ON promociones (orden ASC, created_at DESC);
CREATE INDEX IF NOT EXISTS promociones_activo_idx ON promociones (activo);

-- ── RLS ────────────────────────────────────────────────────────────────────
ALTER TABLE promociones ENABLE ROW LEVEL SECURITY;

-- Lectura pública (anon y authenticated)
CREATE POLICY "promociones_public_read"
  ON promociones FOR SELECT
  TO anon, authenticated
  USING (true);

-- Escritura para anon (admin usa la publishable key sin autenticarse)
CREATE POLICY "promociones_anon_insert"
  ON promociones FOR INSERT
  TO anon, authenticated
  WITH CHECK (true);

CREATE POLICY "promociones_anon_update"
  ON promociones FOR UPDATE
  TO anon, authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "promociones_anon_delete"
  ON promociones FOR DELETE
  TO anon, authenticated
  USING (true);
