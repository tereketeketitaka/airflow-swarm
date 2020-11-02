FROM python:3.6-slim-stretch

ARG VERSION

ENV AIRFLOW_HOME        /opt/airflow
ENV AIRFLOW_CONF        /opt/conf
ENV AIRFLOW_AUTOCONF    True
ENV AIRFLOW_VERSION     ${VERSION}

RUN buildDeps="build-essentials" \ 
    && runtimeDeps="libmariadbclient-dev netcat wget" \
    && apt-get update \
    && apt-get install -y --no-install-recommends $buildDeps $runtimeDeps \
    && pip install apache-airflow[crypto,mysql,postgres,oracle,celery,redis,dask]==$AIRFLOW_VERSION bokeh \
    && apt-get purge -y --auto-remove $buildDeps \
    && rm -rf /var/lib/apt/lists/* \
    && useradd -ms /bin/bash -d ${AIRFLOW_HOME} airflow \
    && chown -R airflow:airflow ${AIRFLOW_HOME}

COPY script/entrypoint.sh /entrypoint.sh
COPY ./airflow.d ${AIRFLOW_CONF}
RUN chmod +x /entrypoint.sh \ 
    && chown -R airflow:airflow ${AIRFLOW_CONF}

EXPOSE 8080 5555 8787
USER airflow
WORKDIR ${AIRFLOW_HOME}
ENTRYPOINT ["/entrypoint.sh"]
CMD ["airflow","version"]
