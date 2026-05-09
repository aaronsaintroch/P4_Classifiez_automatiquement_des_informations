TRUNCATE TABLE eval_manager, sondage, sirh;

\copy sirh (id_employee, age, genre, revenu_mensuel, statut_marital, departement, poste, nombre_experiences_precedentes, nombre_heures_travailless, annee_experience_totale, annees_dans_l_entreprise, annees_dans_le_poste_actuel) FROM '/Users/vincentdesmouceaux/P4_Classifiez_automatiquement_des_informations/data/raw/extrait_sirh.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', NULL '');

\copy sondage (a_quitte_l_entreprise, nombre_participation_pee, nb_formations_suivies, nombre_employee_sous_responsabilite, code_sondage, distance_domicile_travail, niveau_education, domaine_etude, ayant_enfants, frequence_deplacement, annees_depuis_la_derniere_promotion, annes_sous_responsable_actuel) FROM '/Users/vincentdesmouceaux/P4_Classifiez_automatiquement_des_informations/data/raw/extrait_sondage.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', NULL '');

\copy eval_manager (satisfaction_employee_environnement, note_evaluation_precedente, niveau_hierarchique_poste, satisfaction_employee_nature_travail, satisfaction_employee_equipe, satisfaction_employee_equilibre_pro_perso, eval_number, note_evaluation_actuelle, heure_supplementaires, augementation_salaire_precedente) FROM '/Users/vincentdesmouceaux/P4_Classifiez_automatiquement_des_informations/data/raw/extrait_eval.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', NULL '');
