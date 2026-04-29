#!/bin/bash

echo "=== Debugging Wallet Verification Timeout Issue ==="
echo ""

# Check if services are running
echo "1. Checking running services..."
docker compose ps
echo ""

# Check wallet-api logs
echo "2. Checking wallet-api logs (last 50 lines)..."
docker compose logs --tail=50 wallet-api | grep -i "timeout\|error\|exception" || echo "No timeout errors in recent logs"
echo ""

# Check verifier-api logs
echo "3. Checking verifier-api logs (last 50 lines)..."
docker compose logs --tail=50 verifier-api | grep -i "timeout\|error\|exception" || echo "No timeout errors in recent logs"
echo ""

# Test network connectivity
echo "4. Testing network connectivity from wallet-api..."
docker compose exec wallet-api sh -c "ping -c 3 verifier-api" 2>&1 || echo "Ping failed"
echo ""

# Check DNS resolution
echo "5. Testing DNS resolution from wallet-api..."
docker compose exec wallet-api sh -c "nslookup verify.devlab.biz.id" 2>&1 || echo "DNS resolution failed"
echo ""

# Test HTTP connection with timeout
echo "6. Testing HTTP connection with curl (30s timeout)..."
docker compose exec wallet-api sh -c "curl -v --max-time 30 https://verify.devlab.biz.id/health" 2>&1 || echo "HTTP connection failed"
echo ""

echo "=== Debug Complete ==="
echo ""
echo "Common fixes:"
echo "1. Restart services: docker compose restart"
echo "2. Check if verify.devlab.biz.id is accessible from your network"
echo "3. Increase timeout values in Caddyfile"
echo "4. Check firewall/network policies"
