import time
import requests

timeout = 120
start_time = time.time()
while True:

  try:
    r = requests.get('http://195.12.12.53:8000/health', verify=False, timeout=1)
    if r.status_code == 200:
      break

  except requests.exceptions.ConnectionError:
    if time.time() - start_time < timeout:
      print ('[Waiting]: service not ready yet, start sleep')
      time.sleep(30)
    else:
      raise Exception('[Timeout]: service not ready')

print ('[Start tests]: service is ready')
