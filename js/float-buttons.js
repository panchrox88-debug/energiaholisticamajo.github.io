/* float-buttons.js — Botones flotantes WA + Agendar en todas las páginas */
(function () {
  // ── CSS ──────────────────────────────────────────────────────────
  const style = document.createElement('style');
  style.textContent = `
    .wa-float {
      position: fixed; bottom: 28px; right: 28px; z-index: 999;
      width: 58px; height: 58px; border-radius: 50%;
      background: #25D366;
      display: flex; align-items: center; justify-content: center;
      box-shadow: 0 4px 20px rgba(37,211,102,0.45);
      transition: transform 0.2s cubic-bezier(0.22,1,0.36,1), box-shadow 0.2s;
      text-decoration: none;
    }
    .wa-float:hover { transform: scale(1.1); box-shadow: 0 6px 28px rgba(37,211,102,0.6); }
    .wa-float svg { width: 32px; height: 32px; fill: white; }
    .fl-agendar {
      display: none;
      position: fixed; bottom: 98px; right: 31px; z-index: 998;
      width: 52px; height: 52px; border-radius: 16px;
      background: linear-gradient(135deg, #c9858a 0%, #c4606b 100%);
      flex-direction: column; align-items: center; justify-content: center; gap: 2px;
      cursor: pointer; text-decoration: none;
      box-shadow: 0 4px 16px rgba(201,133,138,0.55);
      transition: transform 0.2s, box-shadow 0.2s;
    }
    .fl-agendar-emoji { font-size: 1.25rem; line-height: 1; }
    .fl-agendar-text {
      font-family: 'Nunito', sans-serif;
      font-size: 0.42rem; letter-spacing: 0.1em; text-transform: uppercase;
      color: rgba(255,255,255,0.92); white-space: nowrap;
    }
    .fl-agendar:hover { transform: scale(1.07); box-shadow: 0 6px 22px rgba(201,133,138,0.7); }
    @media (max-width: 900px) { .fl-agendar { display: flex; } }
  `;
  document.head.appendChild(style);

  // ── HTML ─────────────────────────────────────────────────────────
  // Botón WhatsApp
  const waBtn = document.createElement('a');
  waBtn.id = 'waBtnFloat';
  waBtn.className = 'wa-float';
  waBtn.href = '#';
  waBtn.target = '_blank';
  waBtn.rel = 'noopener';
  waBtn.setAttribute('aria-label', 'Contactar por WhatsApp');
  waBtn.innerHTML = `<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347m-5.421 7.403h-.004a9.87 9.87 0 01-5.031-1.378l-.361-.214-3.741.982.998-3.648-.235-.374a9.86 9.86 0 01-1.51-5.26c.001-5.45 4.436-9.884 9.888-9.884 2.64 0 5.122 1.03 6.988 2.898a9.825 9.825 0 012.893 6.994c-.003 5.45-4.437 9.884-9.885 9.884m8.413-18.297A11.815 11.815 0 0012.05 0C5.495 0 .16 5.335.157 11.892c0 2.096.547 4.142 1.588 5.945L.057 24l6.305-1.654a11.882 11.882 0 005.683 1.448h.005c6.554 0 11.89-5.335 11.893-11.893a11.821 11.821 0 00-3.48-8.413z"/></svg>`;
  document.body.appendChild(waBtn);

  // Botón Agendar — apunta a index.html#booking desde otras páginas
  const agBtn = document.createElement('a');
  agBtn.className = 'fl-agendar';
  agBtn.href = 'index.html#booking';
  agBtn.setAttribute('aria-label', 'Agendar sesión');
  agBtn.innerHTML = `<span class="fl-agendar-emoji">✨</span><span class="fl-agendar-text">Agendar</span>`;
  document.body.appendChild(agBtn);

  // ── Número WA desde Supabase ──────────────────────────────────────
  const url = typeof SB_URL !== 'undefined' ? SB_URL : null;
  const key = typeof SB_KEY !== 'undefined' ? SB_KEY : null;
  if (url && key) {
    fetch(`${url}/rest/v1/contacto?select=valor&tipo=eq.whatsapp&limit=1`, {
      headers: { 'apikey': key, 'Authorization': `Bearer ${key}` }
    })
      .then(r => r.json())
      .then(rows => {
        if (rows && rows[0] && rows[0].valor) {
          const num = rows[0].valor.replace(/\D/g, '');
          waBtn.href = `https://wa.me/${num}`;
        }
      })
      .catch(() => {});
  }
})();
