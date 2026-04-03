import type { CSSProperties } from "react";
import { TerminalBox } from "@/components/TerminalBox";
import { DownloadButton } from "@/components/DownloadButton";
import styles from "./Hero.module.css";

const heroLines = [
  ["Pick", "colors", "from"],
  ["your", "screen", "in"],
  ["seconds"],
];

export function Hero() {
  return (
    <section className={styles.hero}>
      <h1
        className={styles.heroTitle}
        aria-label="Pick colors from your screen in seconds"
      >
        {heroLines.map((line, lineIndex) => (
          <span key={line.join("-")} className={styles.heroLine}>
            {line.map((word, wordIndex) => {
              const priorWords = heroLines
                .slice(0, lineIndex)
                .reduce((count, currentLine) => count + currentLine.length, 0);
              const animationIndex = priorWords + wordIndex;

              return (
                <span
                  key={`${word}-${animationIndex}`}
                  className={styles.heroWord}
                  style={
                    {
                      "--word-index": animationIndex,
                    } as CSSProperties
                  }
                >
                  {word}
                </span>
              );
            })}
          </span>
        ))}
      </h1>

      <p className={styles.heroDescription}>
        Peeler is a lightweight open-source macOS app for color picking and palette extraction.
      </p>

      <DownloadButton />
      <p className={styles.downloadNote}>After downloading, run this in Terminal to bypass macOS security and launch:</p>
      <TerminalBox />
    </section>
  );
}
