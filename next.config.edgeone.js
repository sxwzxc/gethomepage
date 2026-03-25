/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  output: "export",
  trailingSlash: true,
  images: {
    remotePatterns: [
      {
        protocol: "https",
        hostname: "cdn.jsdelivr.net",
      },
    ],
    unoptimized: true,
  },
  // Disable i18n for static export - EdgeOne Pages doesn't support i18n routing
  // Note: API routes are not supported in static export mode
  // For full functionality, consider a hybrid deployment with separate backend
};

module.exports = nextConfig;
