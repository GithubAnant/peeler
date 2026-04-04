"use client";

import { useEffect, useState } from "react";

export default function StatsPage() {
  const [count, setCount] = useState<string>("...");

  useEffect(() => {
    const fetchDownloads = async () => {
      try {
        const res = await fetch("https://api.github.com/repos/GithubAnant/peeler/releases");
        const data = await res.json();

        let total = 0;

        data.forEach((release: { assets?: { download_count: number }[] }) => {
          if (release.assets) {
            release.assets.forEach((asset) => {
              total += asset.download_count;
            });
          }
        });

        setCount(total.toString());
      } catch (err) {
        setCount("error");
        console.error(err);
      }
    };

    fetchDownloads();
  }, []);

  return (
    <div
      style={{
        background: "#000",
        color: "#fff",
        minHeight: "100vh",
        display: "flex",
        alignItems: "center",
        justifyContent: "center",
        fontFamily: "var(--font-body), sans-serif",
      }}
    >
      <div style={{ textAlign: "center" }}>
        <div
          style={{
            fontSize: "14px",
            opacity: 0.5,
            marginBottom: "12px",
          }}
        >
          total downloads for peeler
        </div>
        <div
          style={{
            fontSize: "64px",
            letterSpacing: "-1px",
            fontWeight: 300,
          }}
        >
          {count}
        </div>
      </div>
    </div>
  );
}