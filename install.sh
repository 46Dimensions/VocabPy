#!/usr/bin/env sh

set -e

echo "=== VocabPy Installer ==="

# ---------------- Configuration ----------------
REQ_URL="https://raw.githubusercontent.com/46Dimensions/VocabPy/main/requirements.txt"
SCRIPT_URL="https://raw.githubusercontent.com/46Dimensions/VocabPy/main/main.py"
SCRIPT_NAME="main.py"
# ------------------------------------------------------

echo "Downloading requirements..."
curl -fsSL "$REQ_URL" -o requirements.txt

echo "Downloading main program (main.py)..."
curl -fsSL "$SCRIPT_URL" -o "$SCRIPT_NAME"

echo "Creating virtual environment..."
python3 -m venv venv

# Detect Python inside venv
if [ "$(uname)" = "Darwin" ] || [ "$(uname)" = "Linux" ]; then
    PY="venv/bin/python3"
else
    PY="venv/Scripts/python.exe"
fi

echo "Upgrading pip..."
"$PY" -m pip install --upgrade pip

echo "Installing dependencies..."
"$PY" -m pip install -r requirements.txt

echo
echo "=== Installation complete! Launching VocabPy... ==="
echo

"$PY" "$SCRIPT_NAME"

echo
echo "Done!"
echo "To run VocabPy again later:"
if [ "$(uname)" = "Darwin" ] || [ "$(uname)" = "Linux" ]; then
    echo "  source venv/bin/activate && python main.py"
else
    echo "  venv\\Scripts\\activate && python main.py"
fi
echo
