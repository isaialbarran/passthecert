import type { NextConfig } from "next";
import { resolve } from "path";
import { existsSync } from "fs";

function findTurbopackRoot(dir: string): string {
  if (existsSync(resolve(dir, "node_modules"))) return dir;
  const parent = resolve(dir, "..");
  if (parent === dir) return dir;
  return findTurbopackRoot(parent);
}

const nextConfig: NextConfig = {
  turbopack: {
    root: findTurbopackRoot(__dirname),
  },
  headers: async () => [
    {
      source: "/(.*)",
      headers: [
        { key: "X-Content-Type-Options", value: "nosniff" },
        { key: "X-Frame-Options", value: "DENY" },
        {
          key: "Strict-Transport-Security",
          value: "max-age=63072000; includeSubDomains; preload",
        },
        {
          key: "Referrer-Policy",
          value: "strict-origin-when-cross-origin",
        },
        {
          key: "Permissions-Policy",
          value: "camera=(), microphone=(), geolocation=()",
        },
      ],
    },
  ],
};

export default nextConfig;
