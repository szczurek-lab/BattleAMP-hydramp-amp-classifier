inputpath="$1"
outputpath="$2"
python -m amp.inference.scripts.predict_if_amp --model_path models/amp_classifier/ \
--sequence_path "$inputpath" --format fasta --output_csv "$outputpath" &&

python convert_outputs.py "$outputpath" "$outputpath"
