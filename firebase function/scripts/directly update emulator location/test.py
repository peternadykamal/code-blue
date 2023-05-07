import subprocess
import time
import os
adb_path = os.path.join(os.environ['USERPROFILE'], 'AppData', 'Local', 'Android', 'Sdk', 'platform-tools', 'adb')
cmd = f'{adb_path} emu geo fix "31.251466 29.975104"'
subprocess.call(cmd, shell=True)