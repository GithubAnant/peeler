import type { Metadata, Viewport } from "next";
import { Instrument_Sans, Syne } from "next/font/google";
import { GeistSans } from "geist/font/sans";
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

const cardFont = GeistSans;

const siteUrl = new URL("https://peeler.anants.studio");
const siteTitle = "Peeler | Fast color picking for macOS";
const siteDescription =
  "Pick any color from your screen, extract palettes from a region, and copy results in the formats you actually use.";
const socialDescription =
  "A lightweight open-source macOS menu bar app for color picking and palette extraction.";
const socialImage = {
  url: "/twitter-card.png",
  width: 1200,
  height: 675,
  alt: "Peeler color picker app preview",
};

export const viewport: Viewport = {
  themeColor: "#0b0d12",
  colorScheme: "dark",
};

export const metadata: Metadata = {
  metadataBase: siteUrl,
  title: {
    default: siteTitle,
    template: "%s | Peeler",
  },
  description: siteDescription,
  applicationName: "Peeler",
  authors: [{ name: "Anant Singhal", url: "https://anants.studio" }],
  creator: "Anant Singhal",
  publisher: "Anant Singhal",
  keywords: [
    "Peeler",
    "macOS color picker",
    "palette extractor",
    "eyedropper app",
    "design tools",
    "developer tools",
    "open source mac app",
  ],
  alternates: {
    canonical: "/",
  },
  manifest: "/manifest.webmanifest",
  category: "technology",
  referrer: "origin-when-cross-origin",
  formatDetection: {
    telephone: false,
    address: false,
    email: false,
  },
  appleWebApp: {
    capable: true,
    title: "Peeler",
    statusBarStyle: "black-translucent",
  },
  robots: {
    index: true,
    follow: true,
  },
  icons: {
    icon: [{ url: "/logo.png", type: "image/png", sizes: "1024x1024" }],
    shortcut: ["/logo.png"],
    apple: [{ url: "/logo.png", sizes: "1024x1024", type: "image/png" }],
  },
  openGraph: {
    title: siteTitle,
    description: socialDescription,
    siteName: "Peeler",
    url: siteUrl,
    type: "website",
    locale: "en_US",
    images: [socialImage],
  },
  twitter: {
    card: "summary_large_image",
    title: siteTitle,
    description: socialDescription,
    creator: "@GithubAnant",
    images: [socialImage],
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html
      lang="en"
      className={`${displayFont.variable} ${bodyFont.variable} ${cardFont.variable} ${cardFont.className}`}
    >
      <head>
        <script
          src="https://cdn.databuddy.cc/databuddy.js"
          data-client-id="c363dba9-3155-4a9f-87f5-69b47a928b59"
          crossOrigin="anonymous"
          async
        />
      </head>
      <body>
        <SmoothScroll />
        {children}
      </body>
    </html>
  );
}
