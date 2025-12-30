// @ts-check
import sitemap from "@astrojs/sitemap";
import { defineConfig } from "astro/config";

export default defineConfig({
  site: "https://novelty.l4ph.moe",
  integrations: [sitemap()],
  vite: {
    css: {
      transformer: "lightningcss",
    },
  },
});