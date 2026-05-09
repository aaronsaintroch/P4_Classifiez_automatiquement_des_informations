\pset pager off

\echo '============================================================'
\echo '1. Nettoyage SQL de la table sirh'
\echo '============================================================'

DROP VIEW IF EXISTS vw_hr_feature_engineered;
DROP VIEW IF EXISTS vw_hr_advanced_prepared;
DROP VIEW IF EXISTS vw_eval_clean;
DROP VIEW IF EXISTS vw_sondage_clean;
DROP VIEW IF EXISTS vw_sirh_clean;

CREATE VIEW vw_sirh_clean AS
SELECT
    id_employee,

    age,
    genre,
    revenu_mensuel,
    statut_marital,
    departement,
    poste,
    nombre_experiences_precedentes,
    nombre_heures_travailless,
    annee_experience_totale,
    annees_dans_l_entreprise,
    annees_dans_le_poste_actuel,

    -- Nettoyage des variables catégorielles
    TRIM(genre) AS genre_clean,
    TRIM(statut_marital) AS statut_marital_clean,
    TRIM(departement) AS departement_clean,
    TRIM(poste) AS poste_clean,

    -- Contrôles simples sur les variables numériques
    CASE
        WHEN age < 18 OR age > 70 THEN NULL
        ELSE age
    END AS age_clean,

    CASE
        WHEN revenu_mensuel < 0 THEN NULL
        ELSE revenu_mensuel
    END AS revenu_mensuel_clean,

    CASE
        WHEN annee_experience_totale < 0 THEN NULL
        ELSE annee_experience_totale
    END AS annee_experience_totale_clean

FROM sirh;

SELECT *
FROM vw_sirh_clean
LIMIT 10;


\echo '============================================================'
\echo '2. Nettoyage SQL de la table sondage'
\echo '============================================================'

CREATE VIEW vw_sondage_clean AS
SELECT
    code_sondage,

    -- Conversion de code_sondage : '000001' devient 1
    code_sondage::INTEGER AS code_sondage_int,

    a_quitte_l_entreprise,

    -- Encodage de la variable cible
    CASE
        WHEN LOWER(TRIM(a_quitte_l_entreprise)) = 'oui' THEN 1
        WHEN LOWER(TRIM(a_quitte_l_entreprise)) = 'non' THEN 0
        ELSE NULL
    END AS attrition_bin,

    nombre_participation_pee,
    nb_formations_suivies,
    nombre_employee_sous_responsabilite,
    distance_domicile_travail,
    niveau_education,
    domaine_etude,
    ayant_enfants,
    frequence_deplacement,
    annees_depuis_la_derniere_promotion,
    annes_sous_responsable_actuel,

    -- Nettoyage des variables catégorielles
    TRIM(domaine_etude) AS domaine_etude_clean,
    TRIM(frequence_deplacement) AS frequence_deplacement_clean,

    -- Encodage de la variable ayant_enfants
    CASE
        WHEN UPPER(TRIM(ayant_enfants)) = 'Y' THEN 1
        WHEN UPPER(TRIM(ayant_enfants)) = 'N' THEN 0
        ELSE NULL
    END AS ayant_enfants_bin,

    -- Contrôles numériques simples
    CASE
        WHEN distance_domicile_travail < 0 THEN NULL
        ELSE distance_domicile_travail
    END AS distance_domicile_travail_clean,

    CASE
        WHEN nb_formations_suivies < 0 THEN NULL
        ELSE nb_formations_suivies
    END AS nb_formations_suivies_clean

FROM sondage;

SELECT *
FROM vw_sondage_clean
LIMIT 10;


\echo '============================================================'
\echo '3. Nettoyage SQL de la table eval_manager'
\echo '============================================================'

CREATE VIEW vw_eval_clean AS
SELECT
    eval_number,

    -- Conversion de eval_number : 'E_1' devient 1
    REPLACE(eval_number, 'E_', '')::INTEGER AS eval_number_int,

    satisfaction_employee_environnement,
    note_evaluation_precedente,
    niveau_hierarchique_poste,
    satisfaction_employee_nature_travail,
    satisfaction_employee_equipe,
    satisfaction_employee_equilibre_pro_perso,
    note_evaluation_actuelle,
    heure_supplementaires,
    augementation_salaire_precedente,

    -- Encodage de la variable heure_supplementaires
    CASE
        WHEN LOWER(TRIM(heure_supplementaires)) = 'oui' THEN 1
        WHEN LOWER(TRIM(heure_supplementaires)) = 'non' THEN 0
        ELSE NULL
    END AS heure_supplementaires_bin,

    -- Nettoyage du pourcentage : '11 %' devient 11
    REPLACE(REPLACE(augementation_salaire_precedente, '%', ''), ' ', '')::INTEGER
        AS augmentation_salaire_precedente_pct,

    -- Contrôle des notes de satisfaction
    CASE
        WHEN satisfaction_employee_environnement BETWEEN 1 AND 4
        THEN satisfaction_employee_environnement
        ELSE NULL
    END AS satisfaction_employee_environnement_clean,

    CASE
        WHEN satisfaction_employee_nature_travail BETWEEN 1 AND 4
        THEN satisfaction_employee_nature_travail
        ELSE NULL
    END AS satisfaction_employee_nature_travail_clean,

    CASE
        WHEN satisfaction_employee_equilibre_pro_perso BETWEEN 1 AND 4
        THEN satisfaction_employee_equilibre_pro_perso
        ELSE NULL
    END AS satisfaction_employee_equilibre_pro_perso_clean

FROM eval_manager;

SELECT *
FROM vw_eval_clean
LIMIT 10;


\echo '============================================================'
\echo '4. Jointure SQL entre les 3 tables nettoyées'
\echo '============================================================'

CREATE VIEW vw_hr_advanced_prepared AS
WITH sirh_clean AS (
    SELECT *
    FROM vw_sirh_clean
),

sondage_clean AS (
    SELECT *
    FROM vw_sondage_clean
),

eval_clean AS (
    SELECT *
    FROM vw_eval_clean
)

SELECT
    s.id_employee,

    -- Variables SIRH
    s.age_clean AS age,
    s.genre_clean AS genre,
    s.revenu_mensuel_clean AS revenu_mensuel,
    s.statut_marital_clean AS statut_marital,
    s.departement_clean AS departement,
    s.poste_clean AS poste,
    s.nombre_experiences_precedentes,
    s.nombre_heures_travailless,
    s.annee_experience_totale_clean AS annee_experience_totale,
    s.annees_dans_l_entreprise,
    s.annees_dans_le_poste_actuel,

    -- Variables sondage
    so.code_sondage,
    so.a_quitte_l_entreprise,
    so.attrition_bin,
    so.nombre_participation_pee,
    so.nb_formations_suivies_clean AS nb_formations_suivies,
    so.nombre_employee_sous_responsabilite,
    so.distance_domicile_travail_clean AS distance_domicile_travail,
    so.niveau_education,
    so.domaine_etude_clean AS domaine_etude,
    so.ayant_enfants,
    so.ayant_enfants_bin,
    so.frequence_deplacement_clean AS frequence_deplacement,
    so.annees_depuis_la_derniere_promotion,
    so.annes_sous_responsable_actuel,

    -- Variables évaluation
    e.eval_number,
    e.satisfaction_employee_environnement_clean AS satisfaction_employee_environnement,
    e.note_evaluation_precedente,
    e.niveau_hierarchique_poste,
    e.satisfaction_employee_nature_travail_clean AS satisfaction_employee_nature_travail,
    e.satisfaction_employee_equipe,
    e.satisfaction_employee_equilibre_pro_perso_clean AS satisfaction_employee_equilibre_pro_perso,
    e.note_evaluation_actuelle,
    e.heure_supplementaires,
    e.heure_supplementaires_bin,
    e.augementation_salaire_precedente,
    e.augmentation_salaire_precedente_pct

FROM sirh_clean s
LEFT JOIN sondage_clean so
    ON s.id_employee = so.code_sondage_int
LEFT JOIN eval_clean e
    ON s.id_employee = e.eval_number_int;

SELECT *
FROM vw_hr_advanced_prepared
LIMIT 10;


\echo '============================================================'
\echo '5. Vérification de la jointure'
\echo '============================================================'

SELECT COUNT(*) AS nb_lignes_vue_avancee
FROM vw_hr_advanced_prepared;

SELECT COUNT(*) AS nb_salaries_sans_sondage
FROM vw_hr_advanced_prepared
WHERE a_quitte_l_entreprise IS NULL;

SELECT COUNT(*) AS nb_salaries_sans_evaluation
FROM vw_hr_advanced_prepared
WHERE note_evaluation_actuelle IS NULL;


\echo '============================================================'
\echo '6. Statistiques descriptives avec GROUP BY sur les classes'
\echo '============================================================'

SELECT
    a_quitte_l_entreprise,
    attrition_bin,
    COUNT(*) AS effectif,

    ROUND(AVG(age)::NUMERIC, 2) AS age_moyen,
    MIN(age) AS age_min,
    MAX(age) AS age_max,
    ROUND(STDDEV_SAMP(age)::NUMERIC, 2) AS age_ecart_type,

    ROUND(AVG(revenu_mensuel)::NUMERIC, 2) AS revenu_mensuel_moyen,
    MIN(revenu_mensuel) AS revenu_mensuel_min,
    MAX(revenu_mensuel) AS revenu_mensuel_max,
    ROUND(STDDEV_SAMP(revenu_mensuel)::NUMERIC, 2) AS revenu_mensuel_ecart_type,

    ROUND(AVG(distance_domicile_travail)::NUMERIC, 2) AS distance_moyenne,
    ROUND(AVG(annee_experience_totale)::NUMERIC, 2) AS experience_totale_moyenne,
    ROUND(AVG(annees_dans_l_entreprise)::NUMERIC, 2) AS anciennete_moyenne,
    ROUND(AVG(annees_dans_le_poste_actuel)::NUMERIC, 2) AS anciennete_poste_moyenne,

    ROUND(AVG(nb_formations_suivies)::NUMERIC, 2) AS formations_moyennes,
    ROUND(AVG(note_evaluation_actuelle)::NUMERIC, 2) AS note_actuelle_moyenne,
    ROUND(AVG(satisfaction_employee_environnement)::NUMERIC, 2) AS satisfaction_environnement_moyenne,
    ROUND(AVG(satisfaction_employee_nature_travail)::NUMERIC, 2) AS satisfaction_travail_moyenne,
    ROUND(AVG(satisfaction_employee_equilibre_pro_perso)::NUMERIC, 2) AS equilibre_pro_perso_moyen,
    ROUND(AVG(augmentation_salaire_precedente_pct)::NUMERIC, 2) AS augmentation_salaire_moyenne

FROM vw_hr_advanced_prepared
GROUP BY
    a_quitte_l_entreprise,
    attrition_bin
ORDER BY
    attrition_bin DESC;


\echo '============================================================'
\echo '7. Feature engineering SQL'
\echo '============================================================'

CREATE VIEW vw_hr_feature_engineered AS
WITH base AS (
    SELECT *
    FROM vw_hr_advanced_prepared
)

SELECT
    base.*,

    -- Classes d'âge
    CASE
        WHEN age < 30 THEN 'moins_de_30_ans'
        WHEN age BETWEEN 30 AND 39 THEN '30_39_ans'
        WHEN age BETWEEN 40 AND 49 THEN '40_49_ans'
        WHEN age >= 50 THEN '50_ans_et_plus'
        ELSE 'inconnu'
    END AS classe_age,

    -- Classes de revenu
    CASE
        WHEN revenu_mensuel < 3000 THEN 'revenu_faible'
        WHEN revenu_mensuel BETWEEN 3000 AND 7000 THEN 'revenu_intermediaire'
        WHEN revenu_mensuel > 7000 THEN 'revenu_eleve'
        ELSE 'inconnu'
    END AS classe_revenu,

    -- Ratio d'ancienneté dans l'entreprise par rapport à l'expérience totale
    CASE
        WHEN annee_experience_totale > 0
        THEN ROUND((annees_dans_l_entreprise::NUMERIC / annee_experience_totale::NUMERIC), 3)
        ELSE NULL
    END AS ratio_anciennete_entreprise,

    -- Nombre d'années hors entreprise actuelle
    CASE
        WHEN annee_experience_totale >= annees_dans_l_entreprise
        THEN annee_experience_totale - annees_dans_l_entreprise
        ELSE NULL
    END AS experience_hors_entreprise,

    -- Indicateur de promotion récente
    CASE
        WHEN annees_depuis_la_derniere_promotion <= 1 THEN 1
        ELSE 0
    END AS promotion_recente_bin,

    -- Indicateur de longue ancienneté sans promotion
    CASE
        WHEN annees_depuis_la_derniere_promotion >= 5 THEN 1
        ELSE 0
    END AS longue_periode_sans_promotion_bin,

    -- Score moyen de satisfaction
    ROUND((
        satisfaction_employee_environnement::NUMERIC
        + satisfaction_employee_nature_travail::NUMERIC
        + satisfaction_employee_equipe::NUMERIC
        + satisfaction_employee_equilibre_pro_perso::NUMERIC
    ) / 4, 2) AS score_satisfaction_moyen,

    -- Indicateur de risque simple basé sur quelques signaux faibles
    CASE
        WHEN attrition_bin = 1 THEN 'a_quitte'
        WHEN satisfaction_employee_environnement <= 2
             AND satisfaction_employee_nature_travail <= 2
        THEN 'risque_satisfaction'
        WHEN heure_supplementaires_bin = 1
             AND distance_domicile_travail >= 15
        THEN 'risque_charge_distance'
        ELSE 'risque_non_identifie'
    END AS segment_risque_simple

FROM base;

SELECT *
FROM vw_hr_feature_engineered
LIMIT 10;


\echo '============================================================'
\echo '8. Statistiques complémentaires par segment de risque'
\echo '============================================================'

SELECT
    segment_risque_simple,
    COUNT(*) AS effectif,
    ROUND(AVG(age)::NUMERIC, 2) AS age_moyen,
    ROUND(AVG(revenu_mensuel)::NUMERIC, 2) AS revenu_moyen,
    ROUND(AVG(score_satisfaction_moyen)::NUMERIC, 2) AS satisfaction_moyenne,
    ROUND(AVG(distance_domicile_travail)::NUMERIC, 2) AS distance_moyenne
FROM vw_hr_feature_engineered
GROUP BY segment_risque_simple
ORDER BY effectif DESC;


\echo '============================================================'
\echo '9. Statistiques par classe d âge et attrition'
\echo '============================================================'

SELECT
    classe_age,
    a_quitte_l_entreprise,
    attrition_bin,
    COUNT(*) AS effectif,
    ROUND(AVG(revenu_mensuel)::NUMERIC, 2) AS revenu_moyen,
    ROUND(AVG(score_satisfaction_moyen)::NUMERIC, 2) AS satisfaction_moyenne
FROM vw_hr_feature_engineered
GROUP BY
    classe_age,
    a_quitte_l_entreprise,
    attrition_bin
ORDER BY
    classe_age,
    attrition_bin DESC;


\echo '============================================================'
\echo 'Script terminé avec succès'
\echo '============================================================'
