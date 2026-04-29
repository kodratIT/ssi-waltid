# DID Document Hosting via GitHub Pages

## Setup Manual DID:web

### 1. Buat GitHub Repository untuk DID Documents

```bash
mkdir did-documents
cd did-documents
git init
```

### 2. Struktur Folder

```
did-documents/
└── .well-known/
    └── did.json
```

### 3. Copy DID Document

```bash
mkdir -p .well-known
cp ../ssi-waltid/did-documents/issuer-did.json .well-known/did.json
```

### 4. Push ke GitHub

```bash
git add .
git commit -m "Add DID document"
git remote add origin https://github.com/kodratIT/did-documents.git
git push -u origin main
```

### 5. Enable GitHub Pages

1. Buka repository `kodratit/did-documents` di GitHub
2. Settings → Pages
3. Source: Deploy from a branch → `main` → `/ (root)`
4. Save

### 6. Verify DID Resolution

```bash
# Test dari GitHub Pages
curl https://kodratit.github.io/.well-known/did.json

# Test resolver (harus return DID document)
curl https://kodratit.github.io/.well-known/did.json | jq .
```

### 7. DID Configuration

- DID: `did:web:kodratit.github.io`
- Resolve URL: `https://kodratit.github.io/.well-known/did.json`

## Private Key Management

Private key tersimpan di:
- `did-documents/issuer-private-key.json` → Mount ke docker-compose sebagai secret

**PENTING**: Jangan commit private key ke GitHub! Tambahkan ke `.gitignore`.
