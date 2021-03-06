import pyodbc 
# https://docs.microsoft.com/en-us/sql/connect/python/pyodbc/step-1-configure-development-environment-for-pyodbc-python-development?view=sql-server-ver15
# docker run -it --name my-manim-container -v "/home/bgroves@BUSCHE-CNC.COM/srcmanim:/manim" manimcommunity/manim /bin/bash
# Some other example server values are
# server = 'localhost\sqlexpress' # for a named instance
# server = 'myserver,port' # to specify an alternate port
# Function to display the contents of a record
def printRec (rec):

    print("\nPCN           : ", rec[0])
    print("period_key    : ",rec[1])          # Comma on end stops new line being output
    print("period        : ",rec[2])          # Comma on end stops new line being output
    # print("period_display: ",rec[3][0:10])
    print("period_display: ", end ='')
    if rec[3]!=None:
        print(rec[3][0:10])
    else:
        print("-")
    print("start date    :", rec[6])
    print("end date      :", rec[7])
    print("status        :", rec[8])
    print("add date      :", rec[9])
    print("updated date  :", rec[10])

# MSSQLTest
username = 'mg.odbcalbion' 
password = 'Mob3xalbion' 
sqlExecSP = "call sproc300758_11728751_2059406 '123681',202201,202203"
cnxn = pyodbc.connect('DSN=Plex;UID='+username+';PWD='+ password)

# server = 'tcp:mgsqlmi.public.48d444e7f69b.database.windows.net,3342' 
# database = 'mgdw' 
# username = 'mgadmin' 
# password = 'WeDontSharePasswords1!' 
#cnxn = pyodbc.connect('DRIVER={ODBC Driver 18 for SQL Server};SERVER='+server+';DATABASE='+database+';UID='+username+';PWD='+ password)
# Call SP and trap Error if raised
cursor = cnxn.cursor()

try:
    cursor.execute(sqlExecSP)
except pyodbc.Error as e:
    print('Error !!!!! %s') % e

print("\nFirst Set of Results :")
print("----------------------")

# Fetch all rowset from execute
recs=cursor.fetchall()

# Process each record individually
for rec in recs:
	printRec(rec)