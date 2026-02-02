with union_data as(
    SELECT
        DATE_ADD(ss.date, INTERVAL s.sent_date DAY ) as date,
        sp.country,
        count(distinct s.id_message) as sent_cnt,
        count(distinct o.id_message) as open_cnt,
        count(distinct v.id_message) as click_cnt,
        null as account_cnt

FROM
    `DA.email_sent` s
LEFT JOIN
    `DA.account_session` ac ON s.id_account = ac.account_id
LEFT JOIN
    `DA.session_params` sp ON ac.ga_session_id = sp.ga_session_id
LEFT JOIN
    `DA.email_open` o ON s.id_message = o.id_message
LEFT JOIN
    `DA.email_visit` v ON o.id_message = v.id_message
JOIN
    `DA.session` ss ON ac.ga_session_id = ss.ga_session_id
GROUP BY
    sp.country,
    DATE_ADD (ss.date, INTERVAL s.sent_date DAY ) 

UNION ALL

SELECT
    ss.date,
    sp.country,
    null, null, null,
    count(ac.account_id) as account_cnt
FROM
    `DA.account_session` ac
LEFT JOIN
    `DA.session_params` sp ON ac.ga_session_id = sp.ga_session_id
JOIN
    `DA.session` ss ON ac.ga_session_id = ss.ga_session_id
GROUP BY
    ss.date,
    sp.country
)

SELECT
    date,
    country,
    sum(sent_cnt) as sent_cnt, 
    sum(open_cnt) as open_cnt,
    sum(click_cnt) as click_cnt,
    sum(account_cnt) as account_cnt,
FROM
    union_data
GROUP BY
    date,
    country
