DROP VIEW IF EXISTS vw_hr_prepared;

DROP TABLE IF EXISTS eval_manager;
DROP TABLE IF EXISTS sondage;
DROP TABLE IF EXISTS sirh;

CREATE TABLE sirh (
    id_employee INTEGER PRIMARY KEY,
    age INTEGER,
    genre VARCHAR(10),
    revenu_mensuel INTEGER,
    statut_marital VARCHAR(50),
    departement VARCHAR(100),
    poste VARCHAR(100),
    nombre_experiences_precedentes INTEGER,
    nombre_heures_travailless INTEGER,
    annee_experience_totale INTEGER,
    annees_dans_l_entreprise INTEGER,
    annees_dans_le_poste_actuel INTEGER
);

CREATE TABLE sondage (
    a_quitte_l_entreprise VARCHAR(10),
    nombre_participation_pee INTEGER,
    nb_formations_suivies INTEGER,
    nombre_employee_sous_responsabilite INTEGER,
    code_sondage VARCHAR(20) PRIMARY KEY,
    distance_domicile_travail INTEGER,
    niveau_education INTEGER,
    domaine_etude VARCHAR(100),
    ayant_enfants VARCHAR(10),
    frequence_deplacement VARCHAR(50),
    annees_depuis_la_derniere_promotion INTEGER,
    annes_sous_responsable_actuel INTEGER
);

CREATE TABLE eval_manager (
    satisfaction_employee_environnement INTEGER,
    note_evaluation_precedente INTEGER,
    niveau_hierarchique_poste INTEGER,
    satisfaction_employee_nature_travail INTEGER,
    satisfaction_employee_equipe INTEGER,
    satisfaction_employee_equilibre_pro_perso INTEGER,
    eval_number VARCHAR(20) PRIMARY KEY,
    note_evaluation_actuelle INTEGER,
    heure_supplementaires VARCHAR(10),
    augementation_salaire_precedente VARCHAR(20)
);
