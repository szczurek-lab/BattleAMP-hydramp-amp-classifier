#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Install HydrAMP package and dependencies (TF 2.2.1, Keras 2.3.1)
pip install .

# Verify model weights exist
MODEL_DIR="models/amp_classifier"
if [ ! -f "$MODEL_DIR/model_config.json" ]; then
    echo "ERROR: Model weights not found in $MODEL_DIR/" >&2
    exit 1
fi

echo "HydrAMP AMP classifier setup complete"
