import Image from "next/image";
import styles from "./GitHubButton.module.css";

interface GitHubButtonProps {
  starCount: number | null;
}

export function GitHubButton({ starCount }: GitHubButtonProps) {
  return (
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
  );
}
