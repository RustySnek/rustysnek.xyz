// Color scheme management: persisted preference in localStorage ("theme"),
// defaulting to "pink". Users can opt into "auto", which rotates schemes every
// 5 minutes; the rotation index is derived from the clock so it stays in sync
// across reloads/tabs. The smooth cross-fade itself is handled in CSS via
// @property transitions.

export const THEMES = ["ice", "violet", "emerald", "pink"]
const ROTATE_MS = 5 * 60 * 1000
const STORAGE_KEY = "theme"

// Mirrors --theme-bg-2 per scheme, for the browser UI theme-color meta
const THEME_COLORS = {
  ice: "#0a1a2e",
  violet: "#1a0a2e",
  emerald: "#0a2e1c",
  pink: "#2e0a1f",
}

let rotateTimer = null

function storedPreference() {
  try {
    const value = localStorage.getItem(STORAGE_KEY)
    return THEMES.includes(value) || value === "auto" ? value : null
  } catch (_) {
    return null
  }
}

function autoTheme() {
  return THEMES[Math.floor(Date.now() / ROTATE_MS) % THEMES.length]
}

function applyTheme(name) {
  document.documentElement.dataset.theme = name
  document.querySelector('meta[name="theme-color"]')?.setAttribute("content", THEME_COLORS[name])
  updatePickerState()
}

function stopRotation() {
  clearTimeout(rotateTimer)
  rotateTimer = null
}

function startRotation() {
  stopRotation()
  applyTheme(autoTheme())
  const tick = () => {
    applyTheme(autoTheme())
    rotateTimer = setTimeout(tick, ROTATE_MS - (Date.now() % ROTATE_MS))
  }
  rotateTimer = setTimeout(tick, ROTATE_MS - (Date.now() % ROTATE_MS))
}

function setPreference(value) {
  try {
    localStorage.setItem(STORAGE_KEY, value)
  } catch (_) { /* private mode etc. - theme still applies for the session */ }

  if (value === "auto") {
    startRotation()
  } else {
    stopRotation()
    applyTheme(value)
  }
}

export function currentPreference() {
  return storedPreference() || "pink"
}

export function updatePickerState() {
  const preference = currentPreference()
  document.querySelectorAll("[data-theme-choice]").forEach((option) => {
    option.classList.toggle("active", option.dataset.themeChoice === preference)
  })
}

export function initTheme() {
  const preference = currentPreference()
  if (preference === "auto") {
    startRotation()
  } else {
    applyTheme(preference)
  }

  // Event delegation so the picker keeps working across LiveView navigations
  document.addEventListener("click", (event) => {
    const menu = document.getElementById("theme-menu")
    if (!menu) return

    if (event.target.closest("#theme-toggle")) {
      menu.classList.toggle("hidden")
      updatePickerState()
      return
    }

    const option = event.target.closest("[data-theme-choice]")
    if (option) {
      setPreference(option.dataset.themeChoice)
      menu.classList.add("hidden")
      return
    }

    menu.classList.add("hidden")
  })

  // Re-mark the active option after LiveView re-renders the header
  window.addEventListener("phx:page-loading-stop", updatePickerState)
}
