FROM python:3.14-alpine
WORKDIR /app
COPY ./src /app
ENV FLASK_ENV=production
RUN pip install --no-cache-dir -r requirements.txt
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "4", "app:app"]