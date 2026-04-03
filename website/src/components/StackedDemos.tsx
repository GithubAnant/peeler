"use client";

import { startTransition, useEffect, useEffectEvent, useRef, useState } from "react";
import styles from "./StackedDemos.module.css";

type Demo = {
  eyebrow: string;
  title: string;
  description: string;
  src: string;
  filename: string;
};

type StackedDemosProps = {
  demos: Demo[];
};

export function StackedDemos({ demos }: StackedDemosProps) {
  const [activeIndex, setActiveIndex] = useState(0);
  const triggerRefs = useRef<Array<HTMLElement | null>>([]);

  const handleIntersections = useEffectEvent(
    (entries: IntersectionObserverEntry[]) => {
      const visibleEntry = entries
        .filter((entry) => entry.isIntersecting)
        .sort((left, right) => right.intersectionRatio - left.intersectionRatio)[0];

      if (!visibleEntry) {
        return;
      }

      const nextIndex = Number(
        (visibleEntry.target as HTMLElement).dataset.index ?? 0,
      );

      startTransition(() => {
        setActiveIndex((currentIndex) =>
          currentIndex === nextIndex ? currentIndex : nextIndex,
        );
      });
    },
  );

  useEffect(() => {
    const observer = new IntersectionObserver(handleIntersections, {
      rootMargin: "-20% 0px -20% 0px",
      threshold: [0.3, 0.55, 0.8],
    });

    const currentRefs = triggerRefs.current;
    currentRefs.forEach((trigger) => {
      if (trigger) {
        observer.observe(trigger);
      }
    });

    return () => {
      observer.disconnect();
    };
  }, []);

  return (
    <section className={styles.section} id="demos">

      <div className={styles.experience}>
        <div className={styles.stageSticky}>
          <div className={styles.stageShell}>
            <div className={styles.windowBar}>
              <div className={styles.windowDots} aria-hidden="true">
                <span />
                <span />
                <span />
              </div>
              <span className={styles.windowLabel}>{demos[activeIndex]?.filename}</span>
            </div>

            <div className={styles.stageViewport}>
              {demos.map((demo, index) => {
                const stateClass =
                  activeIndex === index
                    ? styles.layerActive
                    : activeIndex > index
                      ? styles.layerBehind
                      : styles.layerWaiting;

                return (
                  <div
                    key={demo.filename}
                    className={`${styles.videoLayer} ${stateClass}`}
                    style={{ zIndex: index + 1 }}
                  >
                    <div className={styles.videoFrame}>
                      <video
                        autoPlay
                        className={styles.video}
                        loop
                        muted
                        playsInline
                        preload="metadata"
                      >
                        <source src={demo.src} type="video/mp4" />
                      </video>
                      <div className={styles.videoOverlay} aria-hidden="true" />
                    </div>
                  </div>
                );
              })}
            </div>
          </div>
        </div>

        <div className={styles.triggerRail}>
          {demos.map((demo, index) => (
            <article
              key={demo.filename}
              ref={(node) => {
                triggerRefs.current[index] = node;
              }}
              className={`${styles.trigger} ${activeIndex === index ? styles.triggerActive : ""}`}
              data-index={index}
            >
              <div className={styles.triggerCopy}>
                <p>{demo.eyebrow}</p>
                <h3>{demo.title}</h3>
                <span>{demo.description}</span>
              </div>
            </article>
          ))}
        </div>
      </div>
    </section>
  );
}
