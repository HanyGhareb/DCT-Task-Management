SELECT SUBSTR(h.source, 1, 300) AS src
FROM   user_ords_modules m
JOIN   user_ords_templates t ON t.module_id = m.id
JOIN   user_ords_handlers  h ON h.template_id = t.id
WHERE  m.name          = 'dct.admin'
  AND  t.uri_template  = 'settings/'
  AND  h.method        = 'GET';
