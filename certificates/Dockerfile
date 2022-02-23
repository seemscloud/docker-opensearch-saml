FROM debian:bullseye-slim

ARG APP_USER="certificates"
ARG APP_GROUP="${APP_USER}"
ARG APP_UID="1000"
ARG APP_GID="${APP_UID}"

ARG DEBIAN_FRONTEND=noninteractive

ENV APP_DIR="/app"

SHELL ["/bin/bash", "-c"]

RUN apt-get update && \
    apt-get install openssl -y

RUN groupadd -g "${APP_GID}" "${APP_GROUP}" && \
    useradd -u "${APP_UID}" -g "${APP_GID}" -s /bin/bash -m -d "${APP_DIR}" "${APP_USER}"

RUN mkdir -p "${APP_DIR}/data"

WORKDIR "${APP_DIR}"

COPY ./entrypoint.sh .

RUN chown --recursive "${APP_USER}":"${APP_USER}" "${APP_DIR}"

USER "${APP_USER}"

ENTRYPOINT [ "/bin/bash", "entrypoint.sh" ]