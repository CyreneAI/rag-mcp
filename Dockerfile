# Dockerfile for rag-mcp
FROM ghcr.io/cyreneai/base-mcp:latest

# Set working directory
WORKDIR /app

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy your application code
COPY . .

# Set environment variables for Kubernetes deployment
ENV LOCAL_MODE="false"
ENV FASTMCP_BASE_URL="http://fastmcp-core-svc:9000"

EXPOSE 9002

CMD ["uvicorn", "mcp-servers.rag-mcp.server:app", "--host", "0.0.0.0", "--port", "9002"]
