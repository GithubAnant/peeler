"use client";

import Image from "next/image";
import styles from "./VideoFeatureCard.module.css";

const featureItems = [
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

function StackIcon() {
  return (
    <svg viewBox="0 0 24 24" aria-hidden="true">
      <rect
        x="4"
        y="4"
        width="11"
        height="14"
        rx="3"
        fill="none"
        stroke="currentColor"
        strokeWidth="2"
      />
      <rect
        x="9"
        y="9"
        width="11"
        height="11"
        rx="3"
        fill="none"
        stroke="currentColor"
        strokeWidth="2"
      />
    </svg>
  );
}

export function VideoFeatureCard() {
  return (
    <section className={styles.section} aria-label="Saved palettes feature">
      <div className={styles.headingWrap}>
        <h2 className={styles.heading}>
          Turn any region into a<br />usable color system.
        </h2>
      </div>

      <article className={styles.card}>
        <div className={styles.textContent}>
          <div className={styles.iconWrap}>
            <StackIcon />
          </div>
          <h3 className={styles.title}>Saved palettes.</h3>

          <div className={styles.featureList}>
            {featureItems.map((item) => (
              <div key={item.title} className={styles.featureItem}>
                <p className={styles.featureTitle}>{item.title}</p>
                <p className={styles.featureDescription}>{item.description}</p>
              </div>
            ))}
          </div>
        </div>

        <Image
          src="/palletes.png"
          alt="Saved palettes showing color collections"
          width={520}
          height={320}
          unoptimized
          style={{ width: "100%", height: "auto" }}
        />
      </article>
    </section>
  );
}
