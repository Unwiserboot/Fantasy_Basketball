#Grab data from nba.com/stats for 2015 2016 season data

#Indicator to use python3
#!/usr/local/bin/python3

#Import packages
import requests
import csv
import sys
import xlwt

#Print Relevant Information
print(sys.version)
#print(sys.path)
#print(sys.executable)


##########################################################################
#2015 2016 Regular season traditional stats

url = 'http://stats.nba.com/stats/leaguedashplayerstats?College=&Conference=&Country=&' +\
      'DateFrom=&DateTo=&Division=&DraftPick=&DraftYear=&GameScope=&GameSegment=&Height' +\
      '=&LastNGames=0&LeagueID=00&Location=&MeasureType=Base&Month=0&OpponentTeamID=0&Out' +\
      'come=&PORound=0&PaceAdjust=N&PerMode=PerGame&Period=0&PlayerExperience=&PlayerPosit' +\
      'ion=&PlusMinus=N&Rank=N&Season=2015-16&SeasonSegment=&SeasonType=Regular+Season&Shot' +\
      'ClockRange=&StarterBench=&TeamID=0&VsConference=&VsDivision=&Weight='

response = requests.get(url)
response.raise_for_status()  # raise exception if invalid response
data = response.json()['resultSets'][0]['rowSet']  # Player data
header = response.json()['resultSets'][0]['headers']  # Header abbreviations

with open('reg_sea_trad.csv', 'w') as fw:  # Export data to excel file
    csv.writer(fw).writerow(header)
    csv.writer(fw).writerows(data)



##########################################################################
#2015 2016 Regular season defensive stats

url = 'http://stats.nba.com/stats/leaguedashptdefend?College=&Conference=&Country=&DateFrom' +\
       '=&DateTo=&DefenseCategory=Overall&Division=&DraftPick=&DraftYear=&GameSegment=&Height' +\
       '=&LastNGames=0&LeagueID=00&Location=&Month=0&OpponentTeamID=0&Outcome=&PORound=0&PerMo' +\
       'de=PerGame&Period=0&PlayerExperience=&PlayerPosition=&Season=2015-16&SeasonSegment=&Se' +\
       'asonType=Regular+Season&StarterBench=&TeamID=0&VsConference=&VsDivision=&Weight='

response = requests.get(url)
response.raise_for_status()  # raise exception if invalid response
data = response.json()['resultSets'][0]['rowSet']  # Player data
header = response.json()['resultSets'][0]['headers']  # Header abbreviations

with open('reg_sea_def.csv', 'w') as fw:  # Export data to excel file
    csv.writer(fw).writerow(header)
    csv.writer(fw).writerows(data)


##########################################################################
#2015 2016 Regular season advanced stats

url = 'http://stats.nba.com/stats/leaguedashplayerstats?College=&Conference=&Country=&DateFrom=&Date' +\
      'To=&Division=&DraftPick=&DraftYear=&GameScope=&GameSegment=&Height=&LastNGames=0&LeagueID=00&L' +\
      'ocation=&MeasureType=Advanced&Month=0&OpponentTeamID=0&Outcome=&PORound=0&PaceAdjust=N&PerMode' +\
      '=Totals&Period=0&PlayerExperience=&PlayerPosition=&PlusMinus=N&Rank=N&Season=2015-16&SeasonSeg' +\
      'ment=&SeasonType=Regular+Season&ShotClockRange=&StarterBench=&TeamID=0&VsConference=&VsDivisio' +\
      'n=&Weight='

response = requests.get(url)
response.raise_for_status()  # raise exception if invalid response
data = response.json()['resultSets'][0]['rowSet']  # Player data
header = response.json()['resultSets'][0]['headers']  # Header abbreviations

with open('reg_sea_adv.csv', 'w') as fw:  # Export data to excel file
    csv.writer(fw).writerow(header)
    csv.writer(fw).writerows(data)
