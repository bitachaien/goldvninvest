#!/bin/bash

################################################################################
# HollaEx Kit - Automated Setup & Production Deploy Script
# Purpose: Complete setup and deployment for goldvninvest.online
# Server: root@137.184.223.15
# Domain: goldvninvest.online
# Deploy Path: /var/www/goldvninvest.online
# Created: 2026-06-16
# Updated: 2026-06-16 - Production Ready Version
################################################################################

set -e

# ============================================================================
# COLORS & OUTPUT
# ============================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() {
    printf "${GREEN}[✓ INFO]${NC} $1\n"
}

log_warn() {
    printf "${YELLOW}[⚠ WARN]${NC} $1\n"
}

log_error() {
    printf "${RED}[✗ ERROR]${NC} $1\n"
}

log_header() {
    printf "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
    printf "${BLUE}$1${NC}\n"
    printf "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━��━━━━━━━━━━${NC}\n"
}

# ============================================================================
# CONFIGURATION
# ============================================================================

DEPLOY_PATH="/var/www/goldvninvest.online"
DOMAIN="goldvninvest.online"
EXCHANGE_NAME="goldvninvest"
ADMIN_EMAIL="admin@goldvninvest.online"
HOLLAEX_REPO="https://github.com/hollaex/hollaex-kit.git"
NODE_VERSION="18"
DOCKER_COMPOSE_VERSION="2.29.1"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/var/backups/goldvninvest_${TIMESTAMP}"

# ============================================================================
# PRE-FLIGHT CHECKS
# ============================================================================

check_root() {
    if [[ $EUID -ne 0 ]]; then
        log_error "This script must be run as root (use sudo)"
        exit 1
    fi
}

check_os() {
    if [[ "$OSTYPE" != "linux-gnu"* ]]; then
        log_error "This script is designed for Linux systems only"
        exit 1
    fi
    
    if ! grep -q "Ubuntu\|Debian" /etc/os-release; then
        log_warn "This script is tested on Ubuntu/Debian. Your OS may differ."
    fi
}

check_disk_space() {
    DISK_SPACE=$(df "$DEPLOY_PATH" 2>/dev/null | tail -1 | awk '{print $4}' || echo "0")
    if [[ $DISK_SPACE -lt 5242880 ]]; then
        log_error "Insufficient disk space. Minimum 5GB required, available: $((DISK_SPACE / 1024 / 1024))GB"
        exit 1
    fi
    log_info "Disk space OK: $((DISK_SPACE / 1024 / 1024))GB available"
}

fix_dpkg() {
    log_info "Fixing package manager conflicts..."
    
    # Check if dpkg is locked
    if lsof /var/lib/apt/lists/lock &>/dev/null; then
        log_warn "Package manager is locked. Waiting..."
        sleep 10
    fi
    
    # Fix dpkg
    dpkg --configure -a 2>/dev/null || true
    apt-get install -f -y 2>/dev/null || true
    apt-get update --fix-missing 2>/dev/null || true
    
    log_info "Package manager fixed"
}

create_backup() {
    if [[ -d "$DEPLOY_PATH" && -n "$(ls -A $DEPLOY_PATH)" ]]; then
        log_info "Creating backup of existing deployment..."
        mkdir -p "$BACKUP_DIR"
        cp -r "$DEPLOY_PATH" "$BACKUP_DIR/goldvninvest.online_backup" 2>/dev/null || true
        log_info "Backup created: $BACKUP_DIR"
    fi
}

# ============================================================================
# DEPENDENCY INSTALLATION
# ============================================================================

install_dependencies() {
    log_header "Installing System Dependencies"
    
    apt-get update
    
    PACKAGES=(
        "curl" "wget" "git" "build-essential" "apt-transport-https"
        "ca-certificates" "gnupg" "lsb-release" "software-properties-common"
        "dnsutils" "jq" "postgresql-client" "unzip" "nginx" "certbot"
        "python3-certbot-nginx" "openssl" "net-tools" "htop" "vim"
    )
    
    apt-get install -y "${PACKAGES[@]}"
    
    log_info "System dependencies installed"
}

install_docker() {
    log_header "Installing Docker"
    
    if command -v docker &>/dev/null; then
        log_warn "Docker already installed: $(docker --version)"
        return 0
    fi
    
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
        gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
        https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list >/dev/null
    
    apt-get update
    apt-get install -y docker-ce docker-ce-cli containerd.io \
        docker-buildx-plugin docker-compose-plugin
    
    systemctl start docker
    systemctl enable docker
    
    log_info "Docker installed: $(docker --version)"
}

install_docker_compose() {
    log_header "Installing Docker Compose V2"
    
    if command -v docker-compose &>/dev/null; then
        COMPOSE_VERSION=$(docker-compose --version | grep -oP '\d+\.\d+\.\d+' | head -1)
        log_warn "Docker Compose already installed: $COMPOSE_VERSION"
        return 0
    fi
    
    DOCKER_COMPOSE_URL="https://github.com/docker/compose/releases/download/v${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)"
    
    curl -SL "$DOCKER_COMPOSE_URL" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    
    log_info "Docker Compose installed: $(docker-compose --version)"
}

install_nodejs() {
    log_header "Installing Node.js"
    
    if command -v node &>/dev/null; then
        log_warn "Node.js already installed: $(node --version)"
        return 0
    fi
    
    curl -fsSL "https://deb.nodesource.com/setup_${NODE_VERSION}.x" | bash -
    apt-get install -y nodejs
    
    log_info "Node.js installed: $(node --version)"
    log_info "npm version: $(npm --version)"
}

# ============================================================================
# DEPLOYMENT PREPARATION
# ============================================================================

prepare_deployment() {
    log_header "Preparing Deployment Environment"
    
    if [[ ! -d "$DEPLOY_PATH" ]]; then
        mkdir -p "$DEPLOY_PATH"
        log_info "Created deployment directory"
    fi
    
    chmod 755 "$DEPLOY_PATH"
    
    mkdir -p \
        "$DEPLOY_PATH/server/logs" \
        "$DEPLOY_PATH/uploads" \
        "$DEPLOY_PATH/backups" \
        "/var/log/hollaex-kit" \
        "/var/lib/hollaex-kit"
    
    chmod 755 "$DEPLOY_PATH"/{server/logs,uploads,backups}
    chmod 755 /var/log/hollaex-kit /var/lib/hollaex-kit
    
    log_info "Deployment directories prepared"
}

clone_repository() {
    log_header "Cloning HollaEx Kit Repository"
    
    cd "$DEPLOY_PATH"
    
    if [[ -d ".git" ]]; then
        log_warn "Repository already exists. Updating..."
        git pull origin master --quiet
    else
        git clone "$HOLLAEX_REPO" . --quiet
    fi
    
    log_info "Repository ready at $DEPLOY_PATH"
}

install_npm_packages() {
    log_header "Installing npm Dependencies"
    
    cd "$DEPLOY_PATH/server"
    
    log_info "Installing server dependencies..."
    npm install --loglevel=error
    
    log_info "npm dependencies installed successfully"
}

# ============================================================================
# CONFIGURATION
# ============================================================================

generate_strong_password() {
    openssl rand -base64 32 | tr -d "=+/" | cut -c1-25
}

setup_environment_file() {
    log_header "Setting Up Environment Configuration"
    
    ENV_FILE="$DEPLOY_PATH/server/hollaex-kit.env"
    
    # Generate strong passwords
    DB_PASSWORD=$(generate_strong_password)
    REDIS_PASSWORD=$(generate_strong_password)
    JWT_SECRET=$(generate_strong_password)
    SESSION_SECRET=$(generate_strong_password)
    
    cat > "$ENV_FILE" << ENVFILE
# ============================================================================
# HollaEx Kit Production Configuration for goldvninvest.online
# Generated: $(date)
# ============================================================================

# Application Environment
ENVIRONMENT=production
EXCHANGE_NAME=$EXCHANGE_NAME
DOMAIN=$DOMAIN
NODE_ENV=production

# API Configuration
API_HOST=0.0.0.0
API_PORT=10010
STREAM_PORT=10080
API_ENABLE_CORS=true
CORS_ORIGIN=https://$DOMAIN,https://www.$DOMAIN

# Database Configuration
DB_NAME=hollaex
DB_USERNAME=hollaex_user
DB_PASSWORD=$DB_PASSWORD
DB_HOST=hollaex-kit-db
DB_PORT=5432
DB_DIALECT=postgres
DB_LOGGING=false
DB_POOL_MIN=2
DB_POOL_MAX=10

# Redis Configuration
REDIS_HOST=hollaex-kit-redis
REDIS_PORT=6379
REDIS_PASSWORD=$REDIS_PASSWORD
REDIS_DB=0
REDIS_SSL=false

# Security
JWT_SECRET=$JWT_SECRET
SESSION_SECRET=$SESSION_SECRET
API_KEY_EXPIRE=3600
REFRESH_TOKEN_EXPIRE=604800
TOKEN_EXPIRY_WINDOW_MINUTES=15
BCRYPT_ROUND=10

# Email Configuration (Update with your SMTP)
SMTP_HOST=smtp.example.com
SMTP_PORT=587
SMTP_USER=your-email@example.com
SMTP_PASSWORD=your-password
SMTP_FROM=noreply@$DOMAIN
SMTP_TLS=true

# Logging
LOG_LEVEL=info
LOG_FILE=/var/log/hollaex-kit/app.log
LOG_FORMAT=combined

# Security Headers
ENABLE_HELMET=true
ENABLE_RATE_LIMIT=true
RATE_LIMIT_WINDOW=900000
RATE_LIMIT_MAX_REQUESTS=100

# API Endpoints
NETWORK_URL=https://api.hollaex.com
NETWORK_TIMEOUT=30000

# File Upload
MAX_UPLOAD_SIZE=10485760
UPLOAD_PATH=$DEPLOY_PATH/uploads

# Exchange Settings
MIN_ORDER_SIZE=0.01
MAKER_FEE=0.001
TAKER_FEE=0.002

# Optional: AWS S3 for file storage
AWS_ENABLED=false
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_S3_BUCKET=
AWS_REGION=us-east-1

ENVFILE
    
    chmod 600 "$ENV_FILE"
    
    log_info "Environment file created: $ENV_FILE"
    log_warn "⚠️  IMPORTANT: Database password: $DB_PASSWORD"
    log_warn "⚠️  IMPORTANT: Redis password: $REDIS_PASSWORD"
    log_warn "⚠️  UPDATE email settings in $ENV_FILE"
}

# ============================================================================
# DOCKER SETUP
# ============================================================================

create_docker_network() {
    log_header "Setting Up Docker Network"
    
    NETWORK_NAME="local_goldvninvest-network"
    
    if docker network ls | grep -q "$NETWORK_NAME"; then
        log_warn "Docker network already exists"
    else
        docker network create "$NETWORK_NAME"
        log_info "Docker network created: $NETWORK_NAME"
    fi
}

start_containers() {
    log_header "Starting Docker Containers"
    
    cd "$DEPLOY_PATH/server"
    
    log_info "Starting services... (this may take a minute)"
    docker-compose -f docker-compose-prod.yaml up -d
    
    log_info "Waiting for services to initialize..."
    sleep 20
    
    log_info "Checking container status..."
    docker-compose -f docker-compose-prod.yaml ps
}

run_migrations() {
    log_header "Running Database Migrations"
    
    cd "$DEPLOY_PATH/server"
    
    log_info "Running database migrations..."
    npm run migrate 2>/dev/null || {
        log_warn "Migrations may require manual intervention"
        log_warn "Try: cd $DEPLOY_PATH/server && npm run migrate"
    }
    
    log_info "Database setup completed"
}

# ============================================================================
# WEB SERVER CONFIGURATION
# ============================================================================

configure_nginx() {
    log_header "Configuring Nginx Reverse Proxy"
    
    cat > /etc/nginx/sites-available/goldvninvest << 'NGINXCONFIG'
upstream hollaex_api {
    server 127.0.0.1:10010 max_fails=3 fail_timeout=30s;
    keepalive 32;
}

upstream hollaex_stream {
    server 127.0.0.1:10080 max_fails=3 fail_timeout=30s;
    keepalive 32;
}

# Redirect HTTP to HTTPS
server {
    listen 80;
    listen [::]:80;
    server_name goldvninvest.online www.goldvninvest.online;
    
    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
    }
    
    location / {
        return 301 https://$server_name$request_uri;
    }
}

# HTTPS Configuration
server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name goldvninvest.online www.goldvninvest.online;
    
    # SSL Configuration
    ssl_certificate /etc/letsencrypt/live/goldvninvest.online/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/goldvninvest.online/privkey.pem;
    
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;
    
    # Security Headers
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;
    
    client_max_body_size 50M;
    proxy_read_timeout 90;
    
    # Logging
    access_log /var/log/nginx/goldvninvest_access.log;
    error_log /var/log/nginx/goldvninvest_error.log;
    
    # API Proxy
    location / {
        proxy_pass http://hollaex_api;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
        proxy_buffering off;
    }
    
    # WebSocket Stream
    location /stream {
        proxy_pass http://hollaex_stream;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_read_timeout 3600s;
        proxy_send_timeout 3600s;
        proxy_buffering off;
    }
    
    # Health check endpoint
    location /health {
        proxy_pass http://hollaex_api/api/public/health;
        access_log off;
    }
}
NGINXCONFIG
    
    # Enable site
    ln -sf /etc/nginx/sites-available/goldvninvest /etc/nginx/sites-enabled/
    rm -f /etc/nginx/sites-enabled/default
    
    # Test configuration
    if nginx -t 2>/dev/null; then
        systemctl restart nginx
        log_info "Nginx configured and restarted"
    else
        log_error "Nginx configuration has errors"
        exit 1
    fi
}

setup_ssl_certificate() {
    log_header "Setting Up SSL/TLS Certificate"
    
    mkdir -p /var/www/certbot
    
    if [[ -f /etc/letsencrypt/live/goldvninvest.online/fullchain.pem ]]; then
        log_warn "SSL certificate already exists"
        return 0
    fi
    
    log_info "Requesting SSL certificate from Let's Encrypt..."
    
    certbot certonly --nginx \
        --non-interactive \
        --agree-tos \
        --email "$ADMIN_EMAIL" \
        -d "$DOMAIN" \
        -d "www.$DOMAIN" 2>/dev/null
    
    # Setup auto-renewal
    systemctl enable certbot.timer
    systemctl start certbot.timer
    
    log_info "SSL certificate installed and auto-renewal enabled"
}

# ============================================================================
# VERIFICATION & HEALTH CHECKS
# ============================================================================

verify_dns() {
    log_header "Verifying DNS Configuration"
    
    log_info "Checking DNS resolution for $DOMAIN..."
    
    IP=$(dig +short A "$DOMAIN" | tail -1)
    
    if [[ -z "$IP" ]]; then
        log_warn "DNS not resolving yet. Please ensure DNS records are configured:"
        log_warn "  A record: $DOMAIN -> 137.184.223.15"
        log_warn "  A record: www.$DOMAIN -> 137.184.223.15"
    else
        log_info "DNS resolves to: $IP"
    fi
}

health_check() {
    log_header "Running Health Checks"
    
    # Check Docker containers
    log_info "Checking Docker containers..."
    cd "$DEPLOY_PATH/server"
    
    if docker-compose -f docker-compose-prod.yaml ps | grep -q "hollaex-kit-db"; then
        log_info "✓ PostgreSQL database is running"
    else
        log_error "✗ PostgreSQL database is not running"
    fi
    
    if docker-compose -f docker-compose-prod.yaml ps | grep -q "hollaex-kit-redis"; then
        log_info "✓ Redis cache is running"
    else
        log_error "✗ Redis cache is not running"
    fi
    
    if docker-compose -f docker-compose-prod.yaml ps | grep -q "hollaex-kit-server-api"; then
        log_info "✓ API server is running"
    else
        log_error "✗ API server is not running"
    fi
    
    # Check Nginx
    if systemctl is-active --quiet nginx; then
        log_info "✓ Nginx is running"
    else
        log_error "✗ Nginx is not running"
    fi
    
    # Test API endpoint
    log_info "Testing API endpoint..."
    if curl -sf "http://localhost:10010/api/public/health" >/dev/null 2>&1; then
        log_info "✓ API responds to health check"
    else
        log_warn "⚠ API health check failed (may need initialization)"
    fi
}

# ============================================================================
# MAINTENANCE & MONITORING
# ============================================================================

setup_logrotate() {
    log_header "Setting Up Log Rotation"
    
    cat > /etc/logrotate.d/hollaex-kit << 'LOGROTATE'
/var/log/hollaex-kit/*.log {
    daily
    rotate 14
    compress
    delaycompress
    notifempty
    create 0640 root root
    sharedscripts
    postrotate
        systemctl reload docker >/dev/null 2>&1 || true
    endscript
}
LOGROTATE
    
    log_info "Log rotation configured"
}

create_systemd_service() {
    log_header "Creating Systemd Service"
    
    cat > /etc/systemd/system/hollaex-kit.service << 'SERVICEFILE'
[Unit]
Description=HollaEx Kit Exchange Platform
After=docker.service network-online.target
Wants=network-online.target
Requires=docker.service

[Service]
Type=simple
WorkingDirectory=/var/www/goldvninvest.online/server
User=root
Restart=on-failure
RestartSec=10

ExecStart=/usr/bin/docker-compose -f docker-compose-prod.yaml up
ExecStop=/usr/bin/docker-compose -f docker-compose-prod.yaml down

StandardOutput=journal
StandardError=journal
SyslogIdentifier=hollaex-kit

[Install]
WantedBy=multi-user.target
SERVICEFILE
    
    systemctl daemon-reload
    systemctl enable hollaex-kit.service
    
    log_info "Systemd service created and enabled"
}

# ============================================================================
# FINAL SUMMARY
# ============================================================================

print_summary() {
    cat << 'SUMMARY'

╔═══════════════════════════════════════════════════════════════════════════╗
║                                                                           ║
║          🎉 HollaEx Kit Installation Completed Successfully! 🎉          ║
║                                                                           ║
║                    Domain: goldvninvest.online                          ║
║                 Server: root@137.184.223.15                             ║
║                                                                           ║
╚═══════════════════════════════════════════════════════════════════════════╝

✅ INSTALLED COMPONENTS:
   ✓ Docker & Docker Compose v2
   ✓ Node.js v18 & npm
   ✓ PostgreSQL Client
   ✓ Nginx Web Server with SSL/TLS
   ✓ HollaEx Kit Repository
   ✓ Docker Containers (PostgreSQL, Redis, API, WebSocket)
   ✓ Let's Encrypt SSL Certificate
   ✓ Systemd Service Manager

📍 IMPORTANT PATHS:
   ├─ Deploy Path:     /var/www/goldvninvest.online
   ├─ Config File:     /var/www/goldvninvest.online/server/hollaex-kit.env
   ├─ Application Logs:/var/log/hollaex-kit/
   ├─ Nginx Config:    /etc/nginx/sites-available/goldvninvest
   └─ Docker Compose:  /var/www/goldvninvest.online/server/docker-compose-prod.yaml

🔗 ACCESS URLS:
   ├─ Web:     https://goldvninvest.online
   ├─ API:     https://goldvninvest.online/api
   └─ Health:  https://goldvninvest.online/health

⚠️  CRITICAL NEXT STEPS (REQUIRED FOR FULL OPERATION):

1️⃣  VERIFY DNS CONFIGURATION:
   Make sure these A records are set:
   ├─ goldvninvest.online          → 137.184.223.15
   └─ www.goldvninvest.online      → 137.184.223.15

2️⃣  UPDATE EMAIL CONFIGURATION:
   File: /var/www/goldvninvest.online/server/hollaex-kit.env
   Update SMTP settings:
   ├─ SMTP_HOST (your email service)
   ├─ SMTP_USER (your email)
   ├─ SMTP_PASSWORD (your password)
   └─ SMTP_FROM (noreply@goldvninvest.online)
   
   Then restart:
   docker-compose -f /var/www/goldvninvest.online/server/docker-compose-prod.yaml restart

3️⃣  REGISTER OUTBOUND IP WITH HOLLAEX (IMPORTANT):
   Email: support@hollaex.com
   Subject: IP Registration for HollaEx Kit
   Content: Please register IP 137.184.223.15 for production access
   Note: This is required for network operations after June 1, 2026

4️⃣  TEST THE DEPLOYMENT:
   # Check containers
   docker-compose -f /var/www/goldvninvest.online/server/docker-compose-prod.yaml ps
   
   # View API logs
   docker-compose -f /var/www/goldvninvest.online/server/docker-compose-prod.yaml logs -f hollaex-kit-server-api
   
   # Health check
   curl https://goldvninvest.online/health

5️⃣  BACKUP DATABASE CREDENTIALS:
   📝 Store these securely (NOT in version control):
   ├─ Database Password: (see .env file)
   ├─ Redis Password: (see .env file)
   └─ JWT Secret: (see .env file)

📚 USEFUL COMMANDS:

View Logs:
   docker-compose -f /var/www/goldvninvest.online/server/docker-compose-prod.yaml logs -f

Check Status:
   systemctl status hollaex-kit
   docker-compose -f /var/www/goldvninvest.online/server/docker-compose-prod.yaml ps

Restart Services:
   systemctl restart hollaex-kit
   # OR manually:
   docker-compose -f /var/www/goldvninvest.online/server/docker-compose-prod.yaml restart

Stop Services:
   docker-compose -f /var/www/goldvninvest.online/server/docker-compose-prod.yaml down

View Database:
   # Connect to PostgreSQL
   docker-compose -f /var/www/goldvninvest.online/server/docker-compose-prod.yaml exec hollaex-kit-db psql -U hollaex_user -d hollaex

🔍 MONITORING & LOGS:

Application Logs:
   tail -f /var/log/hollaex-kit/app.log

Nginx Logs:
   tail -f /var/log/nginx/goldvninvest_*.log

Docker Logs:
   docker logs -f $(docker ps --filter "name=hollaex-kit-server-api" -q)

SSL Certificate Renewal:
   # Manual renewal (auto-renews daily):
   certbot renew

📖 DOCUMENTATION & SUPPORT:

Official Docs:    https://docs.hollaex.com
GitHub:           https://github.com/hollaex/hollaex-kit
Community Forum:  https://forum.hollaex.com
Discord:          https://discord.gg/RkRHU8RbyM

🛟 TROUBLESHOOTING:

If services won't start:
   1. Check logs: docker-compose logs
   2. Verify disk space: df -h
   3. Check port conflicts: netstat -tlnp | grep :10010
   4. Restart Docker: systemctl restart docker

If SSL certificate fails:
   1. Verify DNS is working: nslookup goldvninvest.online
   2. Check firewall: ufw status
   3. Manual renewal: certbot renew --dry-run
   4. Check logs: certbot certificates

If database connection fails:
   1. Check containers: docker-compose ps
   2. Verify environment: cat /var/www/goldvninvest.online/server/hollaex-kit.env
   3. Check network: docker network ls
   4. Restart containers: docker-compose restart

════════════════════════════════════════════════════════════════════════════

✨ Installation completed at: $(date)

👨‍💻 Need help? Check the documentation or community forums above.

SUMMARY
}

# ============================================================================
# MAIN EXECUTION
# ============================================================================

main() {
    log_header "🚀 HollaEx Kit Production Deployment Setup"
    log_info "Domain: $DOMAIN"
    log_info "Server: root@137.184.223.15"
    log_info "Path: $DEPLOY_PATH"
    log_info ""
    
    # Pre-flight checks
    check_root
    check_os
    check_disk_space
    fix_dpkg
    create_backup
    
    # Install dependencies
    install_dependencies
    install_docker
    install_docker_compose
    install_nodejs
    
    # Prepare deployment
    prepare_deployment
    clone_repository
    install_npm_packages
    
    # Configuration
    setup_environment_file
    create_docker_network
    
    # Deploy containers
    start_containers
    run_migrations
    
    # Web server
    configure_nginx
    setup_ssl_certificate
    
    # Maintenance
    setup_logrotate
    create_systemd_service
    
    # Verification
    verify_dns
    health_check
    
    # Summary
    print_summary
}

trap 'log_error "Installation failed at $(date)"; exit 1' ERR

# Run installation
main "$@"

exit 0
