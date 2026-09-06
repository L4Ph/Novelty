import { describe, expect, test } from "bun:test";
import { existsSync, readFileSync } from "node:fs";
import { join } from "node:path";
const root = join(import.meta.dir, "..");
const read = (p: string) => readFileSync(join(root, p), "utf-8");

const PLAY_PROD = "https://play.google.com/store/apps/details?id=moe.l4ph.novelty";
const PLAY_BETA = "https://play.google.com/apps/testing/moe.l4ph.novelty";
const BETA_GROUP = "https://groups.google.com/g/novelty-app";
const RELEASES = "https://github.com/L4Ph/Novelty/releases/latest";
const OBTAINIUM_ADD = "obtainium://add/https://github.com/L4Ph/Novelty";

// 公開インターフェース: ビルド成果物に載る文言・導線・画像の存在
describe("site public contract", () => {
  test("実機スクショ4枚がpublicに存在する", () => {
    for (const f of ["explorer.webp", "history.webp", "library.webp", "tategaki.webp"]) {
      expect(existsSync(join(root, "public", f)), f).toBe(true);
    }
  });

  test("Heroに実機ショットと入手導線がある", () => {
    const hero = read("src/components/Hero.astro");
    const links = read("src/lib/store-links.ts");
    expect(hero.includes("tategaki.webp")).toBe(true);
    // Play URLの真実は src/lib/store-links.ts に一元化し、各面は定数参照する
    // 本番公開前は入手の主導線がGitHub Release、ベータの入口はGoogleグループ
    expect(links.includes(PLAY_PROD)).toBe(true);
    expect(links.includes(PLAY_BETA)).toBe(true);
    expect(links.includes(BETA_GROUP)).toBe(true);
    expect(links.includes(RELEASES)).toBe(true);
    expect(hero.includes("GITHUB_RELEASES_URL")).toBe(true);
    expect(hero.includes("BETA_GROUP_URL")).toBe(true);
    expect(hero.includes("PLAY_PROD_URL")).toBe(false);
  });

  test("交互セクションが4機能分ある（tategaki→explorer→library→historyの順）", () => {
    const index = read("src/pages/index.astro");
    expect(index.includes("Showcase")).toBe(true);
    const showcase = read("src/components/Showcase.astro");
    const order = [
      "tategaki.webp",
      "explorer.webp",
      "library.webp",
      "history.webp",
    ];
    for (const f of order) {
      expect(showcase.includes(f), f).toBe(true);
    }
    const positions = order.map((f) => showcase.indexOf(f));
    expect([...positions].sort((a, b) => a - b)).toEqual(positions);
  });

  test("旧hero.png参照が残っていない", () => {
    const layout = read("src/layouts/Layout.astro");
    expect(layout.includes("hero.png")).toBe(false);
  });

  test("helpの文面がJSONコンテンツにありhelp.astroは直書きしない", () => {
    const faqRaw = read("src/content/faq.json");
    const faqs = JSON.parse(faqRaw) as Array<{
      id: string;
      order: number;
      question: string;
      answer: string;
    }>;
    // 9件の実在契約（件数・順序・必須項目）
    expect(faqs.length).toBe(9);
    expect(faqs.map((f) => f.order)).toEqual([1, 2, 3, 4, 5, 6, 7, 8, 9]);
    for (const f of faqs) {
      expect(f.question.length > 0, `${f.id} question`).toBe(true);
      expect(f.answer.length > 0, `${f.id} answer`).toBe(true);
    }
    const pages = JSON.parse(read("src/content/pages.json")) as Array<{
      id: string;
    }>;
    expect(pages.some((p) => p.id === "help")).toBe(true);
    // help.astroは文面を持たずコレクションから読む
    const help = read("src/pages/help.astro");
    expect(help.includes("const qas")).toBe(false);
    expect(help.includes("なろう専用")).toBe(false);
    expect(help.includes("getCollection")).toBe(true);
    expect(faqRaw.includes("カクヨム")).toBe(true);
    expect(help.includes(PLAY_BETA)).toBe(false);
    expect(faqRaw.includes(PLAY_BETA)).toBe(true);
    expect(faqRaw.includes(BETA_GROUP)).toBe(true);
    expect(faqRaw.includes(OBTAINIUM_ADD)).toBe(true);
    // OGPスクリプトも同じJSONを読む（文言の二重管理をしない）
    const ogp = read("scripts/ogp.ts");
    expect(ogp.includes("content/pages.json")).toBe(true);
  });

  test("OGP画像が1200x630のPNGで生成されている", () => {
    for (const f of ["ogp.png", "ogp-help.png"]) {
      const buf = readFileSync(join(root, "public", f));
      // PNGシグネチャ + IHDRの幅高さを直接読む（外部ライブラリ不使用）
      expect(buf.subarray(0, 8)).toEqual(
        Buffer.from([137, 80, 78, 71, 13, 10, 26, 10]),
      );
      expect(buf.readUInt32BE(16), `${f} width`).toBe(1200);
      expect(buf.readUInt32BE(20), `${f} height`).toBe(630);
    }
  });

  test("og:imageがOGP画像を指しcanonicalがページURLになっている", () => {
    const layout = read("src/layouts/Layout.astro");
    expect(layout.includes('image = "/ogp.png"')).toBe(true);
    // JSON-LDのscreenshot配列は実スクショ参照のままでよい。og:image既定値を見る
    expect(layout.includes('image = "/tategaki.webp"')).toBe(false);
    expect(layout.includes("new URL(image, Astro.url)")).toBe(true);
    // 全ページ固定の正規URLは重複扱いの元なので Astro.url を使う
    expect(layout.includes('<link rel="canonical" href="https://novelty.l4ph.moe">')).toBe(false);
  });

  test("セマンティックトークンがoklchで定義され旧primaryとグラデが残っていない", () => {
    const css = read("src/styles/global.css");
    expect(css.includes("--surface-page")).toBe(true);
    expect(css.includes("--brand-primary")).toBe(true);
    expect(css.includes("oklch")).toBe(true);
    expect(css.includes("#570df8")).toBe(false);
    const src = [
      read("src/components/Hero.astro"),
      read("src/components/Navbar.astro"),
      read("src/components/Footer.astro"),
      read("src/components/Showcase.astro"),
      read("src/components/TechStack.astro"),
    ].join("\n");
    expect(src.includes("linear-gradient")).toBe(false);
    expect(src.match(/gradient-text/)?.length ?? 0).toBe(0);
  });
});
