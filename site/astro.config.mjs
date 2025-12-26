// @ts-check
import sitemap from "@astrojs/sitemap";
import tailwindcss from "@tailwindcss/vite";
import { defineConfig } from "astro/config";

export default defineConfig({
  site: "https://novelty.l4ph.moe",
  integrations: [sitemap()],
  vite: {
    plugins: [tailwindcss()],
  },
});