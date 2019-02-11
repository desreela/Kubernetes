import os

for root, dirs, files in os.walk("/etc/"):  
    for filename in files:
        print(filename)
