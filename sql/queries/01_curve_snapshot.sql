-- Curve snapshot for a given as-of date
-- params: :asof_date
SELECT asof_date, curve_name, tenor, rate
FROM market_curve
WHERE asof_date = :asof_date AND curve_name = 'USD-SOFR-OIS'
ORDER BY
  CASE tenor
    WHEN '1M' THEN 1 WHEN '3M' THEN 2 WHEN '6M' THEN 3 WHEN '1Y' THEN 4
    WHEN '2Y' THEN 5 WHEN '5Y' THEN 6 WHEN '10Y' THEN 7 WHEN '30Y' THEN 8
    ELSE 999
  END;
