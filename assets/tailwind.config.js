// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

const plugin = require("tailwindcss/plugin")
const fs = require("fs")
const path = require("path")

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
        neon: {
          purple: "#a855f7",
          "purple-light": "#c084fc",
          "purple-dark": "#9333ea",
          "purple-glow": "#d946ef",
          pink: "#ec4899",
          "pink-glow": "#f472b6",
          cyan: "#06b6d4",
          "cyan-glow": "#22d3ee",
        },
        glass: {
          dark: "rgba(17, 24, 39, 0.7)",
          darker: "rgba(7, 12, 21, 0.8)",
          purple: "rgba(168, 85, 247, 0.1)",
          "purple-light": "rgba(192, 132, 252, 0.15)",
        },
        primary: { "50": "#fdf4ff", "100": "#fae8ff", "200": "#f5d0fe", "300": "#f0abfc", "400": "#e879f9", "500": "#d946ef", "600": "#c026d3", "700": "#a21caf", "800": "#86198f", "900": "#701a75", "950": "#4a044e" }
      },
      backdropBlur: {
        xs: '2px',
      },
      boxShadow: {
        'neon-purple': '0 0 20px rgba(168, 85, 247, 0.5), 0 0 40px rgba(168, 85, 247, 0.3), 0 0 60px rgba(168, 85, 247, 0.2)',
        'neon-purple-sm': '0 0 10px rgba(168, 85, 247, 0.4), 0 0 20px rgba(168, 85, 247, 0.2)',
        'neon-pink': '0 0 20px rgba(236, 72, 153, 0.5), 0 0 40px rgba(236, 72, 153, 0.3)',
        'glass': '0 8px 32px 0 rgba(168, 85, 247, 0.15), inset 0 0 0 1px rgba(255, 255, 255, 0.1)',
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
