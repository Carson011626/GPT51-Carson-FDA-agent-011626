# Running the Streamlit App — Beginner Guide

This guide shows a simple, beginner-friendly way to run the Streamlit app from this repository on another computer (macOS / Linux / Windows).

## Prerequisites
- Git (to clone the repo) or a copy of the project folder.
- Python 3.11 (recommended). The app was tested with Python 3.11.
- Basic terminal/command prompt familiarity.

Optional system tools (needed for OCR / PDF image processing):
- `tesseract` (for OCR)
- `poppler` (`pdftoppm` used by `pdf2image`)

macOS (Homebrew) install examples:

```bash
# install Homebrew if you don't have it
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew install tesseract
brew install poppler
```

Linux (Ubuntu) examples:

```bash
sudo apt update
sudo apt install -y tesseract-ocr poppler-utils
```

Windows:
- Install Tesseract from: https://github.com/tesseract-ocr/tesseract
- Install Poppler binaries (add to PATH) or use WSL with apt commands above.

## 1) Clone the repository (or copy the folder)

```bash
git clone <repo-url>
cd <repo-folder>
# or copy the provided folder to the other computer and `cd` into it
```

## 2) Create and activate a Python virtual environment

macOS / Linux:

```bash
python3.11 -m venv .venv
source .venv/bin/activate
```

Windows (PowerShell):

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
```

Windows (cmd.exe):

```cmd
.\.venv\Scripts\activate.bat
```

## 3) Upgrade pip and install Python dependencies

Install from `requirements.txt` (recommended):

```bash
python -m pip install --upgrade pip
pip install -r requirements.txt
```

If you prefer to install only core packages for a quick run:

```bash
pip install streamlit pyyaml PyPDF2
# and any SDKs you need, e.g.:
pip install openai google-generativeai anthropic xai_sdk
```

Note: some SDKs may require additional binary dependencies or credentials to call remote APIs.

## 4) Configure API keys (if you plan to call LLM providers)

The app reads API keys from environment variables. Set them before running (example for macOS/Linux):

```bash
export OPENAI_API_KEY="sk-..."
export GEMINI_API_KEY="..."
export ANTHROPIC_API_KEY="..."
export XAI_API_KEY="..."
```

On Windows (PowerShell):

```powershell
$env:OPENAI_API_KEY = "sk-..."
```

Do NOT commit keys to the repo. Consider using a `.env` file and `python-dotenv` if you need a safer local workflow.

## 5) Run the Streamlit app

From the project root (where `app.py` lives):

```bash
# recommended (explicit Python interpreter)
python -m streamlit run app.py

# to run on a specific port and headless (useful on servers):
python -m streamlit run app.py --server.port 8501 --server.headless true
```

Open the URL printed by Streamlit, usually:

```
http://localhost:8501
```

## 6) Run in background (macOS / Linux)

Use `nohup` / `&` or `screen` / `tmux`:

```bash
nohup python -m streamlit run app.py --server.port 8501 --server.headless true > streamlit.log 2>&1 &
```

Later, view logs:

```bash
tail -f streamlit.log
```

Stop the server:

```bash
pkill -f streamlit
# or kill the specific PID shown in `ps aux | grep streamlit`
```

## 7) Windows background run

Use `start` or run inside a terminal multiplexer (e.g., `tmux` under WSL) or create a simple batch file and run it.

## 8) Common troubleshooting

- "ModuleNotFoundError" for a package: run `pip install <package>` in the activated venv.
- Permission errors installing packages: avoid `sudo` inside venv; use `--user` only for global installs or activate the venv.
- Missing system tools for OCR: install `tesseract` and `poppler` as shown above.
- Streamlit shows deprecation warnings (e.g., `google.generativeai`): those are warnings only — app still runs; migrate later if you rely on the library.
- If app fails on provider calls: confirm API keys and network access.

## 9) Helpful commands summary

```bash
# create venv
python3.11 -m venv .venv
source .venv/bin/activate

# install deps
pip install -r requirements.txt

# run app
python -m streamlit run app.py --server.port 8501 --server.headless true

# stop
pkill -f streamlit

# run in background
nohup python -m streamlit run app.py --server.port 8501 --server.headless true > streamlit.log 2>&1 &

# view logs
tail -f streamlit.log
```

## 10) Security & best practices
- Never store API keys in the repository. Use environment variables or a secrets manager.
- For production, use a dedicated host or container and protect the app with authentication / network controls.

---

That’s it — a minimal beginner-friendly workflow. If you want, I can:
- Add a `.env.example` with the environment variable names.
- Create a small script (`run.sh`) to automate venv creation and install.
- Add notes for running inside Docker.

## Using `run.sh` and `.env` (Beginner)

This project includes a helper script `run.sh` (in the project root) and an example `.env.example` you can copy to `.env`.

- Create a `.env` from the example and add your API keys (no quotes):

```bash
cp .env.example .env
# edit .env and add your keys, e.g.
# OPENAI_API_KEY=sk-...
# GEMINI_API_KEY=...
```

- Make `run.sh` executable and run it (this will create a venv, install dependencies, load `.env`, and start Streamlit):

```bash
chmod +x run.sh
./run.sh
```

- `run.sh` behavior summary:
	- Creates a virtual environment at `.venv` if it doesn't exist.
	- Activates the venv.
	- Upgrades `pip` and installs `requirements.txt` (if present).
	- Sources `.env` (if present) so environment variables are available to the app.
	- Starts Streamlit on the port in `STREAMLIT_SERVER_PORT` or `8501` by default.

- Override Python interpreter (if needed):

```bash
PYTHON=/usr/local/bin/python3.11 ./run.sh
```

- Run in background (macOS / Linux):

```bash
nohup ./run.sh > streamlit.log 2>&1 &
tail -f streamlit.log
```

- Security note: never commit `.env` into git. Add `.env` to `.gitignore` (the project now includes a `.gitignore` that ignores `.env` and `.venv`).

If you'd like, I can also add a small note to the top of the README linking to this guide.

