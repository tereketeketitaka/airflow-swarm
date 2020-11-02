#!/bin/bash

function throw {
    echo $1
    exit1 1
}

function export_airflow_variables {
    for var in $(set | grep AIRFLOW__ | grep -v REMOTE_THIS_FROM_RESULT); do
        export ${var}
    done
}

function file_env {
    local var = "$1"
    local fileVar="${var}_FILE"
    local def="${2:-}"
}