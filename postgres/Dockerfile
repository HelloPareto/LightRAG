FROM postgres:15

# Install build dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    postgresql-server-dev-15 \
    cmake \
    curl \
    flex \
    bison \
    libreadline-dev \
    libssl-dev \
    python3-dev \
    python3-pip \
    python3-setuptools

# Install pgvector
RUN cd /tmp && \
    git clone --branch v0.5.1 https://github.com/pgvector/pgvector.git && \
    cd pgvector && \
    make && \
    make install

# Clone and build AGE - use specific branch/tag for PG15 compatibility
RUN cd /tmp && \
    git clone --branch PG15 https://github.com/apache/age.git && \
    cd age && \
    make && \
    make install

# Clean up
RUN apt-get remove -y build-essential git postgresql-server-dev-15 && \
    apt-get autoremove -y && \
    rm -rf /tmp/age /tmp/pgvector

# Copy initialization scripts
COPY init-scripts/ /docker-entrypoint-initdb.d/

# Set environment variables
ENV PATH /usr/lib/postgresql/15/bin:$PATH 