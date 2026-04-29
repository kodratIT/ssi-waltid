# Deployment Guide - devlab.biz.id SSI Stack

## Setup Manual DID:web via GitHub Pages

### 1. Setup GitHub Pages untuk DID Document

Lihat panduan lengkap di: `did-documents/README.md`

Ringkasan:
1. Buat repo `did-documents`
2. Struktur: `.well-known/did.json`
3. Copy `did-documents/issuer-did.json` ke repo
4. Enable GitHub Pages
5. Set custom domain: `devlab.biz.id`
6. DNS: CNAME `@` → `kodratit.github.io`

### 2. Update DID di Config

Setelah GitHub Pages aktif, update:
- `waltid-applications/waltid-web-portal/types/credentials.tsx` → ganti DID ke `did:web:devlab.biz.id`

### 3. Clone dan Deploy
```bash
git clone https://github.com/kodratIT/ssi-waltid.git
cd ssi-waltid/docker-compose
docker compose --profile identity up -d
```

### 4. Setup Nginx Proxy Manager
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

## DID Resolution

| DID | Resolve URL |
|-----|-------------|
| `did:web:devlab.biz.id` (issuer) | `https://devlab.biz.id/.well-known/did.json` |
| `did:web:devlab.biz.id:wallet-api:registry:<uuid>` (user) | `https://devlab.biz.id/wallet-api/registry/<uuid>/did.json` |

## Files

- `did-documents/issuer-did.json` - DID document public (host di GitHub Pages)
- `did-documents/issuer-private-key.json` - Private key (JANGAN commit ke GitHub!)
- `waltid-applications/waltid-web-portal/types/credentials.tsx` - Portal DID config
