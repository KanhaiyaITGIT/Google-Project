<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>Simple Search - Learning Demo</title>
  <style>
    /* Basic reset */
    * { box-sizing: border-box; margin: 0; padding: 0; font-family: Inter, Arial, sans-serif; }

    body {
      min-height: 100vh;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      background: linear-gradient(180deg,#f8f9fa,#ffffff);
      color: #202124;
    }

    .logo {
      font-size: 64px;
      font-weight: 700;
      letter-spacing: 2px;
      margin-bottom: 24px;
      color: #4285F4; /* blue-ish - don't use Google logo */
      display: inline-block;
    }

    .search-card {
      width: min(760px, 94%);
      display: flex;
      flex-direction: column;
      align-items: center;
    }

    .search-box {
      width: 100%;
      display: flex;
      align-items: center;
      border: 1px solid #dfe1e5;
      border-radius: 24px;
      padding: 10px 14px;
      background: white;
      box-shadow: 0 1px 6px rgba(32,33,36,0.08);
    }

    .search-box input {
      flex: 1;
      font-size: 18px;
      border: none;
      outline: none;
      padding: 6px 10px;
    }

    .mic {
      width: 36px; height: 36px;
      display: inline-grid;
      place-items: center;
      border-radius: 50%;
      cursor: pointer;
    }

    .buttons {
      margin-top: 18px;
      display:flex;
      gap:10px;
      flex-wrap:wrap;
    }

    .btn {
      padding: 10px 18px;
      border-radius: 4px;
      border: 1px solid #dadce0;
      background: #f8f9fa;
      cursor: pointer;
      font-size: 14px;
    }

    .btn.primary {
      background: #1a73e8;
      color: white;
      border: none;
      padding: 10px 20px;
    }

    .footer {
      position: fixed;
      left:0; right:0; bottom:0;
      padding: 10px 20px;
      color:#5f6368;
      font-size: 13px;
      display:flex;
      justify-content:space-between;
      background: rgba(255,255,255,0.6);
      backdrop-filter: blur(4px);
    }

    @media (max-width:420px){
      .logo { font-size:48px; }
      .search-box input { font-size:16px; }
      .btn { padding:8px 12px; font-size:13px; }
    }
  </style>
</head>
<body>

  <div class="search-card" role="main">
    <div class="logo">SimpleSearch</div>

    <form id="searchForm" class="search-box" action="https://www.google.com/search" method="GET" target="_blank" aria-label="Search form">
      <!-- name="q" so it works with Google search -->
      <input id="q" name="q" type="search" placeholder="Search the web" aria-label="Search query" autocomplete="off" />
      <button type="button" class="mic" title="Voice (demo)" id="micBtn">🎤</button>
    </form>

    <div class="buttons">
      <button class="btn" id="searchBtn" type="button">Google Search</button>
      <button class="btn primary" id="luckyBtn" type="button">I'm Feeling Lucky</button>
    </div>
  </div>

  <div class="footer">
    <div>Country: India</div>
    <div>Learning demo • Not affiliated with Google</div>
  </div>

  <script>
    // Basic behaviour: wire buttons to the form
    const form = document.getElementById('searchForm');
    const q = document.getElementById('q');
    document.getElementById('searchBtn').addEventListener('click', () => {
      // open Google search in new tab using q param
      if (!q.value.trim()) {
        // If empty, redirect to google.com
        window.open('https://www.google.com', '_blank');
        return;
      }
      form.submit();
    });

    document.getElementById('luckyBtn').addEventListener('click', () => {
      // "I'm Feeling Lucky" - use Google's luck parameter
      // open in new tab with &btnI=I
      const query = encodeURIComponent(q.value.trim() || '');
      if (!query) {
        window.open('https://www.google.com/doodles', '_blank'); // fun fallback
        return;
      }
      window.open('https://www.google.com/search?q=' + query + '&btnI=I', '_blank');
    });

    // Optional: simple mic demo (uses Web Speech API if available)
    const micBtn = document.getElementById('micBtn');
    if (!('webkitSpeechRecognition' in window) && !('SpeechRecognition' in window)) {
      micBtn.title = 'Voice not supported in this browser';
      micBtn.style.opacity = 0.45;
    } else {
      const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
      const recog = new SpeechRecognition();
      recog.lang = 'en-US';
      recog.interimResults = false;
      recog.maxAlternatives = 1;

      micBtn.addEventListener('click', () => {
        try {
          recog.start();
          micBtn.textContent = '🎙️';
        } catch(e) { console.warn(e); }
      });

      recog.addEventListener('result', (ev) => {
        const text = ev.results[0][0].transcript;
        q.value = text;
      });
      recog.addEventListener('end', () => micBtn.textContent = '🎤');
      recog.addEventListener('error', () => micBtn.textContent = '🎤');
    }

    // small UX: press Enter in search box -> submit
    q.addEventListener('keydown', (e) => {
      if (e.key === 'Enter') {
        e.preventDefault();
        document.getElementById('searchBtn').click();
      }
    });
  </script>
</body>
</html>

