#!/usr/bin/env bash
set -euo pipefail

# Ir a la raíz del repo (.. desde /scripts)
cd "$(dirname "$0")/.."

# --- Config ---
# Cambia ACR_NAME al que uses cada vez, o ejecútalo así:
# ACR_NAME="tuacr" ./scripts/push_images_to_acr.sh
ACR_NAME="${ACR_NAME:-acrcp2izan12345}"

# Imagen para la VM (Podman): repositorio/carpeta y tag requeridos por el caso
VM_SRC_IMAGE="${VM_SRC_IMAGE:-docker.io/library/nginx:latest}"
VM_DEST_REPO="${VM_DEST_REPO:-web/nginx}"
VM_DEST_TAG="${VM_DEST_TAG:-casopractico2}"

# --- Helpers ---
tf_out() {
  terraform -chdir=terraform output -raw "$1"
}

echo "[*] Using ACR_NAME=${ACR_NAME}"

# --- Obtener login server y user desde Terraform ---
# Si no existe el output (por lo que sea), hacemos fallback a <acr>.azurecr.io
ACR_LOGIN_SERVER="$(tf_out acr_login_server 2>/dev/null || true)"
if [[ -z "${ACR_LOGIN_SERVER}" ]]; then
  ACR_LOGIN_SERVER="${ACR_NAME}.azurecr.io"
fi

ACR_USER="$(tf_out acr_admin_username)"

echo "[*] ACR_LOGIN_SERVER=${ACR_LOGIN_SERVER}"
echo "[*] ACR_USER=${ACR_USER}"

# --- Obtener password del ACR via Azure CLI ---
# Esto consulta a Azure y devuelve la password admin actual.
echo "[*] Getting ACR password via az..."
ACR_PASS="$(az acr credential show -n "${ACR_NAME}" --query "passwords[0].value" -o tsv)"

# --- Login con Podman ---
# Guarda auth en ~/.config/containers/auth.json para futuros push/pull
echo "[*] Podman login..."
podman login "${ACR_LOGIN_SERVER}" -u "${ACR_USER}" -p "${ACR_PASS}" >/dev/null
echo "[+] Login OK"

# --- Pull -> Tag -> Push (VM image) ---
echo "[*] Pulling source image: ${VM_SRC_IMAGE}"
podman pull "${VM_SRC_IMAGE}"

DEST_IMAGE="${ACR_LOGIN_SERVER}/${VM_DEST_REPO}:${VM_DEST_TAG}"
echo "[*] Tagging -> ${DEST_IMAGE}"
podman tag "${VM_SRC_IMAGE}" "${DEST_IMAGE}"

echo "[*] Pushing -> ${DEST_IMAGE}"
podman push "${DEST_IMAGE}"
echo "[+] Push OK"

# --- Verificar repositorios en ACR ---
echo "[*] Repositories in ACR:"
az acr repository list -n "${ACR_NAME}" -o table

echo "[+] Done."