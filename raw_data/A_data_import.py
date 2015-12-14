#Grab data from nba.com/stats for 2015 2016 season data

#SECTIONS
    #Section 1 - regular season player traditional
    #Section 2 - regular season player defensive
    #Section 3 - regular season player advanced
    #Section 4 - regular season team traditional
    #Section 5 - regular season team opponent
    #Section 6 - regular season team opponent forward
    #Section 7 - regular season team opponent center
    #Section 8 - regular season team opponent guard
    #Section 9 - regular season player traditional 3 game

#Indicator to use python3
#!/Library/Frameworks/Python.framework/Versions/3.5/lib/python3.5

#Import packages
import requests
import csv
import sys
import xlwt

#Print Relevant Information
print(sys.version)
#print(sys.path)
#print(sys.executable)


##########################################################################################################
##########################################################################################################
#SECTION 1
#2015 2016 Regular season player traditional

url = 'http://stats.nba.com/stats/leaguedashplayerstats?College=&Conference=&Country=&DateFrom=&DateTo=&Division=&DraftPick=&DraftYear=&GameScope=&GameSegment=&Height=&LastNGames=0&LeagueID=00&Location=&MeasureType=Base&Month=0&OpponentTeamID=0&Outcome=&PORound=0&PaceAdjust=N&PerMode=PerGame&Period=0&PlayerExperience=&PlayerPosition=&PlusMinus=N&Rank=N&Season=2015-16&SeasonSegment=&SeasonType=Regular+Season&ShotClockRange=&StarterBench=&TeamID=0&VsConference=&VsDivision=&Weight='

response = requests.get(url)
response.raise_for_status()  # raise exception if invalid response
data = response.json()['resultSets'][0]['rowSet']  # Player data
header = response.json()['resultSets'][0]['headers']  # Header abbreviations

with open('reg_sea_player_trad.csv', 'w') as fw:  # Export data to excel file
    csv.writer(fw).writerow(header)
    csv.writer(fw).writerows(data)


#SECTION 1
##########################################################################################################
##########################################################################################################
#SECTION 2
#2015 2016 Regular season player defensive

url = 'http://stats.nba.com/stats/leaguedashptdefend?College=&Conference=&Country=&DateFrom=&DateTo=&DefenseCategory=Overall&Division=&DraftPick=&DraftYear=&GameSegment=&Height=&LastNGames=0&LeagueID=00&Location=&Month=0&OpponentTeamID=0&Outcome=&PORound=0&PerMode=PerGame&Period=0&PlayerExperience=&PlayerPosition=&Season=2015-16&SeasonSegment=&SeasonType=Regular+Season&StarterBench=&TeamID=0&VsConference=&VsDivision=&Weight='

response = requests.get(url)
response.raise_for_status()  # raise exception if invalid response
data = response.json()['resultSets'][0]['rowSet']  # Player data
header = response.json()['resultSets'][0]['headers']  # Header abbreviations

with open('reg_sea_player_def.csv', 'w') as fw:  # Export data to excel file
    csv.writer(fw).writerow(header)
    csv.writer(fw).writerows(data)

#SECTION 2
##########################################################################################################
##########################################################################################################
#SECTION 3
#2015 2016 Regular season player advanced

url = 'http://stats.nba.com/stats/leaguedashplayerstats?College=&Conference=&Country=&DateFrom=&DateTo=&Division=&DraftPick=&DraftYear=&GameScope=&GameSegment=&Height=&LastNGames=0&LeagueID=00&Location=&MeasureType=Advanced&Month=0&OpponentTeamID=0&Outcome=&PORound=0&PaceAdjust=N&PerMode=Totals&Period=0&PlayerExperience=&PlayerPosition=&PlusMinus=N&Rank=N&Season=2015-16&SeasonSegment=&SeasonType=Regular+Season&ShotClockRange=&StarterBench=&TeamID=0&VsConference=&VsDivision=&Weight='

response = requests.get(url)
response.raise_for_status()  # raise exception if invalid response
data = response.json()['resultSets'][0]['rowSet']  # Player data
header = response.json()['resultSets'][0]['headers']  # Header abbreviations

with open('reg_sea_player_adv.csv', 'w') as fw:  # Export data to excel file
    csv.writer(fw).writerow(header)
    csv.writer(fw).writerows(data)

#SECTION 3
##########################################################################################################
##########################################################################################################
#SECTION 4
#2015 2016 Regular season traditional team

url = 'http://stats.nba.com/stats/leaguedashteamstats?Conference=&DateFrom=&DateTo=&Division=&GameScope=&GameSegment=&LastNGames=0&LeagueID=00&Location=&MeasureType=Base&Month=0&OpponentTeamID=0&Outcome=&PORound=0&PaceAdjust=N&PerMode=PerGame&Period=0&PlayerExperience=&PlayerPosition=&PlusMinus=N&Rank=N&Season=2015-16&SeasonSegment=&SeasonType=Regular+Season&ShotClockRange=&StarterBench=&TeamID=0&VsConference=&VsDivision='

response = requests.get(url)
response.raise_for_status()  # raise exception if invalid response
data = response.json()['resultSets'][0]['rowSet']  # Player data
header = response.json()['resultSets'][0]['headers']  # Header abbreviations

with open('reg_sea_team_trad.csv', 'w') as fw:  # Export data to excel file
    csv.writer(fw).writerow(header)
    csv.writer(fw).writerows(data)

#SECTION 4
##########################################################################################################
##########################################################################################################
#SECTION 5
#2015 2016 Regular season opponent team

url = 'http://stats.nba.com/stats/leaguedashteamstats?Conference=&DateFrom=&DateTo=&Division=&GameScope=&GameSegment=&LastNGames=0&LeagueID=00&Location=&MeasureType=Opponent&Month=0&OpponentTeamID=0&Outcome=&PORound=0&PaceAdjust=N&PerMode=PerGame&Period=0&PlayerExperience=&PlayerPosition=&PlusMinus=N&Rank=N&Season=2015-16&SeasonSegment=&SeasonType=Regular+Season&ShotClockRange=&StarterBench=&TeamID=0&VsConference=&VsDivision='

response = requests.get(url)
response.raise_for_status()  # raise exception if invalid response
data = response.json()['resultSets'][0]['rowSet']  # Player data
header = response.json()['resultSets'][0]['headers']  # Header abbreviations

with open('reg_sea_team_opp.csv', 'w') as fw:  # Export data to excel file
    csv.writer(fw).writerow(header)
    csv.writer(fw).writerows(data)

#SECTION 5
##########################################################################################################
##########################################################################################################
#SECTION 6
#2015 2016 Regular season team opponent forward

url = 'http://stats.nba.com/stats/leaguedashteamstats?Conference=&DateFrom=&DateTo=&Division=&GameScope=&GameSegment=&LastNGames=0&LeagueID=00&Location=&MeasureType=Opponent&Month=0&OpponentTeamID=0&Outcome=&PORound=0&PaceAdjust=N&PerMode=PerGame&Period=0&PlayerExperience=&PlayerPosition=F&PlusMinus=N&Rank=N&Season=2015-16&SeasonSegment=&SeasonType=Regular+Season&ShotClockRange=&StarterBench=&TeamID=0&VsConference=&VsDivision='

response = requests.get(url)
response.raise_for_status()  # raise exception if invalid response
data = response.json()['resultSets'][0]['rowSet']  # Player data
header = response.json()['resultSets'][0]['headers']  # Header abbreviations

with open('reg_sea_team_opp_forward.csv', 'w') as fw:  # Export data to excel file
    csv.writer(fw).writerow(header)
    csv.writer(fw).writerows(data)

#SECTION 6
##########################################################################################################
##########################################################################################################
#SECTION 7
#2015 2016 Regular season team opponent center

url ='http://stats.nba.com/stats/leaguedashteamstats?Conference=&DateFrom=&DateTo=&Division=&GameScope=&GameSegment=&LastNGames=0&LeagueID=00&Location=&MeasureType=Opponent&Month=0&OpponentTeamID=0&Outcome=&PORound=0&PaceAdjust=N&PerMode=PerGame&Period=0&PlayerExperience=&PlayerPosition=C&PlusMinus=N&Rank=N&Season=2015-16&SeasonSegment=&SeasonType=Regular+Season&ShotClockRange=&StarterBench=&TeamID=0&VsConference=&VsDivision='

response = requests.get(url)
response.raise_for_status()  # raise exception if invalid response
data = response.json()['resultSets'][0]['rowSet']  # Player data
header = response.json()['resultSets'][0]['headers']  # Header abbreviations

with open('reg_sea_team_opp_center.csv', 'w') as fw:  # Export data to excel file
    csv.writer(fw).writerow(header)
    csv.writer(fw).writerows(data)

#SECTION 7
##########################################################################################################
##########################################################################################################
#SECTION 8
#2015 2016 Regular season team opponent center

url = 'http://stats.nba.com/stats/leaguedashteamstats?Conference=&DateFrom=&DateTo=&Division=&GameScope=&GameSegment=&LastNGames=0&LeagueID=00&Location=&MeasureType=Opponent&Month=0&OpponentTeamID=0&Outcome=&PORound=0&PaceAdjust=N&PerMode=PerGame&Period=0&PlayerExperience=&PlayerPosition=G&PlusMinus=N&Rank=N&Season=2015-16&SeasonSegment=&SeasonType=Regular+Season&ShotClockRange=&StarterBench=&TeamID=0&VsConference=&VsDivision='

response = requests.get(url)
response.raise_for_status()  # raise exception if invalid response
data = response.json()['resultSets'][0]['rowSet']  # Player data
header = response.json()['resultSets'][0]['headers']  # Header abbreviations

with open('reg_sea_team_opp_guard.csv', 'w') as fw:  # Export data to excel file
    csv.writer(fw).writerow(header)
    csv.writer(fw).writerows(data)

#SECTION 8
##########################################################################################################
##########################################################################################################
#SECTION 9
#2015 2016 Regular season team opponent center

url = 'http://stats.nba.com/stats/leaguedashplayerstats?College=&Conference=&Country=&DateFrom=&DateTo=&Division=&DraftPick=&DraftYear=&GameScope=&GameSegment=&Height=&LastNGames=3&LeagueID=00&Location=&MeasureType=Base&Month=0&OpponentTeamID=0&Outcome=&PORound=0&PaceAdjust=N&PerMode=PerGame&Period=0&PlayerExperience=&PlayerPosition=&PlusMinus=N&Rank=N&Season=2015-16&SeasonSegment=&SeasonType=Regular+Season&ShotClockRange=&StarterBench=&TeamID=0&VsConference=&VsDivision=&Weight='

response = requests.get(url)
response.raise_for_status()  # raise exception if invalid response
data = response.json()['resultSets'][0]['rowSet']  # Player data
header = response.json()['resultSets'][0]['headers']  # Header abbreviations

with open('reg_sea_player_trad_3gme.csv', 'w') as fw:  # Export data to excel file
    csv.writer(fw).writerow(header)
    csv.writer(fw).writerows(data)

#SECTION 9
##########################################################################################################
##########################################################################################################
