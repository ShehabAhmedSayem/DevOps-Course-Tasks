FROM python:3.9-slim-buster

WORKDIR /src

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONBUFFERED 1

COPY ./requirements.txt /src/requirements.txt
RUN pip install --no-cache-dir --upgrade -r /src/requirements.txt

COPY ./app /src/app
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8080"]
