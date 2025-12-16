# Contributing

Thank you for your interest in contributing! This guide will help you get started.

## Development Setup

### Prerequisites

- CMake 3.25+
- C++23 compatible compiler:
  - **Linux**: GCC 14+ or Clang 16+
  - **macOS**: AppleClang (Xcode Command Line Tools), Homebrew LLVM, or Homebrew GCC
- Python 3.7+ (for pre-commit hooks)
- (Optional) lcov for coverage reports

### Initial Setup

```bash
# Clone the repository
git clone <your-repo-url>
cd modern-cpp-project-template

# Install pre-commit hooks
pip install pre-commit
pre-commit install
```

## Building the Project

### Using Convenience Scripts (Recommended)

The project includes user-friendly scripts that handle compiler selection and build configuration:

```bash
# List available compilers on your system
./scripts/build.sh --list-compilers

# Build in debug mode (default) - ASAN + UBSAN, warnings as errors
./scripts/build.sh

# Build with specific compiler
./scripts/build.sh debug gcc-15
./scripts/build.sh debug appleclang

# Build in different modes
./scripts/build.sh debug        # ASAN + UBSAN, warnings as errors
./scripts/build.sh debug-tsan   # TSAN, warnings as errors
./scripts/build.sh release      # Optimized, no sanitizers, warnings enabled

# Interactive compiler selection
./scripts/build.sh debug --select

# Reset saved compiler preference
./scripts/build.sh --compiler-reset
```

The build script automatically:
- Detects available compilers (GCC, Clang, AppleClang, etc.)
- Saves your compiler choice for future builds
- Auto-cleans when switching compilers to avoid CMake cache issues
- Shows full version numbers (e.g., "GCC 15.2.0")

### Compiler Selection

You can specify compilers in several ways:

```bash
# Specific version
./scripts/build.sh debug gcc-15
./scripts/build.sh debug clang-18

# Generic (auto-selects latest available)
./scripts/build.sh debug gcc    # Finds latest gcc (gcc-15, gcc-14, etc.)
./scripts/build.sh debug clang  # Finds latest clang

# By name
./scripts/build.sh debug appleclang  # macOS system clang
./scripts/build.sh debug llvm        # Homebrew LLVM
```

### Manual CMake (Advanced)

If you need more control:

```bash
# Debug build with ASAN + UBSAN
cmake -B build -S . \
  -DCMAKE_BUILD_TYPE=Debug \
  -DENABLE_ASAN=ON \
  -DENABLE_UBSAN=ON

# Release build
cmake -B build -S . \
  -DCMAKE_BUILD_TYPE=Release

# Build benchmarks (normally skipped to save time)
cmake -B build -S . \
  -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_BENCHMARKS=ON

cmake --build build
```

## Running Tests

Tests run in debug mode by default with ASAN + UBSAN for maximum bug detection:

```bash
# Run all tests (default: debug mode with ASAN + UBSAN)
./scripts/test.sh

# Run with different build modes
./scripts/test.sh debug       # ASAN + UBSAN
./scripts/test.sh debug-tsan  # Thread Sanitizer
./scripts/test.sh release     # No sanitizers

# Or manually
cd build && ctest --output-on-failure
```

### Sanitizer Support

The project uses sanitizers to catch bugs during testing:
- **ASAN** (Address Sanitizer) - Catches memory errors
- **UBSAN** (Undefined Behavior Sanitizer) - Catches undefined behavior
- **TSAN** (Thread Sanitizer) - Catches race conditions

**Note:** GCC on macOS doesn't support sanitizers. Use AppleClang or Homebrew LLVM instead.

## Running Benchmarks

Benchmarks are **opt-in** to save compile time during regular development. They're only built when you explicitly run the benchmark script:

```bash
# Build and run benchmarks (defaults to release mode)
./scripts/benchmark.sh

# Run with specific build mode
./scripts/benchmark.sh release  # Recommended for accurate results
./scripts/benchmark.sh debug    # For debugging benchmark code

# Pass arguments to Google Benchmark
./scripts/benchmark.sh --benchmark_filter=MyBench
./scripts/benchmark.sh --benchmark_min_time=5s
./scripts/benchmark.sh --benchmark_repetitions=10
./scripts/benchmark.sh --benchmark_format=json --benchmark_out=results.json
```

The first time you run benchmarks, they'll be built (adds ~30-40% to build time). Subsequent runs reuse the built benchmarks.

## Code Coverage

Generate coverage reports to ensure your tests cover your code:

```bash
# Generate coverage report
./scripts/coverage.sh

# View results
open coverage/html/index.html  # macOS
xdg-open coverage/html/index.html  # Linux
```

## Code Style

### Formatting (clang-format)

This project uses **Google C++ Style** with clang-format.

```bash
# Format all files
pre-commit run clang-format --all-files

# Or manually
clang-format -i src/*.cpp include/*.h
```

Pre-commit hooks will automatically format code before commits.

### Compiler Warnings

The project enforces strict warning standards:
- **Debug builds**: All warnings enabled + `-Werror` (warnings as errors)
- **Release builds**: All warnings enabled, but not treated as errors
- **Compiler-specific warnings**: GCC and Clang each enable additional warnings

Code must compile without warnings in debug mode to ensure quality.

## Documentation Style

Use Doxygen comments for all public APIs:

```cpp
/**
 * @brief Brief description of the function
 *
 * Detailed description if needed.
 *
 * @param name Parameter description
 * @return Description of return value
 */
std::string my_function(const std::string& name);
```

See `include/hello_world.h` for examples.

### Generating Documentation

```bash
# Install Doxygen (if not already installed)
brew install doxygen  # macOS
# or
sudo apt install doxygen  # Linux

# Generate documentation
./scripts/docs.sh

# Or manually
doxygen Doxyfile

# View generated docs
open docs/html/index.html  # macOS
xdg-open docs/html/index.html  # Linux
```

The generated documentation will be in the `docs/` directory (git-ignored).

## Pull Request Process

1. **Create a branch** from `main` for your changes
2. **Choose a compiler** and build mode for development
3. **Make your changes** following the code style
4. **Add tests** for new functionality
5. **Run tests** with sanitizers to catch bugs
6. **Update documentation** if adding features
7. **Run pre-commit hooks**: `pre-commit run --all-files`
8. **Submit a PR** with a clear description of changes

### PR Checklist

Before submitting a pull request, ensure:

- [ ] Code follows style guide (clang-format applied)
- [ ] All tests pass (`./scripts/test.sh`)
- [ ] Tests pass with sanitizers (ASAN + UBSAN)
- [ ] New tests added for new features
- [ ] Code compiles without warnings in debug mode
- [ ] Documentation updated (if needed)
- [ ] Pre-commit hooks pass
- [ ] Tested with multiple compilers (if possible)

### Testing with Multiple Compilers

While not required, testing with multiple compilers catches more issues:

```bash
# Test with GCC
./scripts/build.sh debug gcc
./scripts/test.sh

# Test with Clang
./scripts/build.sh debug clang
./scripts/test.sh
```

The CI will automatically test with GCC and Clang on Linux, plus AppleClang on macOS.

## Commit Messages

Write clear, concise commit messages:

```
Brief summary (50 chars or less)

More detailed explanation if needed. Wrap at 72 characters.
Explain the problem this commit solves and why this approach
was chosen.
```

## Project Structure

```
.
├── src/                 # Source files (.cpp)
├── include/             # Public headers (.h)
├── tests/               # Unit tests (Google Test)
├── benchmarks/          # Performance benchmarks (Google Benchmark, opt-in)
├── scripts/             # Build/test convenience scripts
│   ├── build.sh         # Main build script (compiler selection, build modes)
│   ├── test.sh          # Run tests
│   ├── benchmark.sh     # Build and run benchmarks
│   ├── run.sh           # Run demo executable
│   ├── clean.sh         # Clean build artifacts
│   ├── coverage.sh      # Generate coverage reports
│   └── docs.sh          # Generate API documentation
├── .github/workflows/   # CI/CD configuration
├── CMakeLists.txt       # Main CMake configuration
├── Doxyfile             # Doxygen configuration for API docs
├── .clang-format        # Code formatting rules
└── .pre-commit-config.yaml  # Pre-commit hooks
```

## CI/CD

The GitHub Actions CI automatically:
- Builds on Linux (GCC 14 & Clang) and macOS (AppleClang)
- Runs all tests with ASAN + UBSAN
- Enforces warnings as errors
- Generates code coverage reports

**Note:** Benchmarks are NOT run in CI to save time and because CI runners have variable performance.

## Getting Help

- Open an issue for bugs or feature requests
- Check existing issues before creating new ones
- Be respectful and constructive in discussions

## License

By contributing, you agree that your contributions will be licensed under the same license as the project.
