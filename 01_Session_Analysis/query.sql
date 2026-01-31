SELECT
  sp.*,
  s.date
FROM
  `data-analytics-mate.DA.session_params` sp
JOIN
  `DA.session` s ON sp.ga_session_id = s.ga_session_id
