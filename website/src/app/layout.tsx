import type { Metadata } from "next";
import { Instrument_Sans, Syne } from "next/font/google";
import { SmoothScroll } from "@/components/SmoothScroll";
import "./globals.css";

const displayFont = Syne({
  variable: "--font-display",
  subsets: ["latin"],
  weight: ["500", "600", "700", "800"],
});

const bodyFont = Instrument_Sans({
  variable: "--font-body",
  subsets: ["latin"],
  weight: ["400", "500", "600", "700"],
});

export const metadata: Metadata = {
  metadataBase: new URL("https://peeler.anants.studio"),
  title: "Peeler | Fast color picking for macOS",
  description:
    "Pick any color from your screen, extract palettes from a region, and copy results in the formats you actually use.",
  applicationName: "Peeler",
  openGraph: {
    title: "Peeler | Fast color picking for macOS",
    description:
      "A lightweight macOS menu bar app for picking colors and extracting palettes from your screen.",
    siteName: "Peeler",
    type: "website",
  },
  twitter: {
    card: "summary_large_image",
    title: "Peeler | Fast color picking for macOS",
    description:
      "A lightweight macOS menu bar app for picking colors and extracting palettes from your screen.",
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en" className={`${displayFont.variable} ${bodyFont.variable}`}>
      <body>
        <SmoothScroll />
        {children}
      </body>
    </html>
  );
}
