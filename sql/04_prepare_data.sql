DROP VIEW IF EXISTS vw_hr_prepared;

CREATE VIEW vw_hr_prepared AS
SELECT
    s.id_employee,

    -- Données SIRH
    s.age,
    s.genre,
    s.revenu_mensuel,
    s.statut_marital,
    s.departement,
    s.poste,
    s.nombre_experiences_precedentes,
    s.nombre_heures_travailless,
    s.annee_experience_totale,
    s.annees_dans_l_entreprise,
    s.annees_dans_le_poste_actuel,

    -- Identifiant sondage
    so.code_sondage,

    -- Données sondage
    so.a_quitte_l_entreprise,

    CASE
        WHEN LOWER(so.a_quitte_l_entreprise) = 'oui' THEN 1
        WHEN LOWER(so.a_quitte_l_entreprise) = 'non' THEN 0
        ELSE NULL
    END AS attrition_bin,

    so.nombre_participation_pee,
    so.nb_formations_suivies,
    so.nombre_employee_sous_responsabilite,
    so.distance_domicile_travail,
    so.niveau_education,
    so.domaine_etude,
    so.ayant_enfants,
    so.frequence_deplacement,
    so.annees_depuis_la_derniere_promotion,
    so.annes_sous_responsable_actuel,

    -- Identifiant évaluation
    e.eval_number,

    -- Données évaluation
    e.satisfaction_employee_environnement,
    e.note_evaluation_precedente,
    e.niveau_hierarchique_poste,
    e.satisfaction_employee_nature_travail,
    e.satisfaction_employee_equipe,
    e.satisfaction_employee_equilibre_pro_perso,
    e.note_evaluation_actuelle,
    e.heure_supplementaires,

    -- Colonne brute conservée comme dans le fichier source
    e.augementation_salaire_precedente,

    -- Colonne nettoyée en SQL : '11 %' devient 11
    REPLACE(REPLACE(e.augementation_salaire_precedente, '%', ''), ' ', '')::INTEGER
        AS augmentation_salaire_precedente_pct

FROM sirh s
LEFT JOIN sondage so
    ON s.id_employee = so.code_sondage::INTEGER
LEFT JOIN eval_manager e
    ON s.id_employee = REPLACE(e.eval_number, 'E_', '')::INTEGER;
