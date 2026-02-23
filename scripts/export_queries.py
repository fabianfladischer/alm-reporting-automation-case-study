#!/usr/bin/env python3
"""Run canned SQL queries against the mock DB and export results as CSV (for Excel ingestion)."""
from __future__ import annotations
import argparse, sqlite3
from pathlib import Path
import pandas as pd

ROOT = Path(__file__).resolve().parents[1]
DB_PATH = ROOT / "db" / "alm_mock.sqlite"
QUERY_DIR = ROOT / "sql" / "queries"

def run_query(con: sqlite3.Connection, sql: str, params: dict) -> pd.DataFrame:
    return pd.read_sql_query(sql, con, params=params)

def main(argv: list[str] | None = None) -> int:
    p = argparse.ArgumentParser()
    p.add_argument("--asof", required=True, help="As-of date YYYY-MM-DD (e.g. 2026-02-20)")
    p.add_argument("--out", default="outputs/sql_exports", help="Output folder for CSV exports")
    p.add_argument("--portfolio-id", type=int, default=2, help="Portfolio id for liquidity time series")
    p.add_argument("--days", type=int, default=60, help="Lookback days for liquidity time series")
    p.add_argument("--top-n", type=int, default=10, help="Top N trades by abs DV01")
    args = p.parse_args(argv)

    out = Path(args.out)
    out.mkdir(parents=True, exist_ok=True)

    con = sqlite3.connect(DB_PATH)

    (run_query(con, (QUERY_DIR / "01_curve_snapshot.sql").read_text(encoding="utf-8"), {"asof_date": args.asof})
        .to_csv(out / "curve_snapshot.csv", index=False))

    (run_query(con, (QUERY_DIR / "02_maturity_ladder.sql").read_text(encoding="utf-8"), {"asof_date": args.asof})
        .to_csv(out / "maturity_ladder.csv", index=False))

    (run_query(con, (QUERY_DIR / "03_dv01_by_bucket.sql").read_text(encoding="utf-8"), {"asof_date": args.asof})
        .to_csv(out / "dv01_by_bucket.csv", index=False))

    (run_query(con, (QUERY_DIR / "04_liquidity_timeseries.sql").read_text(encoding="utf-8"),
               {"asof_date": args.asof, "portfolio_id": args.portfolio_id, "days": args.days})
        .to_csv(out / "liquidity_timeseries.csv", index=False))

    (run_query(con, (QUERY_DIR / "05_top_trades_dv01.sql").read_text(encoding="utf-8"), {"asof_date": args.asof, "n": args.top_n})
        .to_csv(out / "top_trades_dv01.csv", index=False))

    con.close()
    print(f"Wrote CSV exports to: {out}")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
