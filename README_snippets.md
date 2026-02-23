# ALM Reporting DB Kit (SQLite)

This kit provides:
- a small SQLite DB (`db/alm_mock.sqlite`) with synthetic ALM-style data
- canned SQL queries (`sql/queries/*.sql`)
- a Python exporter that runs the SQL and writes CSVs for Excel ingestion

Typical workflow:
```bash
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt

python scripts/export_queries.py --asof 2026-02-20 --out outputs/sql_exports
```
Excel then imports the CSVs and refreshes pivots/charts via a macro (see guidance in the chat).
