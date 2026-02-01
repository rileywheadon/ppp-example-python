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

# Python dependencies builder stage
FROM python:3.13-alpine AS python-builder
WORKDIR /app

# Install uv and build tools
RUN pip install --no-cache-dir uv

# Create virtual environment
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Copy requirements and install dependencies in virtual environment
COPY src/requirements.txt /app/src/requirements.txt
RUN uv pip install --no-cache -r /app/src/requirements.txt

# Production stage
FROM python:3.13-alpine AS production
WORKDIR /app

# Copy virtual environment from builder
COPY --from=python-builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Copy source files
COPY ./src /app/src

# Copy built CSS from the css-builder stage
COPY --from=css-builder /app/src/static/css/output.css /app/src/static/css/output.css

ENV FLASK_ENV=production
ENV FLASK_APP=src.app
ENV DATABASE_URL=postgresql://postgres:postgres@db:5432/ppp_example_python

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "4", "src.app:app"]