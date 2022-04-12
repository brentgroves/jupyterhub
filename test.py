# import subprocess
# exit_code = subprocess.call(['ksh','unixpi.ksh'])
# print(exit_code)
from subprocess import run

# message = 'Hello, world!\n'
# run( [ 'cat', '-' ], input=message.encode() )

message = '\nYES\n\n\n35057920\nBPG-IN\n004193623\n35057920\n\n'
run( [ 'ksh', 'unixpi.ksh' ], input=message.encode() )
