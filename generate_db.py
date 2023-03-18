import json
import aiohttp
from urllib.parse import urlparse
from tqdm import tqdm

async def check_link(key, subvalue):
    async with aiohttp.ClientSession() as session:
        try:
            async with session.head(subvalue['file']) as response:
                if response.status == 200:
                    domain = urlparse(subvalue['file']).netloc
                    with open('db.csv', 'a', encoding="utf-8") as output:
                        output.write(f"{key},{domain},{subvalue['file']}\n")
        except:
            pass



async def generate_db(progressbar):
    # Ouvrir le fichier JSON avec un bloc "with"
    with open('ghosteshop.json', "r", encoding="utf-8") as db:
        # Charger le contenu JSON dans la variable data
        data = json.load(db)
        # Parcourir le contenu JSON avec tqdm
        for i, item in tqdm(enumerate(data['storeContent']), total=len(data['storeContent'])):
            #set the progressbar value
            value = round(i / (len(data['storeContent']) - 1), 2)
            #update the progressbar every 100 items
            if i % 10 == 0:
                progressbar.set(value)
            # Vérifier si l'élément contient un lien http finissant par cia
            for key, value in item.items():
                if value and type(value) == dict and 'script' in value:
                    for subvalue in value['script']:
                        if 'file' in subvalue and subvalue['file'].endswith('.cia'):
                            await check_link(key, subvalue)
        progressbar.set(1)
        print('Done')