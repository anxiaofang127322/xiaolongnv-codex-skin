((cssText, artDataUrl, logoDataUrl) => {
  const STATE_KEY = "__CODEX_DREAM_SKIN_STATE__";
  const STYLE_ID = "codex-dream-skin-style";
  const CHROME_ID = "codex-dream-skin-chrome";
  window.__CODEX_DREAM_SKIN_DISABLED__ = false;

  const previous = window[STATE_KEY];
  if (previous?.observer) previous.observer.disconnect();
  if (previous?.timer) clearInterval(previous.timer);
  if (previous?.scheduler?.timeout) clearTimeout(previous.scheduler.timeout);
  const artUrl = previous?.artUrl || (() => {
    const comma = artDataUrl.indexOf(",");
    const binary = atob(artDataUrl.slice(comma + 1));
    const bytes = new Uint8Array(binary.length);
    for (let index = 0; index < binary.length; index += 1) bytes[index] = binary.charCodeAt(index);
    return URL.createObjectURL(new Blob([bytes], { type: "image/png" }));
  })();
  const existingStyle = document.getElementById(STYLE_ID);
  if (existingStyle) {
    existingStyle.textContent = cssText;
    existingStyle.dataset.dreamVersion = "1";
  }

  const updateConnectorMap = (chrome, home) => {
    const orbit = chrome.querySelector(".dream-orbit-logo");
    const svg = chrome.querySelector(".dream-connector-map");
    const disc = chrome.querySelector(".dream-logo-disc");
    const paths = [...(svg?.querySelectorAll("path") || [])];
    const dots = [...(svg?.querySelectorAll("circle") || [])];
    const buttons = [...home.querySelectorAll('section[class*="home-suggestions"] button')].slice(0, 4);
    if (!orbit || !svg || !disc || paths.length !== 4 || dots.length !== 8 || buttons.length < 1) return;

    orbit.style.transform = "none";
    const buttonBoxes = buttons.map((button) => button.getBoundingClientRect());
    const baseDiscBox = disc.getBoundingClientRect();
    const firstCenterY = buttonBoxes[0].top + buttonBoxes[0].height / 2;
    const lastBox = buttonBoxes[buttonBoxes.length - 1];
    const lastCenterY = lastBox.top + lastBox.height / 2;
    const groupCenterY = (firstCenterY + lastCenterY) / 2;
    const deltaX = buttonBoxes[0].left - baseDiscBox.right - 48;
    const deltaY = groupCenterY - (baseDiscBox.top + baseDiscBox.height / 2);
    orbit.style.transform = `translate(${deltaX}px, ${deltaY}px)`;

    const svgBox = svg.getBoundingClientRect();
    const discBox = disc.getBoundingClientRect();
    if (svgBox.width <= 0 || svgBox.height <= 0 || discBox.width <= 0) return;
    const local = (x, y) => ({
      x: (x - svgBox.left) * 170 / svgBox.width,
      y: (y - svgBox.top) * 210 / svgBox.height,
    });
    const centerX = discBox.left + discBox.width / 2;
    const centerY = discBox.top + discBox.height / 2;
    const radius = discBox.width / 2 - 2;

    const bends = buttons.length === 3 ? [-6, 0, 6] : [-8, -3, 3, 8];
    paths.forEach((path, index) => {
      const pathDots = [dots[index * 2], dots[index * 2 + 1]];
      if (!buttons[index]) {
        path.style.display = "none";
        pathDots.forEach((dot) => { dot.style.display = "none"; });
        return;
      }
      path.style.display = "";
      pathDots.forEach((dot) => { dot.style.display = ""; });
      const buttonBox = buttonBoxes[index];
      const targetX = buttonBox.left + 2;
      const targetY = buttonBox.top + buttonBox.height / 2;
      const angle = Math.atan2(targetY - centerY, targetX - centerX);
      const start = local(centerX + Math.cos(angle) * radius, centerY + Math.sin(angle) * radius);
      const end = local(targetX, targetY);
      const dx = end.x - start.x;
      const bend = bends[index];
      const control = {
        x: start.x + dx * .56,
        y: (start.y + end.y) / 2 + bend,
      };
      path.setAttribute("d", `M ${start.x} ${start.y} Q ${control.x} ${control.y}, ${end.x} ${end.y}`);
      const length = path.getTotalLength();
      [0.42, 0.76].forEach((ratio, dotIndex) => {
        const point = path.getPointAtLength(length * ratio);
        const dot = dots[index * 2 + dotIndex];
        dot.setAttribute("cx", point.x);
        dot.setAttribute("cy", point.y);
      });
    });
  };

  const findHome = () => {
    const legacyHome = document.querySelector('[role="main"]:has([data-testid="home-icon"])');
    if (legacyHome) return legacyHome;
    for (const source of document.querySelectorAll('[data-feature="game-source"]')) {
      const candidate = source.closest('[role="main"]');
      if (candidate?.querySelector('section[class*="home-suggestions"]') &&
          candidate.querySelector('.composer-surface-chrome')) return candidate;
    }
    return null;
  };

  const ensure = () => {
    if (window.__CODEX_DREAM_SKIN_DISABLED__) return;
    const root = document.documentElement;
    if (!root) return;
    root.classList.add("codex-dream-skin");
    root.style.setProperty("--dream-art", `url("${artUrl}")`);
    root.style.setProperty("--dream-logo", `url("${logoDataUrl}")`);

    let style = document.getElementById(STYLE_ID);
    if (!style) {
      style = document.createElement("style");
      style.id = STYLE_ID;
      (document.head || root).appendChild(style);
    }
    if (style.dataset.dreamVersion !== "1") {
      style.textContent = cssText;
      style.dataset.dreamVersion = "1";
    }

    const shellMain = document.querySelector("main.main-surface") || document.querySelector("main");
    const home = findHome();
    for (const candidate of document.querySelectorAll('[role="main"].dream-home')) {
      if (candidate !== home) candidate.classList.remove("dream-home");
    }
    if (home) home.classList.add("dream-home");

    if (!shellMain || !document.body) return;
    shellMain.classList.toggle("dream-home-shell", Boolean(home));
    let chrome = document.getElementById(CHROME_ID);
    if (!chrome || chrome.parentElement !== document.body) {
      chrome?.remove();
      chrome = document.createElement("div");
      chrome.id = CHROME_ID;
      chrome.setAttribute("aria-hidden", "true");
      document.body.appendChild(chrome);
    }
    if (chrome.querySelector(".dream-connector-map")?.dataset.layout !== "dynamic-v2") {
      chrome.innerHTML = `
        <div class="dream-copy" aria-hidden="true">
          <span class="dream-copy-welcome">欢迎回来，李嘉图</span>
          <span class="dream-copy-title">我们该构建什么？</span>
          <span class="dream-copy-tagline">心若澄明，代码自有章法。</span>
        </div>
        <div class="dream-orbit-logo" aria-hidden="true">
          <svg class="dream-connector-map" data-layout="dynamic-v2" viewBox="0 0 170 210" aria-hidden="true">
            <path></path><path></path><path></path><path></path>
            <circle r="3"></circle><circle r="2.5"></circle>
            <circle r="2.5"></circle><circle r="3"></circle>
            <circle r="3"></circle><circle r="2.5"></circle>
            <circle r="2.5"></circle><circle r="3"></circle>
          </svg>
          <div class="dream-logo-disc"><span class="dream-logo-mark"></span></div>
        </div>`;
    }
    const shellBox = shellMain.getBoundingClientRect();
    root.style.setProperty("--dream-main-left", `${Math.round(shellBox.left)}px`);
    chrome.style.left = `${Math.round(shellBox.left)}px`;
    chrome.style.top = `${Math.round(shellBox.top)}px`;
    chrome.style.width = `${Math.round(shellBox.width)}px`;
    chrome.style.height = `${Math.round(shellBox.height)}px`;
    chrome.classList.toggle("dream-home-shell", Boolean(home));
    if (home) requestAnimationFrame(() => updateConnectorMap(chrome, home));
  };

  const cleanup = () => {
    window.__CODEX_DREAM_SKIN_DISABLED__ = true;
    document.documentElement?.classList.remove("codex-dream-skin");
    document.documentElement?.style.removeProperty("--dream-art");
    document.documentElement?.style.removeProperty("--dream-logo");
    document.documentElement?.style.removeProperty("--dream-main-left");
    document.querySelectorAll(".dream-home").forEach((node) => node.classList.remove("dream-home"));
    document.querySelectorAll(".dream-home-shell").forEach((node) => node.classList.remove("dream-home-shell"));
    document.getElementById(STYLE_ID)?.remove();
    document.getElementById(CHROME_ID)?.remove();
    const state = window[STATE_KEY];
    state?.observer?.disconnect();
    if (state?.timer) clearInterval(state.timer);
    if (state?.scheduler?.timeout) clearTimeout(state.scheduler.timeout);
    if (state?.artUrl) URL.revokeObjectURL(state.artUrl);
    delete window[STATE_KEY];
    return true;
  };

  const scheduler = { timeout: null };
  const scheduleEnsure = () => {
    if (scheduler.timeout) clearTimeout(scheduler.timeout);
    scheduler.timeout = setTimeout(() => {
      scheduler.timeout = null;
      ensure();
    }, 180);
  };
  const observer = new MutationObserver(scheduleEnsure);
  observer.observe(document.documentElement, { childList: true, subtree: true });
  const timer = setInterval(ensure, 5000);
  window[STATE_KEY] = { ensure, cleanup, observer, timer, scheduler, artUrl, version: __DREAM_SKIN_VERSION_JSON__ };
  ensure();
  return { installed: true, version: __DREAM_SKIN_VERSION_JSON__ };
})(__DREAM_CSS_JSON__, __DREAM_ART_JSON__, __DREAM_LOGO_JSON__)
