# LightRAG with PostgreSQL Storage

This guide explains how to run LightRAG with all storage components using PostgreSQL. This setup provides several benefits:

- Single database system for all persistence needs
- Simpler infrastructure compared to multiple databases
- Consistent backup and maintenance procedures
- Better performance for some workloads

## Components Using PostgreSQL

In this setup, all LightRAG components will use PostgreSQL:

1. **KV Storage**: Document chunks, LLM response cache, and document information
2. **Vector Storage**: Entity vectors, relation vectors, and chunks vectors
3. **Graph Storage**: Entity-relation graph storage using the Apache AGE extension
4. **Document Status Storage**: Document indexing status

## Setup Instructions

### 1. Setup Environment Variables

Create or modify your `.env` file using the configuration from the provided `pg-env-setup.txt` file:

```bash
cp pg-env-setup.txt .env
# or edit your existing .env file with the content from pg-env-setup.txt
```

### 2. Setup PostgreSQL Configuration

Use the provided PostgreSQL-specific config file:

```bash
cp config.postgres.ini config.ini
```

### 3. Start the Services

Start LightRAG with PostgreSQL using the provided docker-compose file:

```bash
docker-compose -f docker-compose-pg.yml up -d
```

This will build a custom PostgreSQL image with the AGE extension installed.

### 4. Verify the Setup

Access the LightRAG web interface at http://localhost:9621 and check the status. You should see that all storage components (KV, Vector, Graph, and Document Status) are using PostgreSQL.

## PostgreSQL Schema

The PostgreSQL database will have the following tables:

- **LIGHTRAG_DOC_FULL**: Full document storage
- **LIGHTRAG_DOC_CHUNKS**: Text chunks from documents
- **LIGHTRAG_LLM_CACHE**: Cache for LLM responses
- **LIGHTRAG_VDB_ENTITY**: Entity storage for vector database
- **LIGHTRAG_VDB_RELATION**: Relation storage for vector database
- **LIGHTRAG_DOC_STATUS**: Document processing status

Additionally, the AGE extension creates its own schema for graph storage.

## About Apache AGE Extension

[Apache AGE (A Graph Extension)](https://age.apache.org/) is an extension for PostgreSQL that provides graph database functionality. It allows you to use PostgreSQL as a graph database, with support for graph queries using the Cypher query language.

Our docker-compose-pg.yml setup builds a custom PostgreSQL image with the AGE extension installed, so you don't need to install it separately.

## Troubleshooting

If you encounter any issues:

1. Check that the PostgreSQL image built successfully:
   ```bash
   docker logs lightrag-postgres
   ```

2. Verify the AGE extension is properly installed:
   ```bash
   docker exec -it lightrag-postgres psql -U lightrag -d lightragdb -c "SELECT * FROM pg_extension WHERE extname = 'age';"
   ```

3. If you see errors related to the AGE extension, you might need to modify the Dockerfile to match your specific PostgreSQL version. 