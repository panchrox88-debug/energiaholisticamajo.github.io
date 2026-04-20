-- =========================================================
-- AUTH: perfiles + accesos por usuario
-- Pegar en: Supabase > SQL Editor > New query > Run
-- =========================================================

-- ── 1. RENOMBRAR tabla accesos anterior (si existe) ───────
ALTER TABLE IF EXISTS accesos RENAME TO accesos_legacy;

-- ── 2. TABLA perfiles ─────────────────────────────────────
-- Se crea automáticamente al registrarse un usuario.
-- El campo "rol" distingue admin vs usuario normal.

CREATE TABLE IF NOT EXISTS perfiles (
  id         uuid REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
  email      text NOT NULL,
  nombre     text,
  rol        text NOT NULL DEFAULT 'usuario',   -- 'usuario' | 'admin'
  created_at timestamptz DEFAULT now()
);

ALTER TABLE perfiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Lectura pública perfiles"    ON perfiles FOR SELECT USING (true);
CREATE POLICY "Actualización propia perfil" ON perfiles FOR UPDATE USING (auth.uid() = id);

-- ── 3. TRIGGER: crear perfil al registrarse ───────────────

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER SET search_path = public
AS $$
BEGIN
  INSERT INTO public.perfiles (id, email, nombre)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'nombre', split_part(NEW.email, '@', 1))
  );
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- ── 4. TABLA accesos (user_id → curso_id) ────────────────

CREATE TABLE IF NOT EXISTS accesos (
  id         uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id    uuid REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  curso_id   uuid NOT NULL,
  notas      text,
  created_at timestamptz DEFAULT now(),
  UNIQUE (user_id, curso_id)
);

ALTER TABLE accesos ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Lectura accesos"    ON accesos FOR SELECT USING (true);
CREATE POLICY "Inserción accesos"  ON accesos FOR INSERT WITH CHECK (true);
CREATE POLICY "Eliminación accesos" ON accesos FOR DELETE USING (true);

-- ── 5. ASIGNAR rol admin a Cote ───────────────────────────
-- Después de que Cote (o Francisco) cree su cuenta,
-- ejecutar esto con su correo real:
--
--   UPDATE perfiles SET rol = 'admin' WHERE email = 'correo@deCote.com';
--
-- =========================================================
