#!/usr/bin/python3
from datetime import datetime
import requests
from pathlib import Path
import os
import subprocess
from PIL import Image

NG_base_url = 'http://www.nationalgeographic.com/photography/photo-of-the-day/\
_jcr_content/.gallery.'

def getImageTitleUrl():
	today = datetime.today()
	year = str(today.year)
	if today.month < 10:
		month = '0' + str(today.month)
	else:
		month = str(today.month)
	url = f"{NG_base_url}{year}-{month}.json"
	print(url);

	r = requests.get(url)

	if r.status_code == 200:
			data = r.json()
			if 'items' in data:
				current_photo = data['items'][0]
				if 'sizes' in current_photo:
					return current_photo["title"], current_photo['sizes']['2048']
				return current_photo["title"],current_photo["url"]
	return "";

title, url = getImageTitleUrl();

if len(title) == 0 or len(url) == 0:
	print("failed to retrieve!")
	exit();

destination_file = f'{Path.home()}/Pictures/NationalGeographics/{title.replace(" ","_")}.jpg'
if os.path.isfile(destination_file):
	print("esiste già")
#	exit()
else:
    with open(destination_file, 'wb') as f:
        f.write(requests.get(url).content)
    #png conversion
    png_dest = destination_file.replace(".jpg",".png")
    #subprocess.run(["convert","-scale","3840x2160^",destination_file,png_dest])
    subprocess.run(["convert","-scale","1920x1080^",destination_file,png_dest])
    destination_file = png_dest

            #os.system(f"feh --bg-scale {destination_file}")
result = subprocess.run(['feh', '--bg-scale',destination_file], stdout=subprocess.PIPE)
print(result.stdout)
