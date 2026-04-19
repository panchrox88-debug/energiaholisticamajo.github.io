-- ═══════════════════════════════════════════════════════════════
-- Energía Holística Majo — Setup completo de Supabase
-- Pega todo esto en Supabase → SQL Editor → New query → RUN
-- ═══════════════════════════════════════════════════════════════

-- ── 1. TABLAS ────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS servicios (
  id          text PRIMARY KEY,
  emoji       text NOT NULL DEFAULT '✨',
  titulo      text NOT NULL,
  descripcion text,
  modo        text NOT NULL DEFAULT 'Presencial',
  slides      jsonb NOT NULL DEFAULT '[]',
  orden       int  NOT NULL DEFAULT 0
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
  id                 int PRIMARY KEY DEFAULT 1,
  hora_inicio        text NOT NULL DEFAULT '9:00',
  hora_fin           text NOT NULL DEFAULT '19:00',
  duracion_sesion    int  NOT NULL DEFAULT 60,
  pausa_minutos      int  NOT NULL DEFAULT 15,
  descanso_desde     text,
  descanso_hasta     text,
  dias_habiles       jsonb NOT NULL DEFAULT '[1,2,3,4,5,6]',
  fechas_bloqueadas  jsonb NOT NULL DEFAULT '[]'
);

CREATE TABLE IF NOT EXISTS hero_fotos (
  id       uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  src      text NOT NULL,
  posicion text NOT NULL DEFAULT 'center center',
  orden    int  NOT NULL DEFAULT 0
);

-- ── 2. ROW LEVEL SECURITY ────────────────────────────────────

ALTER TABLE servicios    ENABLE ROW LEVEL SECURITY;
ALTER TABLE testimonios  ENABLE ROW LEVEL SECURITY;
ALTER TABLE contacto     ENABLE ROW LEVEL SECURITY;
ALTER TABLE agenda       ENABLE ROW LEVEL SECURITY;
ALTER TABLE hero_fotos   ENABLE ROW LEVEL SECURITY;

-- Lectura pública (para el sitio)
CREATE POLICY "public read servicios"    ON servicios   FOR SELECT USING (true);
CREATE POLICY "public read contacto"     ON contacto    FOR SELECT USING (true);
CREATE POLICY "public read agenda"       ON agenda      FOR SELECT USING (true);
CREATE POLICY "public read hero_fotos"   ON hero_fotos  FOR SELECT USING (true);
CREATE POLICY "public read testimonios"  ON testimonios FOR SELECT USING (visible = true);

-- Inserción pública de testimonios (formulario del sitio)
CREATE POLICY "public insert testimonio" ON testimonios
  FOR INSERT WITH CHECK (visible = false);

-- Admin: acceso total para usuarios autenticados
CREATE POLICY "admin all servicios"   ON servicios   FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "admin all testimonios" ON testimonios FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "admin all contacto"    ON contacto    FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "admin all agenda"      ON agenda      FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "admin all hero_fotos"  ON hero_fotos  FOR ALL USING (auth.role() = 'authenticated');

-- ── 3. STORAGE (bucket para imágenes) ───────────────────────

INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES ('uploads', 'uploads', true, 5242880, ARRAY['image/jpeg','image/png','image/avif','image/webp'])
ON CONFLICT (id) DO NOTHING;

CREATE POLICY "public read uploads"
  ON storage.objects FOR SELECT USING (bucket_id = 'uploads');

CREATE POLICY "auth upload"
  ON storage.objects FOR INSERT
  WITH CHECK (bucket_id = 'uploads' AND auth.role() = 'authenticated');

CREATE POLICY "auth delete uploads"
  ON storage.objects FOR DELETE
  USING (bucket_id = 'uploads' AND auth.role() = 'authenticated');

-- ── 4. DATOS INICIALES ───────────────────────────────────────

INSERT INTO servicios (id, emoji, titulo, descripcion, modo, slides, orden) VALUES
('psico',    '🧠', 'Psicoterapia Transpersonal',
  'Un espacio de escucha profunda donde trabajamos tus emociones, miedos y bloqueos desde la raíz, integrando cuerpo y mente.',
  'Online & Presencial', '[]', 1),
('limpieza', '✨', 'Limpieza Energética',
  'Limpieza y armonización de tu campo energético para liberar cargas que ya no te pertenecen y restaurar tu flujo vital.',
  'Online & Presencial', '[]', 2),
('reiki',    '🌊', 'Reiki Usui',
  'Canalización de energía universal para activar tu propio poder sanador, relajar el sistema nervioso y equilibrar tus chakras.',
  'Presencial',
  '["img/reiki/01-portada.png","img/reiki/02-frase.png","img/reiki/03-descripcion.png","img/reiki/04-beneficios.png","img/reiki/05-incluye.png"]',
  3),
('masaje',   '💆', 'Masaje Terapéutico',
  'Trabajo corporal que integra técnicas de masaje con conciencia energética para liberar tensiones físicas y emocionales.',
  'Presencial', '[]', 4),
('utero',    '🌺', 'Sanación de Útero',
  'Proceso de reconexión con tu centro femenino, liberando memorias y heridas para recuperar tu poder y creatividad.',
  'Online & Presencial', '[]', 5),
('circulo',  '🌙', 'Círculos de Mujeres',
  'Espacios de encuentro, sanación colectiva y comunidad donde nos acompañamos en el camino de reconocernos y crecer.',
  'Presencial', '[]', 6)
ON CONFLICT (id) DO NOTHING;

INSERT INTO testimonios (nombre, ciudad, texto, emoji, rating, visible) VALUES
('Valentina M.', 'Santiago, Chile',
  'Majo me acompañó en uno de los momentos más difíciles de mi vida. Su enfoque integrador me ayudó a sanar desde un lugar que no sabía que existía.',
  '🌸', 5, true),
('Camila R.', 'Viña del Mar, Chile',
  'Las sesiones de Reiki con Majo transformaron mi relación con mi cuerpo y mis emociones. Me siento más liviana, más yo.',
  '✨', 5, true),
('Catalina F.', 'Providencia, Santiago',
  'Participé en el círculo de mujeres y fue una experiencia que cambió mi vida. Gracias por crear ese espacio tan sagrado y seguro.',
  '🌙', 5, true);

INSERT INTO contacto (etiqueta, valor, tipo, orden) VALUES
('Ubicación',  'Providencia, Santiago · Chile', 'ubicacion', 1),
('WhatsApp',   '+56 9 6663 8304',               'whatsapp',  2),
('Instagram',  '@energiaholisticamajo',          'instagram', 3),
('Modalidad',  'Online & Presencial',            'modalidad', 4)
ON CONFLICT DO NOTHING;

INSERT INTO agenda (id, hora_inicio, hora_fin, duracion_sesion, pausa_minutos,
                    descanso_desde, descanso_hasta, dias_habiles, fechas_bloqueadas)
VALUES (1, '9:00', '19:00', 60, 15, '13:00', '15:00', '[1,2,3,4,5,6]', '[]')
ON CONFLICT (id) DO NOTHING;

-- Hero foto existente (la que Majo ya subió)
INSERT INTO hero_fotos (src, posicion, orden) VALUES
('img/uploads/photo-1552393914-fe2f87df7d39.avif', 'center center', 1)
ON CONFLICT DO NOTHING;

-- ═══════════════════════════════════════════════════════════════
-- LISTO. Después de ejecutar esto ve a:
-- Supabase → Authentication → Users → Add user
-- y crea la cuenta de administrador (email + contraseña de Majo)
-- ═══════════════════════════════════════════════════════════════

-- ── SOBRE MÍ ─────────────────────────────────────────────────

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

ALTER TABLE sobre_mi       ENABLE ROW LEVEL SECURITY;
ALTER TABLE sobre_mi_fotos ENABLE ROW LEVEL SECURITY;

CREATE POLICY "public read sobre_mi"       ON sobre_mi       FOR SELECT USING (true);
CREATE POLICY "public read sobre_mi_fotos" ON sobre_mi_fotos FOR SELECT USING (true);
CREATE POLICY "admin all sobre_mi"         ON sobre_mi       FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "admin all sobre_mi_fotos"   ON sobre_mi_fotos FOR ALL USING (auth.role() = 'authenticated');

INSERT INTO sobre_mi (id, titulo, titulo_em, parrafo1, parrafo2, lista, badge_num, badge_texto)
VALUES (1,
  'Un puente entre la psicología y el',
  'alma',
  'Soy María José Toro, psicóloga y terapeuta holística. Creo en que la sanación verdadera ocurre cuando integramos la mente, el cuerpo y el espíritu como una sola unidad.',
  'Mi práctica combina la psicoterapia transpersonal con herramientas holísticas como Reiki, limpiezas energéticas y masajes terapéuticos para acompañarte en un proceso de transformación profunda.',
  '["Psicóloga con enfoque transpersonal","Terapeuta Reiki certificada","Especialista en sanación del útero","Facilitadora de círculos de mujeres","Atención presencial en Providencia, Santiago"]',
  '6.4K',
  'Personas que confían en mí'
) ON CONFLICT (id) DO NOTHING;

-- ── HERO TEXTO ────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS hero_texto (
  id         int  PRIMARY KEY DEFAULT 1,
  eyebrow    text NOT NULL DEFAULT 'Psicóloga · Terapeuta Holística · Chile',
  titulo     text NOT NULL DEFAULT 'Acompaño tu proceso de',
  titulo_em  text NOT NULL DEFAULT 'sanación',
  descripcion text NOT NULL DEFAULT 'Un espacio seguro y consciente donde cuerpo, mente y alma se encuentran para sanar desde adentro.',
  tags       jsonb NOT NULL DEFAULT '["Psicoterapia","Reiki","Limpiezas Energéticas","Masajes","Online & Presencial"]'
);

ALTER TABLE hero_texto ENABLE ROW LEVEL SECURITY;
CREATE POLICY "public read hero_texto" ON hero_texto FOR SELECT USING (true);
CREATE POLICY "admin all hero_texto"   ON hero_texto FOR ALL USING (auth.role() = 'authenticated');

INSERT INTO hero_texto (id, eyebrow, titulo, titulo_em, descripcion, tags)
VALUES (1,
  'Psicóloga · Terapeuta Holística · Chile',
  'Acompaño tu proceso de',
  'sanación',
  'Un espacio seguro y consciente donde cuerpo, mente y alma se encuentran para sanar desde adentro.',
  '["Psicoterapia","Reiki","Limpiezas Energéticas","Masajes","Online & Presencial"]'
) ON CONFLICT (id) DO NOTHING;
