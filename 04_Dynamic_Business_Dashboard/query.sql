WITH revenue_base AS (
 SELECT
   sp.country,
   s.date,
   p.price AS revenue_value,
   device,
   operating_system
 FROM `data-analytics-mate.DA.order` o
 JOIN `data-analytics-mate.DA.product` p ON o.item_id = p.item_id
 JOIN `data-analytics-mate.DA.session_params` sp ON o.ga_session_id = sp.ga_session_id
 LEFT JOIN `data-analytics-mate.DA.session` s ON sp.ga_session_id = s.ga_session_id
),
registration_base AS (
 SELECT
   sp.country,
   s.date,
   sp.ga_session_id,
   ac.account_id
 FROM `data-analytics-mate.DA.session_params` sp
 LEFT JOIN `data-analytics-mate.DA.account_session` ac ON sp.ga_session_id = ac.ga_session_id
 LEFT JOIN `data-analytics-mate.DA.session` s ON sp.ga_session_id = s.ga_session_id
),
email_base AS (
 SELECT
   sp.country,
   s.date,
   ems.id_message
 FROM `data-analytics-mate.DA.email_sent` ems
 JOIN `data-analytics-mate.DA.account_session` ac ON ems.id_account = ac.account_id
 JOIN `data-analytics-mate.DA.session_params` sp ON ac.ga_session_id = sp.ga_session_id
 LEFT JOIN `data-analytics-mate.DA.session` s ON ac.ga_session_id = s.ga_session_id
)
SELECT 
    country, 
    date, 
    'Revenue' as type, 
    revenue_value as value, 
    operating_system, 
    device 
FROM revenue_base
UNION ALL
SELECT 
    country, 
    date, 
    'Session' as type, 
    1 as value, 
    NULL, 
    NULL 
FROM registration_base
UNION ALL
SELECT 
    country, 
    date, 
    'Registration' as type, 
    (CASE WHEN account_id IS NOT NULL THEN 1 ELSE 0 END) as value, 
    NULL, 
    NULL 
FROM registration_base
UNION ALL
SELECT 
    country, 
    date, 
    'Email' as type, 
    1 as value, 
    NULL, 
    NULL 
FROM email_base
