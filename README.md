

# P4 — Classifiez automatiquement des informations

Projet de data science réalisé dans le cadre d’OpenClassrooms.

## Objectif

Ce projet vise à analyser les causes potentielles d’attrition au sein d’une ESN à partir de plusieurs sources de données RH, puis à construire un modèle de classification capable d’estimer la probabilité de départ d’un employé.

L’approche retenue comprend :

- la préparation et la consolidation des données ;
- l’analyse exploratoire des variables liées à l’attrition ;
- la construction de modèles de classification ;
- l’interprétation des facteurs explicatifs via SHAP.

## Structure du projet

```text
P4_Classifiez_automatiquement_des_informations/
├── data/
│   ├── raw/          # données brutes
│   ├── interim/      # données intermédiaires
│   └── processed/    # données nettoyées / prêtes pour la modélisation
├── notebooks/        # notebooks Jupyter
├── src/              # fonctions Python réutilisables
├── reports/
│   ├── figures/      # graphiques exportés
│   └── presentation/ # support de présentation
├── pyproject.toml
├── uv.lock
└── README.md
```

## Environnement

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

## Dépendances principales

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

## Prochaines étapes

- importer les trois fichiers sources dans `data/raw/` ;
- créer un notebook `01_controle_qualite.ipynb` ;
- vérifier les types, doublons et valeurs manquantes ;
- identifier la clé de jointure entre les différentes sources ;
- construire un dataset analytique pour l’étude de l’attrition.

## Statut

Environnement initialisé, structure du projet créée, dépendances installées.