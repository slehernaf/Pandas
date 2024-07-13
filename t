cac29b87a3d9b7181d9e9bf973675a3ac2b30dfe85322fb0

import pandas as pd
import json
from io import BytesIO

json_data = '''
{
  "Пользователи": [
    {"Имя": "Алексей", "Возраст": 25},
    {"Имя": "Наталья", "Возраст": 30}
  ],
  "Города": [
    {"Город": "Москва", "Население": 12615279},
    {"Город": "Санкт-Петербург", "Население": 5383890}
  ]
}
'''


excel_file = BytesIO()

def create_excel(data):
    global excel_file
    with pd.ExcelWriter(excel_file) as writer:
        for sheet_name, records in data.items():
            df = pd.DataFrame(records)
            df.to_excel(writer, sheet_name=sheet_name, index=False)
    excel_file.seek(0)

def change_data(sheet, data):
    global excel_file
    excel_file.seek(0)
    with pd.ExcelWriter(excel_file, mode='a', if_sheet_exists='replace') as writer:
        data.to_excel(writer, sheet_name=sheet, index=False)
    excel_file.seek(0)

def extract_df(sheet):
    global excel_file
    return pd.read_excel(excel_file,sheet_name=sheet)

def all_sheets():
    global excel_file
    return pd.ExcelFile(excel_file).sheet_names

def write_excel(file_name='mvp.xlsx'):
    global excel_file
    with open(file_name, 'wb') as file:
        file.write(excel_file.getvalue())


create_excel(json.loads(json_data))

users_df = extract_df('Пользователи')
cities_df = extract_df('Города')
del users_df

cities_df['Город миллионник'] = cities_df['Население']>1000000
change_data('Города',cities_df)

pd.ExcelFile(excel_file).sheet_names

for ss in all_sheets():
    print (extract_df(ss))
