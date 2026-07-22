// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

const plugin = require("tailwindcss/plugin")
const fs = require("fs")
const path = require("path")

// Resolves a theme CSS variable while keeping Tailwind opacity modifiers
// (e.g. border-neon-purple/30) working via color-mix.
const themeColor = (variable) =>
  `color-mix(in srgb, var(${variable}) calc(<alpha-value> * 100%), transparent)`

const alphaMix = (variable, percent) =>
  `color-mix(in srgb, var(${variable}) ${percent}%, transparent)`

module.exports = {
  content: [
    "./js/**/*.js",
    "../lib/rustysnek_web.ex",
    "../lib/rustysnek_web/**/*.*ex"
  ],
  darkMode: 'class',
  theme: {
    extend: {
      fontFamily: {
        inter: ['Inter'],
        quicksand: ["QuickSand"]
      },
      colors: {
        // Theme colors resolve through CSS variables (see app.css) so all
        // existing neon-* classes follow the active [data-theme] scheme.
        neon: {
          purple: themeColor("--theme-primary"),
          "purple-light": themeColor("--theme-light"),
          "purple-dark": themeColor("--theme-dark"),
          "purple-glow": themeColor("--theme-glow"),
          pink: themeColor("--theme-accent"),
          "pink-glow": themeColor("--theme-accent-glow"),
          cyan: themeColor("--theme-secondary"),
          "cyan-glow": themeColor("--theme-secondary-glow"),
        },
        // Neutral reading colors (see --theme-text in app.css): `ink` for body
        // copy, `ink-muted` for secondary/metadata text.
        ink: {
          DEFAULT: themeColor("--theme-text"),
          muted: themeColor("--theme-text-muted"),
        },
        glass: {
          dark: "rgba(17, 24, 39, 0.7)",
          darker: "rgba(7, 12, 21, 0.8)",
          purple: "color-mix(in srgb, var(--theme-primary) 10%, transparent)",
          "purple-light": "color-mix(in srgb, var(--theme-light) 15%, transparent)",
        },
        primary: { "50": "#fdf4ff", "100": "#fae8ff", "200": "#f5d0fe", "300": "#f0abfc", "400": "#e879f9", "500": "#d946ef", "600": "#c026d3", "700": "#a21caf", "800": "#86198f", "900": "#701a75", "950": "#4a044e" }
      },
      boxShadow: {
        'neon-purple': `0 0 20px ${alphaMix("--theme-primary", 50)}, 0 0 40px ${alphaMix("--theme-primary", 30)}, 0 0 60px ${alphaMix("--theme-primary", 20)}`,
        'neon-purple-sm': `0 0 10px ${alphaMix("--theme-primary", 40)}, 0 0 20px ${alphaMix("--theme-primary", 20)}`,
        'neon-pink': `0 0 20px ${alphaMix("--theme-accent", 50)}, 0 0 40px ${alphaMix("--theme-accent", 30)}`,
        'neon-dot': `0 0 10px ${alphaMix("--theme-light", 80)}`,
        'glass': `0 8px 32px 0 ${alphaMix("--theme-primary", 15)}, inset 0 0 0 1px rgba(255, 255, 255, 0.1)`,
      },
      keyframes: {
        // Like Tailwind's bounce but starts from the resting position,
        // so hover-triggered bounces don't snap to the top on start
        'bounce-up': {
          '0%, 100%': { transform: 'translateY(0)', animationTimingFunction: 'cubic-bezier(0, 0, 0.2, 1)' },
          '50%': { transform: 'translateY(-25%)', animationTimingFunction: 'cubic-bezier(0.8, 0, 1, 1)' },
        },
      },
      animation: {
        'bounce-up': 'bounce-up 1s infinite',
      },
      dropShadow: {
        'neon': `0 0 10px ${alphaMix("--theme-primary", 80)}`,
        'neon-strong': '0 0 15px var(--theme-primary)',
        'neon-secondary': `0 0 10px ${alphaMix("--theme-secondary", 80)}`,
        'neon-secondary-strong': '0 0 15px var(--theme-secondary)',
      },
    }
  },
  plugins: [
    require("@tailwindcss/forms"),
    // Allows prefixing tailwind classes with LiveView classes to add rules
    // only when LiveView classes are applied, for example:
    //
    //     <div class="phx-click-loading:animate-ping">
    //
    plugin(({ addVariant }) => addVariant("phx-click-loading", [".phx-click-loading&", ".phx-click-loading &"])),
    plugin(({ addVariant }) => addVariant("phx-submit-loading", [".phx-submit-loading&", ".phx-submit-loading &"])),
    plugin(({ addVariant }) => addVariant("phx-change-loading", [".phx-change-loading&", ".phx-change-loading &"])),

    // Embeds Heroicons (https://heroicons.com) into your app.css bundle
    // See your `CoreComponents.icon/1` for more information.
    //
    plugin(function({ matchComponents, theme }) {
      let iconsDir = path.join(__dirname, "../deps/heroicons/optimized")
      let values = {}
      let icons = [
        ["", "/24/outline"],
        ["-solid", "/24/solid"],
        ["-mini", "/20/solid"],
        ["-micro", "/16/solid"]
      ]
      icons.forEach(([suffix, dir]) => {
        fs.readdirSync(path.join(iconsDir, dir)).forEach(file => {
          let name = path.basename(file, ".svg") + suffix
          values[name] = { name, fullPath: path.join(iconsDir, dir, file) }
        })
      })
    })
  ]
}
