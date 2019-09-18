import os
import subprocess

from flask import Flask, request

app = Flask(__name__)


@app.route('/')
def hello():
    return 'I am {}\n'.format(os.uname()[1])


@app.route('/env')
def env():
    name = request.args.get('name')
    return 'Env var {}: {}\n'.format(name, os.getenv(name))


@app.route('/dir')
def file():
    path = request.args.get('path')
    listing = subprocess.call('ls {}'.format(path), shell=True)
    return 'Dir {}: {}\n'.format(path, listing)


app.run(host='0.0.0.0')
