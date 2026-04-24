# Stage 1: Builder
FROM python:3.11-alpine AS builder

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

# Install build dependencies
RUN apk add --no-cache \
    gcc \
    musl-dev \
    postgresql-dev \
    libffi-dev \
    build-base

WORKDIR /app

# Install dependencies to a temporary folder
COPY requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt

# Stage 2: Final Runtime
FROM python:3.11-alpine AS runtime

# Install runtime-only dependencies (netcat for your entrypoint script)
RUN apk add --no-cache netcat-openbsd libpq dos2unix 

WORKDIR /app

# Copy only the installed python packages from the builder
COPY --from=builder /root/.local /home/appuser/.local
COPY --from=builder /app /app

# Copy application code
COPY . .

# Fix potential Windows line-ending issues in the entrypoint script
RUN dos2unix docker-entrypoint.sh && chmod +x docker-entrypoint.sh

# Set up a non-privileged user for security
RUN adduser -D appuser && chown -R appuser:appuser /app
USER appuser

# Ensure local bin is in PATH for Gunicorn
ENV PATH=/home/appuser/.local/bin:$PATH

EXPOSE 5000

ENTRYPOINT [ "./docker-entrypoint.sh" ]
