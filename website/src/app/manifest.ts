import type { MetadataRoute } from "next";

export default function manifest(): MetadataRoute.Manifest {
  return {
    name: "Peeler",
    short_name: "Peeler",
    description:
      "Pick any color from your screen, extract palettes from a region, and copy results in the formats you actually use.",
    start_url: "/",
    scope: "/",
    display: "standalone",
    background_color: "#050505",
    theme_color: "#0b0d12",
    icons: [
      {
        src: "/logo.png",
        sizes: "192x192",
        type: "image/png",
      },
      {
        src: "/logo.png",
        sizes: "512x512",
        type: "image/png",
      },
      {
        src: "/logo.png",
        sizes: "1024x1024",
        type: "image/png",
      },
    ],
  };
}
