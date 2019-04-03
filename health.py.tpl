import os
import time
from pip._vendor import requests

timeout = ${timeout}
start_time = time.time()
while True:

  try:
    r = requests.get('${endpoint}', verify=False, timeout=1)
    if r.status_code == 200:
      break

  except requests.exceptions.ConnectionError:
    if time.time() - start_time < timeout:
      print ('[Waiting]: service not ready yet, start sleep')
      time.sleep(30)
    else:
      raise Exception('[Timeout]: service not ready')

print ('[Start tests]: service is ready')
