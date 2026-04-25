# Energía Holística Majo — Contexto del Proyecto

Sitio web para **Majo**, psicoterapeuta transpersonal. Sistema completo: sitio público + panel admin + reservas con Supabase.

**Repo:** `panchrox88-debug/energiaholisticamajo.github.io` (GitHub Pages, rama `main`)

---

## Stack y reglas inamovibles

- HTML + CSS + JS vanilla inline. **Sin frameworks, sin dependencias externas.**
- Fuentes: **Cormorant Garamond** (titulares) + **Nunito** (cuerpo). No cambiar.
- Paleta de colores solo con variables CSS (`--rose`, `--gold`, `--cream`, `--beige`, `--dark`, `--muted`, `--blush`, `--rose-lt`, `--gold-lt`, `--white`, `--green`, `--red`). No inventar colores.
- Breakpoint responsive: `900px`.
- **Preguntar antes de añadir secciones o contenido nuevo** — la clienta decide.

## Supabase

- URL: `https://yvuzccxqkkytuisgzpqx.supabase.co`
- Anon key: `sb_publishable_FIYlXkb_cpgXlWW8zF8Gww_sDNLFegi`
- Storage: bucket `uploads` (imágenes), bucket `documentos` (PDFs)

---

## Archivos principales

| Archivo | Propósito |
|---------|-----------|
| `index.html` | Sitio público (SPA) |
| `admin/index.html` | Panel admin (solo Majo) |
| `mis-sesiones.html` | Reservas del usuario autenticado |
| `mis-cursos.html` | Cursos del usuario autenticado |
| `cursos.html` / `curso.html` | Listado y vista de curso |
| `promociones.html` / `blog.html` | Páginas secundarias |

---

## Flujo de reservas (decisiones definitivas)

1. **Cliente reserva en `index.html`** → `INSERT reservas` con `estado='confirmada'`. Campos: `servicio_id, servicio_nombre, modalidad, fecha, hora_inicio, hora_fin, nombre_cliente, email_cliente, telefono_cliente`. Teléfono es **obligatorio**.

2. **Slots ocupados** se detectan con `SELECT hora_inicio FROM reservas WHERE fecha=X AND estado != 'cancelada'`. La columna es **`hora_inicio`**, no `hora`.

3. **Reagendamiento (cliente)** en `mis-sesiones.html` → `PATCH reservas SET estado='reagendar_solicitado', nueva_fecha_propuesta=YYYY-MM-DD, nueva_hora_propuesta='HH:MM|HH:MM', notas_reagendar=texto`.

4. **Confirmar reagendamiento (admin)** → aplica `nueva_fecha_propuesta` → `fecha`, parsea `nueva_hora_propuesta` como `"inicio|fin"` → `hora_inicio` + `hora_fin`, luego limpia esos campos y pone `estado='confirmada'`.

5. Cards de reserva en admin tienen `id="res-${id}"` (prefijo `res-`, no `reserva-`).

---

## Agenda/Horarios (tabla `agenda`, id=1)

- `hora_inicio/fin` global, `duracion_sesion` (min), `pausa_minutos`, `descanso_desde/hasta`
- `dias_habiles[]` (0=Dom…6=Sáb), `fechas_bloqueadas[]` (YYYY-MM-DD)
- `horarios_por_dia{}` — override por día: `{ "6": { hora_inicio, hora_fin, modalidad } }`
- `planificacion_semanas{}` — key = lunes de la semana: `{ "2026-04-28": { modalidad: "presencial" } }`
- `dias_adelante` — días a futuro en el calendario

---

## Pendientes

- [ ] Google Calendar: widget listo, falta conectar con Apps Script (sin acceso al correo del servicio aún)
- [ ] Imágenes carrusel para servicios: psico, limpieza, masaje, útero, círculos (solo Reiki tiene imágenes)
