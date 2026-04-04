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
      </header>
      <div className={styles.headerSpacer} aria-hidden="true" />
    </>
  );
}
