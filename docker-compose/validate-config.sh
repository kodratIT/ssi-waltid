#!/bin/bash

echo "=== Validating Docker Compose Configuration ==="
echo ""

# Check if docker-compose.yaml is valid
echo "1. Validating docker-compose.yaml syntax..."
docker compose config > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅ docker-compose.yaml is valid"
else
    echo "❌ docker-compose.yaml has syntax errors"
    docker compose config
    exit 1
fi
echo ""

# Check if .env file exists and has required variables
echo "2. Checking .env file..."
if [ -f .env ]; then
    echo "✅ .env file exists"
    
    # Check required variables
    required_vars=("SERVICE_HOST" "WALLET_BACKEND_PORT" "ISSUER_API_PORT" "VERIFIER_API_PORT" "DATABASE_ENGINE")
    for var in "${required_vars[@]}"; do
        if grep -q "^${var}=" .env; then
            value=$(grep "^${var}=" .env | cut -d'=' -f2)
            echo "  ✅ $var = $value"
        else
            echo "  ❌ $var is missing"
        fi
    done
else
    echo "❌ .env file not found"
    exit 1
fi
echo ""

# Check if Caddyfile exists
echo "3. Checking Caddyfile..."
if [ -f Caddyfile ]; then
    echo "✅ Caddyfile exists"
    
    # Check for timeout configuration
    if grep -q "timeout" Caddyfile; then
        echo "  ✅ Timeout configuration found in Caddyfile"
    else
        echo "  ⚠️  No timeout configuration in Caddyfile"
    fi
else
    echo "❌ Caddyfile not found"
fi
echo ""

# Check wallet-api config
echo "4. Checking wallet-api configuration..."
if [ -d wallet-api/config ]; then
    echo "✅ wallet-api/config directory exists"
    
    config_files=("web.conf" "db.conf" "auth.conf" "http-client.conf")
    for file in "${config_files[@]}"; do
        if [ -f "wallet-api/config/$file" ]; then
            echo "  ✅ $file exists"
        else
            echo "  ⚠️  $file not found"
        fi
    done
else
    echo "❌ wallet-api/config directory not found"
fi
echo ""

# Check verifier-api config
echo "5. Checking verifier-api configuration..."
if [ -d verifier-api/config ]; then
    echo "✅ verifier-api/config directory exists"
    
    if [ -f "verifier-api/config/verifier-service.conf" ]; then
        baseUrl=$(grep "^baseUrl" verifier-api/config/verifier-service.conf | cut -d'=' -f2 | tr -d ' "')
        echo "  ✅ verifier-service.conf exists"
        echo "  📍 baseUrl = $baseUrl"
    else
        echo "  ❌ verifier-service.conf not found"
    fi
else
    echo "❌ verifier-api/config directory not found"
fi
echo ""

# Check network configuration
echo "6. Checking network configuration..."
if docker compose config | grep -q "networks:"; then
    echo "✅ Network configuration found"
    docker compose config | grep -A 5 "networks:" | head -10
else
    echo "⚠️  No explicit network configuration"
fi
echo ""

echo "=== Validation Complete ==="
echo ""
echo "Next steps:"
echo "1. Review any warnings or errors above"
echo "2. Run: docker compose down -v"
echo "3. Run: docker compose up -d"
echo "4. Run: ./debug-timeout.sh"
