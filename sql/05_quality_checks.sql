\pset pager off

\echo '--- Nombre de lignes par table ---'
SELECT 'sirh' AS table_name, COUNT(*) AS nb_lignes FROM sirh
UNION ALL
SELECT 'sondage' AS table_name, COUNT(*) AS nb_lignes FROM sondage
UNION ALL
SELECT 'eval_manager' AS table_name, COUNT(*) AS nb_lignes FROM eval_manager
UNION ALL
SELECT 'vw_hr_prepared' AS table_name, COUNT(*) AS nb_lignes FROM vw_hr_prepared;

\echo '--- Vérification unicité des identifiants ---'
SELECT id_employee, COUNT(*) AS occurrences
FROM sirh
GROUP BY id_employee
HAVING COUNT(*) > 1;

SELECT code_sondage, COUNT(*) AS occurrences
FROM sondage
GROUP BY code_sondage
HAVING COUNT(*) > 1;

SELECT eval_number, COUNT(*) AS occurrences
FROM eval_manager
GROUP BY eval_number
HAVING COUNT(*) > 1;

\echo '--- Répartition de la variable cible ---'
SELECT
    a_quitte_l_entreprise,
    COUNT(*) AS effectif,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS pourcentage
FROM sondage
GROUP BY a_quitte_l_entreprise
ORDER BY effectif DESC;

\echo '--- Vérification des jointures ---'
SELECT COUNT(*) AS nb_salaries_sans_sondage
FROM vw_hr_prepared
WHERE a_quitte_l_entreprise IS NULL;

SELECT COUNT(*) AS nb_salaries_sans_eval
FROM vw_hr_prepared
WHERE note_evaluation_actuelle IS NULL;

\echo '--- Valeurs manquantes SIRH ---'
SELECT
    COUNT(*) FILTER (WHERE revenu_mensuel IS NULL) AS missing_revenu_mensuel,
    COUNT(*) FILTER (WHERE annee_experience_totale IS NULL) AS missing_annee_experience_totale,
    COUNT(*) FILTER (WHERE annees_dans_l_entreprise IS NULL) AS missing_annees_dans_l_entreprise
FROM sirh;

\echo '--- Valeurs manquantes sondage ---'
SELECT
    COUNT(*) FILTER (WHERE distance_domicile_travail IS NULL) AS missing_distance_domicile_travail,
    COUNT(*) FILTER (WHERE niveau_education IS NULL) AS missing_niveau_education,
    COUNT(*) FILTER (WHERE frequence_deplacement IS NULL) AS missing_frequence_deplacement
FROM sondage;

\echo '--- Valeurs manquantes évaluation ---'
SELECT
    COUNT(*) FILTER (WHERE satisfaction_employee_environnement IS NULL) AS missing_satisfaction_environnement,
    COUNT(*) FILTER (WHERE satisfaction_employee_nature_travail IS NULL) AS missing_satisfaction_travail,
    COUNT(*) FILTER (WHERE satisfaction_employee_equilibre_pro_perso IS NULL) AS missing_equilibre_pro_perso
FROM eval_manager;
