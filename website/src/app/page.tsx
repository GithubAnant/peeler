"use client";

import { useEffect, useState } from "react";
import type { CSSProperties } from "react";
import { TerminalBox } from "@/components/TerminalBox";
import Image from "next/image";
import styles from "./page.module.css";

const navigationLinks = [
  {
    href: "https://x.com/GithubAnant",
    label: "Twitter",
  },
  {
    href: "https://www.linkedin.com/in/anantsinghal1/",
    label: "LinkedIn",
  },
  {
    href: "https://github.com/sponsors/GithubAnant",
    label: "Sponsor",
  },
];

const heroLines = [
  ["Pick", "colors", "from"],
  ["your", "screen", "in"],
  ["seconds"],
];

export default function Home() {
  const [starCount, setStarCount] = useState<number | null>(null);

  useEffect(() => {
    fetch("https://api.github.com/repos/GithubAnant/peeler")
      .then((res) => res.json())
      .then((data) => setStarCount(data.stargazers_count ?? null))
      .catch(() => setStarCount(null));
  }, []);

  return (
    <main className={styles.page}>
      <header className={styles.header}>
        <a
          className={styles.brand}
          href="https://github.com/GithubAnant/peeler"
          target="_blank"
          rel="noreferrer"
        >
          <Image
            src="/logo.png"
            alt="Peeler"
            width={28}
            height={28}
            className={styles.brandLogo}
          />
          <span className={styles.brandText}>Peeler</span>
        </a>

        <nav className={styles.nav} aria-label="Primary">
          {navigationLinks.map((link) => (
            <a
              key={link.label}
              href={link.href}
              target="_blank"
              rel="noreferrer"
            >
              {link.label}
            </a>
          ))}
        </nav>

        <a
          className={styles.githubButton}
          href="https://github.com/GithubAnant/peeler"
          target="_blank"
          rel="noreferrer"
        >
          <Image
            src="/github.svg"
            alt=""
            width={18}
            height={18}
            className={styles.githubIcon}
          />
          <span>Star on GitHub</span>
          {starCount !== null && (
            <span className={styles.starRight}>
              <Image
                src="/star.svg"
                alt=""
                width={14}
                height={14}
                className={styles.githubStarIcon}
              />
              <span className={styles.starCount}>{starCount}</span>
            </span>
          )}
        </a>
      </header>
      <div className={styles.headerSpacer} aria-hidden="true" />

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

        <a
          className={styles.downloadButton}
          href="https://github.com/GithubAnant/peeler/releases"
          target="_blank"
          rel="noreferrer"
        >
          <Image
            src="/apple.svg"
            alt=""
            width={18}
            height={18}
            className={styles.downloadIcon}
          />
          <span>Download for macOS</span>
        </a>
        <p className={styles.downloadNote}>After downloading, run this in Terminal to bypass macOS security and launch:</p>
        <TerminalBox />
      </section>
    </main>
  );
}
