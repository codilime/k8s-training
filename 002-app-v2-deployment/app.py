import os
import sys

from flask import Flask, request

app = Flask(__name__)


@app.route('/')
def hello():
    user_agent = request.headers.get('User-Agent')
    print(f'User-Agent: {user_agent}', file=sys.stderr)
    return 'I am {}\n'.format(os.uname()[1])


app.run(host='0.0.0.0')
