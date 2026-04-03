"use client";

import { useEffect, useState } from "react";
import { Navbar } from "@/components/Navbar";
import { Hero } from "@/components/Hero";
import { Footer } from "@/components/Footer";
import styles from "./page.module.css";

export default function Home() {
  const [starCount, setStarCount] = useState<number | null>(null);

  useEffect(() => {
    fetch("https://api.github.com/repos/GithubAnant/peeler")
      .then((res) => res.json())
      .then((data) => setStarCount(data.stargazers_count ?? null))
      .catch(() => setStarCount(null));
  }, []);

  return (
    <main className={styles.page}>
      <Navbar starCount={starCount} />
      <Hero />
      <Footer />
    </main>
  );
}
