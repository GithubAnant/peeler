"use client";

import { useState } from "react";
import styles from "./VideoShowcase.module.css";

const demoVideos = [
  "/demos/demo-01.mp4",
  "/demos/demo-02.mp4",
  "/demos/demo-03.mp4",
];

export function VideoShowcase() {
  const [videoSrc] = useState(
    () => demoVideos[Math.floor(Math.random() * demoVideos.length)],
  );

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
          />
        </div>
      </div>
    </section>
  );
}
