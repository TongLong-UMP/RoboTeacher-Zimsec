import csv
import json

CSV_FILE = 'vocab_bulk_template.csv'
JSON_FILE = 'vocabulary_list.json'

vocab_list = []

with open(CSV_FILE, encoding='utf-8') as csvfile:
    reader = csv.DictReader(csvfile)
    for row in reader:
        vocab_list.append({
            'word': row['word'].strip(),
            'part_of_speech': row['part_of_speech'].strip(),
            'example': row['example'].strip(),
            'variant': row['variant'].strip(),
            'category': row['category'].strip(),
        })

with open(JSON_FILE, 'w', encoding='utf-8') as jsonfile:
    json.dump({'vocabulary': vocab_list}, jsonfile, ensure_ascii=False, indent=2)

print(f"Converted {CSV_FILE} to {JSON_FILE} with {len(vocab_list)} entries.") 