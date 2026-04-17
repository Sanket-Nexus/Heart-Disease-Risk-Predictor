# Base image
FROM python:3.11-slim

# Avoid python buffering
ENV PYTHONUNBUFFERED=1

# Set working directory
WORKDIR /app

# Install system dependencies (important for numpy, matplotlib, tensorflow)
RUN apt-get update && apt-get install -y \
    build-essential \
    gcc \
    g++ \
    libgl1 \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first (for caching)
COPY requirements.txt .

# Install python dependencies
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# Copy full project
COPY . .

# Expose port
EXPOSE 5000

# Run app using gunicorn
# CMD ["gunicorn", "-w", "2", "-b", "0.0.0.0:5000", "app:app"]

CMD ["gunicorn", "-w", "1", "--timeout", "120", "--preload", "-b", "0.0.0.0:5000", "app:app"]