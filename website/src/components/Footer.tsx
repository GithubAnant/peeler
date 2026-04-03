import Image from "next/image";
import styles from "./Footer.module.css";

const footerLinks = [
  {
    href: "https://github.com/GithubAnant/peeler/releases",
    label: "Download",
  },
  {
    href: "https://github.com/GithubAnant/peeler",
    label: "GitHub",
  },
  {
    href: "https://github.com/sponsors/GithubAnant",
    label: "Sponsor",
  },
];

function XIcon() {
  return (
    <svg viewBox="0 0 24 24" aria-hidden="true">
      <path
        d="M18.9 3H21l-6.87 7.85L22 21h-6.16l-4.82-6.3L5.5 21H3.4l7.35-8.4L2 3h6.32l4.36 5.75L18.9 3Zm-1.08 16.14h1.17L7.7 4.8H6.44l11.38 14.34Z"
        fill="currentColor"
      />
    </svg>
  );
}

function GitHubIcon() {
  return (
    <svg viewBox="0 0 24 24" aria-hidden="true">
      <path
        d="M12 .5a12 12 0 0 0-3.79 23.39c.6.11.82-.26.82-.58v-2.03c-3.34.73-4.04-1.42-4.04-1.42-.55-1.37-1.33-1.74-1.33-1.74-1.09-.75.08-.74.08-.74 1.2.09 1.83 1.2 1.83 1.2 1.07 1.8 2.8 1.28 3.49.98.11-.76.42-1.28.77-1.57-2.66-.3-5.47-1.3-5.47-5.78 0-1.28.47-2.32 1.22-3.14-.12-.3-.53-1.53.12-3.2 0 0 1-.31 3.3 1.2a11.7 11.7 0 0 1 6 0c2.29-1.51 3.29-1.2 3.29-1.2.65 1.67.24 2.9.12 3.2.76.82 1.22 1.86 1.22 3.14 0 4.49-2.81 5.47-5.49 5.77.43.37.82 1.1.82 2.22v3.29c0 .32.22.7.83.58A12 12 0 0 0 12 .5Z"
        fill="currentColor"
      />
    </svg>
  );
}

export function Footer() {
  return (
    <footer className={styles.footer}>
      <div className={styles.footerBrandBlock}>
        <a
          className={styles.footerBrand}
          href="https://github.com/GithubAnant/peeler"
          target="_blank"
          rel="noreferrer"
        >
          <Image
            src="/logo.png"
            alt="Peeler"
            width={30}
            height={30}
            className={styles.footerLogo}
          />
          <span className={styles.footerBrandText}>Peeler</span>
        </a>

        <p className={styles.footerDescription}>
          The open-source macOS app for fast color picking and palette extraction.
        </p>

        <div className={styles.footerSocials} aria-label="Social links">
          <a
            href="https://x.com/GithubAnant"
            target="_blank"
            rel="noreferrer"
            aria-label="Peeler on X"
          >
            <XIcon />
          </a>
          <a
            href="https://github.com/GithubAnant/peeler"
            target="_blank"
            rel="noreferrer"
            aria-label="Peeler on GitHub"
          >
            <GitHubIcon />
          </a>
        </div>
      </div>

      <div className={styles.footerNavBlock}>
        <p className={styles.footerNavTitle}>Navigation</p>
        <div className={styles.footerLinks}>
          {footerLinks.map((link) => (
            <a
              key={link.label}
              href={link.href}
              target="_blank"
              rel="noreferrer"
            >
              {link.label}
            </a>
          ))}
        </div>
      </div>
    </footer>
  );
}
