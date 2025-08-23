FROM python:3.12-slim AS build

WORKDIR /pyth-app

COPY requirements.txt .

RUN pip install -r requirements.txt

COPY app.py .

ENTRYPOINT [ "python", "app.py" ]