/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./index.html", "./src/**/*.{vue,js,ts,jsx,tsx}"],
  theme: {
    fontFamily: {
      sans: ["iosevka-web", "ui-sans-serif", "system-ui"],
      serif: ["ui-serif", "Georgia"],
      mono: ["iosevka-web", "ui-monospace", "SFMono-Regular"],
    },
    extend: {},
  },
  plugins: [],
}

