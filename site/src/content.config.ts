import { defineCollection, z } from "astro:content";
import { file } from "astro/loaders";

// helpページの文面はJSONで管理し、.astro側に直書きしない。
// OGP生成スクリプト（scripts/ogp.ts）も同じJSONを読む。
const faq = defineCollection({
  loader: file("src/content/faq.json"),
  schema: z.object({
    id: z.string(),
    order: z.number(),
    question: z.string(),
    answer: z.string(),
  }),
});

const pages = defineCollection({
  loader: file("src/content/pages.json"),
  schema: z.object({
    id: z.string(),
    title: z.string(),
    description: z.string(),
    image: z.string(),
    ogpEyebrow: z.string(),
    ogpTitleColumn1: z.string(),
    ogpTitleColumn2: z.string(),
    ogpDescription: z.string(),
    ogpShot: z.string(),
    ogpShotAlt: z.string(),
  }),
});

export const collections = { faq, pages };
