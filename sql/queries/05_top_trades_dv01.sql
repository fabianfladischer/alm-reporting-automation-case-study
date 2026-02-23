-- Top trades by absolute DV01 (simple approximation)
-- params: :asof_date, :n
WITH pos AS (
  SELECT trade_id, portfolio_id, pay_receive_fixed, notional,
         (julianday(maturity_date) - julianday(effective_date))/360.0 AS years_to_mat
  FROM fact_positions
  WHERE asof_date = :asof_date
),
dv AS (
  SELECT trade_id, portfolio_id, pay_receive_fixed,
         ROUND((CASE WHEN pay_receive_fixed='RECEIVE' THEN 1 ELSE -1 END) * notional * (years_to_mat*0.85) * 0.0001, 2) AS dv01_usd
  FROM pos
)
SELECT d.trade_id, p.portfolio_name, d.pay_receive_fixed, d.dv01_usd
FROM dv d
JOIN dim_portfolio p USING (portfolio_id)
ORDER BY ABS(d.dv01_usd) DESC
LIMIT :n;
