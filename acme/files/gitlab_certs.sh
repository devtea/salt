#!/usr/bin/env bash
# set bash strict mode
set -euo pipefail
IFS=$'\n\t'

GITLAB_CERT_DIR="/etc/gitlab/ssl"
GITLAB_DOMAIN="{{ gitlab.domain }}"
ACME_KEY_FILE="/home/{{ acme.user }}/.acme.sh/${GITLAB_DOMAIN}_ecc/${GITLAB_DOMAIN}.key"
ACME_FULLCHAIN_FILE="/home/{{ acme.user }}/.acme.sh/${GITLAB_DOMAIN}_ecc/fullchain.cer"
ACME_CERT_FILE="/home/{{ acme.user }}/.acme.sh/${GITLAB_DOMAIN}_ecc/${GITLAB_DOMAIN}.cer"

###############################################################################
#                                  Checks                                     #
###############################################################################
echo "Running checks..."

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
echo "Copying the SSL certificates to the GitLab configuration directory..."
cp "${ACME_KEY_FILE}" "${GITLAB_CERT_DIR}/${GITLAB_DOMAIN}.key"
# Gitlab has root so we don't need to open this up at all.
chmod 600 "${GITLAB_CERT_DIR}/${GITLAB_DOMAIN}.key"

# Certificate
cp "${ACME_FULLCHAIN_FILE}" "${GITLAB_CERT_DIR}/${GITLAB_DOMAIN}.crt"
chmod 644 "${GITLAB_CERT_DIR}/${GITLAB_DOMAIN}.crt"

# Reload services
echo "Reloading the GitLab web services..."
sudo gitlab-ctl hup nginx
sudo gitlab-ctl hup registry