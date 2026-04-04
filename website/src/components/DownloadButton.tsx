import Image from "next/image";
import styles from "./DownloadButton.module.css";

export function DownloadButton() {
  return (
    <a
      className={styles.downloadButton}
      href="https://github.com/GithubAnant/peeler/releases/latest/download/Peeler-1.0.5.dmg"
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
  );
}
