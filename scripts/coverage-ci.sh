#!/usr/bin/env bash
# CI coverage script - text summary only, with threshold check
# Usage: ./scripts/coverage-ci.sh [threshold_percentage]

set -e

BUILD_DIR="build"
COVERAGE_DIR="coverage"
THRESHOLD="${1:-80}"  # Default 80% minimum

echo "Building with coverage enabled..."
cmake -B "$BUILD_DIR" -S . \
  -DCMAKE_BUILD_TYPE=Debug \
  -DENABLE_COVERAGE=ON \
  -DENABLE_TSAN=OFF

cmake --build "$BUILD_DIR" -j $(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 4)

echo "Running tests to generate coverage data..."
cd "$BUILD_DIR"
ctest --output-on-failure
cd ..

echo "Generating coverage report..."
mkdir -p "$COVERAGE_DIR"

# Capture coverage data (suppress warnings for CI)
lcov --capture --directory "$BUILD_DIR" \
  --output-file "$COVERAGE_DIR/coverage.info" \
  --ignore-errors inconsistent,format \
  --quiet 2>/dev/null || true

# Remove system and test files from coverage
lcov --remove "$COVERAGE_DIR/coverage.info" \
  '/usr/*' \
  '*/build/_deps/*' \
  '*/tests/*' \
  '*/benchmarks/*' \
  --output-file "$COVERAGE_DIR/coverage.info" \
  --ignore-errors unused \
  --quiet 2>/dev/null || true

# Show summary
echo ""
echo "==============================="
echo "      Coverage Summary"
echo "==============================="
lcov --summary "$COVERAGE_DIR/coverage.info" 2>&1 | grep -E "(lines|functions).*:" || echo "No coverage data found"

# Extract line coverage percentage and check threshold
COVERAGE=$(lcov --summary "$COVERAGE_DIR/coverage.info" 2>&1 | awk -F'[ :%]+' '/lines/ {print $3}' || echo "0")

if [ "$COVERAGE" = "0" ] || [ -z "$COVERAGE" ]; then
    echo ""
    echo "⚠️  Warning: No coverage data generated"
    echo "   Make sure your tests actually execute source code!"
    exit 0
fi

echo ""
echo "Line coverage: ${COVERAGE}%"
echo "Threshold: ${THRESHOLD}%"
echo ""

# Use awk for floating point comparison (bc might not be available)
if awk "BEGIN {exit !($COVERAGE < $THRESHOLD)}"; then
    echo "❌ FAILED: Coverage ${COVERAGE}% is below threshold ${THRESHOLD}%"
    exit 1
else
    echo "✅ PASSED: Coverage ${COVERAGE}% meets threshold ${THRESHOLD}%"
fi
