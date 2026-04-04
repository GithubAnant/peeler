"use client";

import { useState } from "react";
import styles from "./VideoFeatureCard.module.css";

const featureRows = [
  {
    title: "Seamless distribution.",
    video: "/demos/demo-02.mp4",
    visualLabel: "Shared exports",
    bullets: [
      "Share saved palettes and exports across your workflow.",
      "Keep handoff fast for design, code, and content teams.",
      "Move from extraction to distribution without cleanup work.",
    ],
  },
  {
    title: "Offline by default.",
    video: "/demos/demo-01.mp4",
    visualLabel: "Instant capture",
    bullets: [
      "Keep extracting palettes without waiting on a network round trip.",
      "Use Peeler during focused design work with zero service dependency.",
      "Stay in flow while collecting references, themes, and reusable sets.",
    ],
  },
  {
    title: "Zero setup friction.",
    video: "/demos/demo-03.mp4",
    visualLabel: "Fast workflow",
    bullets: [
      "Grab a region, get a palette, and copy formats immediately.",
      "Skip manual cleanup when handing colors over to code or design.",
      "Go from inspiration to usable tokens in a few seconds.",
    ],
  },
];

function Chevron({ expanded }: { expanded: boolean }) {
  return (
    <svg viewBox="0 0 20 20" aria-hidden="true">
      <path
        d={expanded ? "M5 12l5-5 5 5" : "M5 8l5 5 5-5"}
        fill="none"
        stroke="currentColor"
        strokeLinecap="round"
        strokeLinejoin="round"
        strokeWidth="2"
      />
    </svg>
  );
}

function StackIcon() {
  return (
    <svg viewBox="0 0 24 24" aria-hidden="true">
      <rect x="4" y="4" width="11" height="14" rx="3" fill="none" stroke="currentColor" strokeWidth="2" />
      <rect x="9" y="9" width="11" height="11" rx="3" fill="none" stroke="currentColor" strokeWidth="2" />
    </svg>
  );
}

export function VideoFeatureCard() {
  const [activeIndex, setActiveIndex] = useState<number | null>(0);
  const activeRow = activeIndex === null ? featureRows[0] : featureRows[activeIndex];

  return (
    <section className={styles.section} aria-label="Palette workflow feature">
      <article className={styles.card}>
        <div className={styles.accordionPanel}>
          {featureRows.map((row, index) => (
            <div
              key={row.title}
              className={`${styles.row} ${activeIndex === index ? styles.rowExpanded : ""}`}
            >
              <button
                type="button"
                className={styles.rowButton}
                aria-expanded={activeIndex === index}
                aria-controls={`video-feature-panel-${index}`}
                onClick={() =>
                  setActiveIndex((currentIndex) =>
                    currentIndex === index ? null : index,
                  )
                }
              >
                <div className={styles.rowTitleWrap}>
                  {index === 0 ? <StackIcon /> : <span className={styles.dot} aria-hidden="true" />}
                  <h3 className={styles.rowTitle}>{row.title}</h3>
                </div>
                <Chevron expanded={activeIndex === index} />
              </button>

              {activeIndex === index ? (
                <ul
                  id={`video-feature-panel-${index}`}
                  className={styles.rowBullets}
                >
                  {row.bullets?.map((bullet) => (
                    <li key={bullet}>{bullet}</li>
                  ))}
                </ul>
              ) : null}
            </div>
          ))}
        </div>

        <div className={styles.visualPanel}>
          <div className={styles.backdrop} />

          <div className={styles.deviceFrame}>
            <div className={styles.deviceHeader}>
              <span>{activeRow.visualLabel}</span>
              <span>Peeler</span>
            </div>

            <video
              className={styles.video}
              key={activeRow.video}
              src={activeRow.video}
              autoPlay
              muted
              loop
              playsInline
              controls={false}
            />
          </div>
        </div>
      </article>
    </section>
  );
}
