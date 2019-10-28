import time
import requests
import os

timeout = os.environ['HEALTH_TIMEOUT']
start_time = time.time()
while True:

  try:
    r = requests.get(os.environ['HEALTH_ENDPOINT'], verify=False)
    if r.status_code == 200:
      break

  except requests.exceptions.ConnectionError:
    if time.time() - start_time < timeout:
      time.sleep(15)
    else:
      raise Exception(f'[Timeout]: service not ready in {timeout} sec')

print (f'[Start tests]: service is ready in {int(time.time() - start_time)} sec')
