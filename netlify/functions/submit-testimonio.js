// Netlify Function: recibe un testimonio del formulario y lo agrega a
// content/testimonios.json vía GitHub API con visible:false (pendiente de aprobación)

const OWNER  = 'panchrox88-debug';
const REPO   = 'energiaholisticamajo.github.io';
const PATH   = 'content/testimonios.json';
const BRANCH = 'main';
const EMOJIS = ['🌸', '✨', '🌙', '🌺', '🌊', '💫', '🕊️', '🦋'];

exports.handler = async (event) => {
  // Solo POST
  if (event.httpMethod !== 'POST') {
    return { statusCode: 405, body: 'Método no permitido' };
  }

  // Parsear body
  let payload;
  try {
    payload = JSON.parse(event.body);
  } catch {
    return { statusCode: 400, body: 'JSON inválido' };
  }

  const nombre = (payload.nombre || '').trim();
  const ciudad = (payload.ciudad || '').trim();
  const texto  = (payload.texto  || '').trim();

  if (!nombre || !texto) {
    return { statusCode: 400, body: 'Faltan campos obligatorios' };
  }

  const token = process.env.GITHUB_TOKEN;
  if (!token) {
    return { statusCode: 500, body: 'Token de GitHub no configurado' };
  }

  const headers = {
    Authorization: `Bearer ${token}`,
    Accept: 'application/vnd.github.v3+json',
    'Content-Type': 'application/json',
    'User-Agent': 'energiaholistica-cms',
  };

  // 1. Leer archivo actual de GitHub
  const getRes = await fetch(
    `https://api.github.com/repos/${OWNER}/${REPO}/contents/${PATH}?ref=${BRANCH}`,
    { headers }
  );

  if (!getRes.ok) {
    return { statusCode: 500, body: 'No se pudo leer testimonios.json' };
  }

  const fileData = await getRes.json();
  const currentContent = JSON.parse(
    Buffer.from(fileData.content, 'base64').toString('utf-8')
  );

  // 2. Agregar nuevo testimonio (visible: false — pendiente de aprobación)
  const emoji = EMOJIS[Math.floor(Math.random() * EMOJIS.length)];
  currentContent.lista.push({
    nombre,
    ciudad,
    texto,
    emoji,
    visible: false,
  });

  // 3. Commit via GitHub API
  const newContent = Buffer.from(
    JSON.stringify(currentContent, null, 2)
  ).toString('base64');

  const putRes = await fetch(
    `https://api.github.com/repos/${OWNER}/${REPO}/contents/${PATH}`,
    {
      method: 'PUT',
      headers,
      body: JSON.stringify({
        message: `testimonio: nuevo envío de ${nombre} (pendiente de aprobación)`,
        content: newContent,
        sha: fileData.sha,
        branch: BRANCH,
      }),
    }
  );

  if (!putRes.ok) {
    const err = await putRes.text();
    console.error('GitHub API error:', err);
    return { statusCode: 500, body: 'No se pudo guardar el testimonio' };
  }

  return {
    statusCode: 200,
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ ok: true }),
  };
};
