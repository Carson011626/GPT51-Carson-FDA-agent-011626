#!/usr/bin/env bash
set -euo pipefail

# Small helper to create/activate a venv, install requirements, load .env and run Streamlit
# Usage: ./run.sh  (or P.YTHON env var to override `python3.11`)

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
VENV_DIR=".venv"
PYTHON=${PYTHON:-python3.11}

echo "Using python: $PYTHON"

if [ ! -d "$VENV_DIR" ]; then
  echo "Creating virtualenv in $VENV_DIR..."
  $PYTHON -m venv "$VENV_DIR"
fi

echo "Activating venv..."
. "$VENV_DIR/bin/activate"

echo "Upgrading pip and installing requirements..."
python -m pip install --upgrade pip
if [ -f requirements.txt ]; then
  python -m pip install -r requirements.txt
else
  echo "requirements.txt not found; install dependencies manually."
fi

if [ -f .env ]; then
  echo "Loading environment variables from .env"
  set -a
  # shellcheck disable=SC1091
  . .env
  set +a
fi

PORT="${STREAMLIT_SERVER_PORT:-8501}"
echo "Starting Streamlit on port $PORT..."
streamlit run app.py --server.port "$PORT" --server.headless true
