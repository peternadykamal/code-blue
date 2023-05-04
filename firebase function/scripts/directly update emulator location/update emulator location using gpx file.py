import xml.etree.ElementTree as ET
import subprocess
import time
import os

# Replace with the path to your GPX file
gpx_file = 'file.gpx'

# Parse GPX file
tree = ET.parse(gpx_file)
root = tree.getroot()

# Get adb path
adb_path = os.path.join(os.environ['USERPROFILE'], 'AppData', 'Local', 'Android', 'Sdk', 'platform-tools', 'adb')
print(adb_path)

# Iterate through track points
prev_time = None
for trkpt in root.findall('.//{http://www.topografix.com/GPX/1/1}trkpt'):
    # Get latitude and longitude
    lat = trkpt.get('lat')
    lon = trkpt.get('lon')

    # Get time
    time_str = trkpt.find('{http://www.topografix.com/GPX/1/1}time').text
    timestamp = time.mktime(time.strptime(time_str, '%Y-%m-%dT%H:%M:%S.%fZ'))

    # Send geo fix command to emulator
    cmd = f'{adb_path} emu geo fix "{lon} {lat}"'
    subprocess.call(cmd, shell=True)

    # Wait for the "OK" response from the command
    while True:
        output = subprocess.check_output(cmd, shell=True)
        if output.strip() == b'OK':
            break
        time.sleep(0.1)

    # Wait for the time difference
    if prev_time:
        time_diff = abs(timestamp - prev_time)
        time.sleep(time_diff)
        print(f'Waited for {time_diff} seconds, moved to ({lat}, {lon})')

    # Update previous time
    prev_time = timestamp
