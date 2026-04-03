"use client";

import styles from "./TerminalBox.module.css";

export function TerminalBox() {
  const command = "xattr -rd com.apple.quarantine /Applications/Peeler.app";

  return (
    <div className={styles.terminalBox}>
      <div className={styles.terminalContent}>
        <code>{command}</code>
        <button
          className={styles.copyButton}
          onClick={() => navigator.clipboard.writeText(command)}
          aria-label="Copy command"
        >
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
            <rect x="9" y="9" width="13" height="13" rx="2" ry="2"/>
            <path d="M5 15H4a2 2 0 01-2-2V4a2 2 0 012-2h9a2 2 0 012 2v1"/>
          </svg>
        </button>
      </div>
    </div>
  );
}
