FROM polinux/centos-supervisor

ENV \
      GOSU_VERSION=1.10 \
      PG_VERSION=94 \
      PG_MAJOR=9.4 \
      PGDATA=/var/lib/postgresql/data \
      TERM=xterm \
      POSTGRES_PASSWORD=password \
      POSTGRES_USER=postgres \
      POSTGRES_DB=postgres \
      POSTGRES_PORT=5432 \
      MODE=single \
      MASTER_ADDRESS=localhost \
      MASTER_PORT=5432 \
      SLAVE_PORT=5432


RUN \
  rpm --rebuilddb && yum clean all && \
  yum install -y  http://packages.2ndquadrant.com/postgresql-bdr${PG_VERSION}-2ndquadrant/yum-repo-rpms/postgresql-bdr94-2ndquadrant-redhat-latest.noarch.rpm && \
  yum update -y yum-skip-broken && \
  yum install -y postgresql-bdr${PG_VERSION}-bdr && \
  yum clean all && \
  curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64" && \
  chmod +x /usr/local/bin/gosu && \
  mkdir -p /var/run/postgresql && \
  chown -R postgres /var/run/postgresql

COPY container-files/ /

ENV PATH /usr/pgsql-${PG_MAJOR}/bin:$PATH

VOLUME /var/lib/postgresql/data

EXPOSE 5432
