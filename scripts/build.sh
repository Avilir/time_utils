#!/bin/bash
# build.sh - Build source and wheel distributions for time_utils

set -e  # Exit on error

echo "=== Building time_utils distributions ==="

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    echo "Error: Virtual environment not found. Run './scripts/setup_dev.sh' first."
    exit 1
fi

# Activate virtual environment
echo "Activating virtual environment..."
source venv/bin/activate

# Check if build tool is installed
if ! python -m build --version &> /dev/null; then
    echo "Error: build tool not found. Installing..."
    pip install build
fi

# Clean previous builds
echo "Cleaning previous builds..."
rm -rf build/ dist/ *.egg-info src/*.egg-info

# Run tests first
echo "Running tests before building..."
python -m pytest --quiet
if [ $? -ne 0 ]; then
    echo "Error: Tests failed. Fix tests before building."
    exit 1
fi
echo "Tests passed ✓"

# Check code quality
echo "Checking code quality..."
ruff check . --quiet
if [ $? -ne 0 ]; then
    echo "Error: Linting failed. Fix linting issues before building."
    exit 1
fi
echo "Code quality check passed ✓"

# Run type checking
echo "Running type checks..."
mypy src --quiet
if [ $? -ne 0 ]; then
    echo "Error: Type checking failed. Fix type issues before building."
    exit 1
fi
echo "Type checking passed ✓"

# Build distributions
echo "Building source distribution..."
python -m build --sdist

echo "Building wheel distribution..."
python -m build --wheel

# Validate distributions
echo ""
echo "Validating distributions..."
if command -v twine &> /dev/null; then
    twine check dist/*
else
    echo "Twine not installed, skipping distribution validation"
fi

# List created distributions
echo ""
echo "=== Build complete! ==="
echo "Created distributions:"
ls -lh dist/

echo ""
echo "To upload to PyPI (when ready):"
echo "  twine upload dist/*"
echo ""
echo "To upload to TestPyPI first:"
echo "  twine upload --repository testpypi dist/*"
