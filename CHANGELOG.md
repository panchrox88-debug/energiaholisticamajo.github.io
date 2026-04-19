# Changelog

Notas de cambios principales al proyecto. Ordenado del más reciente al más antiguo.

---

## [Servicios con carrusel expandible inline]

### Añadido
- **Carrusel inline en sección "Mis Servicios"** — al hacer click en una tarjeta de servicio, el grid de tarjetas se colapsa suavemente y se despliega un panel elegante con:
  - Título del servicio + divisor dorado
  - Carrusel con flechas (`‹ ›`), puntitos indicadores, contador "N / total"
  - Botón "Reservar esta sesión →" que cierra el panel y baja a la sección de reserva
- Navegación por teclado (← → Esc) y swipe en móvil.
- Primer servicio con contenido: **Reiki Usui** (5 slides).

### Archivos nuevos
- `img/reiki/01-portada.png` — portada "REIKI · Donde hay energía, hay sanación"
- `img/reiki/02-frase.png` — "El Reiki llega donde las palabras no"
- `img/reiki/03-descripcion.png` — descripción del servicio Reiki Usui
- `img/reiki/04-beneficios.png` — lista de beneficios
- `img/reiki/05-incluye.png` — "¿Qué incluye esta sesión?"

### Cambiado
- Las tarjetas de servicios ahora tienen atributo `data-service` para identificarlas.
- Las tarjetas sin slides (`SERVICE_DATA[x].slides = []`) reciben `data-empty` y no son clicables.

### Descartado
- Primera iteración usaba un **modal popup** con fondo oscuro — se descartó a favor del panel inline expandible (más elegante, se integra con el flujo de la página).

---

## [Booking por WhatsApp — ajuste de formato]

### Corregido
- El mensaje enviado a WhatsApp usaba guiones `-` al inicio de línea (`- Servicio: Reiki`), y WhatsApp los renderiza como bullets `·` al recibir. Cambiado a formato `Etiqueta: valor` sin guiones.

### Notas
- El botón de confirmación construye un mensaje con `encodeURIComponent` y abre `https://wa.me/<numero>?text=...`.
- Ejemplo de formato actual:
  ```
  Hola Majo! Quisiera reservar una sesión:

  Servicio: Reiki Usui
  Modalidad: Presencial
  Día: Jueves 20 de noviembre
  Hora: 16:00
  ```

---

## [Base del sitio]

Sitio de una sola página con:
- Nav con CTA sticky
- Hero con titular grande + eyebrow dorado
- About con tarjeta de Majo
- Services (grid 3×2)
- Testimonials
- CTA banner
- Contact form
- Booking de 4 pasos que envía a WhatsApp
- Footer

Paleta: rose + gold + cream. Fuentes: Cormorant Garamond + Nunito.

---

## Formato

Usar este changelog como bitácora cronológica de decisiones importantes. No hace falta ser exhaustivo con cada tweak CSS — solo cambios que alguien retomando el proyecto necesitaría saber.
