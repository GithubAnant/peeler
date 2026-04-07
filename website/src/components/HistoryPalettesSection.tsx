import type { ReactNode } from "react";
import Image from "next/image";
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

function HistoryImage() {
  return (
    <Image
      src="/history.png"
      alt="Color history showing captured colors"
      width={520}
      height={320}
      unoptimized
      className={styles.gridImage}
    />
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
          Keep your best color <br /> decisions close.
        </h2>
      </div>

      <div className={styles.grid}>
        <HistoryImage />
        <InfoCard icon={<HistoryIcon />} title="History" items={historyItems} />
      </div>
    </section>
  );
}
