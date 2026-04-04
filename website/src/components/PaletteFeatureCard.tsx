import Image from "next/image";
import styles from "./PaletteFeatureCard.module.css";

const palettePlaceholder = `data:image/svg+xml;charset=UTF-8,${encodeURIComponent(`
  <svg width="1200" height="900" viewBox="0 0 1200 900" fill="none" xmlns="http://www.w3.org/2000/svg">
    <rect width="1200" height="900" fill="#111111"/>
    <rect width="1200" height="900" fill="url(#bg)"/>
    <circle cx="240" cy="210" r="220" fill="#F26A6A" fill-opacity="0.46"/>
    <circle cx="912" cy="248" r="250" fill="#7B8CFF" fill-opacity="0.5"/>
    <circle cx="602" cy="640" r="310" fill="#F5C98B" fill-opacity="0.34"/>
    <rect x="110" y="526" width="980" height="190" rx="28" fill="#090909" fill-opacity="0.86" stroke="rgba(255,255,255,0.12)"/>
    <rect x="150" y="566" width="126" height="108" rx="18" fill="#FF8A65"/>
    <rect x="294" y="566" width="126" height="108" rx="18" fill="#FFD166"/>
    <rect x="438" y="566" width="126" height="108" rx="18" fill="#7BD389"/>
    <rect x="582" y="566" width="126" height="108" rx="18" fill="#59C3C3"/>
    <rect x="726" y="566" width="126" height="108" rx="18" fill="#7E6BFF"/>
    <rect x="870" y="566" width="180" height="108" rx="18" fill="#141414"/>
    <path d="M906 621H1014" stroke="#2B2B2B" stroke-width="10" stroke-linecap="round"/>
    <path d="M906 650H984" stroke="#2B2B2B" stroke-width="10" stroke-linecap="round"/>
    <defs>
      <linearGradient id="bg" x1="84" y1="96" x2="1078" y2="808" gradientUnits="userSpaceOnUse">
        <stop stop-color="#FFE6C7"/>
        <stop offset="0.28" stop-color="#FFB4A2"/>
        <stop offset="0.58" stop-color="#8AA8FF"/>
        <stop offset="1" stop-color="#111111"/>
      </linearGradient>
    </defs>
  </svg>
`)}`;

const paletteBullets = [
  "Extract dominant colors from any selected area.",
  "Save palettes for later comparison and reuse.",
  "Export clean sets for CSS, Tailwind, or design handoff.",
];

export function PaletteFeatureCard() {
  return (
    <section className={styles.section} aria-label="Palette extraction feature">
      <article className={styles.card}>
        <div className={styles.copy}>
          <p className={styles.eyebrow}>Palette Extraction</p>
          <h2 className={styles.title}>Turn any region into a usable color system.</h2>
          <p className={styles.description}>
            Capture a slice of the screen and let Peeler build a balanced palette you can save,
            revisit, and export.
          </p>

          <ul className={styles.bullets}>
            {paletteBullets.map((item) => (
              <li key={item}>{item}</li>
            ))}
          </ul>
        </div>

        <div className={styles.visual}>
          <Image
            src={palettePlaceholder}
            alt="Placeholder preview for palette extraction"
            width={1200}
            height={900}
            unoptimized
            className={styles.placeholderImage}
          />

          <div className={styles.palettePanel} aria-hidden="true">
            <div className={styles.panelHeader}>
              <span className={styles.panelTitle}>Selected palette</span>
              <span className={styles.panelMeta}>5 colors</span>
            </div>

            <div className={styles.swatches}>
              <span style={{ background: "#FF8A65" }} />
              <span style={{ background: "#FFD166" }} />
              <span style={{ background: "#7BD389" }} />
              <span style={{ background: "#59C3C3" }} />
              <span style={{ background: "#7E6BFF" }} />
            </div>
          </div>
        </div>
      </article>
    </section>
  );
}
