#!/usr/bin/env python3
"""Build (or rebuild) the SQLite mock database."""
from __future__ import annotations
from pathlib import Path
import subprocess, sys

def main() -> int:
    # This repo ships a ready DB at db/alm_mock.sqlite.
    # Rebuild by running the generation notebook/script in this folder if you want to customize.
    print("DB is already present at db/alm_mock.sqlite. If you need regeneration, replace this stub with your generator.")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
