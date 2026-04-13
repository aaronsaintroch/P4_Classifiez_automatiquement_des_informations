from pathlib import Path

import numpy as np
import pandas as pd
import shap
import sklearn
import xgboost

print("=== ENVIRONNEMENT OK ===")
print(f"pandas: {pd.__version__}")
print(f"numpy: {np.__version__}")
print(f"scikit-learn: {sklearn.__version__}")
print(f"shap: {shap.__version__}")
print(f"xgboost: {xgboost.__version__}")

df = pd.DataFrame({
    "a": [1, 2, 3],
    "b": [4, 5, 6],
})

print("\n=== TEST DATAFRAME ===")
print(df)

PROJECT_ROOT = Path.cwd().resolve()
DATA_RAW = PROJECT_ROOT / "data" / "raw"

print("\n=== CHEMINS PROJET ===")
print(f"PROJECT_ROOT: {PROJECT_ROOT}")
print(f"DATA_RAW: {DATA_RAW}")