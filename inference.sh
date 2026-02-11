#!/bin/bash
# HydrAMP AMP classifier inference wrapper for battleamp-snakemake
#
# Interface contract:
#   $1 = path to input FASTA file (absolute)
#   $2 = path to output TSV file (absolute)
#
# Output columns: sequence  Prediction  Probability_score

set -euo pipefail

INPUT_FASTA="$1"
OUTPUT_TSV="$2"

if [ -z "$INPUT_FASTA" ] || [ -z "$OUTPUT_TSV" ]; then
    echo "Usage: inference.sh <input.fasta> <output.tsv>" >&2
    exit 1
fi

if [ ! -f "$INPUT_FASTA" ]; then
    echo "Error: input FASTA not found: $INPUT_FASTA" >&2
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP_OUTPUT="${OUTPUT_TSV}.raw"

# Step 1: Run HydrAMP prediction
# predict_if_amp creates a temp CSV alongside the input FASTA
cd "$SCRIPT_DIR"
python -m amp.inference.scripts.predict_if_amp \
    --model_path models/amp_classifier/ \
    --sequence_path "$INPUT_FASTA" \
    --format fasta \
    --output_csv "$TMP_OUTPUT"

# Clean up the temp CSV that fasta2csv creates next to the input
TEMP_CSV="${INPUT_FASTA%.fasta}.csv"
rm -f "$TEMP_CSV"

# Step 2: Convert to standard pipeline format
# Raw output columns: Sequence, Prediction (raw sigmoid probability)
# Pipeline standard: sequence, Prediction (AMP/non-AMP), Probability_score
python3 - "$TMP_OUTPUT" "$OUTPUT_TSV" << 'PYEOF'
import sys
import numpy as np
import pandas as pd

raw_path = sys.argv[1]
out_path = sys.argv[2]

df = pd.read_csv(raw_path)

out = pd.DataFrame({
    "sequence": df["Sequence"],
    "Prediction": np.where(df["Prediction"] >= 0.5, "AMP", "non-AMP"),
    "Probability_score": df["Prediction"],
})

out.to_csv(out_path, sep="\t", index=False)
print(f"Converted {len(out)} predictions to {out_path}", file=sys.stderr)
PYEOF

rm -f "$TMP_OUTPUT"
echo "HydrAMP AMP classifier inference complete: $(wc -l < "$OUTPUT_TSV") lines" >&2
