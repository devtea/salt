#!/usr/bin/env bash
# set bash strict mode
set -euo pipefail
IFS=$'\n\t'

CONTAINERD_CERT_DIR="{{ containerd.cert_dir }}"
CONTAINERD_SERVICE_DOMAIN="{{ containerd['services_conf'][service]['domain'] }}"
ACME_KEY_FILE="/home/{{ acme.user }}/.acme.sh/${CONTAINERD_SERVICE_DOMAIN}_ecc/${CONTAINERD_SERVICE_DOMAIN}.key"
ACME_FULLCHAIN_FILE="/home/{{ acme.user }}/.acme.sh/${CONTAINERD_SERVICE_DOMAIN}_ecc/fullchain.cer"
ACME_CERT_FILE="/home/{{ acme.user }}/.acme.sh/${CONTAINERD_SERVICE_DOMAIN}_ecc/${CONTAINERD_SERVICE_DOMAIN}.cer"

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
if [ ! -d "${CONTAINERD_CERT_DIR}" ]; then
  echo "The certificate directory does not exist"
  exit 1
fi

###############################################################################
#      Copy the SSL certificates to the containerd.certificate directory       #
###############################################################################

# Key
echo "Copying the SSL certificates to the containerd configuration directory..."
cp "${ACME_KEY_FILE}" "${CONTAINERD_CERT_DIR}/${CONTAINERD_SERVICE_DOMAIN}.key"
#  has root so we don't need to open this up at all.
chmod 600 "${CONTAINERD_CERT_DIR}/${CONTAINERD_SERVICE_DOMAIN}.key"

# Copy the full chain
cp "${ACME_FULLCHAIN_FILE}" "${CONTAINERD_CERT_DIR}/${CONTAINERD_SERVICE_DOMAIN}.crt"
chmod 644 "${CONTAINERD_CERT_DIR}/${CONTAINERD_SERVICE_DOMAIN}.crt"

# Reload services
echo "Reloading the nginx service..."
sudo systemctl reload nginx