#!/usr/bin/env bash
# set bash strict mode
set -euo pipefail
IFS=$'\n\t'

ACME_KEY_FILE="/home/{{ acme.user }}/.acme.sh/{{ gitlab.domain }}_ecc/{{ gitlab.domain }}.key"
ACME_FULLCHAIN_FILE="/home/{{ acme.user }}/.acme.sh/{{ gitlab.domain }}_ecc/fullchain.cer"
ACME_CERT_FILE="/home/{{ acme.user }}/.acme.sh/{{ gitlab.domain }}_ecc/{{ gitlab.domain }}.cer"
GITLAB_CERT_DIR="/etc/gitlab/ssl"

###############################################################################
#                                  Checks                                     #
###############################################################################

# check that the certificate files exist
if [ ! -f "${ACME_KEY_FILE}" ]; then
  echo "The key file does not exist"
  exit 1
fi
if [ ! -f "${ACME_FULLCHAIN_FILE}" ]; then
  echo "The fullchain file does not exist"
  exit 1
fi

# Check that the GitLab configuration directory exists
if [ ! -d "${GITLAB_CERT_DIR}" ]; then
  echo "The GitLab configuration directory does not exist"
  exit 1
fi

###############################################################################
#      Copy the SSL certificates to the GitLab configuration directory        #
###############################################################################

# Key
cp "${ACME_KEY_FILE}" "${GITLAB_CERT_DIR}/${{ gitlab.domain }}.key"
# Gitlab has root so we don't need to open this up at all.
chmod 600 "${GITLAB_CERT_DIR}/${{ gitlab.domain }}.key"

# Certificate
cp "${ACME_FULLCHAIN_FILE}" "${GITLAB_CERT_DIR}/${{ gitlab.domain }}.crt"
chmod 644 "${GITLAB_CERT_DIR}/${{ gitlab.domain }}.crt"

# Reload services
sudo gitlab-ctl hup nginx
sudo gitlab-ctl hup registry
