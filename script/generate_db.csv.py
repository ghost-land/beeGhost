# Script pour générer le fichier db.csv à partir d'un json

import json

# Ouvrir le fichier JSON avec un bloc "with"
with open('ghosteshop.json', "r", encoding="utf-8") as db:
    # Charger le contenu JSON dans la variable data
    data = json.load(db)
    # Parcourir le contenu JSON
    for item in data['storeContent']:
        # Vérifier si l'élément contient un lien http finissant par cia
        for key, value in item.items():
            if value and type(value) == dict and 'script' in value:
                for subvalue in value['script']:
                    if 'file' in subvalue and subvalue['file'].endswith('.cia'):
                        # Écrire le lien dans le fichier db.csv
                        with open('db.csv', 'a', encoding="utf-8") as output:
                            # Vérifier si le lien contient http ou non
                            if 'http' in subvalue['file']:
                                output.write(f"{key},{subvalue['file']}\n")
                                print(subvalue['file'])