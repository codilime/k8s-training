FROM python:rc-alpine

COPY . /app
WORKDIR /app

RUN pip install -r requirements.txt
ENTRYPOINT ["python", "app.py"]
