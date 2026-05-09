\pset pager off

\echo '--- Aperçu table sirh ---'
SELECT * FROM sirh LIMIT 10;

\echo '--- Aperçu table sondage ---'
SELECT * FROM sondage LIMIT 10;

\echo '--- Aperçu table eval_manager ---'
SELECT * FROM eval_manager LIMIT 10;

\echo '--- Nombre de lignes par table ---'
SELECT COUNT(*) AS nb_lignes_sirh
FROM sirh;

SELECT COUNT(*) AS nb_lignes_sondage
FROM sondage;

SELECT COUNT(*) AS nb_lignes_eval_manager
FROM eval_manager;
