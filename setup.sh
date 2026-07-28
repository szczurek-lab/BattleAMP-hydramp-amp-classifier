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

# Verify model weights exist
MODEL_DIR="models/amp_classifier"
if [ ! -f "$MODEL_DIR/model_config.json" ]; then
    echo "ERROR: Model weights not found in $MODEL_DIR/" >&2
    exit 1
fi

echo "HydrAMP AMP classifier setup complete"