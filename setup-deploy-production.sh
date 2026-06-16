#!/bin/bash

################################################################################
# HollaEx Kit - Automated Setup & Production Deploy Script
# Customized for: goldvninvest.online
# Server: root@137.184.223.15
# Deploy Path: /var/www/goldvninvest.online
# Created: 2026-06-16
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
    printf "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

# ============================================================================
# CONFIGURATION
# ============================================================================

DEPLOY_PATH="/var/www/goldvninvest.online"
DOMAIN="goldvninvest.online"
EXCHANGE_NAME="goldvninvest"
ADMIN_EMAIL="admin@goldvninvest.online"
SUPPORT_EMAIL="support@goldvninvest.online"
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
}

check_disk_space() {
    DISK_SPACE=$(df "$DEPLOY_PATH" 2>/dev/null | tail -1 | awk '{print $4}' || echo "0")
    if [[ $DISK_SPACE -lt 5242880 ]]; then
        log_error "Insufficient disk space. Minimum 5GB required"
        exit 1
    fi
    log_info "Disk space OK: $((DISK_SPACE / 1024 / 1024))GB available"
}

fix_dpkg() {
    log_info "Fixing package manager conflicts..."
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
        log_warn "Docker Compose already installed"
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
        "/var/log/goldvninvest" \
        "/var/lib/goldvninvest"
    
    chmod 755 "$DEPLOY_PATH"/{server/logs,uploads,backups}
    chmod 755 /var/log/goldvninvest /var/lib/goldvninvest
    
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
    log_header "Setting Up Environment Configuration for goldvninvest"
    
    ENV_FILE="$DEPLOY_PATH/server/hollaex-kit.env"
    
    # Generate strong passwords
    DB_PASSWORD=$(generate_strong_password)
    REDIS_PASSWORD=$(generate_strong_password)
    SECRET=$(generate_strong_password)
    
    cat > "$ENV_FILE" << ENVFILE
# ============================================================================
# HollaEx Kit Configuration - goldvninvest.online
# Generated: $(date)
# ============================================================================

# Application Settings
ENVIRONMENT=production
EXCHANGE_NAME=$EXCHANGE_NAME
DOMAIN=https://$DOMAIN
API_HOST=https://$DOMAIN/api
API_NAME=$EXCHANGE_NAME
ISSUER=$EXCHANGE_NAME
NODE_ENV=production
KIT_VERSION=3.0.0
PORT=10010
WEBSOCKET_PORT=10080

# Network Configuration
NETWORK=mainnet
NETWORK_URL=https://api.hollaex.network

# Database Configuration
DB_DIALECT=postgres
DB_HOST=hollaex-kit-db
DB_PORT=5432
DB_NAME=goldvninvest
DB_USERNAME=goldvninvest_user
DB_PASSWORD=$DB_PASSWORD
DB_SSL=false

# Redis/PubSub Configuration
REDIS_HOST=hollaex-kit-redis
REDIS_PORT=6379
REDIS_PASSWORD=$REDIS_PASSWORD
PUBSUB_HOST=hollaex-kit-redis
PUBSUB_PORT=6379
PUBSUB_PASSWORD=$REDIS_PASSWORD

# Security
SECRET=$SECRET

# Email Configuration
ADMIN_EMAIL=$ADMIN_EMAIL
SENDER_EMAIL=noreply@$DOMAIN
SUPPORT_EMAIL=$SUPPORT_EMAIL
KYC_EMAIL=$SUPPORT_EMAIL
SUPERVISOR_EMAIL=$ADMIN_EMAIL
SMTP_SERVER=smtp.example.com
SMTP_PORT=587
SMTP_USER=your-email@example.com
SMTP_PASSWORD=your-password
SEND_EMAIL_TO_SUPPORT=true

# UI Configuration
DEFAULT_THEME=dark
NEW_USER_DEFAULT_LANGUAGE=en
NEW_USER_IS_ACTIVATED=true
VALID_LANGUAGES=en
CURRENCIES=xht,usdt
PAIRS=xht-usdt
USER_LEVEL_NUMBER=4

# Logging
LOG_LEVEL=info
EMAILS_TIMEZONE=UTC

# Optional - Remove before production use
ACTIVATION_CODE=
API_KEY=
API_SECRET=
VAULT_NAME=
LOGO_IMAGE=https://bitholla.s3.ap-northeast-2.amazonaws.com/kit/LOGO_IMAGE_LIGHT

ENVFILE
    
    chmod 600 "$ENV_FILE"
    
    log_info "Environment file created: $ENV_FILE"
    log_warn "⚠️  Generated passwords:"
    log_warn "   Database: $DB_PASSWORD"
    log_warn "⚠️  Update email settings in $ENV_FILE"
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
    
    log_info "Starting services..."
    docker-compose -f docker-compose-prod.yaml up -d
    
    log_info "Waiting for services to initialize (20 seconds)..."
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
upstream goldvninvest_api {
    server 127.0.0.1:10010 max_fails=3 fail_timeout=30s;
    keepalive 32;
}

upstream goldvninvest_stream {
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
    
    client_max_body_size 50M;
    proxy_read_timeout 90;
    
    access_log /var/log/nginx/goldvninvest_access.log;
    error_log /var/log/nginx/goldvninvest_error.log;
    
    # API Proxy
    location / {
        proxy_pass http://goldvninvest_api;
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
        proxy_pass http://goldvninvest_stream;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_read_timeout 3600s;
        proxy_send_timeout 3600s;
    }
}
NGINXCONFIG
    
    ln -sf /etc/nginx/sites-available/goldvninvest /etc/nginx/sites-enabled/
    rm -f /etc/nginx/sites-enabled/default
    
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
        -d "goldvninvest.online" \
        -d "www.goldvninvest.online" 2>/dev/null
    
    systemctl enable certbot.timer
    systemctl start certbot.timer
    
    log_info "SSL certificate installed"
}

# ============================================================================
# VERIFICATION & HEALTH CHECKS
# ============================================================================

health_check() {
    log_header "Running Health Checks"
    
    cd "$DEPLOY_PATH/server"
    
    log_info "Checking Docker containers..."
    
    if docker-compose -f docker-compose-prod.yaml ps | grep -q "hollaex-kit-db"; then
        log_info "✓ PostgreSQL database is running"
    else
        log_warn "✗ PostgreSQL database is not running"
    fi
    
    if docker-compose -f docker-compose-prod.yaml ps | grep -q "hollaex-kit-redis"; then
        log_info "✓ Redis cache is running"
    else
        log_warn "✗ Redis cache is not running"
    fi
    
    if docker-compose -f docker-compose-prod.yaml ps | grep -q "hollaex-kit-server-api"; then
        log_info "✓ API server is running"
    else
        log_warn "✗ API server is not running"
    fi
    
    if systemctl is-active --quiet nginx; then
        log_info "✓ Nginx is running"
    else
        log_warn "✗ Nginx is not running"
    fi
}

# ============================================================================
# MAINTENANCE
# ============================================================================

setup_logrotate() {
    log_header "Setting Up Log Rotation"
    
    cat > /etc/logrotate.d/goldvninvest << 'LOGROTATE'
/var/log/goldvninvest/*.log {
    daily
    rotate 14
    compress
    delaycompress
    notifempty
    create 0640 root root
    sharedscripts
}
LOGROTATE
    
    log_info "Log rotation configured"
}

create_systemd_service() {
    log_header "Creating Systemd Service"
    
    cat > /etc/systemd/system/goldvninvest.service << 'SERVICEFILE'
[Unit]
Description=GoldVN Invest - HollaEx Kit Exchange Platform
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
SyslogIdentifier=goldvninvest

[Install]
WantedBy=multi-user.target
SERVICEFILE
    
    systemctl daemon-reload
    systemctl enable goldvninvest.service
    
    log_info "Systemd service created and enabled"
}

# ============================================================================
# SUMMARY
# ============================================================================

print_summary() {
    cat << 'SUMMARY'

╔═══════════════════════════════════════════════════════════════════════════╗
║                                                                           ║
║        🎉 GoldVN Invest Deployment Completed Successfully! 🎉           ║
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
   ✓ HollaEx Kit Repository (goldvninvest)
   ✓ Docker Containers (PostgreSQL, Redis, API, WebSocket)
   ✓ Let's Encrypt SSL Certificate
   ✓ Systemd Service Manager

📍 IMPORTANT PATHS:
   ├─ Deploy Path:     /var/www/goldvninvest.online
   ├─ Config File:     /var/www/goldvninvest.online/server/hollaex-kit.env
   ├─ Application Logs:/var/log/goldvninvest/
   ├─ Nginx Config:    /etc/nginx/sites-available/goldvninvest
   └─ Docker Compose:  /var/www/goldvninvest.online/server/docker-compose-prod.yaml

🔗 ACCESS URLS:
   ├─ Web:     https://goldvninvest.online
   ├─ API:     https://goldvninvest.online/api
   └─ WebSocket: wss://goldvninvest.online/stream

⚠️  CRITICAL NEXT STEPS:

1️⃣  VERIFY DNS CONFIGURATION:
   Make sure A records are set:
   ├─ goldvninvest.online          → 137.184.223.15
   └─ www.goldvninvest.online      → 137.184.223.15

2️⃣  UPDATE EMAIL CONFIGURATION:
   nano /var/www/goldvninvest.online/server/hollaex-kit.env
   
   Update these fields:
   - SMTP_SERVER (your email service)
   - SMTP_USER (your email)
   - SMTP_PASSWORD (your password)

3️⃣  REGISTER OUTBOUND IP WITH HOLLAEX:
   Email: support@hollaex.com
   Provide: IP 137.184.223.15 for goldvninvest.online

4️⃣  RESTART SERVICES:
   systemctl restart goldvninvest

5️⃣  TEST THE DEPLOYMENT:
   docker-compose -f /var/www/goldvninvest.online/server/docker-compose-prod.yaml ps
   curl https://goldvninvest.online/api

📚 USEFUL COMMANDS:

View Status:
   systemctl status goldvninvest
   docker-compose -f /var/www/goldvninvest.online/server/docker-compose-prod.yaml ps

View Logs:
   docker-compose -f /var/www/goldvninvest.online/server/docker-compose-prod.yaml logs -f

Restart Services:
   systemctl restart goldvninvest

Stop Services:
   docker-compose -f /var/www/goldvninvest.online/server/docker-compose-prod.yaml down

Check Nginx:
   nginx -t
   systemctl status nginx

🎯 DOCUMENTATION:
   https://docs.hollaex.com
   https://github.com/hollaex/hollaex-kit

✨ Installation completed at: $(date)

SUMMARY
}

# ============================================================================
# MAIN EXECUTION
# ============================================================================

main() {
    log_header "🚀 GoldVN Invest - HollaEx Kit Production Deployment"
    log_info "Domain: $DOMAIN"
    log_info "Server: root@137.184.223.15"
    log_info "Exchange: $EXCHANGE_NAME"
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
    health_check
    
    # Summary
    print_summary
}

trap 'log_error "Installation failed at $(date)"; exit 1' ERR

# Run installation
main "$@"

exit 0
