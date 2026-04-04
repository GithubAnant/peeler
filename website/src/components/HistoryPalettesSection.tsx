import type { ReactNode } from "react";
import styles from "./HistoryPalettesSection.module.css";

const historyItems = [
  {
    title: "Recent picks",
    description: "Re-copy the last colors you captured without sampling again.",
  },
  {
    title: "Format recall",
    description: "Jump back into HEX, RGB, OKLCH, SwiftUI, or whatever you used last.",
  },
  {
    title: "Visual trace",
    description: "Keep a running trail of the shades you tested while iterating.",
  },
  {
    title: "Fast comparison",
    description: "Check nearby picks side by side before committing to a final tone.",
  },
];

const savedPaletteItems = [
  {
    title: "Named collections",
    description: "Save grouped colors as reusable palettes instead of loose one-off picks.",
  },
  {
    title: "Project sets",
    description: "Separate client work, explorations, and brand systems cleanly.",
  },
  {
    title: "Export-ready groups",
    description: "Keep palettes ready for CSS variables, Tailwind tokens, or design handoff.",
  },
  {
    title: "Reliable reuse",
    description: "Come back to proven color sets without rebuilding them from scratch.",
  },
];

function HistoryIcon() {
  return (
    <svg viewBox="0 0 24 24" aria-hidden="true">
      <path
        d="M12 6v6l4 2"
        fill="none"
        stroke="currentColor"
        strokeLinecap="round"
        strokeLinejoin="round"
        strokeWidth="2"
      />
      <path
        d="M5.2 8A8 8 0 1 1 4 12"
        fill="none"
        stroke="currentColor"
        strokeLinecap="round"
        strokeLinejoin="round"
        strokeWidth="2"
      />
      <path
        d="M4 5v4h4"
        fill="none"
        stroke="currentColor"
        strokeLinecap="round"
        strokeLinejoin="round"
        strokeWidth="2"
      />
    </svg>
  );
}

function PaletteIcon() {
  return (
    <svg viewBox="0 0 24 24" aria-hidden="true">
      <path
        d="M12 3a9 9 0 1 0 0 18h1.1a2.4 2.4 0 0 0 0-4.8h-1.7a1.6 1.6 0 0 1 0-3.2h1.1A5.5 5.5 0 0 0 12 3Z"
        fill="none"
        stroke="currentColor"
        strokeLinecap="round"
        strokeLinejoin="round"
        strokeWidth="2"
      />
      <circle cx="7.5" cy="11" r="1" fill="currentColor" />
      <circle cx="10.5" cy="8" r="1" fill="currentColor" />
      <circle cx="8.5" cy="15" r="1" fill="currentColor" />
    </svg>
  );
}

type InfoCardProps = {
  icon: ReactNode;
  title: string;
  highlight?: string;
  items: Array<{ title: string; description: string }>;
};

function InfoCard({ icon, title, highlight, items }: InfoCardProps) {
  return (
    <article className={styles.card}>
      <div className={styles.cardIcon}>{icon}</div>
      <h3 className={styles.cardTitle}>
        {title}
        {highlight ? <span className={styles.cardHighlight}> {highlight}</span> : null}
      </h3>

      <div className={styles.itemList}>
        {items.map((item) => (
          <div key={item.title} className={styles.item}>
            <p className={styles.itemTitle}>{item.title}</p>
            <p className={styles.itemDescription}>{item.description}</p>
          </div>
        ))}
      </div>
    </article>
  );
}

export function HistoryPalettesSection() {
  return (
    <section className={styles.section} aria-label="History and saved palettes">
      <div className={styles.headingWrap}>
        <h2 className={styles.heading}>
          Keep your best color decisions close.
        </h2>
      </div>

      <div className={styles.grid}>
        <InfoCard icon={<HistoryIcon />} title="History" items={historyItems} />
        <InfoCard
          icon={<PaletteIcon />}
          title="Saved palettes"
          highlight="ready"
          items={savedPaletteItems}
        />
      </div>
    </section>
  );
}
