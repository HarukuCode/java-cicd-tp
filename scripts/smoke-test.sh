#!/bin/sh
set -eu
image="${1:?Usage : sh scripts/smoke-test.sh IMAGE}"
container="java-smoke-$$"
cleanup() {
  docker logs "$container" || true
  docker rm -f "$container" >/dev/null 2>&1 || true
}
trap cleanup EXIT
docker run -d --name "$container" "$image" >/dev/null
attempt=0
until docker exec "$container" wget -T 2 -qO- http://127.0.0.1:8080/health | grep -qx 'OK'; do
  attempt=$((attempt + 1))
  if [ "$attempt" -ge 30 ]; then
    echo "ÉCHEC : l'application n'est pas prête après 30 tentatives."
    exit 1
  fi
  sleep 1
done
docker exec "$container" wget -T 2 -qO- http://127.0.0.1:8080/ \
  | grep -q 'Bonjour Docker et GitLab CI'
echo "SUCCÈS : l'image démarre et répond en HTTP."
