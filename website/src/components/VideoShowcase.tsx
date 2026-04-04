"use client";

import { useState } from "react";
import styles from "./VideoShowcase.module.css";

export function VideoShowcase() {
  const [videoSrc] = useState("/demos/demo-01.mp4");

  return (
    <section className={styles.showcase} aria-label="Peeler demo video">
      <div className={styles.frame}>
        <div className={styles.videoShell}>
          <video
            className={styles.video}
            src={videoSrc}
            autoPlay
            muted
            loop
            playsInline
            controls={false}
            preload="none"
          />
        </div>
      </div>
    </section>
  );
}
