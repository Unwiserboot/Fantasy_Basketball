import sys
print(sys.version)

import requests
import csv
from bs4 import BeautifulSoup

preseason_traditional_url = 'http://stats.nba.com/stats/leaguedashplayerstats?College=&Conference=&Cou' + \
                'ntry=&DateFrom=&DateTo=&Division=&DraftPick=&DraftYear=&GameScope=&GameSeg' + \
                'ment=&Height=&LastNGames=0&LeagueID=00&Location=&MeasureType=Base&Month=0&O' + \
                'pponentTeamID=0&Outcome=&PORound=0&PaceAdjust=N&PerMode=PerGame&Period=0&Pl' + \
                'ayerExperience=&PlayerPosition=&PlusMinus=N&Rank=N&Season=2015-16&SeasonSeg' + \
                'ment=&SeasonType=Pre+Season&ShotClockRange=&StarterBench=&TeamID=0&VsConfere' + \
                'nce=&VsDivision=&Weight='

response = requests.get(preseason_traditional_url)
response.raise_for_status() #raise exception if invalid response
preseason_traditional_data = response.json()['resultSets'][0]['rowSet'] #Website data
preseason_traditional_header = response.json()['resultSets'][0]['headers'] #Header abbreviation

with open('preseason_traditional_data.csv', 'w') as fw: #Export preseason to excel file
        csv.writer(fw).writerow(preseason_traditional_header)
        csv.writer(fw).writerows(preseason_traditional_data)

###############################################################################################################
