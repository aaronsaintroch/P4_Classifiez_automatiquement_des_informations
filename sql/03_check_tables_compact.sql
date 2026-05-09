\pset pager off

\echo '--- Aperçu SIRH ---'
SELECT
    id_employee,
    age,
    genre,
    revenu_mensuel,
    statut_marital,
    departement,
    poste
FROM sirh
LIMIT 10;

\echo '--- Aperçu sondage ---'
SELECT
    code_sondage,
    a_quitte_l_entreprise,
    nb_formations_suivies,
    distance_domicile_travail,
    niveau_education,
    frequence_deplacement
FROM sondage
LIMIT 10;

\echo '--- Aperçu évaluation ---'
SELECT
    eval_number,
    satisfaction_employee_environnement,
    note_evaluation_precedente,
    note_evaluation_actuelle,
    heure_supplementaires,
    augementation_salaire_precedente
FROM eval_manager
LIMIT 10;

\echo '--- Comptage des lignes ---'
SELECT 'sirh' AS table_name, COUNT(*) AS nb_lignes FROM sirh
UNION ALL
SELECT 'sondage' AS table_name, COUNT(*) AS nb_lignes FROM sondage
UNION ALL
SELECT 'eval_manager' AS table_name, COUNT(*) AS nb_lignes FROM eval_manager;
