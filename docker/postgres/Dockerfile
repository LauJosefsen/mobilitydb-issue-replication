FROM postgis/postgis:15-3.3

# -----------------------------
# CITUS INSTALLATION BEGIN
# https://github.com/citusdata/docker/blob/master/Dockerfile
# -----------------------------

ARG VERSION=11.1.4

ENV CITUS_VERSION ${VERSION}.citus-1

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       ca-certificates \
       curl \
    && curl -s https://install.citusdata.com/community/deb.sh | bash \
    && apt-get install -y postgresql-$PG_MAJOR-citus-11.1=$CITUS_VERSION \
                          postgresql-$PG_MAJOR-hll=2.17.citus-1 \
                          postgresql-$PG_MAJOR-topn=2.5.0.citus-1 \
    && apt-get purge -y --auto-remove curl \
    && rm -rf /var/lib/apt/lists/*

COPY 001-create-citus-extension.sql /docker-entrypoint-initdb.d/

COPY pg_healthcheck wait-for-manager.sh /
RUN chmod +x /wait-for-manager.sh
RUN sed "/unset PGPASSWORD/d" -i /usr/local/bin/docker-entrypoint.sh

# -----------------------------
# CITUS INSTALLATION END
# -----------------------------

# -----------------------------
# MOBILITYDB INSTALLATION BEGIN
# -----------------------------

ENV MOBILITYDB_VERSION 1.1

# Fix the Release file expired problem
RUN echo "Acquire::Check-Valid-Until \"false\";\nAcquire::Check-Date \"false\";" | cat > /etc/apt/apt.conf.d/10no--check-valid-until

# Install Prerequisites 
RUN apt-get update \
 && apt-get install -y \
    build-essential \
    cmake \
    git \
    libproj-dev \    
    g++ \
    wget \
    autoconf \
    autotools-dev \
    libgeos-dev \
    libpq-dev \
    libproj-dev \
    libjson-c-dev \
    protobuf-c-compiler \
    xsltproc \
    libgsl-dev \
    libgslcblas0 \  
    postgresql-server-dev-${PG_MAJOR} \
  && rm -rf /var/lib/apt/lists/*     

# Install MobilityDB     
RUN git clone https://github.com/MobilityDB/MobilityDB.git -b develop /usr/local/src/MobilityDB
RUN mkdir /usr/local/src/MobilityDB/build
RUN cd /usr/local/src/MobilityDB/build && \
    cmake .. && \
    make -j$(nproc) && \
    make install

RUN rm /docker-entrypoint-initdb.d/10_postgis.sh

# -----------------------------
# MOBILITYDB INSTALLATION END
# -----------------------------

# Preload Postgis
RUN echo "shared_preload_libraries='citus,postgis-3.so'" >> /usr/share/postgresql/postgresql.conf.sample

# Open for all access on local network.
COPY pg_hba.conf /usr/local/share/postgresql/pg_hba.conf

# Copy the setup script
COPY 002-setup-database.sql /docker-entrypoint-initdb.d/
COPY queries/ /queries/

HEALTHCHECK --interval=4s --start-period=6s CMD ./pg_healthcheck