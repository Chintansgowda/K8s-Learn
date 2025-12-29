#!/bin/bash

# Exit when any command fails
set -e
set -o pipefail

echo "🚀 Starting installation of Docker, Kind, and kubectl..."

# ----------------------------
# 1. Install Docker
# ----------------------------
if ! command -v docker &>/dev/null; then
  echo "📦 Installing Docker..."
  sudo apt-get update -y
  sudo apt-get install -y docker.io

  echo "👤 Adding current user to docker group..."
  sudo usermod -aG docker "$USER"

  echo "🔄 You may need to log out and log back in for docker group changes to apply."
  echo "✅ Docker installed and user added to docker group."
else
  echo "✅ Docker is already installed."
fi

# ----------------------------
# 2. Install Kind (based on architecture)
# ----------------------------
if ! command -v kind &>/dev/null; then
  echo "📦 Installing Kind..."

  ARCH=$(uname -m)
  case "$ARCH" in
    x86_64)
      curl -Lo kind https://kind.sigs.k8s.io/dl/v0.29.0/kind-linux-amd64
      ;;
    aarch64|arm64)
      curl -Lo kind https://kind.sigs.k8s.io/dl/v0.29.0/kind-linux-arm64
      ;;
    *)
      echo "❌ Unsupported architecture: $ARCH"
      exit 1
      ;;
  esac

  chmod +x kind
  sudo mv kind /usr/local/bin/kind
  echo "✅ Kind installed successfully."
else
  echo "✅ Kind is already installed."
fi

# ----------------------------
# 3. Install kubectl (latest stable)
# ----------------------------
if ! command -v kubectl &>/dev/null; then
  echo "📦 Installing kubectl (latest stable version)..."

  VERSION=$(curl -Ls https://dl.k8s.io/release/stable.txt)
  ARCH=$(uname -m)

  case "$ARCH" in
    x86_64)
      curl -Lo kubectl "https://dl.k8s.io/release/${VERSION}/bin/linux/amd64/kubectl"
      ;;
    aarch64|arm64)
      curl -Lo kubectl "https://dl.k8s.io/release/${VERSION}/bin/linux/arm64/kubectl"
      ;;
    *)
      echo "❌ Unsupported architecture: $ARCH"
      exit 1
      ;;
  esac

  chmod +x kubectl
  sudo mv kubectl /usr/local/bin/kubectl
  echo "✅ kubectl installed successfully."
else
  echo "✅ kubectl is already installed."
fi

# ----------------------------
# 4. Confirm Versions
# ----------------------------
echo
echo "🔍 Installed Versions:"
docker --version || echo "Docker not available in current session."
kind --version
kubectl version --client --output=yaml

echo
echo "🎉 Docker, Kind, and kubectl installation complete!"

