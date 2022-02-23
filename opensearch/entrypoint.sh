#!/bin/bash

/bin/bash copy-certs.sh

export OPENSEARCH_HOME=/usr/share/opensearch
export OPENSEARCH_JAVA_OPTS="-Dopensearch.cgroups.hierarchy.override=/ $OPENSEARCH_JAVA_OPTS"

declare OPENSEARCH_PID
declare PA_PID

function setupSecurityPlugin {
    SECURITY_PLUGIN="opensearch-security"

    if [ -d "$OPENSEARCH_HOME/plugins/$SECURITY_PLUGIN" ]; then
        if [ "$DISABLE_INSTALL_DEMO_CONFIG" = "true" ]; then
            echo "Disabling execution of install_demo_configuration.sh for OpenSearch Security Plugin"
        else
            echo "Enabling execution of install_demo_configuration.sh for OpenSearch Security Plugin"
            bash $OPENSEARCH_HOME/plugins/$SECURITY_PLUGIN/tools/install_demo_configuration.sh -y -i -s
        fi

        if [ "$DISABLE_SECURITY_PLUGIN" = "true" ]; then
            echo "Disabling OpenSearch Security Plugin"
            opensearch_opt="-Eplugins.security.disabled=true"
            opensearch_opts+=("${opensearch_opt}")
        else
            echo "Enabling OpenSearch Security Plugin"
        fi
    fi
}

function terminateProcesses {
    if kill -0 $OPENSEARCH_PID >& /dev/null; then
        echo "Killing opensearch process $OPENSEARCH_PID"
        kill -TERM $OPENSEARCH_PID
        wait $OPENSEARCH_PID
    fi
    if kill -0 $PA_PID >& /dev/null; then
        echo "Killing performance analyzer process $PA_PID"
        kill -TERM $PA_PID
        wait $PA_PID
    fi
}

function runOpensearch {
    # Files created by OpenSearch should always be group writable too
    umask 0002

    if [[ "$(id -u)" == "0" ]]; then
        echo "OpenSearch cannot run as root. Please start your container as another user."
        exit 1
    fi

    opensearch_opts=()
    while IFS='=' read -r envvar_key envvar_value
    do
        if [[ "$envvar_key" =~ ^[a-z0-9_]+\.[a-z0-9_]+ || "$envvar_key" == "processors" ]]; then
            if [[ ! -z $envvar_value ]]; then
            opensearch_opt="-E${envvar_key}=${envvar_value}"
            opensearch_opts+=("${opensearch_opt}")
            fi
        fi
    done < <(env)

    setupSecurityPlugin

    set -m

    trap terminateProcesses TERM INT EXIT CHLD

    "$@" "${opensearch_opts[@]}" &
    OPENSEARCH_PID=$!

    # performance-analyzer-agent-cli > $OPENSEARCH_HOME/logs/performance-analyzer.log 2>&1 &
    PA_PID=$!

    wait $OPENSEARCH_PID
    local opensearch_exit_code=$?
    echo "OpenSearch exited with code ${opensearch_exit_code}"

    wait $PA_PID
    echo "Performance analyzer exited with code $?"
}

if [ $# -eq 0 ] || [ "${1:0:1}" = '-' ]; then
    set -- opensearch "$@"
fi

if [ "$1" = "opensearch" ]; then
    runOpensearch "$@"
else
    exec "$@"
fi