#!/bin/bash

set -e

asias_services=("cas" "cas/db" "csp-reporter" "jira" "jira/db" "ldap" "liferay" "liferay/db" "piwik" "piwik/db" "smtpsink" "web" "_restore/web")
facility_services=("cas" "cas/db" "ldap" "liferay" "liferay/db" "reportviewer" "reportviewer_cisp" "reportviewer_cist/db" "reportviewer/db" "smtpsink" "web" "_restore/web")

if [[ $1 == asias ]]; then
    for i in "${asias_services[@]}"
    do
        pd service $2 "/asias/localcluster/$i"
    done
elif [[ $1 == facility ]]; then
    for i in "${facility_services[@]}"
    do
        pd service $2 "/facility/localcluster/$i"
    done
fi
