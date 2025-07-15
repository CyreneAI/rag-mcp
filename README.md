````markdown
# 📚 RAG MCP

This repository contains the RAG MCP (Retrieval-Augmented Generation Multi-Channel Platform) server, a specialized microservice within the Multi-Agent Bot system. Its primary function is to provide tools for interacting with a vector database (ChromaDB) to perform Retrieval-Augmented Generation (RAG). This allows agents to query custom knowledge bases and retrieve relevant information to enhance their responses.

## ✨ Features

- **Vector Database Integration**: Connects with ChromaDB for storing and retrieving vectorized documents.
- **Document Querying**: Exposes a tool (`query_docs`) that allows agents to search the ChromaDB for information relevant to a given query.
- **FastMCP Integration**: Registers RAG functionalities as discoverable tools for the cyrene-agent (bot-api).
- **Modular & Scalable**: Runs as an independent microservice, allowing for easy scaling and maintenance.
- **Persistent Storage**: Designed to work with a Persistent Volume Claim (PVC) in Kubernetes for ChromaDB data, ensuring knowledge persists across pod restarts.

## 🏛️ Architecture Context

The rag-mcp interacts directly with a ChromaDB instance, which typically stores embeddings of your custom documents. The cyrene-agent discovers its `query_docs` tool via the fastmcp-core-server and then invokes it on the rag-mcp service when an agent needs to retrieve information from the knowledge base.

## 🚀 Getting Started

### Prerequisites

* Python 3.12+
* **ChromaDB Instance**: This MCP expects to connect to a ChromaDB instance.

  * For local development, you can run ChromaDB as a Docker container or an in-memory instance (though persistence will require a file path).
  * For Kubernetes deployment, ChromaDB is typically deployed as a separate service with a PVC.
* **RAG Data**: You'll need documents to load into ChromaDB. The main orchestrator repository includes a rag-data-loader-job for this purpose.

### Installation

Clone this repository:

```bash
git clone https://github.com/CyreneAI/rag-mcp.git
cd rag-mcp
```

> **Note:** If you are setting up the entire multi-repo system, you would typically clone the main orchestrator repository first.

Install Python dependencies:

```bash
pip install -r requirements.txt
```

### Environment Variables

Create a `.env` file in the root of this `rag-mcp` directory with the following variable:

```env
# .env in rag-mcp directory
CHROMA_DB_PATH=./chroma_data
```

* `CHROMA_DB_PATH`: The path to the ChromaDB data directory.

  * Example for local development: `CHROMA_DB_PATH=./chroma_data`
  * Example for Kubernetes (matching PVC mount path): `CHROMA_DB_PATH=/chroma/data`

### Running the Application (Local Development)

1. Ensure your ChromaDB instance is running and accessible at the path specified in `CHROMA_DB_PATH`. You can run a simple ChromaDB server locally via Docker:

   ```bash
   docker run -p 8000:8000 chromadb/chroma
   # Or, for persistent data:
   # docker run -p 8000:8000 -v /path/to/your/local/chroma_data:/chroma/data chromadb/chroma
   ```

2. Load initial RAG data into your ChromaDB instance using the rag-data-loader-job (from the main orchestrator repo) or a local script.

3. Run the rag-mcp service:

   ```bash
   uvicorn server:app --reload --host 0.0.0.0 --port 9002
   ```

The rag-mcp server will be accessible at `http://localhost:9002`. It will automatically register its tools with the fastmcp-core-server if it's running and configured correctly.

## 🧪 Usage

Once the rag-mcp server is running and its `query_docs` tool is registered with fastmcp-core-server, the cyrene-agent can invoke it.

Example queries you can send to your agent (via the agent-UI or direct API chat) that would trigger the rag-mcp tool:

* “Tell me about the GAIA benchmark.”
* “What is the performance of Alita on the latest tests?”
* “Summarize the document about project X.”

> **Note:** The quality of responses depends heavily on the data loaded into your ChromaDB.

## 📁 Project Structure

```
rag-mcp/
├── .env.example
├── .gitignore
├── README.md           # <- This file
├── Dockerfile          # Dockerfile for the rag-mcp service
├── requirements.txt    # Python dependencies for rag-mcp
└── server.py           # FastAPI application for the rag-mcp
```

