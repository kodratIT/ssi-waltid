# Deployment Guide - devlab.biz.id SSI Stack

## Setup Awal (Sekali saja)

### 1. Clone dan Deploy
```bash
git clone https://github.com/kodratIT/ssi-waltid.git
cd ssi-waltid/docker-compose
docker compose --profile identity up -d
```

### 2. Setup Nginx Proxy Manager
Tambahkan proxy hosts berikut:

| Domain | Forward to | Port |
|--------|-----------|------|
| devlab.biz.id | docker-compose-caddy-1 | 7001 |
| wallet.devlab.biz.id | docker-compose-caddy-1 | 7101 |
| wallet-api.devlab.biz.id | docker-compose-caddy-1 | 7001 |
| issue.devlab.biz.id | docker-compose-caddy-1 | 7002 |
| verify.devlab.biz.id | docker-compose-caddy-1 | 7003 |
| portal.devlab.biz.id | docker-compose-caddy-1 | 7102 |
| vc.devlab.biz.id | docker-compose-caddy-1 | 7103 |

Enable SSL untuk semua.

### 3. Onboard Issuer (Sekali saja)
```bash
curl -X POST https://issue.devlab.biz.id/onboard/issuer \
  -H "Content-Type: application/json" \
  -d '{
    "key": {"backend": "jwk", "keyType": "secp256r1"},
    "did": {"method": "web", "config": {"domain": "devlab.biz.id", "path": "/wallet-api/registry/issuer"}}
  }'
```

Simpan response ke `config/issuer-hardcoded.json`.

## Rebuild Portal (Kalau ada perubahan DID)

```bash
cd ssi-waltid/waltid-applications/waltid-web-portal
# Edit types/credentials.tsx dengan DID baru
# Lalu build:
docker build -t waltid/portal:custom -f Dockerfile ../../
cd ../../docker-compose
docker compose --profile identity up -d
```

Atau pakai Docker Compose build:
```bash
cd docker-compose
docker compose --profile identity build web-portal
docker compose --profile identity up -d
```

## Endpoint API

| Service | URL |
|---------|-----|
| Wallet API | https://wallet-api.devlab.biz.id |
| Issuer API | https://issue.devlab.biz.id |
| Verifier API | https://verify.devlab.biz.id |
| Wallet UI | https://wallet.devlab.biz.id |
| Portal | https://portal.devlab.biz.id |

## Hardcoded Files

- `docker-compose/config/issuer-hardcoded.json` - Issuer DID & Key
- `waltid-applications/waltid-web-portal/types/credentials.tsx` - Portal DID config
