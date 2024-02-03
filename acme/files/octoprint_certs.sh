#!/usr/bin/env bash
# set bash strict mode
set -euo pipefail
IFS=$'\n\t'

OCTOPRINT_CERT_DIR="{{ octoprint.cert_dir }}"
OCTOPRINT_DOMAIN="{{ octoprint.domain }}"
ACME_KEY_FILE="/home/{{ acme.user }}/.acme.sh/${OCTOPRINT_DOMAIN}_ecc/${OCTOPRINT_DOMAIN}.key"
ACME_FULLCHAIN_FILE="/home/{{ acme.user }}/.acme.sh/${OCTOPRINT_DOMAIN}_ecc/fullchain.cer"
ACME_CERT_FILE="/home/{{ acme.user }}/.acme.sh/${OCTOPRINT_DOMAIN}_ecc/${OCTOPRINT_DOMAIN}.cer"

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

# Check that the certificate directory exists
if [ ! -d "${OCTOPRINT_CERT_DIR}" ]; then
  echo "The certificate directory does not exist"
  exit 1
fi

###############################################################################
#      Copy the SSL certificates to the Octoprint certificate directory       #
###############################################################################

# Key
echo "Copying the SSL certificates to the Octoprint configuration directory..."
cp "${ACME_KEY_FILE}" "${OCTOPRINT_CERT_DIR}/${OCTOPRINT_DOMAIN}.key"
#  has root so we don't need to open this up at all.
chmod 600 "${OCTOPRINT_CERT_DIR}/${OCTOPRINT_DOMAIN}.key"

# Copy the full chain
cp "${ACME_FULLCHAIN_FILE}" "${OCTOPRINT_CERT_DIR}/${OCTOPRINT_DOMAIN}.crt"
chmod 644 "${OCTOPRINT_CERT_DIR}/${OCTOPRINT_DOMAIN}.crt"

# Reload services
echo "Reloading the nginx service..."
sudo systemctl reload nginx