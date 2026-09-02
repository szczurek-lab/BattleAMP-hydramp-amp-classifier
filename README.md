# HydrAMP (AMP Classifier)

Fork of [szczurek-lab/hydramp](https://github.com/szczurek-lab/hydramp), using the AMP
classification component. Integrated with the
[battleamp-snakemake](https://github.com/szczurek-lab/battleamp-snakemake) benchmarking
pipeline.

## Supported tasks

AMP classification (binary: AMP / non-AMP).

## Reference

Szymczak, P., Możejko, M., Grzegorzek, T. et al. Discovering highly potent antimicrobial peptides with deep generative model HydrAMP. Nat Commun 14, 1453 (2023). https://doi.org/10.1038/s41467-023-36994-z


## Model overview

HydrAMP is a conditional variational autoencoder for antimicrobial peptide generation
and classification. This submodule uses HydrAMP's built-in AMP classifier (LSTM-based),
which outputs the probability that a given peptide is antimicrobial.

Maximum sequence length: 25 amino acids.

## Training data

`setup.sh` step 3 keeps only the files this classifier was trained on:

| File | Records | Role |
|---|---|---|
| `unlabelled_positive.csv` | 20,313 | positives |
| `unlabelled_negative.csv` | 25,762 | negatives |

`scripts/amp_classifier_training_procedure.ipynb` merges the two files and trains on a
10-fold split. Positives are DBAASP-derived, negatives are UniProt TrEMBL filtered to
25 amino acids.

Upstream ships a single `data.zip` covering every HydrAMP component. The VAE generator splits,
competitor outputs and figure inputs are not kept, since no benchmarked variant reads them.

`data/` is gitignored and DVC-tracked, so it is not committed. Archive sha256
`1994b741a1dfef7842dda15bbdaa26877d23d0991583b9af7d3e1273964206c6`.

## Changes from the original

The model architecture, pretrained weights, and core code are unchanged. 

- Python 3.8
- conda (for environment creation by the pipeline)
- NVIDIA GPU
- Model checkpoints and PCA decomposer (included or downloaded via `get_data.sh`)

## Installation

```bash
conda create -n hydramp python=3.8
conda activate hydramp
sh setup.sh
```

`sh setup.sh` runs, in order:

1. Installs the HydrAMP package and its dependencies.
2. Downloads the training data described above, skipping any file already present.
3. Verifies the training data and the model weights in `models/amp_classifier/`.

Any missing file exits non-zero. Weights ship with the repository. `get_data.sh` re-fetches
them, but also downloads about 1.8 GB of results and wheels.

## Usage within the pipeline

```bash
sh inference.sh input.fasta output.tsv
```

The pipeline handles environment creation, inference, and evaluation automatically.

## License

Same as the original HydrAMP repository.