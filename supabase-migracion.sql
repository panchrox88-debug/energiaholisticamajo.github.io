-- ═══════════════════════════════════════════════════════════════
-- Energía Holística Majo — Script de migración completo
-- Ejecutar en el proyecto NUEVO de Supabase → SQL Editor → Run
-- Después importar los CSV tabla por tabla desde Table Editor
-- ═══════════════════════════════════════════════════════════════

-- ── 1. TABLAS ────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS servicios (
  id          text PRIMARY KEY,
  emoji       text NOT NULL DEFAULT '✨',
  titulo      text NOT NULL,
  descripcion text,
  modo        text NOT NULL DEFAULT 'Presencial',
  slides      jsonb NOT NULL DEFAULT '[]',
  orden       int  NOT NULL DEFAULT 0,
  precio      integer,
  foto_fondo  text
);

CREATE TABLE IF NOT EXISTS testimonios (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  nombre     text NOT NULL,
  ciudad     text,
  texto      text NOT NULL,
  emoji      text DEFAULT '🌸',
  rating     int  NOT NULL DEFAULT 5 CHECK (rating BETWEEN 1 AND 5),
  visible    boolean NOT NULL DEFAULT false,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS contacto (
  id       uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  etiqueta text NOT NULL,
  valor    text NOT NULL,
  tipo     text NOT NULL DEFAULT 'otro',
  orden    int  NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS agenda (
  id                           int PRIMARY KEY DEFAULT 1,
  hora_inicio                  text NOT NULL DEFAULT '9:00',
  hora_fin                     text NOT NULL DEFAULT '19:00',
  duracion_sesion              int  NOT NULL DEFAULT 60,
  pausa_minutos                int  NOT NULL DEFAULT 15,
  descanso_desde               text,
  descanso_hasta               text,
  dias_habiles                 jsonb NOT NULL DEFAULT '[1,2,3,4,5,6]',
  fechas_bloqueadas            jsonb NOT NULL DEFAULT '[]',
  horarios_por_dia             jsonb NOT NULL DEFAULT '{}',
  dias_adelante                int DEFAULT 30,
  planificacion_semanas        jsonb DEFAULT '{}',
  horas_anticipacion_reagendar int DEFAULT 24
);

CREATE TABLE IF NOT EXISTS hero_fotos (
  id       uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  src      text NOT NULL,
  posicion text NOT NULL DEFAULT 'center center',
  orden    int  NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS hero_texto (
  id          int  PRIMARY KEY DEFAULT 1,
  eyebrow     text NOT NULL DEFAULT 'Psicóloga · Terapeuta Holística · Chile',
  titulo      text NOT NULL DEFAULT 'Acompaño tu proceso de',
  titulo_em   text NOT NULL DEFAULT 'sanación',
  descripcion text NOT NULL DEFAULT 'Un espacio seguro y consciente donde cuerpo, mente y alma se encuentran para sanar desde adentro.',
  tags        jsonb NOT NULL DEFAULT '["Psicoterapia","Reiki","Limpiezas Energéticas","Masajes","Online & Presencial"]'
);

CREATE TABLE IF NOT EXISTS sobre_mi (
  id          int PRIMARY KEY DEFAULT 1,
  titulo      text NOT NULL DEFAULT 'Un puente entre la psicología y el',
  titulo_em   text NOT NULL DEFAULT 'alma',
  parrafo1    text,
  parrafo2    text,
  lista       jsonb NOT NULL DEFAULT '[]',
  badge_num   text DEFAULT '6.4K',
  badge_texto text DEFAULT 'Personas que confían en mí'
);

CREATE TABLE IF NOT EXISTS sobre_mi_fotos (
  id    uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  src   text NOT NULL,
  orden int  NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS banner (
  id           int PRIMARY KEY DEFAULT 1,
  activo       boolean NOT NULL DEFAULT false,
  texto        text NOT NULL DEFAULT '',
  subtexto     text,
  imagen       text,
  color_fondo  text NOT NULL DEFAULT '#c9858a',
  color_texto  text NOT NULL DEFAULT '#ffffff',
  descuento    integer,
  aplica_todos boolean DEFAULT true,
  aplica_a     jsonb DEFAULT '[]'
);

CREATE TABLE IF NOT EXISTS reservas (
  id                   uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  servicio_id          text NOT NULL,
  servicio_nombre      text NOT NULL,
  modalidad            text NOT NULL,
  fecha                date NOT NULL,
  hora_inicio          text NOT NULL,
  hora_fin             text NOT NULL,
  nombre_cliente       text NOT NULL,
  email_cliente        text NOT NULL,
  telefono_cliente     text,
  estado               text NOT NULL DEFAULT 'confirmada',
  created_at           timestamptz NOT NULL DEFAULT now(),
  notas_reagendar      text,
  nueva_fecha_propuesta date,
  nueva_hora_propuesta text,
  precio_pagado        integer,
  precio_original      integer,
  descuento_pct        integer
);

CREATE TABLE IF NOT EXISTS politicas (
  id             bigserial PRIMARY KEY,
  icono          text DEFAULT '',
  titulo         text NOT NULL,
  contenido      text DEFAULT '',
  orden          integer DEFAULT 0,
  activa         boolean DEFAULT true,
  actualizado_en timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS promociones (
  id                 uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  titulo             text NOT NULL,
  descripcion        text,
  imagen             text,
  color_tema         text DEFAULT '#c9858a',
  items              jsonb DEFAULT '[]',
  precio_referencial integer,
  precio_combo       integer,
  link_pago          text,
  activo             boolean DEFAULT true,
  orden              integer DEFAULT 0,
  created_at         timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS blog_posts (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  titulo     text NOT NULL,
  resumen    text,
  contenido  text NOT NULL,
  imagen     text,
  slug       text,
  publicado  boolean NOT NULL DEFAULT false,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS comentarios (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  post_id    uuid NOT NULL,
  nombre     text NOT NULL,
  mensaje    text NOT NULL,
  created_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS cursos (
  id               uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  titulo           text NOT NULL,
  descripcion      text,
  imagen           text,
  precio           integer,
  gratuito         boolean NOT NULL DEFAULT false,
  categoria        text,
  link_pago        text,
  activo           boolean NOT NULL DEFAULT true,
  orden            integer NOT NULL DEFAULT 0,
  created_at       timestamptz NOT NULL DEFAULT now(),
  secciones        jsonb NOT NULL DEFAULT '[]',
  intro            text,
  color_tema       text DEFAULT '#c9858a',
  etiqueta_seccion text DEFAULT 'Módulo',
  imagen_posicion  text DEFAULT '50% 50%',
  pdf_url          text,
  pdfs             jsonb DEFAULT '[]'
);

CREATE TABLE IF NOT EXISTS encuentros (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  titulo      text NOT NULL,
  descripcion text,
  motivo      text,
  fecha       date NOT NULL,
  hora_inicio time NOT NULL,
  hora_fin    time NOT NULL,
  modalidad   text DEFAULT 'presencial',
  precio      numeric DEFAULT 0,
  cupo_maximo integer,
  imagen      text,
  activo      boolean DEFAULT true,
  created_at  timestamptz DEFAULT now(),
  fotos       text[] DEFAULT '{}'
);

CREATE TABLE IF NOT EXISTS inscripciones (
  id               uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  encuentro_id     uuid,
  user_id          uuid,
  nombre_cliente   text NOT NULL,
  email_cliente    text NOT NULL,
  telefono_cliente text,
  estado           text DEFAULT 'confirmada',
  created_at       timestamptz DEFAULT now(),
  mp_preference_id text,
  mp_payment_id    text
);

CREATE TABLE IF NOT EXISTS fichas_clientes (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  email_cliente   text NOT NULL,
  nombre          text NOT NULL,
  telefono        text,
  notas_generales text,
  created_at      timestamptz DEFAULT now(),
  updated_at      timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS sesiones_fichas (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  email_cliente text NOT NULL,
  fecha         date NOT NULL DEFAULT CURRENT_DATE,
  descripcion   text,
  notas         text,
  created_at    timestamptz DEFAULT now()
);

-- Tabla legacy (histórica, no se usa activamente)
CREATE TABLE IF NOT EXISTS accesos_legacy (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  created_at timestamptz DEFAULT now()
);

-- ── 2. AUTH: perfiles + accesos ──────────────────────────────

CREATE TABLE IF NOT EXISTS perfiles (
  id         uuid REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
  email      text NOT NULL,
  nombre     text,
  rol        text NOT NULL DEFAULT 'usuario',
  created_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS accesos (
  id         uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id    uuid REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  curso_id   uuid NOT NULL,
  notas      text,
  created_at timestamptz DEFAULT now(),
  UNIQUE (user_id, curso_id)
);

-- Trigger: crea perfil automáticamente al registrar usuario
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

-- ── 3. ROW LEVEL SECURITY ────────────────────────────────────

ALTER TABLE servicios       ENABLE ROW LEVEL SECURITY;
ALTER TABLE testimonios     ENABLE ROW LEVEL SECURITY;
ALTER TABLE contacto        ENABLE ROW LEVEL SECURITY;
ALTER TABLE agenda          ENABLE ROW LEVEL SECURITY;
ALTER TABLE hero_fotos      ENABLE ROW LEVEL SECURITY;
ALTER TABLE hero_texto      ENABLE ROW LEVEL SECURITY;
ALTER TABLE sobre_mi        ENABLE ROW LEVEL SECURITY;
ALTER TABLE sobre_mi_fotos  ENABLE ROW LEVEL SECURITY;
ALTER TABLE banner          ENABLE ROW LEVEL SECURITY;
ALTER TABLE reservas        ENABLE ROW LEVEL SECURITY;
ALTER TABLE politicas       ENABLE ROW LEVEL SECURITY;
ALTER TABLE promociones     ENABLE ROW LEVEL SECURITY;
ALTER TABLE blog_posts      ENABLE ROW LEVEL SECURITY;
ALTER TABLE comentarios     ENABLE ROW LEVEL SECURITY;
ALTER TABLE cursos          ENABLE ROW LEVEL SECURITY;
ALTER TABLE encuentros      ENABLE ROW LEVEL SECURITY;
ALTER TABLE inscripciones   ENABLE ROW LEVEL SECURITY;
ALTER TABLE fichas_clientes ENABLE ROW LEVEL SECURITY;
ALTER TABLE sesiones_fichas ENABLE ROW LEVEL SECURITY;
ALTER TABLE perfiles        ENABLE ROW LEVEL SECURITY;
ALTER TABLE accesos         ENABLE ROW LEVEL SECURITY;

-- Lectura pública
CREATE POLICY "public read servicios"      ON servicios      FOR SELECT USING (true);
CREATE POLICY "public read testimonios"    ON testimonios    FOR SELECT USING (visible = true);
CREATE POLICY "public read contacto"       ON contacto       FOR SELECT USING (true);
CREATE POLICY "public read agenda"         ON agenda         FOR SELECT USING (true);
CREATE POLICY "public read hero_fotos"     ON hero_fotos     FOR SELECT USING (true);
CREATE POLICY "public read hero_texto"     ON hero_texto     FOR SELECT USING (true);
CREATE POLICY "public read sobre_mi"       ON sobre_mi       FOR SELECT USING (true);
CREATE POLICY "public read sobre_mi_fotos" ON sobre_mi_fotos FOR SELECT USING (true);
CREATE POLICY "public read banner"         ON banner         FOR SELECT USING (true);
CREATE POLICY "public read politicas"      ON politicas      FOR SELECT USING (true);
CREATE POLICY "public read promociones"    ON promociones    FOR SELECT USING (true);
CREATE POLICY "public read blog_posts"     ON blog_posts     FOR SELECT USING (true);
CREATE POLICY "public read comentarios"    ON comentarios    FOR SELECT USING (true);
CREATE POLICY "public read cursos"         ON cursos         FOR SELECT USING (true);
CREATE POLICY "public read encuentros"     ON encuentros     FOR SELECT USING (true);
CREATE POLICY "public read inscripciones"  ON inscripciones  FOR SELECT USING (true);
CREATE POLICY "public read reservas"       ON reservas       FOR SELECT USING (true);
CREATE POLICY "public read perfiles"       ON perfiles       FOR SELECT USING (true);
CREATE POLICY "public read accesos"        ON accesos        FOR SELECT USING (true);

-- Inserción pública
CREATE POLICY "public insert reserva"      ON reservas      FOR INSERT WITH CHECK (estado = 'confirmada');
CREATE POLICY "public insert testimonio"   ON testimonios   FOR INSERT WITH CHECK (visible = false);
CREATE POLICY "public insert comentario"   ON comentarios   FOR INSERT WITH CHECK (true);
CREATE POLICY "public insert inscripcion"  ON inscripciones FOR INSERT WITH CHECK (true);
CREATE POLICY "public insert acceso"       ON accesos       FOR INSERT WITH CHECK (true);

-- Admin: acceso total (usuario autenticado)
CREATE POLICY "admin all servicios"       ON servicios       FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "admin all testimonios"     ON testimonios     FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "admin all contacto"        ON contacto        FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "admin all agenda"          ON agenda          FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "admin all hero_fotos"      ON hero_fotos      FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "admin all hero_texto"      ON hero_texto      FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "admin all sobre_mi"        ON sobre_mi        FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "admin all sobre_mi_fotos"  ON sobre_mi_fotos  FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "admin all banner"          ON banner          FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "admin all reservas"        ON reservas        FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "admin all politicas"       ON politicas       FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "admin all promociones"     ON promociones     FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "admin all blog_posts"      ON blog_posts      FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "admin all comentarios"     ON comentarios     FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "admin all cursos"          ON cursos          FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "admin all encuentros"      ON encuentros      FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "admin all inscripciones"   ON inscripciones   FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "admin all fichas_clientes" ON fichas_clientes FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "admin all sesiones_fichas" ON sesiones_fichas FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "admin all accesos"         ON accesos         FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "update propia perfil"      ON perfiles        FOR UPDATE USING (auth.uid() = id);

-- ── 4. STORAGE ───────────────────────────────────────────────

INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES
  ('uploads',    'uploads',    true, 5242880,  ARRAY['image/jpeg','image/png','image/avif','image/webp']),
  ('documentos', 'documentos', true, 20971520, ARRAY['application/pdf'])
ON CONFLICT (id) DO NOTHING;

CREATE POLICY "public read uploads"
  ON storage.objects FOR SELECT USING (bucket_id = 'uploads');
CREATE POLICY "auth upload uploads"
  ON storage.objects FOR INSERT WITH CHECK (bucket_id = 'uploads' AND auth.role() = 'authenticated');
CREATE POLICY "auth delete uploads"
  ON storage.objects FOR DELETE USING (bucket_id = 'uploads' AND auth.role() = 'authenticated');

CREATE POLICY "public read documentos"
  ON storage.objects FOR SELECT USING (bucket_id = 'documentos');
CREATE POLICY "auth upload documentos"
  ON storage.objects FOR INSERT WITH CHECK (bucket_id = 'documentos' AND auth.role() = 'authenticated');
CREATE POLICY "auth delete documentos"
  ON storage.objects FOR DELETE USING (bucket_id = 'documentos' AND auth.role() = 'authenticated');

-- ── 5. ÍNDICES ───────────────────────────────────────────────

CREATE INDEX IF NOT EXISTS promociones_orden_idx  ON promociones (orden ASC, created_at DESC);
CREATE INDEX IF NOT EXISTS promociones_activo_idx ON promociones (activo);

-- ═══════════════════════════════════════════════════════════════
-- LISTO el schema. Próximos pasos:
--
-- 1. Importar los CSV en Table Editor → cada tabla → Import data
--    Orden recomendado: servicios, agenda, banner, hero_texto,
--    hero_fotos, sobre_mi, politicas, promociones, testimonios,
--    cursos, fichas_clientes, sesiones_fichas, reservas
--
-- 2. Crear la cuenta de admin en Authentication → Users → Add user
--    (email y contraseña de Majo/Cote)
--
-- 3. Actualizar la URL y anon key en CLAUDE.md y en todos los
--    archivos HTML del sitio (ver instrucciones en el chat)
-- ═══════════════════════════════════════════════════════════════
