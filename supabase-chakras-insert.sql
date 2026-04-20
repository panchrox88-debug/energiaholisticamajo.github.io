-- =========================================================
-- INSERT: Curso "Los 7 Chakras" — Energía Holística Majo
-- Pegar en: Supabase > SQL Editor > New query > Run
-- =========================================================

INSERT INTO cursos (
  titulo, descripcion, intro, categoria, color_tema,
  precio, gratuito, link_pago, activo, orden, secciones
) VALUES (
  'Los 7 Chakras',
  'Un viaje por los siete centros energéticos del cuerpo: qué son, dónde se ubican, cómo se bloquean y cómo activarlos para vivir en equilibrio y plenitud.',
  'Los chakras son centros de energía que recorren el cuerpo desde la base de la columna hasta la coronilla. Cuando están equilibrados, la energía fluye libremente y nos sentimos en paz, con vitalidad y conectados con nosotras mismas.\n\nCada chakra rige distintas áreas de nuestra vida —seguridad, creatividad, poder personal, amor, expresión, intuición y conexión espiritual— y cuando alguno se bloquea, lo sentimos en el cuerpo, las emociones y los pensamientos.\n\nEn este recorrido aprenderás a identificar el estado de cada uno de tus chakras y encontrarás herramientas prácticas para restaurar su equilibrio.',
  'Chakras',
  '#9b7bb8',
  NULL,
  true,
  NULL,
  true,
  1,
  '[
    {
      "icono": "🔴",
      "color": "#c0392b",
      "titulo": "Chakra Raíz",
      "subtitulo": "Muladhara",
      "ubicacion": "Base de la columna · Elemento Tierra",
      "tags": ["Seguridad", "Estabilidad", "Supervivencia", "Arraigo"],
      "descripcion": "El Chakra Raíz es nuestra base, nuestra conexión con la tierra y con el instinto de supervivencia. Rige todo lo relacionado con la seguridad material, el hogar, el cuerpo físico y el sentido de pertenencia. Cuando está equilibrado nos sentimos seguras, presentes y confiadas en la vida. Cuando está bloqueado aparece el miedo, la ansiedad, la desconexión del cuerpo o la sensación de no tener un suelo firme.",
      "afirmacion": "Estoy segura. Confío en la vida. Tengo todo lo que necesito."
    },
    {
      "icono": "🟠",
      "color": "#e67e22",
      "titulo": "Chakra Sacro",
      "subtitulo": "Svadhisthana",
      "ubicacion": "Bajo vientre · Elemento Agua",
      "tags": ["Creatividad", "Sexualidad", "Placer", "Emociones"],
      "descripcion": "El Chakra Sacro es el centro de nuestra creatividad, sensualidad y vida emocional. Gobierna nuestra capacidad de sentir placer, de fluir con las emociones y de conectar íntimamente con otras personas. En equilibrio nos sentimos creativas, receptivas y en contacto con nuestros deseos. Bloqueado puede manifestarse como culpa, rigidez emocional, dificultades sexuales o falta de inspiración.",
      "afirmacion": "Abrazo mis emociones. Fluyo con la vida. Mi creatividad es un regalo."
    },
    {
      "icono": "🟡",
      "color": "#f1c40f",
      "titulo": "Chakra del Plexo Solar",
      "subtitulo": "Manipura",
      "ubicacion": "Área del ombligo · Elemento Fuego",
      "tags": ["Poder personal", "Voluntad", "Autoestima", "Acción"],
      "descripcion": "El Chakra del Plexo Solar es el centro de nuestro poder personal, de la voluntad y de la identidad. Desde aquí tomamos decisiones, marcamos límites y actuamos en el mundo con confianza. Equilibrado se siente como determinación, propósito y seguridad en una misma. Bloqueado puede generar baja autoestima, dificultad para decir que no, vergüenza o control excesivo.",
      "afirmacion": "Soy poderosa. Confío en mis decisiones. Actúo desde mi centro."
    },
    {
      "icono": "💚",
      "color": "#27ae60",
      "titulo": "Chakra del Corazón",
      "subtitulo": "Anahata",
      "ubicacion": "Centro del pecho · Elemento Aire",
      "tags": ["Amor", "Compasión", "Perdón", "Relaciones"],
      "descripcion": "El Chakra del Corazón es el puente entre los chakras inferiores (materiales) y los superiores (espirituales). Es el centro del amor incondicional, la compasión, el perdón y la conexión con los demás y con nosotras mismas. Abierto nos permite dar y recibir amor sin miedo. Cerrado puede manifestarse como heridas del pasado, relaciones dependientes, dificultad para perdonar o un muro emocional.",
      "afirmacion": "Doy y recibo amor libremente. Me perdono. Mi corazón está abierto."
    },
    {
      "icono": "🔵",
      "color": "#2980b9",
      "titulo": "Chakra de la Garganta",
      "subtitulo": "Vishuddha",
      "ubicacion": "Garganta · Elemento Éter",
      "tags": ["Expresión", "Comunicación", "Verdad", "Voz propia"],
      "descripcion": "El Chakra de la Garganta rige nuestra expresión, comunicación y capacidad de vivir y hablar con autenticidad. Es la voz del alma. Equilibrado nos permite expresar nuestra verdad con claridad y confianza, escuchar activamente y ser creativas con las palabras. Bloqueado puede manifestarse como miedo a hablar, mentiras propias o ajenas, dificultad para pedir lo que necesitamos o una voz que se apaga.",
      "afirmacion": "Mi voz importa. Hablo mi verdad con amor y claridad."
    },
    {
      "icono": "🟣",
      "color": "#8e44ad",
      "titulo": "Tercer Ojo",
      "subtitulo": "Ajna",
      "ubicacion": "Entre las cejas · Luz",
      "tags": ["Intuición", "Visión", "Sabiduría", "Claridad mental"],
      "descripcion": "El Tercer Ojo es el centro de la intuición, la percepción interior y la sabiduría. Nos conecta con nuestra capacidad de ver más allá de las apariencias, confiar en nuestra guía interna y comprender el sentido de lo que vivimos. Activo nos sentimos clarividentes, centradas y guiadas por algo más profundo. Bloqueado puede generar confusión mental, desconexión de la intuición, pensamiento rígido o incapacidad de visualizar el futuro.",
      "afirmacion": "Confío en mi intuición. Veo con claridad. La sabiduría vive en mí."
    },
    {
      "icono": "🌸",
      "color": "#9b59b6",
      "titulo": "Chakra de la Corona",
      "subtitulo": "Sahasrara",
      "ubicacion": "Coronilla · Elemento Conciencia",
      "tags": ["Espiritualidad", "Unidad", "Propósito", "Trascendencia"],
      "descripcion": "El Chakra de la Corona es nuestro punto de conexión con lo divino, con el universo y con la conciencia pura. Es el chakra de la iluminación, del propósito de vida y de la comprensión de que somos parte de algo mucho más grande. Cuando está abierto sentimos paz profunda, gratitud y sentido. Bloqueado puede manifestarse como nihilismo, desconexión espiritual, apego excesivo al ego o sensación de vivir sin propósito.",
      "afirmacion": "Soy parte del todo. Confío en el universo. Vivo en gratitud y propósito."
    }
  ]'::jsonb
)
ON CONFLICT DO NOTHING;
