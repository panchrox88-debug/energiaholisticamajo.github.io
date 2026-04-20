// =========================================================
// js/auth.js — Energía Holística Majo
// Requiere: @supabase/supabase-js v2 CDN cargado antes,
//           SB_URL y SB_KEY definidos en la página.
// =========================================================

(function () {
  // ── Cliente ─────────────────────────────────────────────
  // Nota: SB_URL y SB_KEY son const en cada página → NO están en window.
  // Se acceden sin prefijo window (comparten scope global de scripts).
  const { createClient } = window.supabase;
  const _sb = createClient(SB_URL, SB_KEY);  // sin window.

  let _user   = null;
  let _perfil = null;

  // ── Inyectar modal ───────────────────────────────────────
  function _injectModal() {
    if (document.getElementById('authModal')) return;
    const div = document.createElement('div');
    div.id = 'authModal';
    div.style.cssText = 'display:none;position:fixed;inset:0;background:rgba(61,43,43,0.5);backdrop-filter:blur(6px);z-index:3000;align-items:center;justify-content:center;padding:20px';
    div.innerHTML = `
      <div style="background:#faf5f0;border-radius:22px;max-width:400px;width:100%;padding:40px 36px 32px;position:relative;box-shadow:0 24px 64px rgba(61,43,43,0.22);font-family:'Nunito',sans-serif">
        <button onclick="closeLogin()" style="position:absolute;top:14px;right:18px;background:none;border:none;font-size:1.5rem;color:#7a5c5c;cursor:pointer;line-height:1;padding:4px 8px">×</button>

        <p style="font-size:0.6rem;letter-spacing:0.38em;text-transform:uppercase;color:#c9a96e;margin-bottom:6px">Energía Holística Majo</p>
        <h2 style="font-family:'Cormorant Garamond',serif;font-size:2rem;font-weight:300;color:#3d2b2b;margin-bottom:6px;line-height:1.2">Bienvenida</h2>
        <p id="authModalSub" style="font-size:0.84rem;color:#7a5c5c;margin-bottom:28px;line-height:1.75">Inicia sesión para acceder a tu cuenta</p>

        <div style="display:flex;border-radius:12px;overflow:hidden;border:1.5px solid #ede0d4;margin-bottom:26px">
          <button id="authTabLogin"  onclick="authSetTab('login')"    style="flex:1;padding:10px 8px;border:none;cursor:pointer;font-family:'Nunito',sans-serif;font-size:0.75rem;letter-spacing:0.15em;text-transform:uppercase;transition:all 0.2s">Ingresar</button>
          <button id="authTabReg"    onclick="authSetTab('register')" style="flex:1;padding:10px 8px;border:none;cursor:pointer;font-family:'Nunito',sans-serif;font-size:0.75rem;letter-spacing:0.15em;text-transform:uppercase;transition:all 0.2s">Crear cuenta</button>
        </div>

        <div id="authFormLogin">
          <!-- Google -->
          <button onclick="doGoogle()"
            style="width:100%;padding:11px 16px;background:white;color:#3d2b2b;border:1.5px solid #ede0d4;border-radius:40px;font-family:'Nunito',sans-serif;font-size:0.82rem;letter-spacing:0.08em;cursor:pointer;display:flex;align-items:center;justify-content:center;gap:10px;margin-bottom:16px;transition:border-color 0.2s">
            <svg width="18" height="18" viewBox="0 0 48 48"><path fill="#EA4335" d="M24 9.5c3.54 0 6.71 1.22 9.21 3.6l6.85-6.85C35.9 2.38 30.47 0 24 0 14.62 0 6.51 5.38 2.56 13.22l7.98 6.19C12.43 13.72 17.74 9.5 24 9.5z"/><path fill="#4285F4" d="M46.98 24.55c0-1.57-.15-3.09-.38-4.55H24v9.02h12.94c-.58 2.96-2.26 5.48-4.78 7.18l7.73 6c4.51-4.18 7.09-10.36 7.09-17.65z"/><path fill="#FBBC05" d="M10.53 28.59c-.48-1.45-.76-2.99-.76-4.59s.27-3.14.76-4.59l-7.98-6.19C.92 16.46 0 20.12 0 24c0 3.88.92 7.54 2.56 10.78l7.97-6.19z"/><path fill="#34A853" d="M24 48c6.48 0 11.93-2.13 15.89-5.81l-7.73-6c-2.18 1.48-4.97 2.36-8.16 2.36-6.26 0-11.57-4.22-13.47-9.91l-7.98 6.19C6.51 42.62 14.62 48 24 48z"/><path fill="none" d="M0 0h48v48H0z"/></svg>
            Continuar con Google
          </button>
          <div style="display:flex;align-items:center;gap:10px;margin-bottom:16px">
            <div style="flex:1;height:1px;background:#ede0d4"></div>
            <span style="font-size:0.72rem;color:#b0948e;letter-spacing:0.1em">o</span>
            <div style="flex:1;height:1px;background:#ede0d4"></div>
          </div>
          <input id="authEmail" type="email" placeholder="tu@correo.com"
            style="width:100%;padding:12px 16px;border:1.5px solid #ede0d4;border-radius:11px;font-family:'Nunito',sans-serif;font-size:0.88rem;background:white;outline:none;margin-bottom:11px;box-sizing:border-box;color:#3d2b2b"/>
          <input id="authPass" type="password" placeholder="Contraseña"
            style="width:100%;padding:12px 16px;border:1.5px solid #ede0d4;border-radius:11px;font-family:'Nunito',sans-serif;font-size:0.88rem;background:white;outline:none;margin-bottom:14px;box-sizing:border-box;color:#3d2b2b"/>
          <button id="authLoginBtn" onclick="doLogin()"
            style="width:100%;padding:13px;background:#c9858a;color:white;border:none;border-radius:40px;font-family:'Nunito',sans-serif;font-size:0.78rem;font-weight:400;letter-spacing:0.2em;text-transform:uppercase;cursor:pointer;margin-bottom:11px">
            Ingresar →
          </button>
          <button onclick="doMagicLink()"
            style="width:100%;padding:11px;background:transparent;color:#7a5c5c;border:1.5px solid #ede0d4;border-radius:40px;font-family:'Nunito',sans-serif;font-size:0.75rem;letter-spacing:0.15em;text-transform:uppercase;cursor:pointer">
            Enviar enlace mágico
          </button>
        </div>

        <div id="authFormReg" style="display:none">
          <button onclick="doGoogle()"
            style="width:100%;padding:11px 16px;background:white;color:#3d2b2b;border:1.5px solid #ede0d4;border-radius:40px;font-family:'Nunito',sans-serif;font-size:0.82rem;letter-spacing:0.08em;cursor:pointer;display:flex;align-items:center;justify-content:center;gap:10px;margin-bottom:16px">
            <svg width="18" height="18" viewBox="0 0 48 48"><path fill="#EA4335" d="M24 9.5c3.54 0 6.71 1.22 9.21 3.6l6.85-6.85C35.9 2.38 30.47 0 24 0 14.62 0 6.51 5.38 2.56 13.22l7.98 6.19C12.43 13.72 17.74 9.5 24 9.5z"/><path fill="#4285F4" d="M46.98 24.55c0-1.57-.15-3.09-.38-4.55H24v9.02h12.94c-.58 2.96-2.26 5.48-4.78 7.18l7.73 6c4.51-4.18 7.09-10.36 7.09-17.65z"/><path fill="#FBBC05" d="M10.53 28.59c-.48-1.45-.76-2.99-.76-4.59s.27-3.14.76-4.59l-7.98-6.19C.92 16.46 0 20.12 0 24c0 3.88.92 7.54 2.56 10.78l7.97-6.19z"/><path fill="#34A853" d="M24 48c6.48 0 11.93-2.13 15.89-5.81l-7.73-6c-2.18 1.48-4.97 2.36-8.16 2.36-6.26 0-11.57-4.22-13.47-9.91l-7.98 6.19C6.51 42.62 14.62 48 24 48z"/><path fill="none" d="M0 0h48v48H0z"/></svg>
            Registrarse con Google
          </button>
          <div style="display:flex;align-items:center;gap:10px;margin-bottom:16px">
            <div style="flex:1;height:1px;background:#ede0d4"></div>
            <span style="font-size:0.72rem;color:#b0948e;letter-spacing:0.1em">o</span>
            <div style="flex:1;height:1px;background:#ede0d4"></div>
          </div>
          <input id="regNombre" type="text" placeholder="Tu nombre"
            style="width:100%;padding:12px 16px;border:1.5px solid #ede0d4;border-radius:11px;font-family:'Nunito',sans-serif;font-size:0.88rem;background:white;outline:none;margin-bottom:11px;box-sizing:border-box;color:#3d2b2b"/>
          <input id="regEmail" type="email" placeholder="tu@correo.com"
            style="width:100%;padding:12px 16px;border:1.5px solid #ede0d4;border-radius:11px;font-family:'Nunito',sans-serif;font-size:0.88rem;background:white;outline:none;margin-bottom:11px;box-sizing:border-box;color:#3d2b2b"/>
          <input id="regPass" type="password" placeholder="Contraseña (mín. 6 caracteres)"
            style="width:100%;padding:12px 16px;border:1.5px solid #ede0d4;border-radius:11px;font-family:'Nunito',sans-serif;font-size:0.88rem;background:white;outline:none;margin-bottom:14px;box-sizing:border-box;color:#3d2b2b"/>
          <button id="authRegBtn" onclick="doRegister()"
            style="width:100%;padding:13px;background:#c9858a;color:white;border:none;border-radius:40px;font-family:'Nunito',sans-serif;font-size:0.78rem;font-weight:400;letter-spacing:0.2em;text-transform:uppercase;cursor:pointer">
            Crear cuenta →
          </button>
        </div>

        <p id="authMsg" style="margin-top:14px;font-size:0.82rem;min-height:18px;text-align:center;line-height:1.6;color:#7a5c5c"></p>
      </div>`;
    document.body.appendChild(div);
    div.addEventListener('click', e => { if (e.target === div) closeLogin(); });
    authSetTab('login');
  }

  // ── Perfil ───────────────────────────────────────────────
  async function _loadPerfil(userId, token) {
    try {
      const res = await fetch(`${SB_URL}/rest/v1/perfiles?id=eq.${userId}&select=*`, {
        headers: { 'apikey': SB_KEY, 'Authorization': 'Bearer ' + token }
      });
      const rows = await res.json();
      _perfil = Array.isArray(rows) ? (rows[0] || null) : null;
    } catch (e) { _perfil = null; }
  }

  // ── API pública ──────────────────────────────────────────
  window.openLogin = function (subtitle) {
    _injectModal();
    const m = document.getElementById('authModal');
    if (subtitle) document.getElementById('authModalSub').textContent = subtitle;
    m.style.display = 'flex';
    document.getElementById('authMsg').textContent = '';
    authSetTab('login');
  };

  window.closeLogin = function () {
    const m = document.getElementById('authModal');
    if (m) m.style.display = 'none';
  };

  window.authSetTab = function (tab) {
    const isLogin = tab === 'login';
    document.getElementById('authFormLogin').style.display = isLogin ? '' : 'none';
    document.getElementById('authFormReg').style.display  = isLogin ? 'none' : '';
    const tl = document.getElementById('authTabLogin');
    const tr = document.getElementById('authTabReg');
    if (tl && tr) {
      tl.style.background = isLogin ? '#c9858a' : '#faf5f0';
      tl.style.color      = isLogin ? 'white'   : '#7a5c5c';
      tr.style.background = isLogin ? '#faf5f0'  : '#c9858a';
      tr.style.color      = isLogin ? '#7a5c5c'  : 'white';
    }
    const msg = document.getElementById('authMsg');
    if (msg) msg.textContent = '';
  };

  window.doLogin = async function () {
    const email = (document.getElementById('authEmail')?.value || '').trim();
    const pass  =  document.getElementById('authPass')?.value || '';
    const btn   =  document.getElementById('authLoginBtn');
    const msg   =  document.getElementById('authMsg');
    if (!email || !pass) { _setMsg(msg, 'Completa todos los campos.', 'err'); return; }
    btn.textContent = 'Ingresando…'; btn.disabled = true;
    const { error } = await _sb.auth.signInWithPassword({ email, password: pass });
    if (error) {
      _setMsg(msg, error.message.includes('Invalid') ? 'Correo o contraseña incorrectos.' : error.message, 'err');
      btn.textContent = 'Ingresar →'; btn.disabled = false;
    } else {
      _setMsg(msg, '¡Bienvenida! Cargando…', 'ok');
      setTimeout(closeLogin, 1200);
    }
  };

  window.doRegister = async function () {
    const nombre = (document.getElementById('regNombre')?.value || '').trim();
    const email  = (document.getElementById('regEmail')?.value  || '').trim();
    const pass   =  document.getElementById('regPass')?.value  || '';
    const btn    =  document.getElementById('authRegBtn');
    const msg    =  document.getElementById('authMsg');
    if (!nombre || !email || !pass) { _setMsg(msg, 'Completa todos los campos.', 'err'); return; }
    if (pass.length < 6) { _setMsg(msg, 'La contraseña debe tener al menos 6 caracteres.', 'err'); return; }
    btn.textContent = 'Creando cuenta…'; btn.disabled = true;
    const { error } = await _sb.auth.signUp({ email, password: pass, options: { data: { nombre } } });
    if (error) {
      _setMsg(msg, error.message, 'err');
    } else {
      _setMsg(msg, '¡Cuenta creada! Revisa tu correo para confirmar tu registro.', 'ok');
    }
    btn.textContent = 'Crear cuenta →'; btn.disabled = false;
  };

  window.doMagicLink = async function () {
    const email = (document.getElementById('authEmail')?.value || '').trim();
    const msg   =  document.getElementById('authMsg');
    if (!email) { _setMsg(msg, 'Ingresa tu correo primero.', 'err'); return; }
    const { error } = await _sb.auth.signInWithOtp({ email });
    _setMsg(msg, error ? error.message : '¡Enlace enviado! Revisa tu correo.', error ? 'err' : 'ok');
  };

  window.doGoogle = async function () {
    const { error } = await _sb.auth.signInWithOAuth({
      provider: 'google',
      options: { redirectTo: location.href }
    });
    if (error) {
      const msg = document.getElementById('authMsg');
      if (msg) { msg.textContent = error.message; msg.style.color = '#c9585a'; }
    }
  };

  window.doLogout = async function () {
    await _sb.auth.signOut();
    _user = null; _perfil = null;
  };

  window.getAuthUser   = () => _user;
  window.getAuthPerfil = () => _perfil;
  window.isAdmin       = () => _perfil?.rol === 'admin';
  window.getAuthToken  = async function () {
    const { data: { session } } = await _sb.auth.getSession();
    return session?.access_token || SB_KEY;  // sin window.
  };

  window.initAuth = async function (onReady) {
    _injectModal();
    const { data: { session } } = await _sb.auth.getSession();
    if (session) {
      _user = session.user;
      await _loadPerfil(_user.id, session.access_token);
    }
    _sb.auth.onAuthStateChange(async (event, session) => {
      _user = session?.user || null;
      if (_user) await _loadPerfil(_user.id, session.access_token);
      else _perfil = null;
      if (onReady) onReady(_user, _perfil);
    });
    if (onReady) onReady(_user, _perfil);
  };

  function _setMsg(el, txt, type) {
    if (!el) return;
    el.textContent = txt;
    el.style.color = type === 'ok' ? '#2d6a4f' : '#c9585a';
  }

  document.addEventListener('keydown', e => { if (e.key === 'Escape') closeLogin(); });
})();
