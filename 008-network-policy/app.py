import os
import sys
import random
import concurrent.futures
import time

import requests
from flask import Flask, request

app = Flask(__name__)
services = [f"app{i}" for i in range(1,4)]

@app.route('/')
def hello():
    return 'I am {}\n'.format(os.uname()[1])

def dialer():
    while True:
        time.sleep(2)
        svc = random.choice(services)
        resp = requests.get(f"http://{svc}")
        print(f"Call to {svc} ended with {resp.status_code}", file=sys.stderr)

if __name__ == "__main__":
    with concurrent.futures.ThreadPoolExecutor(max_workers=4) as executor:
        executor.submit(dialer)
        app.run(host='0.0.0.0')
