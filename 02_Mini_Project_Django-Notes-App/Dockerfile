<<<<<<< HEAD
FROM python:3.11-slim
=======
FROM python:3.11
>>>>>>> 732bb9404fc5418ab8a28a142dcbc88db42e856e

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8000

ENV PYTHONDONTWRITEBYTECODE=1

ENV PYTHONUNBUFFERED=1

CMD [ "sh", "-c", "python3 manage.py migrate && gunicorn notesapp.wsgi:application --bind 0.0.0.0:8000" ]
