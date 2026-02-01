# Build stage for Tailwind CSS
FROM node:18-alpine AS css-builder
WORKDIR /app

# Copy package files and install Node.js dependencies
COPY package*.json tailwind.config.js ./
RUN npm install

# Copy only what's needed for CSS compilation
COPY src/templates ./src/templates
COPY src/static/css/input.css ./src/static/css/input.css

# Build Tailwind CSS
RUN npx tailwindcss -i ./src/static/css/input.css -o ./src/static/css/output.css --minify

# Production stage
FROM python:3.13-alpine AS production
WORKDIR /app

# Copy Python requirements and install Python dependencies
COPY src/requirements.txt /app/src/requirements.txt
RUN pip install --no-cache-dir -r /app/src/requirements.txt

# Copy source files
COPY ./src /app/src

# Copy built CSS from the build stage
COPY --from=css-builder /app/src/static/css/output.css /app/src/static/css/output.css

ENV FLASK_ENV=production
ENV FLASK_APP=src.app
ENV DATABASE_URL=postgresql://postgres:postgres@db:5432/ppp_example_python

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "4", "src.app:app"]