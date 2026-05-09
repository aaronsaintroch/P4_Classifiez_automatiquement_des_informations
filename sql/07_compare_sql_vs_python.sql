\pset pager off

\echo '--- Comparaison du nombre de lignes ---'
SELECT 'vw_hr_prepared' AS source, COUNT(*) AS nb_lignes
FROM vw_hr_prepared
UNION ALL
SELECT 'df_central_reference' AS source, COUNT(*) AS nb_lignes
FROM df_central_reference;

\echo '--- Colonnes communes ---'
SELECT column_name
FROM information_schema.columns
WHERE table_name = 'vw_hr_prepared'

INTERSECT

SELECT column_name
FROM information_schema.columns
WHERE table_name = 'df_central_reference'
ORDER BY column_name;

\echo '--- Colonnes dans df_central_reference mais absentes de vw_hr_prepared ---'
SELECT column_name
FROM information_schema.columns
WHERE table_name = 'df_central_reference'

EXCEPT

SELECT column_name
FROM information_schema.columns
WHERE table_name = 'vw_hr_prepared'
ORDER BY column_name;

\echo '--- Colonnes dans vw_hr_prepared mais absentes de df_central_reference ---'
SELECT column_name
FROM information_schema.columns
WHERE table_name = 'vw_hr_prepared'

EXCEPT

SELECT column_name
FROM information_schema.columns
WHERE table_name = 'df_central_reference'
ORDER BY column_name;
