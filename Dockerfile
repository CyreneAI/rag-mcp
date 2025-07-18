# Dockerfile for rag-mcp
FROM ghcr.io/cyreneai/base-mcp:latest

# Set working directory
WORKDIR /app

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy your application code
COPY . .

EXPOSE 9002

CMD ["uvicorn", "server:app", "--host", "0.0.0.0", "--port", "9002"]
