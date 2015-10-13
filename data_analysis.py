import sys
print(sys.version)

import csv

fanduel_data = open('fanduel_data.csv')
fanduel_data = csv.reader(fanduel_data)


#for row in fanduel_data:
  #print (row)





from openpyxl import Workbook
from openpyxl.compat import range
from openpyxl.cell import get_column_letter

wb = Workbook()

dest_filename = 'analysis.xlsx'

ws1 = wb.active
ws1.title = "QB"

for row in fanduel_data:
    if row(1) == 'QB'
        ws1.append(row)


wb.save(filename = dest_filename)
