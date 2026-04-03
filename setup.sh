#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Install HydrAMP package without resolving dependencies.
# TF 2.2.1 and Keras 2.3.1 are provided by the conda environment
# (no longer available on PyPI).
pip install .

# Verify model weights exist
MODEL_DIR="models/amp_classifier"
if [ ! -f "$MODEL_DIR/model_config.json" ]; then
    echo "ERROR: Model weights not found in $MODEL_DIR/" >&2
    exit 1
fi

echo "HydrAMP AMP classifier setup complete"