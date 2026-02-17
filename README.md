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

## Usage within the pipeline

```bash
sh inference.sh input.fasta output.tsv
```

The pipeline handles environment creation, inference, and evaluation automatically.

## License

Same as the original HydrAMP repository.