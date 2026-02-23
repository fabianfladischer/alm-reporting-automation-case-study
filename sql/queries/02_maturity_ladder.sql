-- Notional maturity ladder by bucket (USD mm)
-- params: :asof_date
WITH pos AS (
  SELECT trade_id, pay_receive_fixed, notional,
         julianday(maturity_date) - julianday(effective_date) AS days_to_mat
  FROM fact_positions
  WHERE asof_date = :asof_date
),
buck AS (
  SELECT
    CASE
      WHEN days_to_mat <= 360 THEN '0-1Y'
      WHEN days_to_mat <= 720 THEN '1-2Y'
      WHEN days_to_mat <= 1800 THEN '2-5Y'
      WHEN days_to_mat <= 3600 THEN '5-10Y'
      ELSE '10Y+'
    END AS bucket,
    pay_receive_fixed,
    notional
  FROM pos
)
SELECT bucket, pay_receive_fixed,
       ROUND(SUM(notional)/1e6, 2) AS notional_usd_mm
FROM buck
GROUP BY bucket, pay_receive_fixed
ORDER BY
  CASE bucket WHEN '0-1Y' THEN 1 WHEN '1-2Y' THEN 2 WHEN '2-5Y' THEN 3 WHEN '5-10Y' THEN 4 ELSE 5 END,
  pay_receive_fixed;
