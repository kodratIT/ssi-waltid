#!/bin/bash

echo "=== Testing Connectivity between Services ==="
echo ""

# Test dari wallet-api ke verifier-api
echo "1. Testing wallet-api -> verifier-api (internal)"
docker compose exec wallet-api wget -O- --timeout=10 http://verifier-api:7003/health 2>&1 || echo "FAILED"
echo ""

# Test dari host ke verifier external URL
echo "2. Testing host -> verify.devlab.biz.id (external)"
curl -v --max-time 10 https://verify.devlab.biz.id/health 2>&1 || echo "FAILED"
echo ""

# Test dari wallet-api ke verifier external URL
echo "3. Testing wallet-api -> verify.devlab.biz.id (external via host)"
docker compose exec wallet-api wget -O- --timeout=10 https://verify.devlab.biz.id/health 2>&1 || echo "FAILED"
echo ""

echo "=== Test Complete ==="
