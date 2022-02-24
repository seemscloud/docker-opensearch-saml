FROM debian:bullseye-slim

ARG APP_USER="opensearch"
ARG APP_GROUP="${APP_USER}"
ARG APP_UID="1000"
ARG APP_GID="${APP_UID}"
ARG APP_URL="https://artifacts.opensearch.org/releases/bundle/opensearch-dashboards"
ARG APP_VERSION="1.2.0"
ARG DEBIAN_FRONTEND=noninteractive
ARG APP_DIR="/app"

ENV PATH="${APP_DIR}/bin:${PATH}"

SHELL ["/bin/bash", "-c"]

RUN apt-get update && \
    apt-get install wget curl -y

RUN groupadd -g "${APP_GID}" "${APP_GROUP}" && \
    useradd -u "${APP_UID}" -g "${APP_GID}" -s /bin/bash -m -d "${APP_DIR}" "${APP_USER}"

WORKDIR /tmp

RUN wget "${APP_URL}/${APP_VERSION}/opensearch-dashboards-${APP_VERSION}-linux-x64.tar.gz" -O dashboards.tar.gz && \
    tar -xvf dashboards.tar.gz -C "${APP_DIR}" --strip-components=1 && \
    rm -f dashboards.tar.gz

WORKDIR "${APP_DIR}"

COPY ./entrypoint.sh .
COPY ./copy-certs.sh .

RUN chown --recursive "${APP_USER}":"${APP_USER}" "${APP_DIR}"

USER "${APP_USER}"

ENTRYPOINT [ "/bin/bash", "entrypoint.sh" ]