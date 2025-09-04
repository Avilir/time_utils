#!/bin/bash
# publish_pypi.sh - Publish time_utils to PyPI (test or production)

set -e  # Exit on error

echo "=== PyPI Publishing Script for time_utils ==="

# Check if virtual environment is active
if [ -z "$VIRTUAL_ENV" ]; then
    echo "Error: Virtual environment is not active. Please activate it first:"
    echo "  source venv/bin/activate"
    exit 1
fi

# Function to check PyPI credentials
check_credentials() {
    local index=$1
    if ! grep -q "password = pypi-" ~/.pypirc 2>/dev/null; then
        echo "Warning: PyPI token not found in ~/.pypirc"
        echo "Please add your $index API token to ~/.pypirc"
        echo "Get tokens from:"
        echo "  TestPyPI: https://test.pypi.org/manage/account/token/"
        echo "  PyPI: https://pypi.org/manage/account/token/"
        return 1
    fi
    return 0
}

# Parse command line arguments
if [ "$1" == "test" ]; then
    REPO="testpypi"
    REPO_URL="https://test.pypi.org"
elif [ "$1" == "prod" ] || [ "$1" == "production" ]; then
    REPO="pypi"
    REPO_URL="https://pypi.org"
else
    echo "Usage: $0 [test|prod]"
    echo "  test - Publish to TestPyPI"
    echo "  prod - Publish to production PyPI"
    exit 1
fi

echo "Target repository: $REPO ($REPO_URL)"
echo ""

# Check for credentials
if ! check_credentials $REPO; then
    echo "Please configure your PyPI credentials and try again."
    exit 1
fi

# Clean previous builds
echo "Cleaning previous builds..."
rm -rf dist/ build/ *.egg-info src/*.egg-info

# Run tests first
echo "Running tests..."
python -m pytest --quiet
if [ $? -ne 0 ]; then
    echo "Error: Tests failed. Fix tests before publishing."
    exit 1
fi
echo "Tests passed ✓"

# Build the package
echo "Building package..."
python -m build
echo "Build complete ✓"

# Check the distributions
echo "Checking distributions..."
twine check dist/*
echo "Distribution check passed ✓"

# Upload to PyPI
echo ""
echo "Ready to upload to $REPO"
echo "Files to upload:"
ls -la dist/
echo ""
read -p "Continue with upload? [y/N] " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Uploading to $REPO..."
    twine upload --repository $REPO dist/*
    echo ""
    echo "✅ Upload complete!"
    echo ""
    echo "View your package at:"
    if [ "$REPO" == "testpypi" ]; then
        echo "  $REPO_URL/project/time-utils/"
        echo ""
        echo "To test installation:"
        echo "  pip install --index-url https://test.pypi.org/simple/ --extra-index-url https://pypi.org/simple/ time-utils"
    else
        echo "  $REPO_URL/project/time-utils/"
        echo ""
        echo "To install:"
        echo "  pip install time-utils"
    fi
else
    echo "Upload cancelled."
    exit 1
fi
