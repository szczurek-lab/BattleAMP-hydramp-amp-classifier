import pandas as pd
import numpy as np
import argparse

def process_file(filepath: str, output_filename: str):
    """ implement for specific model
    expects tsv file with columns:
    classifier: Prediction, Probability_score
    regressor: Prediction"""
    df = pd.read_csv(filepath)
    df.rename(columns={"Prediction": "Probability_score"}, inplace=True)
    df["Prediction"] = np.where((df["Probability_score"] >= 0.5), "AMP", "non-AMP")
    df.to_csv(output_filename, sep="\t")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Process a TSV file for AMP classification.')
    parser.add_argument('filepath', type=str, help='Path to the input TSV file')
    parser.add_argument('output_filename', type=str, help='Path to the output TSV file')

    args = parser.parse_args()
    process_file(args.filepath, args.output_filename)