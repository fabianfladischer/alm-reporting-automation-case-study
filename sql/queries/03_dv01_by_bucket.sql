-- Simple DV01 approximation by bucket (USD)
-- params: :asof_date
WITH pos AS (
  SELECT trade_id, pay_receive_fixed, notional,
         (julianday(maturity_date) - julianday(effective_date))/360.0 AS years_to_mat
  FROM fact_positions
  WHERE asof_date = :asof_date
),
dv AS (
  SELECT
    CASE
      WHEN years_to_mat <= 1 THEN '0-1Y'
      WHEN years_to_mat <= 2 THEN '1-2Y'
      WHEN years_to_mat <= 5 THEN '2-5Y'
      WHEN years_to_mat <= 10 THEN '5-10Y'
      ELSE '10Y+'
    END AS bucket,
    (CASE WHEN pay_receive_fixed='RECEIVE' THEN 1 ELSE -1 END) AS sgn,
    notional,
    years_to_mat
  FROM pos
)
SELECT bucket,
       ROUND(SUM(sgn * notional * (years_to_mat*0.85) * 0.0001), 2) AS dv01_usd
FROM dv
GROUP BY bucket
ORDER BY
  CASE bucket WHEN '0-1Y' THEN 1 WHEN '1-2Y' THEN 2 WHEN '2-5Y' THEN 3 WHEN '5-10Y' THEN 4 ELSE 5 END;
