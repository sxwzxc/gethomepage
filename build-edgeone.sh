#!/bin/bash
# EdgeOne Pages Static Export Build Script
# This script builds the Homepage project for Tencent Cloud EdgeOne Pages deployment

set -e

echo "=== Building Homepage for EdgeOne Pages ==="

# Clean previous builds
echo "Cleaning previous builds..."
rm -rf out .next

# Run Next.js build with EdgeOne config
echo "Building with Next.js..."
NEXT_CONFIG_FILE=./next.config.edgeone.js pnpm exec next build

# Create output directory
echo "Creating output directory..."
mkdir -p out/_next

# Copy static files
echo "Copying static files..."
cp -r .next/static out/_next/ || true
cp -r public/* out/ 2>/dev/null || true

# Copy server-generated pages
echo "Copying generated pages..."
if [ -d ".next/server/pages" ]; then
  # Copy HTML files
  find .next/server/pages -name "*.html" -exec cp {} out/ \;

  # Handle index page
  if [ -f ".next/server/pages/en.html" ]; then
    cp .next/server/pages/en.html out/index.html
  elif [ -f ".next/server/pages/index.html" ]; then
    cp .next/server/pages/index.html out/index.html
  fi
fi

# Create a simple 404 page if it doesn't exist
if [ ! -f "out/404.html" ]; then
  echo "<!DOCTYPE html><html><head><title>404 - Not Found</title></head><body><h1>404 - Page Not Found</h1></body></html>" > out/404.html
fi

echo "=== Build completed ==="
echo "Static files are in the 'out' directory"
echo ""
echo "⚠️  Note: API routes (/api/*) will not work in static export mode."
echo "For full functionality, consider a hybrid deployment with a separate backend server."
echo ""
echo "To deploy to EdgeOne Pages:"
echo "1. Upload the 'out' directory to EdgeOne Pages"
echo "2. Or configure your Git repository with build command: './build-edgeone.sh'"
echo "3. Set output directory to: 'out'"
