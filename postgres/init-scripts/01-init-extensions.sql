-- Enable the vector extension required for vector storage
CREATE EXTENSION IF NOT EXISTS vector;

-- Enable AGE extension for graph storage
CREATE EXTENSION IF NOT EXISTS age;
LOAD 'age';
SET search_path = ag_catalog, "$user", public;

-- Create necessary tables for LightRAG
-- These tables would be created by LightRAG on startup, but we provide them here for clarity

-- KV Storage tables
CREATE TABLE IF NOT EXISTS LIGHTRAG_DOC_FULL (
  id VARCHAR(255),
  workspace VARCHAR(255),
  doc_name VARCHAR(1024),
  content TEXT,
  meta JSONB,
  create_time TIMESTAMP(0),
  update_time TIMESTAMP(0),
  CONSTRAINT LIGHTRAG_DOC_FULL_PK PRIMARY KEY (workspace, id)
);

CREATE TABLE IF NOT EXISTS LIGHTRAG_DOC_CHUNKS (
  id VARCHAR(255),
  workspace VARCHAR(255),
  full_doc_id VARCHAR(256),
  chunk_order_index INTEGER,
  tokens INTEGER,
  content TEXT,
  content_vector VECTOR,
  file_path VARCHAR(256),
  create_time TIMESTAMP(0) WITH TIME ZONE,
  update_time TIMESTAMP(0) WITH TIME ZONE,
  CONSTRAINT LIGHTRAG_DOC_CHUNKS_PK PRIMARY KEY (workspace, id)
);

CREATE TABLE IF NOT EXISTS LIGHTRAG_LLM_CACHE (
  workspace VARCHAR(255) NOT NULL,
  id VARCHAR(255) NOT NULL,
  mode VARCHAR(32) NOT NULL,
  original_prompt TEXT,
  return_value TEXT,
  create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  update_time TIMESTAMP,
  CONSTRAINT LIGHTRAG_LLM_CACHE_PK PRIMARY KEY (workspace, mode, id)
);

-- Vector Storage tables
CREATE TABLE IF NOT EXISTS LIGHTRAG_VDB_ENTITY (
  id VARCHAR(255),
  workspace VARCHAR(255),
  entity_name VARCHAR(255),
  content TEXT,
  content_vector VECTOR,
  create_time TIMESTAMP(0) WITH TIME ZONE,
  update_time TIMESTAMP(0) WITH TIME ZONE,
  chunk_ids VARCHAR(255)[] NULL,
  file_path TEXT NULL,
  CONSTRAINT LIGHTRAG_VDB_ENTITY_PK PRIMARY KEY (workspace, id)
);

CREATE TABLE IF NOT EXISTS LIGHTRAG_VDB_RELATION (
  id VARCHAR(255),
  workspace VARCHAR(255),
  source_id VARCHAR(256),
  target_id VARCHAR(256),
  content TEXT,
  content_vector VECTOR,
  create_time TIMESTAMP(0) WITH TIME ZONE,
  update_time TIMESTAMP(0) WITH TIME ZONE,
  chunk_ids VARCHAR(255)[] NULL,
  file_path TEXT NULL,
  CONSTRAINT LIGHTRAG_VDB_RELATION_PK PRIMARY KEY (workspace, id)
);

-- Document Status Storage table
CREATE TABLE IF NOT EXISTS LIGHTRAG_DOC_STATUS (
  workspace VARCHAR(255) NOT NULL,
  id VARCHAR(255) NOT NULL,
  content TEXT NULL,
  content_summary VARCHAR(255) NULL,
  content_length INT4 NULL,
  chunks_count INT4 NULL,
  status VARCHAR(64) NULL,
  file_path TEXT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NULL,
  CONSTRAINT LIGHTRAG_DOC_STATUS_PK PRIMARY KEY (workspace, id)
);

-- Create indexes for all tables
CREATE INDEX IF NOT EXISTS idx_lightrag_doc_full_id ON LIGHTRAG_DOC_FULL(id);
CREATE INDEX IF NOT EXISTS idx_lightrag_doc_chunks_id ON LIGHTRAG_DOC_CHUNKS(id);
CREATE INDEX IF NOT EXISTS idx_lightrag_vdb_entity_id ON LIGHTRAG_VDB_ENTITY(id);
CREATE INDEX IF NOT EXISTS idx_lightrag_vdb_relation_id ON LIGHTRAG_VDB_RELATION(id);
CREATE INDEX IF NOT EXISTS idx_lightrag_llm_cache_id ON LIGHTRAG_LLM_CACHE(id);
CREATE INDEX IF NOT EXISTS idx_lightrag_doc_status_id ON LIGHTRAG_DOC_STATUS(id); 