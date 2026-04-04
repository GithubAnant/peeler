"use client";

import { useState } from "react";
import Image from "next/image";
import { GitHubButton } from "@/components/GitHubButton";
import styles from "./Navbar.module.css";

const navigationLinks = [
  {
    href: "https://x.com/anant_hq",
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

interface NavbarProps {
  starCount: number | null;
}

export function Navbar({ starCount }: NavbarProps) {
  const [mobileOpen, setMobileOpen] = useState(false);

  return (
    <>
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

        <div className={styles.githubButtonWrapper}>
          <GitHubButton starCount={starCount} />
        </div>

        <button
          className={styles.mobileToggle}
          onClick={() => setMobileOpen(!mobileOpen)}
          aria-label="Toggle menu"
        >
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
            {mobileOpen ? (
              <path d="M6 6l12 12M6 18L18 6" />
            ) : (
              <>
                <path d="M3 12h18M3 6h18M3 18h18" />
              </>
            )}
          </svg>
        </button>
      </header>

      {mobileOpen && (
        <div className={styles.mobileMenu}>
          <nav className={styles.mobileNav}>
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
          <div className={styles.mobileGitHub}>
            <GitHubButton starCount={starCount} />
          </div>
        </div>
      )}

      <div className={styles.headerSpacer} aria-hidden="true" />
    </>
  );
}
