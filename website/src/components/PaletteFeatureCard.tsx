import styles from "./PaletteFeatureCard.module.css";

const paletteFeatureItems = [
  {
    title: "Extract colors",
    description: "Capture any region on screen and extract dominant colors.",
  },
  {
    title: "Smart balancing",
    description: "Peeler automatically creates a balanced, harmonious palette.",
  },
  {
    title: "One-click export",
    description: "Export to CSS, Tailwind, SwiftUI, or your favorite format.",
  },
  {
    title: "Save & reuse",
    description: "Keep palettes for later comparison or reference.",
  },
];

function EyedropperIcon() {
  return (
    <svg viewBox="0 0 24 24" aria-hidden="true">
      <path
        d="M15.154 3.338a1.375 1.375 0 0 1 1.941 1.941l-7.616 7.616a2.446 2.446 0 0 0-.563.836l-.275 1.107a.5.5 0 0 1-.457.457l-1.107.275a2.445 2.445 0 0 0-.836.563l-.324.324a.75.75 0 0 1-1.06 0l-2.064-2.064a.75.75 0 0 1 0-1.06l7.616-7.616a.75.75 0 0 1 1.06 0l.324.324a2.445 2.445 0 0 0 .563.836l1.107.275a.5.5 0 0 1 .457.457l.275 1.107a2.446 2.446 0 0 0 .836.563l.324.324a.75.75 0 0 1 0 1.06l-2.064 2.064a.75.75 0 0 1-1.06 0l-.324-.324a2.445 2.445 0 0 0-.836-.563l-1.107-.275a.5.5 0 0 1-.457-.457l-.275-1.107a2.446 2.446 0 0 0-.563-.836l-.324-.324Z"
        fill="none"
        stroke="currentColor"
        strokeWidth="1.5"
        strokeLinecap="round"
        strokeLinejoin="round"
      />
    </svg>
  );
}

export function PaletteFeatureCard() {
  return (
    <section className={styles.section} aria-label="Palette extraction feature">
      <div className={styles.headingWrap}>
        <h2 className={styles.heading}>
          Extract colors from<br />any region on screen.
        </h2>
      </div>

      <article className={styles.card}>
        <div className={styles.textContent}>
          <div className={styles.iconWrap}>
            <EyedropperIcon />
          </div>
          <h3 className={styles.title}>Palette Extraction</h3>

          <div className={styles.featureList}>
            {paletteFeatureItems.map((item) => (
              <div key={item.title} className={styles.featureItem}>
                <p className={styles.featureTitle}>{item.title}</p>
                <p className={styles.featureDescription}>{item.description}</p>
              </div>
            ))}
          </div>
        </div>

        <video
          src="/demos/demo-02.mp4"
          autoPlay
          muted
          loop
          playsInline
          controls={false}
          preload="none"
          className={styles.visual}
        />
      </article>
    </section>
  );
}
