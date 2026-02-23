PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS fact_positions;
DROP TABLE IF EXISTS market_curve;
DROP TABLE IF EXISTS fact_liquidity_metrics;
DROP TABLE IF EXISTS dim_portfolio;

CREATE TABLE dim_portfolio (
  portfolio_id INTEGER PRIMARY KEY,
  portfolio_name TEXT NOT NULL,
  desk TEXT NOT NULL
);

CREATE TABLE market_curve (
  asof_date TEXT NOT NULL,
  curve_name TEXT NOT NULL,
  tenor TEXT NOT NULL,
  rate REAL NOT NULL,
  PRIMARY KEY (asof_date, curve_name, tenor)
);

CREATE TABLE fact_positions (
  asof_date TEXT NOT NULL,
  trade_id TEXT NOT NULL,
  portfolio_id INTEGER NOT NULL,
  instrument_type TEXT NOT NULL,
  currency TEXT NOT NULL,
  float_index TEXT NOT NULL,
  pay_receive_fixed TEXT NOT NULL,
  notional REAL NOT NULL,
  fixed_rate REAL NOT NULL,
  float_spread_bps REAL NOT NULL,
  effective_date TEXT NOT NULL,
  maturity_date TEXT NOT NULL,
  fixed_leg_freq TEXT NOT NULL,
  float_leg_freq TEXT NOT NULL,
  PRIMARY KEY (asof_date, trade_id),
  FOREIGN KEY (portfolio_id) REFERENCES dim_portfolio(portfolio_id)
);

CREATE TABLE fact_liquidity_metrics (
  asof_date TEXT NOT NULL,
  portfolio_id INTEGER NOT NULL,
  hqla_usd REAL NOT NULL,
  net_outflows_30d_usd REAL NOT NULL,
  lcr REAL NOT NULL,
  nsfr REAL NOT NULL,
  slr REAL NOT NULL,
  PRIMARY KEY (asof_date, portfolio_id),
  FOREIGN KEY (portfolio_id) REFERENCES dim_portfolio(portfolio_id)
);
