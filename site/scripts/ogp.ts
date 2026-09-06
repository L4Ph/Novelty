/**
 * OGP画像生成スクリプト。
 *
 * 使い方: mise exec -- bun run ogp
 * Satoru（Wasmレンダラ）でHTMLテンプレートから1200x630のPNGを吐き出す。
 * 日本語フォントはGoogle Fontsから自動解決されるため、実行時に通信が必要。
 * public/ogp.png（トップ）とpublic/ogp-help.png（help）を上書きする。
 */
import { readFileSync, writeFileSync } from "node:fs";
import { join, dirname } from "node:path";
import { fileURLToPath } from "node:url";
import { render } from "satoru-render";

const root = join(dirname(fileURLToPath(import.meta.url)), "..");
const readPublic = (name: string): string => {
  const buf = readFileSync(join(root, "public", name));
  const mime = name.endsWith(".webp") ? "image/webp" : "image/png";
  return `data:${mime};base64,${buf.toString("base64")}`;
};

interface OgpPage {
  out: string;
  eyebrow: string;
  titleColumn1: string;
  titleColumn2: string;
  description: string;
  shot: string;
  shotAlt: string;
}

// サイトのセマンティックトークンに対応（Steel Azure #084887 主色、文庫感の明朝見出し）。
// 見出しは縦書き2柱（右から「Web小説を」「縦書きで読む」の順）。
const template = (page: OgpPage, shotDataUri: string): string => `
<div style="display:flex;width:1200px;height:630px;background:#ffffff;overflow:hidden;align-items:center;">
  <div style="position:relative;width:760px;height:630px;">
    <div style="position:absolute;left:64px;top:64px;font-family:sans-serif;font-size:28px;font-weight:bold;color:#084887;letter-spacing:4px;">${page.eyebrow}</div>
    <div style="position:absolute;left:170px;top:120px;width:80px;height:400px;writing-mode:vertical-rl;font-family:serif;font-size:64px;font-weight:bold;color:#1a1a2e;line-height:1.25;">${page.titleColumn1}</div>
    <div style="position:absolute;left:64px;top:120px;width:80px;height:400px;writing-mode:vertical-rl;font-family:serif;font-size:64px;font-weight:bold;color:#1a1a2e;line-height:1.25;">${page.titleColumn2}</div>
    <div style="position:absolute;left:64px;bottom:64px;font-family:sans-serif;font-size:28px;color:#555560;">${page.description}</div>
  </div>
  <div style="display:flex;align-items:center;justify-content:center;width:440px;height:630px;background:#eef4f6;">
    <img src="${shotDataUri}" alt="${page.shotAlt}" style="height:560px;" />
  </div>
</div>
`;

const pages: OgpPage[] = [
  {
    out: "ogp.png",
    eyebrow: "NOVELTY",
    titleColumn1: "Web小説を",
    titleColumn2: "縦書きで読む",
    description: "なろう・カクヨム対応の小説ビューアー",
    shot: "tategaki.webp",
    shotAlt: "縦書き読書画面",
  },
  {
    out: "ogp-help.png",
    eyebrow: "NOVELTY HELP",
    titleColumn1: "よくある",
    titleColumn2: "質問と回答",
    description: "導入方法・ベータ参加・使い方の案内",
    shot: "explorer.webp",
    shotAlt: "作品探索画面",
  },
];

for (const page of pages) {
  const png = await render({
    value: template(page, readPublic(page.shot)),
    width: 1200,
    format: "png",
  });
  writeFileSync(join(root, "public", page.out), png);
  console.log(`wrote public/${page.out} (${png.length} bytes)`);
}
