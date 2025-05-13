# PostgreSQL Integration for LightRAG

This directory contains all the files needed to set up LightRAG with PostgreSQL for all storage components (KV, Vector, Graph, and Document Status).

## Contents

- `Dockerfile` - Builds a custom PostgreSQL image with pgvector and AGE extensions pre-installed
- `init-scripts/` - SQL scripts that run on container initialization
- `config.ini` - PostgreSQL configuration file for LightRAG
- `env-setup.txt` - Guide for setting up the .env file

## Quick Start

1. Copy the environment configuration:
   ```bash
   cp postgres/env-setup.txt .env
   # or edit your existing .env file with these configurations
   ```

2. Copy the PostgreSQL config:
   ```bash
   cp postgres/config.ini config.ini
   ```

3. Start the services using the PostgreSQL-specific docker-compose file:
   ```bash
   docker-compose -f docker-compose-pg.yml up -d
   ```

## About the PostgreSQL Setup

This setup provides:

- **Pre-installed Extensions**: The pgvector extension (for vector storage) and the Apache AGE extension (for graph database functionality) are pre-installed in the PostgreSQL image
- **Automated Table Creation**: All necessary tables and indexes are created automatically during container initialization
- **All-in-One Storage**: All LightRAG storage components use PostgreSQL, providing a single database for all persistence needs

## Custom PostgreSQL Image

The Dockerfile builds a custom PostgreSQL image with:

1. **pgvector extension** - For vector embeddings storage and similarity search
2. **Apache AGE extension** - For graph database functionality in PostgreSQL

This eliminates the need for separate databases for different storage types, simplifying deployment and maintenance.

## PostgreSQL Schema

The initialization scripts create the following tables:

- **LIGHTRAG_DOC_FULL**: Full document storage
- **LIGHTRAG_DOC_CHUNKS**: Text chunks from documents
- **LIGHTRAG_LLM_CACHE**: Cache for LLM responses
- **LIGHTRAG_VDB_ENTITY**: Entity storage for vector database
- **LIGHTRAG_VDB_RELATION**: Relation storage for vector database
- **LIGHTRAG_DOC_STATUS**: Document processing status

Additionally, the AGE extension creates its own schema for graph storage. 