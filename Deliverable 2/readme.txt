
#pyexasol is a python library to connect with exasol database and execute the queries

#Installation : pip install pyexasol

#Usage Includes
con.execute('TRUNCATE TABLE genres')
con.import_from_pandas(df_genres.drop_duplicates(), 'genres')
