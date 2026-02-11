# BattleAMP-hydramp-amp-classifier

AMP classifier component from [HydrAMP](https://github.com/szczurek-lab/hydramp) (Szymczak et al., 2023), adapted for the [BattleAMP benchmark pipeline](https://github.com/szczurek-lab/battleamp-snakemake).

## What is this model

The HydrAMP AMP classifier is a two-layer LSTM network (NoConvAMPClassifier) trained as part of the HydrAMP conditional variational autoencoder for antimicrobial peptide generation. It takes one-hot encoded peptide sequences (up to 25 amino acids) and outputs a sigmoid probability of AMP activity.

Original paper: Szymczak et al. (2023). Discovering highly potent antimicrobial peptides with deep generative model HydrAMP, Nat Comm, https://doi.org/10.1038/s42256-023-00619-3

## Changes from the original HydrAMP repository

The original HydrAMP repository contains the full generative model (encoder, decoder, AMP classifier, MIC classifier). This fork extracts only the AMP classifier for standalone inference. The `amp/` package code is unchanged from the original.

## Requirements

- Python 3.8 (pinned for TF 2.2.1/Keras 2.3.1 compatibility)
- conda (for environment creation by the pipeline)
- No GPU required (TF 2.2.1 needs CUDA 10.1; the model is small enough for CPU)

## Notes

- Sequences longer than 25 amino acids are silently dropped by the model. The pipeline's pre-filter enforces this range.
- Sequences with non-standard amino acids are filtered by the model's `fasta2csv` utility.
- The model creates a temporary CSV file next to the input FASTA during inference; the adapter cleans this up.

## License

MIT (same as the original HydrAMP repository).