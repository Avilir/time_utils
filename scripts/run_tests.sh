#!/bin/bash
# run_tests.sh - Run tests with coverage for time_utils

set -e  # Exit on error

echo "=== Running time_utils tests ==="

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    echo "Error: Virtual environment not found. Run './scripts/setup_dev.sh' first."
    exit 1
fi

# Activate virtual environment
echo "Activating virtual environment..."
source venv/bin/activate

# Check if pytest is installed
if ! command -v pytest &> /dev/null; then
    echo "Error: pytest not found. Run 'pip install -r requirements-dev.txt' to install dependencies."
    exit 1
fi

# Run tests with coverage
echo "Running tests with coverage..."
python -m pytest -v

# Show coverage report
echo ""
echo "=== Coverage Summary ==="
coverage report

# Generate HTML coverage report
echo ""
echo "Generating HTML coverage report..."
coverage html
echo "HTML coverage report generated in htmlcov/"

# Check coverage threshold
coverage_percent=$(coverage report | grep TOTAL | awk '{print $4}' | sed 's/%//')
threshold=100

echo ""
if [ "${coverage_percent%.*}" -lt "$threshold" ]; then
    echo "⚠️  Warning: Coverage is below $threshold% (currently $coverage_percent%)"
    exit 1
else
    echo "✓ Coverage is $coverage_percent%"
fi

echo ""
echo "=== Tests completed successfully! ==="
