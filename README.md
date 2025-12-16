# C++ Project Template

[![CI](https://github.com/jasonjdominguez99/modern-cpp-project-template/actions/workflows/ci.yml/badge.svg)](https://github.com/jasonjdominguez99/modern-cpp-project-template)
[![codecov](https://codecov.io/gh/jasonjdominguez99/modern-cpp-project-template/branch/main/graph/badge.svg)](https://codecov.io/gh/jasonjdominguez99/modern-cpp-project-template)

> **TODO for template users:** Update the badge URLs above (lines 3-4) to point to your own repository. Replace `jasonjdominguez99/modern-cpp-project-template` with your GitHub username and repository name.

A modern C++23 project template with best practices, testing, benchmarking, and CI/CD.

## Features

- **C++23 Standard** - Latest C++ features
- **Modern CMake** (3.25+) - Clean, maintainable build system
- **Multi-Compiler Support** - GCC, Clang, AppleClang with automatic detection
- **Comprehensive Warnings** - Strict warning configuration with `-Werror` in debug builds
- **Memory Sanitizers** - ASAN, UBSAN, and TSAN for bug detection
- **Google Test** - Unit testing framework
- **Google Benchmark** - Performance benchmarking (opt-in to save compile time)
- **Code Coverage** - Track test coverage with Codecov integration
- **clang-format** - Automatic code formatting (Google C++ style)
- **pre-commit hooks** - Enforce code quality
- **GitHub Actions CI** - Automated testing on Linux & macOS
- **Convenience scripts** - User-friendly build scripts

## Quick Start

### Prerequisites

- CMake 3.25+
- C++23 compatible compiler:
  - **GCC 14+** or **Clang 16+** (Linux)
  - **AppleClang** (macOS - comes with Xcode Command Line Tools)
  - **Homebrew LLVM** (macOS - optional, `brew install llvm`)
  - **Homebrew GCC** (macOS - optional, `brew install gcc`)
- (Optional) lcov for coverage reports: `brew install lcov` / `apt install lcov`
- (Optional) Doxygen for API documentation: `brew install doxygen` / `apt install doxygen`

### Build & Run

```bash
# Build (debug mode with ASAN + UBSAN)
./scripts/build.sh

# Or explicitly choose compiler
./scripts/build.sh debug gcc-15
./scripts/build.sh debug appleclang

# List available compilers
./scripts/build.sh --list-compilers

# Run the demo
./scripts/run.sh

# Run tests
./scripts/test.sh

# Run benchmarks (builds benchmarks on first run)
./scripts/benchmark.sh

# Clean build artifacts
./scripts/clean.sh
```

### Build Modes

The build system supports multiple modes with different optimizations and sanitizers:

```bash
# Debug mode (default) - ASAN + UBSAN, warnings as errors
./scripts/build.sh debug [compiler]

# Debug with Thread Sanitizer - TSAN, warnings as errors
./scripts/build.sh debug-tsan [compiler]

# Release mode - Optimized, no sanitizers, warnings enabled
./scripts/build.sh release [compiler]
```

### Compiler Selection

The build script automatically detects available compilers and lets you choose:

```bash
# List all available compilers
./scripts/build.sh --list-compilers

# Use specific compiler
./scripts/build.sh debug gcc-15
./scripts/build.sh debug clang-18
./scripts/build.sh debug appleclang

# Use latest available (auto-selects latest version)
./scripts/build.sh debug gcc    # Finds latest gcc (gcc-15, gcc-14, etc.)
./scripts/build.sh debug clang  # Finds latest clang

# Interactive selection (prompts you to choose)
./scripts/build.sh debug --select

# Reset saved compiler preference
./scripts/build.sh --compiler-reset
```

The script saves your compiler choice, so you don't need to specify it every time.

## Development

### Running Tests

Tests run in debug mode by default (with ASAN + UBSAN for bug detection):

```bash
./scripts/test.sh
```

Or with a specific build mode:
```bash
./scripts/test.sh debug       # Default: ASAN + UBSAN
./scripts/test.sh debug-tsan  # Thread Sanitizer
./scripts/test.sh release     # No sanitizers
```

### Running Benchmarks

Benchmarks are **opt-in** to save compile time during regular development. They're only built when you explicitly run the benchmark script:

```bash
# Build and run benchmarks (defaults to release mode for accurate results)
./scripts/benchmark.sh

# Run with specific build mode
./scripts/benchmark.sh release
./scripts/benchmark.sh debug  # For debugging benchmark code

# Pass arguments to Google Benchmark
./scripts/benchmark.sh --benchmark_filter=MyBench
./scripts/benchmark.sh --benchmark_min_time=5s
```

The first run will build Google Benchmark and your benchmarks (~30-40% slower than regular builds). Subsequent runs are fast.

### Code Coverage

```bash
./scripts/coverage.sh
open coverage/html/index.html
```

### Code Formatting

```bash
# Format all files
pre-commit run --all-files

# Auto-format on commit
pre-commit install
```

### API Documentation

```bash
# Generate Doxygen documentation
./scripts/docs.sh

# View generated docs
open docs/html/index.html
```

## Project Structure

```
.
├── src/                 # Source files
├── include/             # Header files
├── tests/               # Unit tests (Google Test)
├── benchmarks/          # Performance benchmarks (Google Benchmark, opt-in)
├── scripts/             # Build/test convenience scripts
├── .github/workflows/   # CI/CD configuration
├── CMakeLists.txt       # CMake configuration
├── Doxyfile             # Doxygen configuration for API docs
├── .clang-format        # Code formatting rules (Google style)
├── .pre-commit-config.yaml  # Pre-commit hooks
└── .editorconfig        # Editor configuration
```

## Using as a Template

1. Click "Use this template" on GitHub (or clone/fork)
2. Update the badge URLs in this README (lines 3-4) with your GitHub username/repo
3. Set up Codecov:
   - Create account at [codecov.io](https://codecov.io) and add your repository
   - Add `CODECOV_TOKEN` as a GitHub secret (Settings → Secrets and variables → Actions)
   - After first CI run with coverage, verify badges are working
4. Find and replace `hello_world` with your project name
5. Update `CMakeLists.txt` project name and version
6. Update this README with your project details
7. Start coding!

## CI/CD

GitHub Actions automatically:
- Builds on Ubuntu (GCC 14 & Clang) and macOS (AppleClang)
- Runs all tests with **Address Sanitizer (ASAN)** and **Undefined Behavior Sanitizer (UBSAN)**
- Enforces **warnings as errors** to catch code quality issues
- Generates code coverage reports
- **Benchmarks are NOT run in CI** (only built/run locally for performance work)
- **100% free for public repos!**

See `.github/workflows/ci.yml` for configuration.

## Compiler Support

### Multiple Compilers

The template detects and supports multiple compilers:
- **GCC**: gcc-15, gcc-14, gcc-13, etc.
- **Clang**: clang-19, clang-18, clang-17, etc.
- **Homebrew LLVM**: Latest LLVM/Clang from Homebrew
- **AppleClang**: System Clang on macOS

Use `./scripts/build.sh --list-compilers` to see what's available on your system.

### Sanitizer Support

| Sanitizer | Linux GCC | Linux Clang | macOS AppleClang | macOS GCC |
|-----------|-----------|-------------|------------------|-----------|
| ASAN      | ✅        | ✅          | ✅               | ❌        |
| UBSAN     | ✅        | ✅          | ✅               | ❌        |
| TSAN      | ✅        | ✅          | ✅               | ❌        |

**Note:** GCC on macOS (Homebrew) doesn't include sanitizer runtime libraries. Use AppleClang or Homebrew LLVM for sanitizers on macOS.

### macOS Configuration

The template automatically handles macOS-specific setup:
- **Homebrew LLVM**: Auto-configures libc++ paths for C++23 support
- **AppleClang**: Uses system clang (no additional setup needed)
- **GCC**: Disables Apple-specific flags and sanitizers

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.
