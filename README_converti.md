# P4 — Classifiez automatiquement des informations

Projet de data science réalisé dans le cadre d’OpenClassrooms.

## 1. Objectif du projet

Ce projet vise à analyser les causes potentielles d’attrition au sein d’une ESN fictive, **TechNova Partners**, à partir
de plusieurs sources de données RH.

L’objectif est double :

1. comprendre les facteurs associés au départ des employés ;
2. construire un modèle de classification capable d’estimer la probabilité de départ d’un collaborateur.

L’approche retenue suit une progression en plusieurs étapes :

- mise en place de l’environnement de travail ;
- import et contrôle qualité des données RH brutes ;
- préparation et consolidation des données avec Python ;
- analyse exploratoire des variables liées à l’attrition ;
- construction de modèles de classification ;
- amélioration et interprétation des modèles avec SHAP ;
- formalisation des résultats pour la restitution métier ;
- industrialisation partielle de la préparation des données avec PostgreSQL et SQL.

---

## 2. Contexte métier

Dans le cadre de la mission, le service SIRH souhaite mieux comprendre les facteurs pouvant expliquer les démissions au
sein de TechNova Partners.

Après une première phase d’analyse et de modélisation réalisée en Python, une étape complémentaire a été menée afin de
préparer l’industrialisation du projet.

Cette étape consiste à construire une base de données PostgreSQL contenant les données RH brutes et à migrer
progressivement une partie des traitements de préparation depuis Python vers SQL.

L’objectif n’est pas encore de mettre le modèle prédictif en production, mais de poser une première brique technique
fiable : une base relationnelle structurée, interrogeable et reproductible.

---

## 3. Structure du projet

```text
P4_Classifiez_automatiquement_des_informations/
├── data/
│   ├── raw/
│   │   ├── extrait_eval.csv
│   │   ├── extrait_sirh.csv
│   │   └── extrait_sondage.csv
│   ├── interim/
│   └── processed/
│       └── df_central.csv
├── notebooks/
│   ├── 01_eda_attrition.ipynb
│   ├── 02_preparation_modelisation.ipynb
│   ├── 03_premiers_modeles_classification.ipynb
│   ├── 04_amelioration_classification.ipynb
│   └── 05_optimisation_interpretation.ipynb
├── reports/
│   ├── figures/
│   └── presentation/
│       └── Etape_6_Formalisation_Resultats_Attrition_v3.pptx
├── sql/
│   ├── 01_create_tables.sql
│   ├── 02_load_data.sql
│   ├── 03_check_tables.sql
│   ├── 03_check_tables_compact.sql
│   ├── 04_prepare_data.sql
│   ├── 05_quality_checks.sql
│   ├── 06_load_df_central_reference.sql
│   ├── 07_compare_sql_vs_python.sql
│   └── 08_advanced_sql_queries.sql
├── src/
│   └── main.py
├── .gitignore
├── pyproject.toml
├── uv.lock
└── README.md
```

> Les dossiers `.venv/` et `.ipykernel_checkpoints/` ne doivent pas être versionnés.

---

## 4. Mise en place de l’environnement Python

Le projet utilise `uv` pour la gestion de l’environnement Python et des dépendances.

### Initialisation

```bash
uv sync
source .venv/bin/activate
```

### Lancer JupyterLab

```bash
uv run jupyter lab
```

### Dépendances principales

- pandas
- numpy
- pyarrow
- matplotlib
- seaborn
- scikit-learn
- scipy
- shap
- xgboost
- jupyterlab
- ipykernel
- missingno

---

## 5. Données utilisées

Les données brutes sont stockées dans le dossier :

```text
data/raw/
```

Elles sont composées de trois fichiers principaux :

- `extrait_sirh.csv` ;
- `extrait_sondage.csv` ;
- `extrait_eval.csv`.

Ces fichiers correspondent respectivement :

- aux informations administratives et RH des employés ;
- aux données de sondage ;
- aux données d’évaluation managériale.

Un fichier traité est également disponible :

```text
data/processed/df_central.csv
```

Ce fichier correspond au dataset consolidé généré précédemment avec Python. Il est utilisé comme **table de référence**
pour comparer les traitements Python avec les traitements SQL.

---

## 6. Chronologie de mise en place du programme

### Étape 1 — Initialisation du projet

La première étape a consisté à mettre en place la structure du projet, l’environnement Python et les dépendances
nécessaires à l’analyse de données.

Les dossiers `data/`, `notebooks/`, `src/`, `reports/` et `sql/` ont été organisés afin de séparer les données brutes,
les traitements Python, les sorties d’analyse et les scripts SQL.

### Étape 2 — Import et contrôle qualité des données brutes

Les trois fichiers RH bruts ont été placés dans `data/raw/` :

```text
extrait_sirh.csv
extrait_sondage.csv
extrait_eval.csv
```

Les premiers contrôles ont porté sur :

- les types de variables ;
- les dimensions des fichiers ;
- les valeurs manquantes ;
- les doublons ;
- l’identification des clés de jointure.

### Étape 3 — Consolidation des données avec Python

Les données ont ensuite été consolidées avec Python afin de créer un dataset central exploitable pour l’analyse et la
modélisation.

Le fichier consolidé obtenu est :

```text
data/processed/df_central.csv
```

Ce fichier contient les données jointes et préparées à partir des trois sources initiales.

### Étape 4 — Analyse exploratoire de l’attrition

L’analyse exploratoire a permis d’étudier la variable cible :

```text
a_quitte_l_entreprise
```

Elle a été transformée en variable binaire :

```text
Oui → 1
Non → 0
```

Répartition observée :

| Classe | Effectif | Pourcentage |
|--------|---------:|------------:|
| Non    |     1233 |     83.88 % |
| Oui    |      237 |     16.12 % |

Cette répartition montre un déséquilibre de classes, élément important à prendre en compte dans la phase de
modélisation.

### Étape 5 — Préparation pour la modélisation

Les traitements de préparation ont permis de construire un dataset exploitable par les modèles de classification.

Les principales opérations réalisées incluent :

- encodage de la variable cible ;
- sélection des variables explicatives ;
- traitement des variables catégorielles ;
- préparation des variables quantitatives ;
- séparation entre jeu d’entraînement et jeu de test ;
- préparation des pipelines de modélisation.

### Étape 6 — Premiers modèles de classification

Des premiers modèles de classification ont été entraînés afin d’estimer la probabilité de départ d’un employé.

L’objectif était de disposer d’une première base de comparaison avant amélioration des performances.

### Étape 7 — Amélioration et interprétation des modèles

Les modèles ont ensuite été améliorés et interprétés, notamment avec SHAP, afin d’identifier les variables contribuant
le plus aux prédictions.

Cette étape permet de relier les résultats techniques à une lecture métier compréhensible pour le SIRH.

### Étape 8 — Restitution métier

Les résultats ont été formalisés dans un support de présentation destiné à Amandine et Augustin.

Le support est stocké dans :

```text
reports/presentation/
```

### Étape 9 — Industrialisation partielle avec PostgreSQL

À la suite de la demande métier, une base PostgreSQL a été créée afin de poser une première brique d’industrialisation.

L’objectif est de conserver les données brutes en base, puis de migrer progressivement certains traitements Python vers
SQL.

---

## 7. Base de données PostgreSQL

Une base PostgreSQL a été créée pour structurer les données RH et migrer progressivement les traitements de préparation
depuis Python vers SQL.

### Base créée

```text
hr_analytics
```

### Tables brutes

Les trois fichiers sources ont été importés dans trois tables PostgreSQL :

- `sirh` ;
- `sondage` ;
- `eval_manager`.

Chaque table contient **1470 lignes**.

Ces tables conservent les données au format brut transmis par le SIRH.

### Table de référence Python

Le fichier traité `df_central.csv` a été chargé dans une table séparée :

```text
df_central_reference
```

Cette table n’est pas utilisée comme source principale. Elle sert uniquement à comparer le résultat des traitements SQL
avec le dataset consolidé précédemment en Python.

---

## 8. Scripts SQL

Les scripts SQL sont stockés dans le dossier :

```text
sql/
```

| Script                             | Rôle                                                                              |
|------------------------------------|-----------------------------------------------------------------------------------|
| `01_create_tables.sql`             | Création des tables brutes PostgreSQL                                             |
| `02_load_data.sql`                 | Chargement des fichiers CSV bruts dans PostgreSQL                                 |
| `03_check_tables.sql`              | Vérification du contenu des tables                                                |
| `03_check_tables_compact.sql`      | Version compacte des contrôles de tables                                          |
| `04_prepare_data.sql`              | Création de la vue centrale `vw_hr_prepared`                                      |
| `05_quality_checks.sql`            | Contrôles qualité : volumes, doublons, jointures, valeurs manquantes              |
| `06_load_df_central_reference.sql` | Chargement du fichier Python traité `df_central.csv`                              |
| `07_compare_sql_vs_python.sql`     | Comparaison entre la vue SQL et le dataset Python                                 |
| `08_advanced_sql_queries.sql`      | Nettoyage avancé, jointures, statistiques descriptives et feature engineering SQL |

### Pipeline SQL

Le pipeline SQL peut être relancé avec les commandes suivantes :

```bash
psql -d hr_analytics -f sql/01_create_tables.sql
psql -d hr_analytics -f sql/02_load_data.sql
psql -d hr_analytics -f sql/03_check_tables_compact.sql
psql -d hr_analytics -f sql/04_prepare_data.sql
psql -d hr_analytics -f sql/05_quality_checks.sql
psql -d hr_analytics -f sql/06_load_df_central_reference.sql
psql -d hr_analytics -f sql/07_compare_sql_vs_python.sql
psql -d hr_analytics -f sql/08_advanced_sql_queries.sql
```

---

## 9. Vue SQL préparée

Une vue centrale a été créée :

```text
vw_hr_prepared
```

Elle réalise :

- la jointure entre les trois sources brutes ;
- la conversion de `code_sondage` en identifiant numérique ;
- la conversion de `eval_number` en identifiant numérique ;
- la création de la variable cible `attrition_bin` ;
- la conservation des colonnes présentes dans `df_central.csv` ;
- la création d’une colonne nettoyée `augmentation_salaire_precedente_pct`.

Exemple de transformation SQL :

```text
"11 %" → 11
"23 %" → 23
```

---

## 10. Contrôles qualité SQL

Les contrôles qualité ont permis de valider :

```text
sirh              → 1470 lignes
sondage           → 1470 lignes
eval_manager      → 1470 lignes
vw_hr_prepared    → 1470 lignes
```

### Unicité des identifiants

Aucun doublon détecté sur :

- `id_employee` ;
- `code_sondage` ;
- `eval_number`.

### Jointures

Aucune perte de données lors des jointures :

```text
salariés sans sondage     → 0
salariés sans évaluation  → 0
```

### Valeurs manquantes

Aucune valeur manquante détectée sur les principales variables utilisées pour l’analyse :

- revenu mensuel ;
- expérience totale ;
- ancienneté dans l’entreprise ;
- distance domicile-travail ;
- niveau d’éducation ;
- fréquence de déplacement ;
- satisfaction environnement ;
- satisfaction travail ;
- équilibre vie professionnelle / personnelle.

---

## 11. Comparaison SQL / Python

Le fichier Python traité `df_central.csv` a été chargé dans PostgreSQL dans la table :

```text
df_central_reference
```

La comparaison avec la vue SQL montre :

```text
vw_hr_prepared        → 1470 lignes
df_central_reference  → 1470 lignes
```

Toutes les colonnes présentes dans `df_central_reference` sont désormais reproduites dans `vw_hr_prepared`.

La vue SQL contient une colonne supplémentaire :

```text
augmentation_salaire_precedente_pct
```

Cette colonne correspond à une amélioration SQL permettant d’exploiter numériquement le champ textuel d’augmentation
salariale.

---

## 12. Requêtes SQL avancées

Le script suivant applique des fonctionnalités SQL plus avancées :

```text
08_advanced_sql_queries.sql
```

Il contient :

- des vues de nettoyage pour chaque table brute ;
- une jointure propre entre les trois sources ;
- des statistiques descriptives avec `GROUP BY` ;
- des transformations de colonnes ;
- du feature engineering en SQL.

### Vues créées

```text
vw_sirh_clean
vw_sondage_clean
vw_eval_clean
vw_hr_advanced_prepared
vw_hr_feature_engineered
```

### Nettoyages réalisés

#### Table `sirh`

- standardisation des variables catégorielles ;
- contrôle de cohérence sur l’âge ;
- contrôle de cohérence sur le revenu mensuel ;
- contrôle de cohérence sur l’expérience totale.

#### Table `sondage`

- conversion de `code_sondage` en entier ;
- création de `attrition_bin` ;
- encodage de `ayant_enfants` ;
- nettoyage de `domaine_etude` ;
- nettoyage de `frequence_deplacement`.

#### Table `eval_manager`

- conversion de `eval_number` en entier ;
- encodage de `heure_supplementaires` ;
- transformation de `augementation_salaire_precedente` en pourcentage numérique ;
- contrôle des notes de satisfaction.

---

## 13. Feature engineering SQL

Le script SQL avancé crée plusieurs variables dérivées :

```text
classe_age
classe_revenu
ratio_anciennete_entreprise
experience_hors_entreprise
promotion_recente_bin
longue_periode_sans_promotion_bin
score_satisfaction_moyen
segment_risque_simple
```

Ces variables permettent d’enrichir l’analyse de l’attrition et de préparer de futurs jeux de données exploitables pour
la modélisation.

---

## 14. Statistiques descriptives SQL

Des requêtes `GROUP BY` permettent de comparer les salariés ayant quitté l’entreprise avec ceux encore présents dans les
effectifs.

Les statistiques sont calculées sur plusieurs variables quantitatives :

- âge ;
- revenu mensuel ;
- distance domicile-travail ;
- expérience totale ;
- ancienneté dans l’entreprise ;
- ancienneté dans le poste actuel ;
- nombre de formations suivies ;
- note d’évaluation actuelle ;
- satisfaction environnement ;
- satisfaction travail ;
- équilibre vie professionnelle / personnelle ;
- augmentation salariale précédente.

Ces requêtes permettent de reproduire en SQL une partie des analyses descriptives précédemment réalisées avec Python.

---

## 15. Commandes PostgreSQL utiles

### Ouvrir la base

```bash
psql -d hr_analytics
```

### Lister les tables

```sql
\dt
```

### Lister les vues

```sql
\dv
```

### Quitter PostgreSQL

```sql
\q
```

### Désactiver le pager dans un script SQL

```sql
\pset pager off
```

### Exécuter une requête ponctuelle

```bash
psql -d hr_analytics -c "SELECT COUNT(*) FROM vw_hr_prepared;"
```

---

## 16. Sécurité et confidentialité

Les données RH sont sensibles.

Les fichiers bruts et traités ne doivent pas être exposés publiquement sans anonymisation ou accord explicite.

La base PostgreSQL locale sert uniquement au développement, aux contrôles qualité et à la préparation du projet.

---

## 17. Statut du projet

### Réalisé

- structure du projet créée ;
- environnement Python initialisé avec `uv` ;
- données brutes importées ;
- contrôles qualité réalisés en Python ;
- dataset central `df_central.csv` généré ;
- analyse exploratoire réalisée ;
- premiers modèles de classification construits ;
- amélioration et interprétation des modèles engagées ;
- support de restitution préparé ;
- base PostgreSQL `hr_analytics` créée ;
- trois tables brutes SQL créées et alimentées ;
- vue SQL centrale `vw_hr_prepared` créée ;
- table de référence `df_central_reference` ajoutée ;
- comparaison SQL / Python validée ;
- contrôles qualité SQL réalisés ;
- script SQL avancé créé pour le nettoyage, les jointures, les statistiques descriptives et le feature engineering.

### Prochaines étapes

- finaliser la comparaison des facteurs d’attrition entre les deux classes ;
- stabiliser les variables finales pour la modélisation ;
- évaluer les performances avec des métriques adaptées au déséquilibre de classes ;
- approfondir l’interprétation des modèles avec SHAP ;
- finaliser le support de restitution pour Amandine et Augustin ;
- documenter les limites avant toute perspective d’industrialisation.

---

## 18. Remarque sur l’industrialisation

Le modèle prédictif développé dans ce projet reste un prototype analytique.

La mise en production nécessiterait des étapes supplémentaires :

- alimentation automatisée des données RH ;
- supervision de la qualité des données ;
- gestion des droits d’accès ;
- anonymisation ou pseudonymisation des données sensibles ;
- suivi de la performance du modèle dans le temps ;
- validation métier et juridique avant tout usage opérationnel.