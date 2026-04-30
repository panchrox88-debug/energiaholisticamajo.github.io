-- =============================================================
-- SECURITY FIX — Energía Holística Majo
-- Ejecutar en Supabase > SQL Editor
-- =============================================================

-- ─────────────────────────────────────────
-- 1. RESERVAS — quitar lectura pública total
--    Reemplazar por vista pública sin PII
-- ─────────────────────────────────────────

-- Eliminar política pública insegura
DROP POLICY IF EXISTS "public read reservas" ON reservas;
DROP POLICY IF EXISTS "Public read reservas" ON reservas;
DROP POLICY IF EXISTS "anon read reservas" ON reservas;

-- Solo el propio cliente puede leer sus reservas
CREATE POLICY "cliente lee sus reservas"
  ON reservas FOR SELECT
  USING (auth.email() = email_cliente);

-- Admin puede leer todas
CREATE POLICY "admin lee todas las reservas"
  ON reservas FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM perfiles
      WHERE id = auth.uid() AND rol = 'admin'
    )
  );

-- Vista pública para verificar disponibilidad (sin PII)
CREATE OR REPLACE VIEW disponibilidad_publica AS
  SELECT fecha, hora_inicio, hora_fin
  FROM reservas
  WHERE estado = 'confirmada';

GRANT SELECT ON disponibilidad_publica TO anon, authenticated;

-- ─────────────────────────────────────────
-- 2. PROMOCIONES — eliminar escritura anónima
-- ─────────────────────────────────────────
DROP POLICY IF EXISTS "promociones_anon_insert" ON promociones;
DROP POLICY IF EXISTS "promociones_anon_update" ON promociones;
DROP POLICY IF EXISTS "promociones_anon_delete" ON promociones;
DROP POLICY IF EXISTS "Insertar promocion" ON promociones;
DROP POLICY IF EXISTS "Actualizar promocion" ON promociones;
DROP POLICY IF EXISTS "Eliminar promocion" ON promociones;

-- Solo admin puede escribir
CREATE POLICY "admin gestiona promociones"
  ON promociones FOR ALL
  USING (
    EXISTS (SELECT 1 FROM perfiles WHERE id = auth.uid() AND rol = 'admin')
  )
  WITH CHECK (
    EXISTS (SELECT 1 FROM perfiles WHERE id = auth.uid() AND rol = 'admin')
  );

-- ─────────────────────────────────────────
-- 3. COMENTARIOS — eliminar borrado público
-- ─────────────────────────────────────────
DROP POLICY IF EXISTS "Eliminación pública comentarios" ON comentarios;
DROP POLICY IF EXISTS "delete public comentarios" ON comentarios;

-- Solo admin puede eliminar comentarios
CREATE POLICY "admin elimina comentarios"
  ON comentarios FOR DELETE
  USING (
    EXISTS (SELECT 1 FROM perfiles WHERE id = auth.uid() AND rol = 'admin')
  );

-- Solo admin puede responder (update)
DROP POLICY IF EXISTS "admin update comentarios" ON comentarios;
CREATE POLICY "admin actualiza comentarios"
  ON comentarios FOR UPDATE
  USING (
    EXISTS (SELECT 1 FROM perfiles WHERE id = auth.uid() AND rol = 'admin')
  );

-- ─────────────────────────────────────────
-- 4. ACCESOS — eliminar insert/delete anónimo
-- ─────────────────────────────────────────
DROP POLICY IF EXISTS "accesos_anon_insert" ON accesos;
DROP POLICY IF EXISTS "accesos_anon_delete" ON accesos;
DROP POLICY IF EXISTS "insert accesos anon" ON accesos;
DROP POLICY IF EXISTS "delete accesos anon" ON accesos;

-- Solo el propio usuario puede ver sus accesos
DROP POLICY IF EXISTS "Lectura accesos propios" ON accesos;
CREATE POLICY "usuario lee sus accesos"
  ON accesos FOR SELECT
  USING (auth.email() = email_usuario);

-- Solo admin puede insertar/modificar/borrar accesos
CREATE POLICY "admin gestiona accesos"
  ON accesos FOR ALL
  USING (
    EXISTS (SELECT 1 FROM perfiles WHERE id = auth.uid() AND rol = 'admin')
  )
  WITH CHECK (
    EXISTS (SELECT 1 FROM perfiles WHERE id = auth.uid() AND rol = 'admin')
  );

-- ─────────────────────────────────────────
-- 5. PERFILES — restringir lectura pública
-- ─────────────────────────────────────────
DROP POLICY IF EXISTS "Lectura pública perfiles" ON perfiles;
DROP POLICY IF EXISTS "public read perfiles" ON perfiles;

-- Cada usuario lee solo su perfil
CREATE POLICY "usuario lee su perfil"
  ON perfiles FOR SELECT
  USING (auth.uid() = id);

-- Admin puede leer todos
CREATE POLICY "admin lee todos los perfiles"
  ON perfiles FOR SELECT
  USING (
    EXISTS (SELECT 1 FROM perfiles p WHERE p.id = auth.uid() AND p.rol = 'admin')
  );

-- ─────────────────────────────────────────
-- 6. RESERVAS UPDATE — solo el cliente propio o admin
-- ─────────────────────────────────────────
DROP POLICY IF EXISTS "cliente actualiza su reserva" ON reservas;
DROP POLICY IF EXISTS "update reservas authenticated" ON reservas;

CREATE POLICY "cliente actualiza su reserva"
  ON reservas FOR UPDATE
  USING (
    auth.email() = email_cliente
    OR EXISTS (SELECT 1 FROM perfiles WHERE id = auth.uid() AND rol = 'admin')
  );

-- ─────────────────────────────────────────
-- 7. FICHAS_CLIENTES — solo admin
-- ─────────────────────────────────────────
DROP POLICY IF EXISTS "public read fichas" ON fichas_clientes;
DROP POLICY IF EXISTS "anon read fichas" ON fichas_clientes;

CREATE POLICY "solo admin gestiona fichas"
  ON fichas_clientes FOR ALL
  USING (
    EXISTS (SELECT 1 FROM perfiles WHERE id = auth.uid() AND rol = 'admin')
  )
  WITH CHECK (
    EXISTS (SELECT 1 FROM perfiles WHERE id = auth.uid() AND rol = 'admin')
  );

-- ─────────────────────────────────────────
-- 8. SESIONES_FICHAS — solo admin
-- ─────────────────────────────────────────
CREATE POLICY "solo admin gestiona sesiones_fichas"
  ON sesiones_fichas FOR ALL
  USING (
    EXISTS (SELECT 1 FROM perfiles WHERE id = auth.uid() AND rol = 'admin')
  )
  WITH CHECK (
    EXISTS (SELECT 1 FROM perfiles WHERE id = auth.uid() AND rol = 'admin')
  );
