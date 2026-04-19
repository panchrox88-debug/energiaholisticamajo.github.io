# Energía Holística Majo — Contexto del Proyecto

Sitio web de una sola página (SPA estática) para **Majo**, psicoterapeuta transpersonal y terapeuta holística. El proyecto vive en un solo archivo HTML (`index.html`) con CSS y JS inline, más una carpeta `img/` con imágenes de servicios.

**Repo:** `panchrox88-debug/energiaholisticamajo.github.io` (GitHub Pages, rama `main`)
**Dominio:** energiaholisticamajo.github.io
**Idioma:** Español (todo copy, UI y comentarios)

---

## Stack

- **HTML + CSS + JS vanilla**, todo inline en `index.html` — sin build, sin frameworks, sin dependencias externas más allá de Google Fonts.
- Fuentes: **Cormorant Garamond** (serif, titulares, énfasis en cursiva) + **Nunito** (sans, cuerpo).
- Sin scripts de analytics ni tracking.

## Paleta de colores (CSS variables en `:root`)

```css
--rose:    #c9858a;  /* primario — CTAs, énfasis, acentos */
--rose-lt: #dba8ac;  /* rosa claro — hover, dots activos */
--blush:   #f0dada;  /* fondos sutiles, chips/tags */
--cream:   #faf5f0;  /* fondo principal */
--beige:   #ede0d4;  /* fondo secciones alternas */
--gold:    #c9a96e;  /* eyebrows, iconos decorativos, divisores */
--gold-lt: #e8d5b0;  /* divisores finos */
--dark:    #3d2b2b;  /* texto principal */
--muted:   #7a5c5c;  /* texto secundario */
--white:   #ffffff;
```

**Regla:** usar únicamente estas variables. No inventar colores nuevos. Si se necesita variación, usar `rgba()` de una variable existente.

## Sistema tipográfico

- **Titulares + énfasis cursivo** → `Cormorant Garamond`, weight 300–500. Usar `<em>` con `color: var(--rose)` e `font-style: italic` para resaltar palabras clave.
- **Eyebrows** (kickers de sección) → `Nunito`, `uppercase`, `letter-spacing: 0.45em`, `font-size: 0.65rem`, `color: var(--gold)`.
- **Cuerpo** → `Nunito` weight 300, `line-height: 1.9–2` para legibilidad.
- **Handwritten / script** (logo "Energía Holística Majo") → está como imagen, no como fuente.

## Estructura del sitio (secciones en `index.html`)

1. **Nav** — logo + links + CTA "Reservar"
2. **Hero** — titular grande, eyebrow dorado, CTA
3. **About** — tarjeta con info de Majo + bio
4. **Services** — grid 3×2 de tarjetas + **panel inline expandible con carrusel**
5. **Testimonials** — grid de reseñas con estrellas
6. **CTA banner** — banner oscuro con gradiente rose
7. **Contact form** — formulario con datos de contacto
8. **Booking** — flujo de 4 pasos: servicio → modalidad → día → hora, que envía a WhatsApp
9. **Footer**

---

## Componentes clave

### Booking (reserva por WhatsApp)
- 4 pasos secuenciales, cada uno se habilita al completar el anterior.
- Servicios con modalidad Online, Presencial o ambas.
- Calendario inline (lun-sáb) con fechas dinámicas desde hoy.
- Slots de hora, los ocupados se muestran tachados.
- Al confirmar, abre WhatsApp (`https://wa.me/...`) con mensaje pre-llenado formato `Etiqueta: valor` (NO usar guiones `-` al inicio — WhatsApp los renderiza como bullets).
- Número de Majo: revisar en el `href` del botón de confirmación.

### Services + Carrusel inline (último cambio)
- 6 tarjetas de servicios con `data-service="reiki|psico|limpieza|masaje|utero|circulo"`.
- Al hacer click en una tarjeta con slides disponibles → el grid colapsa (fade + max-height 0) y aparece un **panel de detalle inline** con:
  - Eyebrow "Conoce más" + título del servicio + divisor dorado
  - **Carrusel** con flechas laterales (`‹ ›`), puntitos, contador "N / total"
  - Botón "Reservar esta sesión →" que cierra el panel y baja a `#booking`
- Navegación: flechas ← → del teclado, swipe en móvil, Esc para cerrar.
- Config en `SERVICE_DATA` (objeto JS dentro del `<script>`):
  ```js
  const SERVICE_DATA = {
    reiki:    { title: 'Reiki Usui', slides: ['img/reiki/01-...', ...] },
    psico:    { title: 'Psicoterapia Transpersonal', slides: [] },
    limpieza: { title: 'Limpieza Energética', slides: [] },
    masaje:   { title: 'Masaje Terapéutico', slides: [] },
    utero:    { title: 'Sanación de Útero', slides: [] },
    circulo:  { title: 'Círculos de Mujeres', slides: [] },
  };
  ```
- Servicios con `slides: []` reciben atributo `data-empty` y no reaccionan al click.

**Para añadir slides a un nuevo servicio:**
1. Crear carpeta `img/<servicio>/` y añadir las PNGs ordenadas (01-, 02-, ...).
2. Llenar el array `slides` en `SERVICE_DATA` con las rutas.
3. (Si las imágenes traen flechas de navegación del diseño original, quitarlas antes — ver `DESIGN_NOTES.md`.)

---

## Convenciones de código

- **CSS:** variables `--*` en `:root`, selectores de clase simples, sin BEM estricto pero con prefijos por sección (`.service-*`, `.hero-*`, `.bk-*` para booking).
- **Animaciones:** todas con `cubic-bezier(0.22, 1, 0.36, 1)` — easing suave marca de la casa.
- **Responsive:** breakpoint principal en `900px`. Grids colapsan a 1–2 columnas, paddings se reducen.
- **`.reveal`** es una clase de intersección-observer para animaciones de entrada al hacer scroll (fade-up).
- **IDs de DOM** son camelCase (`serviceDetail`, `carouselTrack`, `detailReserve`).

## Convenciones de copy

- **Tono:** cálido, espiritual, femenino, no místico-exagerado. Tratar a la usuaria de "tú".
- Énfasis con `<strong>` en frases clave (color rose).
- Firma recurrente: **"Energía Holística Majo"** (en logo y cerraduras).
- Instagram: `@energiaholisticamajo`.
- Evitar emojis en el copy del sitio (sí se usan como íconos decorativos en `.service-icon` porque son parte del diseño — 🧠 ✨ 🌊 💆 🌺 🌙).

---

## Próximos pasos pendientes

- [ ] Obtener imágenes del carrusel para los otros 5 servicios (psico, limpieza, masaje, útero, círculos) y añadirlas a `SERVICE_DATA`.
- [ ] Cuando el cliente pase imágenes nuevas, limpiar las flechas laterales del diseño original (ver script en `DESIGN_NOTES.md`).
- [ ] Probar el flujo de reserva en WhatsApp móvil end-to-end.

## Cosas a NO tocar sin consultar

- La paleta de colores y las fuentes — están validadas por la clienta.
- El formato del mensaje de WhatsApp en booking (sin guiones iniciales — se renderizan como bullets).
- El número de WhatsApp de Majo en el botón de confirmación.

---

## Tips para Claude Code al retomar

- Este proyecto se construyó iterativamente con mucho feedback visual. **Preguntar antes de añadir contenido o secciones nuevas** — la clienta es quien decide qué incluir.
- **No introducir dependencias externas** (React, Tailwind, librerías de carrusel). Todo vanilla.
- Para cambios pequeños → editar `index.html` directamente.
- Para añadir imágenes → siempre a `img/<servicio>/` con nombres `01-`, `02-`, etc.
- Leer `CHANGELOG.md` para contexto de qué se ha hecho.
- Leer `DESIGN_NOTES.md` para decisiones de diseño y tricks útiles (como limpiar flechas de imágenes).
