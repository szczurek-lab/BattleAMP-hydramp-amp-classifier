#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Install HydrAMP package without resolving dependencies.
# TF 2.2.1 and Keras 2.3.1 are provided by the conda environment
# (no longer available on PyPI).
pip install .

# amp/utils/phys_chem_propterties.py imports modlamp unconditionally, but it is
# commented out in setup.py's install_requires: modlamp 4.2.3 pins
# mysql-connector-python==8.0.17, which no longer exists on PyPI, so listing it
# there fails the whole install. Newer modlamp needs Python >=3.9 and this env
# is 3.8. Install it after, without deps -- modlamp.analysis only needs
# numpy/scipy/matplotlib/scikit-learn, all pinned by pip install . above.
pip install --no-deps "modlamp==4.2.3"

# Training data. Upstream ships one data.zip for all HydrAMP components, so it
# is fetched by file id (the folder also holds 1.8 GB of models/results/wheels)
# and only the files the classifiers use are kept.
python - <<'EOF'
import os, tempfile, zipfile
import gdown

WANTED = ["unlabelled_positive.csv", "unlabelled_negative.csv"]
missing = [f for f in WANTED if not os.path.exists("data/" + f)]

if not missing:
    print("Training data: already present")
else:
    os.makedirs("data", exist_ok=True)
    with tempfile.TemporaryDirectory() as tmp:
        archive = os.path.join(tmp, "data.zip")
        if gdown.download(id="1ZybZxNr-lPY9vopPzcsVl0PWGPEjgtPi", output=archive) is None:
            raise SystemExit("ERROR: failed to download data.zip")
        with zipfile.ZipFile(archive) as zf:
            for name in missing:
                with zf.open("data/" + name) as src, open("data/" + name, "wb") as dst:
                    dst.write(src.read())
EOF

for CSV in unlabelled_positive unlabelled_negative; do
    if [ ! -f "data/$CSV.csv" ]; then
        echo "ERROR: Training data not found: data/$CSV.csv" >&2
        exit 1
    fi
done
echo "Training data: OK"

# Verify model weights exist
MODEL_DIR="models/amp_classifier"
if [ ! -f "$MODEL_DIR/model_config.json" ]; then
    echo "ERROR: Model weights not found in $MODEL_DIR/" >&2
    exit 1
fi

echo "HydrAMP AMP classifier setup complete"