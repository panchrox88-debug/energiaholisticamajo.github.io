# Notas de Diseño

Guía del sistema visual y patrones usados en el sitio. Respetar para mantener coherencia.

---

## Paleta

| Variable     | Hex       | Uso principal                                          |
|--------------|-----------|--------------------------------------------------------|
| `--rose`     | `#c9858a` | Primario. CTAs, palabras resaltadas en `<em>`, acentos |
| `--rose-lt`  | `#dba8ac` | Hover de CTAs, dots activos, detalles secundarios      |
| `--blush`    | `#f0dada` | Fondo de chips/tags (modalidad)                        |
| `--cream`    | `#faf5f0` | Fondo principal del sitio                              |
| `--beige`    | `#ede0d4` | Fondo de secciones alternas (services, booking)        |
| `--gold`     | `#c9a96e` | Eyebrows, íconos ✦, divisores decorativos              |
| `--gold-lt`  | `#e8d5b0` | Líneas divisorias finas                                |
| `--dark`     | `#3d2b2b` | Texto principal (marrón muy oscuro, nunca negro puro)  |
| `--muted`    | `#7a5c5c` | Texto secundario, descripciones                        |
| `--white`    | `#ffffff` | Fondos de cards flotantes, hover de inputs             |

**Regla de oro:** no introducir colores nuevos. Si necesitas variación → `rgba(201, 133, 138, 0.2)` etc. usando los mismos hex.

**Gradientes usados:**
- Fondo services: `linear-gradient(180deg, var(--beige) 0%, var(--cream) 100%)`
- CTA banner: `linear-gradient(135deg, var(--rose) 0%, #b06b74 50%, #9a5060 100%)`
- Barra top de service-card hover: `linear-gradient(90deg, var(--rose), var(--gold))`

---

## Tipografía

### Jerarquía

| Elemento          | Familia              | Peso  | Tamaño             | Notas                              |
|-------------------|----------------------|-------|--------------------|------------------------------------|
| Hero title        | Cormorant Garamond   | 300   | `clamp(3rem, 7vw, 5.5rem)` | `<em>` en rose italic              |
| H2 sección        | Cormorant Garamond   | 300   | `clamp(2rem, 4vw, 3rem)`   | `<em>` en rose italic              |
| H3 card / detail  | Cormorant Garamond   | 400–500 | `1.4–2.8rem`     |                                    |
| Eyebrow           | Nunito (por defecto) | —     | `0.65rem`          | `uppercase`, `letter-spacing: 0.45em`, `color: var(--gold)` |
| Cuerpo            | Nunito               | 300   | `0.85–1rem`        | `line-height: 1.9–2`               |
| Testimonios       | Cormorant Garamond   | 400   | `1.05rem` italic   |                                    |

### Tricks

- **Énfasis:** usar `<em>` con `color: var(--rose); font-style: italic` en titulares.
- **Tracking amplio en eyebrows** (`letter-spacing: 0.45em`) da el aire boutique.
- Nunca usar `font-weight: bold` en titulares serif — queda denso. Usar 400–500 max.

---

## Espaciado

- **Padding vertical de secciones:** `120px` desktop, `80px` mobile.
- **Padding horizontal:** `64px` desktop, `24px` mobile.
- **Max-width de contenido interior:** `1100px` (grids) o `1200px` (secciones amplias).
- **Gap en grids:** `24–32px`.
- **Margin entre párrafos:** `16–24px`.

## Border-radius

- Botones pill: `40px` (rounded-full vibe)
- Cards: `16–24px`
- Panel de detalle: `28px`
- Inputs: `12px`

## Sombras

Siempre tintadas con rose/marrón, nunca grises:
```css
box-shadow: 0 8px 28px rgba(201, 133, 138, 0.4);   /* CTA hover */
box-shadow: 0 10px 24px rgba(122, 84, 84, 0.2);    /* panel */
box-shadow: 0 20px 60px rgba(122, 84, 84, 0.08);   /* suave grande */
```

---

## Animaciones

### Easing estándar
Todo el sitio usa una curva suave:
```css
cubic-bezier(0.22, 1, 0.36, 1)
```

### Entradas con scroll (clase `.reveal`)
Elementos con `.reveal` empiezan con `opacity: 0; translateY(20px)` y se activan con un IntersectionObserver cuando entran al viewport.

### Hover de cards
- Levantar 2–4px (`translateY(-2px)`)
- Intensificar sombra
- Revelar barra de gradiente top (en service-cards)

### Carrusel (services inline)
- Grid colapsa: `max-height` + `opacity` + `margin` → 0 en `0.6s`
- Panel se abre: `max-height` de 0 a `2400px` en `0.7s`
- Slides se mueven con `transform: translateX(-N * 100%)` en `0.55s`

---

## Patrones de interacción

### Reveal inline vs modal
- **Modal/popup** → descartado. Interrumpe el flujo y se siente pesado.
- **Expansión inline** → patrón preferido. Las cards colapsan, el contenido crece en el mismo lugar, la página respira.

### Scroll al abrir panel
Al abrir el carrusel se hace `scrollTo` al top de la sección con offset de `60px`, para que el título "Mis Servicios" quede visible de contexto.

### Booking progresivo
Cada paso se habilita solo al completar el anterior. Los pasos bloqueados tienen opacidad baja y `pointer-events: none`.

---

## Iconografía

- Emojis seleccionados como íconos de servicios: 🧠 ✨ 🌊 💆 🌺 🌙
- Decoración tipográfica: `✦` en `--gold` (antes de items de lista).
- Estrellas de testimonios: `★★★★★` en `--gold`.

**No introducir nuevos emojis** sin alinear con la clienta — los actuales son intencionados.

---

## Imágenes del carrusel — flujo de limpieza

Las imágenes originales que pasa la clienta (diseñadas en Canva) vienen con **flechas de navegación pintadas** a los lados (arrows `‹ ›` decorativas del slider de Canva). Hay que quitarlas antes de montarlas en el carrusel del sitio — nuestro carrusel tiene sus propias flechas.

### Script para limpiar flechas de múltiples imágenes

Para imágenes con fondo uniforme (slides de texto puro):

```js
// Pseudocódigo — ejecutar con helper run_script o canvas local
const img = await readImage('input.png');
const canvas = createCanvas(img.width, img.height);
const ctx = canvas.getContext('2d');
ctx.drawImage(img, 0, 0);

// Muestrea color de fondo en zona limpia (arriba a la izquierda)
const d = ctx.getImageData(10, 30, 1, 1).data;
ctx.fillStyle = `rgb(${d[0]}, ${d[1]}, ${d[2]})`;

// Tapa las flechas (aprox. en el centro vertical, 60px de alto x 60px ancho)
const cy = Math.round(img.height * 0.505);
ctx.fillRect(5, cy - 30, 60, 60);                       // flecha izquierda
ctx.fillRect(img.width - 65, cy - 30, 60, 60);          // flecha derecha

await saveFile('output.png', canvas);
```

Para imágenes con **fondo fotográfico** (tipo la slide de frase sobre foto), no sirve rellenar con color plano — hay que clonar una franja adyacente y estirarla sobre la flecha:

```js
const sampleStrip = ctx.getImageData(80, cy - 30, 5, 60);
const tmp = createCanvas(5, 60);
tmp.getContext('2d').putImageData(sampleStrip, 0, 0);
ctx.drawImage(tmp, 0, 0, 5, 60, 10, cy - 30, 60, 60);   // estira la franja sobre la flecha
```

### Estructura de carpetas para imágenes
```
img/
└── <servicio>/
    ├── 01-portada.png
    ├── 02-<tema>.png
    ├── 03-<tema>.png
    └── ...
```

Nombres con prefijo numérico (`01-`, `02-`) para mantener orden determinista en el array de `SERVICE_DATA[servicio].slides`.

---

## Accesibilidad

- Contraste AA+ en todos los textos (rose sobre cream pasa, dark sobre cream excelente).
- `aria-label` en botones solo-ícono (flechas, cerrar, menú).
- `aria-hidden` en el panel de detalle cuando está cerrado.
- Navegación por teclado en carrusel: ← → Esc.
- Focus visible (estilos por defecto del navegador — considerar mejorarlos en futuro).

---

## Lo que NO hacemos

- ❌ Colores fuera de la paleta (ni "casi rose", ni grises neutros)
- ❌ Sombras grises puras (siempre tintadas)
- ❌ Fuentes distintas a Cormorant + Nunito
- ❌ Weights serif superiores a 500
- ❌ Animaciones bruscas (spring overshoots, bounces exagerados) — el tono es suave
- ❌ Modales popup para navegación de contenido
- ❌ Iconos genéricos tipo FontAwesome — usamos emoji seleccionado o caracteres unicode (`✦ ★ ‹ ›`)
- ❌ Gradientes de 3+ colores o arcoíris
- ❌ Emojis en el copy — solo como íconos decorativos de servicios
