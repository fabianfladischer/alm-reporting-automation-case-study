-- Liquidity KPIs (last N days) for one portfolio
-- params: :portfolio_id, :days, :asof_date
SELECT asof_date, portfolio_id,
       ROUND(lcr, 4) AS lcr,
       ROUND(nsfr, 4) AS nsfr,
       ROUND(slr, 4) AS slr
FROM fact_liquidity_metrics
WHERE portfolio_id = :portfolio_id
  AND asof_date >= date(:asof_date, '-' || :days || ' day')
  AND asof_date <= :asof_date
ORDER BY asof_date;
