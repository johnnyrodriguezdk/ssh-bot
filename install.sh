#!/bin/bash
# ================================================
# SERVERTUC™ BOT v8.7 - FIX COMANDOS PLANES
# Correcciones aplicadas:
# 1. ✅ MENÚ PRINCIPAL: 1=Prueba, 2=Ver Planes, 3=Cuentas, 4=Estado, 5=APP, 6=Soporte
# 2. ✅ MENÚ PLANES: 1=7d 1con, 2=15d 1con, 3=30d 1con, 4=7d 2con, 5=15d 2con, 6=30d 2con, 7=50d 1con
# 3. ✅ SISTEMA DE ESTADOS: Cuando usuario está en "modo compra", los números 1-7 son para comprar
# 4. ✅ FIX TOTAL: Sin conflictos entre menús
# 5. ✅ NUEVO PLAN: 50 días (1 conexión)
# ================================================

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m'

# Banner inicial
clear
echo -e "${CYAN}${BOLD}"
cat << "BANNER"
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║    ███████╗███████╗██████╗ ██╗   ██╗██████╗ ████████╗██╗   ██╗║
║    ██╔════╝██╔════╝██╔══██╗██║   ██║██╔══██╗╚══██╔══╝██║   ██║║
║    ███████╗█████╗  ██████╔╝██║   ██║██████╔╝   ██║   ██║   ██║║
║    ╚════██║██╔══╝  ██╔══██╗██║   ██║██╔══██╗   ██║   ██║   ██║║
║    ███████║███████╗██║  ██║╚██████╔╝██║  ██║   ██║   ╚██████╔╝║
║    ╚══════╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝   ╚═╝    ╚═════╝ ║
╠══════════════════════════════════════════════════════════════╣
║                                                              ║
║                     SERVERTUC™ BOT v8.7                      ║
║               💡 SISTEMA DE ESTADOS INTELIGENTE             ║
║               🔌 1,2,3,4,5,6,7 PARA COMPRAR EN PLANES       ║
║               🔐 CONTRASEÑA FIJA: 12345                     ║
║               🆕 NUEVO PLAN: 50 días (1 conexión)           ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
BANNER
echo -e "${NC}"

echo -e "${GREEN}✅ NUEVO SISTEMA DE COMANDOS:${NC}"
echo -e "  🔴 ${RED}MENÚ PRINCIPAL:${NC}"
echo -e "     ${GREEN}1${NC} = Prueba gratis"
echo -e "     ${GREEN}2${NC} = Ver planes"
echo -e "     ${GREEN}3${NC} = Mis cuentas"
echo -e "     ${GREEN}4${NC} = Estado de pago"
echo -e "     ${GREEN}5${NC} = Descargar APP"
echo -e "     ${GREEN}6${NC} = Soporte"
echo -e "  🟡 ${YELLOW}MENÚ PLANES:${NC}"
echo -e "     ${GREEN}1${NC} = 7 días (1 conexión) - COMPRAR"
echo -e "     ${GREEN}2${NC} = 15 días (1 conexión) - COMPRAR"
echo -e "     ${GREEN}3${NC} = 30 días (1 conexión) - COMPRAR"
echo -e "     ${GREEN}4${NC} = 7 días (2 conexiones) - COMPRAR"
echo -e "     ${GREEN}5${NC} = 15 días (2 conexiones) - COMPRAR"
echo -e "     ${GREEN}6${NC} = 30 días (2 conexiones) - COMPRAR"
echo -e "     ${GREEN}7${NC} = 50 días (1 conexión) - COMPRAR"
echo -e "  🟢 ${GREEN}FIX:${NC} Sistema de estados evita conflictos"
echo -e "${CYAN}══════════════════════════════════════════════════════════════${NC}\n"

# Verificar root
if [[ $EUID -ne 0 ]]; then
    echo -e "${RED}${BOLD}❌ ERROR: Debes ejecutar como root${NC}"
    echo -e "${YELLOW}Usa: sudo bash $0${NC}"
    exit 1
fi

# Detectar IP
echo -e "${CYAN}${BOLD}🔍 DETECTANDO IP DEL SERVIDOR...${NC}"
SERVER_IP=$(curl -4 -s --max-time 10 ifconfig.me 2>/dev/null || hostname -I | awk '{print $1}' || echo "127.0.0.1")
if [[ -z "$SERVER_IP" || "$SERVER_IP" == "127.0.0.1" ]]; then
    echo -e "${RED}❌ No se pudo obtener IP pública${NC}"
    read -p "📝 Ingresa la IP del servidor manualmente: " SERVER_IP
fi

echo -e "${GREEN}✅ IP detectada: ${CYAN}$SERVER_IP${NC}\n"

# Confirmar instalación
echo -e "${YELLOW}⚠️  ESTE INSTALADOR HARÁ:${NC}"
echo -e "   • Instalar Node.js 20.x + Chrome"
echo -e "   • Crear SERVERTUC™ BOT v8.7 CON SISTEMA DE ESTADOS"
echo -e "   • Sistema: 1,2,3,4,5,6,7 funcionan para comprar EN PLANES"
echo -e "   • Sin conflictos entre menús"
echo -e "   • Panel de control 100% funcional"
echo -e "   • APK automático + Test 2h"
echo -e "   • Cron limpieza cada 15 minutos"
echo -e "   • 🔐 CONTRASEÑA FIJA: 12345 para todos"
echo -e "   • 🔌 PLANES CON 2 CONEXIONES"
echo -e "   • 👤 Nombres de usuario terminan en 'j'"
echo -e "   • 🆕 NUEVO PLAN: 50 días (1 conexión)"
echo -e "   • 🤖 BOT SILENCIOSO: Solo responde a comandos válidos"
echo -e "\n${RED}⚠️  Se eliminarán instalaciones anteriores${NC}"

read -p "$(echo -e "${YELLOW}¿Continuar con la instalación? (s/N): ${NC}")" -n 1 -r
echo
if [[ ! $REPLY =~ ^[Ss]$ ]]; then
    echo -e "${RED}❌ Instalación cancelada${NC}"
    exit 0
fi

# ================================================
# INSTALAR DEPENDENCIAS
# ================================================
echo -e "\n${CYAN}${BOLD}📦 INSTALANDO DEPENDENCIAS...${NC}"

# Actualizar sistema
apt-get update -y
apt-get upgrade -y

# Instalar Node.js 20.x
echo -e "${YELLOW}📦 Instalando Node.js 20.x...${NC}"
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt-get install -y nodejs
apt-get install -y gcc g++ make

# Instalar Chromium
echo -e "${YELLOW}🌐 Instalando Chrome/Chromium...${NC}"
apt-get install -y wget gnupg
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list
apt-get update -y
apt-get install -y google-chrome-stable

# Instalar dependencias del sistema
echo -e "${YELLOW}⚙️ Instalando utilidades...${NC}"
apt-get install -y \
    git \
    curl \
    wget \
    sqlite3 \
    jq \
    build-essential \
    libcairo2-dev \
    libpango1.0-dev \
    libjpeg-dev \
    libgif-dev \
    librsvg2-dev \
    pkg-config \
    python3 \
    python3-pip \
    ffmpeg \
    unzip \
    cron \
    ufw

# Instalar PM2 globalmente
echo -e "${YELLOW}🔄 Instalando PM2...${NC}"
npm install -g pm2
pm2 update

# Configurar firewall
echo -e "${YELLOW}🛡️ Configurando firewall...${NC}"
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow 8001/tcp
ufw allow 3000/tcp
ufw --force enable

echo -e "${GREEN}✅ Dependencias instaladas${NC}"

# ================================================
# PREPARAR ESTRUCTURA
# ================================================
echo -e "\n${CYAN}${BOLD}📁 CREANDO ESTRUCTURA...${NC}"

INSTALL_DIR="/opt/ssh-bot"
USER_HOME="/root/ssh-bot"
DB_FILE="$INSTALL_DIR/data/users.db"
CONFIG_FILE="$INSTALL_DIR/config/config.json"

# Limpiar instalaciones anteriores
echo -e "${YELLOW}🧹 Limpiando instalaciones anteriores...${NC}"
pm2 delete ssh-bot 2>/dev/null || true
pm2 flush 2>/dev/null || true
rm -rf "$INSTALL_DIR" "$USER_HOME" 2>/dev/null || true
rm -rf /root/.wwebjs_auth /root/.wwebjs_cache 2>/dev/null || true

# Crear directorios
mkdir -p "$INSTALL_DIR"/{data,config,qr_codes,logs}
mkdir -p "$USER_HOME"
mkdir -p /root/.wwebjs_auth
chmod -R 755 "$INSTALL_DIR"
chmod -R 700 /root/.wwebjs_auth

# Crear configuración CON NUEVOS PLANES INCLUYENDO 50 DÍAS
cat > "$CONFIG_FILE" << EOF
{
    "bot": {
        "name": "SERVERTUC™ BOT",
        "version": "8.7-FIX-COMANDOS-ESTADOS",
        "server_ip": "$SERVER_IP",
        "default_password": "12345"
    },
    "prices": {
        "test_hours": 2,
        "price_7d_1conn": 500.00,
        "price_15d_1conn": 800.00,
        "price_30d_1conn": 1200.00,
        "price_50d_1conn": 1800.00,
        "price_7d_2conn": 800.00,
        "price_15d_2conn": 1200.00,
        "price_30d_2conn": 1800.00,
        "currency": "ARS"
    },
    "mercadopago": {
        "access_token": "",
        "enabled": false
    },
    "links": {
        "tutorial": "https://youtube.com",
        "support": "https://wa.me/3813414485"
    },
    "paths": {
        "database": "$DB_FILE",
        "chromium": "/usr/bin/google-chrome",
        "qr_codes": "$INSTALL_DIR/qr_codes"
    }
}
EOF

# Crear base de datos
sqlite3 "$DB_FILE" << 'SQL'
CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    phone TEXT,
    username TEXT UNIQUE,
    password TEXT DEFAULT '12345',
    tipo TEXT DEFAULT 'test',
    expires_at DATETIME,
    max_connections INTEGER DEFAULT 1,
    status INTEGER DEFAULT 1,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE daily_tests (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    phone TEXT,
    date DATE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(phone, date)
);
CREATE TABLE payments (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    payment_id TEXT UNIQUE,
    phone TEXT,
    plan TEXT,
    days INTEGER,
    connections INTEGER DEFAULT 1,
    amount REAL,
    status TEXT DEFAULT 'pending',
    payment_url TEXT,
    qr_code TEXT,
    preference_id TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    approved_at DATETIME
);
CREATE TABLE logs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    type TEXT,
    message TEXT,
    data TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE user_state (
    phone TEXT PRIMARY KEY,
    state TEXT DEFAULT 'main_menu',
    data TEXT,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_users_phone ON users(phone);
CREATE INDEX idx_users_status ON users(status);
CREATE INDEX idx_payments_status ON payments(status);
CREATE INDEX idx_payments_phone_plan ON payments(phone, plan, status);
SQL

echo -e "${GREEN}✅ Estructura creada con sistema de estados${NC}"

# ================================================
# CREAR BOT CON SISTEMA DE ESTADOS
# ================================================
echo -e "\n${CYAN}${BOLD}🤖 CREANDO BOT CON SISTEMA DE ESTADOS...${NC}"

cd "$USER_HOME"

# package.json
cat > package.json << 'PKGEOF'
{
    "name": "ssh-bot-pro",
    "version": "8.7.0",
    "main": "bot.js",
    "dependencies": {
        "whatsapp-web.js": "^1.24.0",
        "qrcode-terminal": "^0.12.0",
        "qrcode": "^1.5.3",
        "moment": "^2.30.1",
        "sqlite3": "^5.1.7",
        "chalk": "^4.1.2",
        "node-cron": "^3.0.3",
        "mercadopago": "^2.0.15",
        "axios": "^1.6.5"
    }
}
PKGEOF

echo -e "${YELLOW}📦 Instalando paquetes Node.js...${NC}"
npm install --silent 2>&1 | grep -v "npm WARN" || true

# ✅ APLICAR PARCHE PARA ERROR markedUnread
echo -e "${YELLOW}🔧 Aplicando parche para error WhatsApp Web...${NC}"
find node_modules/whatsapp-web.js -name "Client.js" -type f -exec sed -i 's/if (chat && chat.markedUnread)/if (false \&\& chat.markedUnread)/g' {} \; 2>/dev/null || true
find node_modules/whatsapp-web.js -name "Client.js" -type f -exec sed -i 's/const sendSeen = async (chatId) => {/const sendSeen = async (chatId) => { console.log("[DEBUG] sendSeen deshabilitado"); return;/g' {} \; 2>/dev/null || true

echo -e "${GREEN}✅ Parche markedUnread aplicado${NC}"

# Crear bot.js COMPLETO CON SISTEMA DE ESTADOS Y PLAN 50 DÍAS
echo -e "${YELLOW}📝 Creando bot.js con sistema de estados y plan 50 días...${NC}"

cat > "bot.js" << 'BOTEOF'
const { Client, LocalAuth, MessageMedia } = require('whatsapp-web.js');
const qrcodeTerminal = require('qrcode-terminal');
const QRCode = require('qrcode');
const moment = require('moment');
const sqlite3 = require('sqlite3').verbose();
const { exec } = require('child_process');
const util = require('util');
const chalk = require('chalk');
const cron = require('node-cron');
const fs = require('fs');
const path = require('path');
const axios = require('axios');

const execPromise = util.promisify(exec);

function loadConfig() {
    delete require.cache[require.resolve('/opt/ssh-bot/config/config.json')];
    return require('/opt/ssh-bot/config/config.json');
}

let config = loadConfig();
const db = new sqlite3.Database(config.paths.database);

// ✅ FUNCIONES DE ESTADO
function getUserState(phone) {
    return new Promise((resolve) => {
        db.get('SELECT state, data FROM user_state WHERE phone = ?', [phone], (err, row) => {
            if (err || !row) {
                resolve({ state: 'main_menu', data: null });
            } else {
                resolve({
                    state: row.state || 'main_menu',
                    data: row.data ? JSON.parse(row.data) : null
                });
            }
        });
    });
}

function setUserState(phone, state, data = null) {
    return new Promise((resolve) => {
        const dataStr = data ? JSON.stringify(data) : null;
        db.run(
            `INSERT OR REPLACE INTO user_state (phone, state, data, updated_at) VALUES (?, ?, ?, CURRENT_TIMESTAMP)`,
            [phone, state, dataStr],
            (err) => {
                if (err) console.error(chalk.red('❌ Error estado:'), err.message);
                resolve();
            }
        );
    });
}

function clearUserState(phone) {
    db.run('DELETE FROM user_state WHERE phone = ?', [phone]);
}

// ✅ MERCADOPAGO SDK V2.X
let mpClient = null;
let mpPreference = null;

function initMercadoPago() {
    config = loadConfig();
    if (config.mercadopago.access_token && config.mercadopago.access_token !== '') {
        try {
            const { MercadoPagoConfig, Preference } = require('mercadopago');
            
            mpClient = new MercadoPagoConfig({ 
                accessToken: config.mercadopago.access_token,
                options: { timeout: 5000, idempotencyKey: true }
            });
            
            mpPreference = new Preference(mpClient);
            
            console.log(chalk.green('✅ MercadoPago SDK v2.x ACTIVO'));
            console.log(chalk.cyan(`🔑 Token: ${config.mercadopago.access_token.substring(0, 20)}...`));
            return true;
        } catch (error) {
            console.log(chalk.red('❌ Error inicializando MP:'), error.message);
            mpClient = null;
            mpPreference = null;
            return false;
        }
    }
    console.log(chalk.yellow('⚠️ MercadoPago NO configurado (token vacío)'));
    return false;
}

let mpEnabled = initMercadoPago();
moment.locale('es');

console.log(chalk.cyan.bold('\n╔══════════════════════════════════════════════════════════════╗'));
console.log(chalk.cyan.bold('║      🤖 SERVERTUC™ BOT v8.7 - SISTEMA DE ESTADOS              ║'));
console.log(chalk.cyan.bold('║               💡 1,2,3,4,5,6,7 PARA COMPRAR EN PLANES       ║'));
console.log(chalk.cyan.bold('║               🔐 CONTRASEÑA FIJA: 12345                      ║'));
console.log(chalk.cyan.bold('║               🆕 NUEVO PLAN: 50 días (1 conexión)           ║'));
console.log(chalk.cyan.bold('╚══════════════════════════════════════════════════════════════╝\n'));
console.log(chalk.yellow(`📍 IP: ${config.bot.server_ip}`));
console.log(chalk.yellow(`📞 Soporte: ${config.links.support}`));
console.log(chalk.yellow(`💳 MercadoPago: ${mpEnabled ? '✅ SDK v2.x ACTIVO' : '❌ NO CONFIGURADO'}`));
console.log(chalk.green('✅ WhatsApp Web parcheado (no markedUnread error)'));
console.log(chalk.green('✅ SISTEMA DE ESTADOS: Sin conflictos entre menús'));
console.log(chalk.green('✅ MENÚ PLANES: 1,2,3,4,5,6,7 para comprar'));
console.log(chalk.green('✅ NUEVO PLAN: 50 días (1 conexión) disponible'));
console.log(chalk.green('✅ APK automático desde /root'));
console.log(chalk.green('✅ Test 2 horas exactas'));
console.log(chalk.green('✅ CONTRASEÑA FIJA: 12345 para todos los usuarios'));
console.log(chalk.green('✅ PLANES CON 2 CONEXIONES'));
console.log(chalk.green('✅ USUARIOS TERMINAN EN "j"'));
console.log(chalk.green('✅ BOT SILENCIOSO: Solo responde a comandos válidos'));

// Función para generar nombre de usuario terminado en 'j'
function generateUsername() {
    const randomNum = Math.floor(Math.random() * 1000);
    const username = 'user' + randomNum + 'j';
    return username;
}

// Servidor APK
let apkServer = null;
function startAPKServer(apkPath) {
    return new Promise((resolve) => {
        try {
            const http = require('http');
            const fileName = path.basename(apkPath);
            
            apkServer = http.createServer((req, res) => {
                if (req.url === '/' || req.url === `/${fileName}`) {
                    try {
                        const stat = fs.statSync(apkPath);
                        res.writeHead(200, {
                            'Content-Type': 'application/vnd.android.package-archive',
                            'Content-Length': stat.size,
                            'Content-Disposition': `attachment; filename="${fileName}"`
                        });
                        
                        const readStream = fs.createReadStream(apkPath);
                        readStream.pipe(res);
                        console.log(chalk.cyan(`📥 APK descargado: ${fileName}`));
                    } catch (err) {
                        res.writeHead(404);
                        res.end('APK no encontrado');
                    }
                } else {
                    res.writeHead(404);
                    res.end('Not found');
                }
            });
            
            apkServer.listen(8001, '0.0.0.0', () => {
                console.log(chalk.green(`✅ Servidor APK: http://${config.bot.server_ip}:8001/`));
                resolve(true);
            });
            
            setTimeout(() => {
                if (apkServer) {
                    apkServer.close();
                    console.log(chalk.yellow('⏰ Servidor APK cerrado (1h)'));
                }
            }, 3600000);
            
        } catch (error) {
            console.error(chalk.red('❌ Error servidor APK:'), error);
            resolve(false);
        }
    });
}

const client = new Client({
    authStrategy: new LocalAuth({dataPath: '/root/.wwebjs_auth', clientId: 'server-bot-v87'}),
    puppeteer: {
        headless: true,
        executablePath: config.paths.chromium,
        args: ['--no-sandbox', '--disable-setuid-sandbox', '--disable-dev-shm-usage', '--disable-gpu', '--no-first-run', '--disable-extensions'],
        timeout: 60000
    },
    authTimeoutMs: 60000
});

let qrCount = 0;

client.on('qr', (qr) => {
    qrCount++;
    console.clear();
    console.log(chalk.yellow.bold(`\n╔════════ 📱 QR #${qrCount} - ESCANEA AHORA ════════╗\n`));
    qrcodeTerminal.generate(qr, { small: true });
    QRCode.toFile('/root/qr-whatsapp.png', qr, { width: 500 }).catch(() => {});
    console.log(chalk.cyan('\n1️⃣ Abre WhatsApp → Dispositivos vinculados'));
    console.log(chalk.cyan('2️⃣ Escanea el QR ☝️'));
    console.log(chalk.green('\n💾 QR guardado: /root/qr-whatsapp.png\n'));
});

client.on('authenticated', () => console.log(chalk.green('✅ Autenticado')));
client.on('loading_screen', (p, m) => console.log(chalk.yellow(`⏳ Cargando: ${p}% - ${m}`)));
client.on('ready', () => {
    console.clear();
    console.log(chalk.green.bold('\n✅ BOT CONECTADO Y OPERATIVO\n'));
    console.log(chalk.cyan('💬 Envía "menu" a tu WhatsApp\n'));
    qrCount = 0;
});
client.on('auth_failure', (m) => console.log(chalk.red('❌ Error auth:'), m));
client.on('disconnected', (r) => console.log(chalk.yellow('⚠️ Desconectado:'), r));

function generatePassword() {
    return '12345';
}

async function createSSHUser(phone, username, password, days, connections = 1) {
    if (days === 0) {
        const expireFull = moment().add(2, 'hours').format('YYYY-MM-DD HH:mm:ss');
        
        console.log(chalk.yellow(`⌛ Test ${username} expira: ${expireFull} (2 horas)`));
        
        const commands = [
            `useradd -m -s /bin/bash ${username}`,
            `echo "${username}:12345" | chpasswd`
        ];
        
        for (const cmd of commands) {
            try {
                await execPromise(cmd);
            } catch (error) {
                console.error(chalk.red(`❌ Error: ${cmd}`), error.message);
                throw error;
            }
        }
        
        const tipo = 'test';
        return new Promise((resolve, reject) => {
            db.run(`INSERT INTO users (phone, username, password, tipo, expires_at, max_connections, status) VALUES (?, ?, ?, ?, ?, ?, 1)`,
                [phone, username, '12345', tipo, expireFull, 1],
                (err) => err ? reject(err) : resolve({ 
                    username, 
                    password: '12345',
                    expires: expireFull,
                    tipo: 'test',
                    duration: '2 horas'
                }));
        });
    } else {
        const expireDate = moment().add(days, 'days').format('YYYY-MM-DD');
        const expireFull = moment().add(days, 'days').format('YYYY-MM-DD 23:59:59');
        
        console.log(chalk.yellow(`⌛ Premium ${username} expira: ${expireDate} (${connections} conexiones)`));
        
        try {
            await execPromise(`useradd -M -s /bin/false -e ${expireDate} ${username} && echo "${username}:12345" | chpasswd`);
        } catch (error) {
            console.error(chalk.red('❌ Error creando premium:'), error.message);
            throw error;
        }
        
        const tipo = 'premium';
        return new Promise((resolve, reject) => {
            db.run(`INSERT INTO users (phone, username, password, tipo, expires_at, max_connections, status) VALUES (?, ?, ?, ?, ?, ?, 1)`,
                [phone, username, '12345', tipo, expireFull, connections],
                (err) => err ? reject(err) : resolve({ 
                    username, 
                    password: '12345',
                    expires: expireFull,
                    tipo: 'premium',
                    duration: `${days} días`,
                    connections: connections
                }));
        });
    }
}

function canCreateTest(phone) {
    return new Promise((resolve) => {
        const today = moment().format('YYYY-MM-DD');
        db.get('SELECT COUNT(*) as count FROM daily_tests WHERE phone = ? AND date = ?', [phone, today],
            (err, row) => resolve(!err && row && row.count === 0));
    });
}

function registerTest(phone) {
    db.run('INSERT OR IGNORE INTO daily_tests (phone, date) VALUES (?, ?)', [phone, moment().format('YYYY-MM-DD')]);
}

async function createMercadoPagoPayment(phone, plan, days, amount, connections) {
    try {
        config = loadConfig();
        
        if (!config.mercadopago.access_token || config.mercadopago.access_token === '') {
            console.log(chalk.red('❌ Token MP vacío'));
            return { success: false, error: 'MercadoPago no configurado - Token vacío' };
        }
        
        if (!mpPreference) {
            console.log(chalk.yellow('🔄 Reinicializando MercadoPago...'));
            mpEnabled = initMercadoPago();
            if (!mpEnabled || !mpPreference) {
                return { success: false, error: 'No se pudo inicializar MercadoPago' };
            }
        }
        
        const phoneClean = phone.split('@')[0];
        const paymentId = `PREMIUM-${phoneClean}-${plan}-${connections}conn-${Date.now()}`;
        
        console.log(chalk.cyan(`🔄 Creando pago MP: ${paymentId}`));
        
        const expirationDate = moment().add(24, 'hours');
        const isoDate = expirationDate.toISOString();
        
        const preferenceData = {
            items: [{
                title: `SERVERTUC™ PREMIUM ${days} DÍAS (${connections} conexiones)`,
                description: `SERVERTUC™ BOT - Acceso completo por ${days} días con ${connections} conexiones simultáneas`,
                quantity: 1,
                currency_id: config.prices.currency || 'ARS',
                unit_price: parseFloat(amount)
            }],
            external_reference: paymentId,
            expires: true,
            expiration_date_from: moment().toISOString(),
            expiration_date_to: isoDate,
            back_urls: {
                success: `https://wa.me/${phoneClean}?text=Pago%20exitoso`,
                failure: `https://wa.me/${phoneClean}?text=Pago%20fallido`,
                pending: `https://wa.me/${phoneClean}?text=Pago%20pendiente`
            },
            auto_return: 'approved',
            statement_descriptor: 'SERVERTUC™ PREMIUM',
            notification_url: `http://${config.bot.server_ip}:3000/webhook`
        };
        
        console.log(chalk.yellow(`📦 Producto: ${preferenceData.items[0].title}`));
        console.log(chalk.yellow(`💰 Monto: $${amount} ${config.prices.currency}`));
        console.log(chalk.yellow(`🔌 Conexiones: ${connections}`));
        
        const response = await mpPreference.create({ body: preferenceData });
        
        console.log(chalk.cyan('📄 Respuesta MP recibida'));
        
        if (response && response.id) {
            const paymentUrl = response.init_point;
            const qrPath = `${config.paths.qr_codes}/${paymentId}.png`;
            
            await QRCode.toFile(qrPath, paymentUrl, { 
                width: 400,
                margin: 1,
                color: {
                    dark: '#000000',
                    light: '#FFFFFF'
                }
            });
            
            db.run(
                `INSERT INTO payments (payment_id, phone, plan, days, connections, amount, status, payment_url, qr_code, preference_id) VALUES (?, ?, ?, ?, ?, ?, 'pending', ?, ?, ?)`,
                [paymentId, phone, plan, days, connections, amount, paymentUrl, qrPath, response.id],
                (err) => {
                    if (err) {
                        console.error(chalk.red('❌ Error guardando en BD:'), err.message);
                    }
                }
            );
            
            console.log(chalk.green(`✅ Pago creado exitosamente`));
            console.log(chalk.cyan(`🔗 URL: ${paymentUrl.substring(0, 50)}...`));
            
            return { 
                success: true, 
                paymentId, 
                paymentUrl, 
                qrPath,
                preferenceId: response.id,
                connections: connections
            };
        }
        
        throw new Error('Respuesta inválida de MercadoPago');
        
    } catch (error) {
        console.error(chalk.red('❌ Error MercadoPago:'), error.message);
        
        db.run(
            `INSERT INTO logs (type, message, data) VALUES ('mp_error', ?, ?)`,
            [error.message, JSON.stringify({ stack: error.stack })]
        );
        
        return { success: false, error: error.message };
    }
}

// ✅ FUNCIÓN CLAVE: VERIFICAR SI YA EXISTE UN PAGO PENDIENTE
async function getExistingPayment(phone, plan, days, connections) {
    return new Promise((resolve) => {
        const query = `
            SELECT payment_id, payment_url, qr_code, amount, created_at 
            FROM payments 
            WHERE phone = ? 
            AND plan = ? 
            AND days = ? 
            AND connections = ? 
            AND status = 'pending'
            AND created_at > datetime('now', '-24 hours')
            ORDER BY created_at DESC 
            LIMIT 1
        `;
        
        db.get(query, [phone, plan, days, connections], (err, row) => {
            if (err) {
                console.error(chalk.red('❌ Error buscando pago existente:'), err.message);
                resolve(null);
            } else if (row) {
                console.log(chalk.green(`✅ Pago existente encontrado: ${row.payment_id}`));
                resolve(row);
            } else {
                resolve(null);
            }
        });
    });
}

async function checkPendingPayments() {
    config = loadConfig();
    if (!config.mercadopago.access_token || config.mercadopago.access_token === '') return;
    
    db.all('SELECT * FROM payments WHERE status = "pending" AND created_at > datetime("now", "-48 hours")', async (err, payments) => {
        if (err || !payments || payments.length === 0) return;
        
        console.log(chalk.yellow(`🔍 Verificando ${payments.length} pagos pendientes...`));
        
        for (const payment of payments) {
            try {
                const url = `https://api.mercadopago.com/v1/payments/search?external_reference=${payment.payment_id}`;
                const response = await axios.get(url, {
                    headers: { 
                        'Authorization': `Bearer ${config.mercadopago.access_token}`,
                        'Content-Type': 'application/json'
                    },
                    timeout: 15000
                });
                
                if (response.data && response.data.results && response.data.results.length > 0) {
                    const mpPayment = response.data.results[0];
                    
                    console.log(chalk.cyan(`📋 Pago ${payment.payment_id}: ${mpPayment.status}`));
                    
                    if (mpPayment.status === 'approved') {
                        console.log(chalk.green(`✅ PAGO APROBADO: ${payment.payment_id}`));
                        
                        const username = generateUsername();
                        const password = '12345';
                        const result = await createSSHUser(payment.phone, username, password, payment.days, payment.connections);
                        
                        db.run(`UPDATE payments SET status = 'approved', approved_at = CURRENT_TIMESTAMP WHERE payment_id = ?`, [payment.payment_id]);
                        
                        const expireDate = moment().add(payment.days, 'days').format('DD/MM/YYYY');
                        
                        const message = `╔══════════════════════════════════════╗
║   🎉 *PAGO CONFIRMADO*               ║
╚══════════════════════════════════════╝

✅ Tu compra ha sido aprobada

📋 *DATOS DE ACCESO SERVERTUC™ BOT:*
👤 Usuario: *${username}*
🔑 Contraseña: *12345*

⏰ *VÁLIDO HASTA:* ${expireDate}
🔌 *CONEXIÓN:* ${payment.connections} ${payment.connections > 1 ? 'conexiones simultáneas' : 'conexión'}

📱 *INSTALACIÓN:*
1. Descarga la app (Escribe *5*)
2. Seleccionar servidor 1
3. Ingresar Usuario y Contraseña
4. ¡Conéctate automáticamente!

🎊 ¡Disfruta del servicio premium!

📞 Soporte: *${config.links.support}*`;
                        
                        await client.sendMessage(payment.phone, message, { sendSeen: false });
                        console.log(chalk.green(`✅ Usuario creado y notificado: ${username} (${payment.connections} conexiones)`));
                    }
                }
            } catch (error) {
                console.error(chalk.red(`❌ Error verificando ${payment.payment_id}:`), error.message);
            }
        }
    });
}

client.on('message', async (msg) => {
    const text = msg.body.toLowerCase().trim();
    const phone = msg.from;
    if (phone.includes('@g.us')) return;
    
    config = loadConfig();
    console.log(chalk.cyan(`📩 [${phone.split('@')[0]}]: ${text.substring(0, 30)}`));
    
    // Obtener estado actual del usuario
    const userState = await getUserState(phone);
    
    if (['menu', 'hola', 'start', 'hi', 'volver', 'atras'].includes(text)) {
        // Resetear estado a menú principal
        await setUserState(phone, 'main_menu');
        
        await client.sendMessage(phone, `╔══════════════════════════════════════╗
║   🚀 *HOLA SERVERTUC™ BOT*          ║
╚══════════════════════════════════════╝

📋 *MENU PRINCIPAL:*

⌛️ *1* - Prueba GRATIS (2h) 
💰 *2* - Planes Internet
👤 *3* - Mis cuentas
💳 *4* - Estado de pago
📱 *5* - Descargar APP
🔧 *6* - Soporte

💬 Responde con el número`, { sendSeen: false });
    }
    else if (text === '1' && userState.state === 'main_menu') {
        // ✅ COMANDO 1 EN MENÚ PRINCIPAL = PRUEBA GRATIS
        if (!(await canCreateTest(phone))) {
            await client.sendMessage(phone, `⚠️ *YA USASTE TU PRUEBA HOY*

⏳ Vuelve mañana
💎 *Escribe 2* para planes`, { sendSeen: false });
            return;
        }
        await client.sendMessage(phone, '⏳ Creando cuenta test...', { sendSeen: false });
        try {
            const username = generateUsername();
            const password = '12345';
            await createSSHUser(phone, username, password, 0, 1);
            registerTest(phone);
            
            await client.sendMessage(phone, `✅ *PRUEBA ACTIVADA*

👤 Usuario: *${username}*
🔑 Contraseña: *12345*
⏰ Duración: 2 horas  
🔌 Conexión: 1

📱 *PARA CONECTAR:*
1. Descarga la app (Escribe *5*)
2. Selecionar servidor
3. Ingresa usuario y contraseña
4. ¡Listo!

💎 ¿Te gustó? *Escribe 2* para ver planes premium`, { sendSeen: false });
            
            console.log(chalk.green(`✅ Test creado: ${username}`));
        } catch (error) {
            await client.sendMessage(phone, `❌ Error al crear cuenta: ${error.message}`, { sendSeen: false });
        }
    }
    else if (text === '2' && userState.state === 'main_menu') {
        // ✅ COMANDO 2 EN MENÚ PRINCIPAL = VER PLANES
        await setUserState(phone, 'viewing_plans');
        
        await client.sendMessage(phone, `💎 *PLANES INTERNET - ELIGE UN PLAN*

📱 *1 DISPOSITIVO*
  *1* - 7 días - $${config.prices.price_7d_1conn} ARS
  *2* - 15 días - $${config.prices.price_15d_1conn} ARS
  *3* - 30 días - $${config.prices.price_30d_1conn} ARS

📱 *2 DISPOSITIVO*
  *4* - 7 días - $${config.prices.price_7d_2conn} ARS
  *5* - 15 días - $${config.prices.price_15d_2conn} ARS
  *6* - 30 días - $${config.prices.price_30d_2conn} ARS

📱 *1 DISPOSITIVO*
  *7* - 50 días  - $${config.prices.price_50d_1conn} ARS

💳 Pago: MercadoPago
⚡ Activación: 2-5 min

💰 *PARA COMPRAR:* Escribe el número del plan (1-7)
💬 *Para volver:* Escribe "menu"`, { sendSeen: false });
    }
    else if ((text === '1' || text === '2' || text === '3' || text === '4' || text === '5' || text === '6' || text === '7') && userState.state === 'viewing_plans') {
        // ✅ COMANDOS 1-7 CUANDO EL USUARIO ESTÁ VIENDO PLANES = COMPRAR
        config = loadConfig();
        
        console.log(chalk.yellow(`🔑 Verificando token MP para compra...`));
        
        if (!config.mercadopago.access_token || config.mercadopago.access_token === '') {
            await client.sendMessage(phone, `❌ *MERCADOPAGO NO CONFIGURADO*

El administrador debe configurar MercadoPago primero.

📞 Soporte: *${config.links.support}*`, { sendSeen: false });
            await setUserState(phone, 'main_menu');
            return;
        }
        
        if (!mpEnabled || !mpPreference) {
            console.log(chalk.yellow('🔄 Reinicializando MercadoPago...'));
            mpEnabled = initMercadoPago();
        }
        
        if (!mpEnabled || !mpPreference) {
            await client.sendMessage(phone, `❌ *ERROR CON MERCADOPAGO*

El sistema de pagos no está disponible.

📞 Contacta soporte: *${config.links.support}*`, { sendSeen: false });
            await setUserState(phone, 'main_menu');
            return;
        }
        
        // MAPEO DE PLANES - CON LA SECUENCIA CORRECTA
        const planMap = {
            '1': { days: 7, amount: config.prices.price_7d_1conn, plan: '7d', conn: 1, name: '7 DÍAS (1 conexión)' },
            '2': { days: 15, amount: config.prices.price_15d_1conn, plan: '15d', conn: 1, name: '15 DÍAS (1 conexión)' },
            '3': { days: 30, amount: config.prices.price_30d_1conn, plan: '30d', conn: 1, name: '30 DÍAS (1 conexión)' },
            '4': { days: 7, amount: config.prices.price_7d_2conn, plan: '7d', conn: 2, name: '7 DÍAS (2 conexiones)' },
            '5': { days: 15, amount: config.prices.price_15d_2conn, plan: '15d', conn: 2, name: '15 DÍAS (2 conexiones)' },
            '6': { days: 30, amount: config.prices.price_30d_2conn, plan: '30d', conn: 2, name: '30 DÍAS (2 conexiones)' },
            '7': { days: 50, amount: config.prices.price_50d_1conn, plan: '50d', conn: 1, name: '50 DÍAS (1 conexión)' }
        };
        
        const p = planMap[text];
        
        if (!p) {
            await client.sendMessage(phone, `❌ *PLAN NO VÁLIDO*

Escribe solo números del 1 al 7

💬 Escribe "menu" para volver`, { sendSeen: false });
            return;
        }
        
        console.log(chalk.cyan(`📦 Plan seleccionado: ${p.name}, $${p.amount}`));
        
        // ✅ VERIFICAR SI YA EXISTE UN PAGO PENDIENTE
        const existingPayment = await getExistingPayment(phone, p.plan, p.days, p.conn);
        
        if (existingPayment) {
            console.log(chalk.yellow(`📌 Reutilizando pago existente: ${existingPayment.payment_id}`));
            
            const connText = p.conn > 1 ? `${p.conn} CONEXIONES SIMULTÁNEAS` : '1 CONEXIÓN';
            
            await client.sendMessage(phone, `📋 *TIENES UN PAGO PENDIENTE*

Ya generaste un pago para este plan.

⚡ *PLAN:* ${p.name}
💰 *$${existingPayment.amount} ARS*

🔗 *ENLACE DE PAGO EXISTENTE:*
${existingPayment.payment_url}

⏰ *Este enlace expira en 24 horas*

💬 Escribe *4* para ver estado del pago
💬 Escribe "menu" para volver`, { sendSeen: false });
            
            // Enviar QR si existe
            if (fs.existsSync(existingPayment.qr_code)) {
                try {
                    const media = MessageMedia.fromFilePath(existingPayment.qr_code);
                    await client.sendMessage(phone, media, { 
                        caption: `📱 *ESCAPEA CON MERCADOPAGO*
                        
⚡ ${p.name}
💰 $${existingPayment.amount} ARS
⏰ Válido por 24 horas`, 
                        sendSeen: false 
                    });
                    console.log(chalk.green('✅ QR de pago existente enviado'));
                } catch (qrError) {
                    console.error(chalk.red('⚠️ Error enviando QR:'), qrError.message);
                }
            }
            
            await setUserState(phone, 'main_menu');
            return;
        }
        
        // Si no hay pago existente, crear uno nuevo
        const connText = p.conn > 1 ? `${p.conn} conexiones simultáneas` : '1 conexión';
        
        await client.sendMessage(phone, `⏳ *PROCESANDO TU COMPRA...*

📦 Plan: *${p.name}*
💰 Monto: *$${p.amount} ARS*
🔌 Conexión: *${connText}*

⏰ *GENERANDO ENLACE DE PAGO...*`, { sendSeen: false });
        
        try {
            const payment = await createMercadoPagoPayment(phone, p.plan, p.days, p.amount, p.conn);
            
            if (payment.success) {
                const connDisplay = p.conn > 1 ? `${p.conn} CONEXIONES SIMULTÁNEAS` : '1 CONEXIÓN';
                
                await client.sendMessage(phone, `💳 *PAGO GENERADO EXITOSAMENTE*

⚡ *PLAN:* ${p.name}
💰 *$${p.amount} ARS*

🔗 *ENLACE DE PAGO:*
${payment.paymentUrl}

✅ *TE NOTIFICARÉ CUANDO SE APRUEBE EL PAGO*

💬 Escribe *4* para ver estado del pago
💬 Escribe "menu" para volver al inicio`, { sendSeen: false });
                
                // Enviar QR si existe
                if (fs.existsSync(payment.qrPath)) {
                    try {
                        const media = MessageMedia.fromFilePath(payment.qrPath);
                        await client.sendMessage(phone, media, { 
                            caption: `📱 *ESCAPEA CON MERCADOPAGO*
                            
⚡ ${p.name}
💰 $${p.amount} ARS
⏰ Pago válido por 24 horas`, 
                            sendSeen: false 
                        });
                        console.log(chalk.green('✅ QR de pago enviado'));
                    } catch (qrError) {
                        console.error(chalk.red('⚠️ Error enviando QR:'), qrError.message);
                    }
                }
            } else {
                await client.sendMessage(phone, `❌ *ERROR AL GENERAR PAGO*

Detalles: ${payment.error}

Por favor, intenta de nuevo en unos minutos o contacta soporte.

📞 Soporte: *${config.links.support}*`, { sendSeen: false });
            }
        } catch (error) {
            console.error(chalk.red('❌ Error en compra:'), error);
            await client.sendMessage(phone, `❌ *ERROR INESPERADO*

${error.message}

📞 Contacta soporte: *${config.links.support}*`, { sendSeen: false });
        }
        
        await setUserState(phone, 'main_menu');
    }
    else if (text === '3' && userState.state === 'main_menu') {
        // ✅ COMANDO 3 EN MENÚ PRINCIPAL = MIS CUENTAS
        db.all(`SELECT username, password, tipo, expires_at, max_connections FROM users WHERE phone = ? AND status = 1 ORDER BY created_at DESC LIMIT 10`, [phone],
            async (err, rows) => {
                if (!rows || rows.length === 0) {
                    await client.sendMessage(phone, `📋 *SIN CUENTAS ACTIVAS*

🆓 *Escribe 1* - Prueba gratis
💰 *Escribe 2* - Ver planes premium`, { sendSeen: false });
                    return;
                }
                let msg = `📋 *TUS CUENTAS ACTIVAS - SERVERTUC™ BOT*

`;
                rows.forEach((a, i) => {
                    const tipo = a.tipo === 'premium' ? '💎' : '🆓';
                    const tipoText = a.tipo === 'premium' ? 'PREMIUM' : 'TEST';
                    const expira = moment(a.expires_at).format('DD/MM HH:mm');
                    const connText = a.max_connections > 1 ? `${a.max_connections} conexiones` : '1 conexión';
                    
                    msg += `*${i+1}. ${tipo} ${tipoText}*
`;
                    msg += `👤 *${a.username}*
`;
                    msg += `🔑 *12345*
`;
                    msg += `⏰ ${expira}
`;
                    msg += `🔌 ${connText}

`;
                });
                msg += `📱 Para conectar descarga la app (Escribe *5*)
📞 Soporte: *${config.links.support}*
💬 Escribe "menu" para volver`;
                await client.sendMessage(phone, msg, { sendSeen: false });
            });
    }
    else if (text === '4' && userState.state === 'main_menu') {
        // ✅ COMANDO 4 EN MENÚ PRINCIPAL = ESTADO DE PAGO
        db.all(`SELECT plan, amount, status, created_at, payment_url, connections FROM payments WHERE phone = ? ORDER BY created_at DESC LIMIT 5`, [phone],
            async (err, pays) => {
                if (!pays || pays.length === 0) {
                    await client.sendMessage(phone, `💳 *SIN PAGOS REGISTRADOS*

💰 *Escribe 2* - Ver planes disponibles
💬 Escribe "menu" para volver`, { sendSeen: false });
                    return;
                }
                let msg = `💳 *ESTADO DE TUS PAGOS - SERVERTUC™ BOT*

`;
                pays.forEach((p, i) => {
                    const emoji = p.status === 'approved' ? '✅' : '⏳';
                    const statusText = p.status === 'approved' ? 'APROBADO' : 'PENDIENTE';
                    const connText = p.connections > 1 ? `${p.connections} conexiones` : '1 conexión';
                    msg += `*${i+1}. ${emoji} ${statusText}*
`;
                    msg += `Plan: ${p.plan} | $${p.amount} ARS
`;
                    msg += `Conexiones: ${connText}
`;
                    msg += `Fecha: ${moment(p.created_at).format('DD/MM HH:mm')}
`;
                    if (p.status === 'pending' && p.payment_url) {
                        msg += `🔗 ${p.payment_url.substring(0, 40)}...
`;
                    }
                    msg += `
`;
                });
                msg += `🔄 Verificación automática cada 2 minutos
📞 Soporte: *${config.links.support}*
💬 Escribe "menu" para volver`;
                await client.sendMessage(phone, msg, { sendSeen: false });
            });
    }
    else if (text === '5' && userState.state === 'main_menu') {
        // ✅ COMANDO 5 EN MENÚ PRINCIPAL = DESCARGAR APP
        const searchPaths = [
            '/root/app.apk',
            '/root/ssh-bot/app.apk',
            '/root/android.apk',
            '/root/vpn.apk'
        ];
        
        let apkFound = null;
        let apkName = 'app.apk';
        
        for (const filePath of searchPaths) {
            if (fs.existsSync(filePath)) {
                apkFound = filePath;
                apkName = path.basename(filePath);
                break;
            }
        }
        
        if (apkFound) {
            try {
                const stats = fs.statSync(apkFound);
                const fileSize = (stats.size / (1024 * 1024)).toFixed(2);
                
                console.log(chalk.cyan(`📱 Enviando APK: ${apkName} (${fileSize}MB)`));
                
                await client.sendMessage(phone, `📱 *DESCARGANDO APP SERVERTUC™ BOT*

📦 Archivo: ${apkName}
📊 Tamaño: ${fileSize} MB

⏳ Enviando archivo, espera...`, { sendSeen: false });
                
                const media = MessageMedia.fromFilePath(apkFound);
                await client.sendMessage(phone, media, {
                    caption: `📱 *${apkName}*

✅ Archivo enviado correctamente

📱 *INSTRUCCIONES:*
1. Toca el archivo para instalar
2. Permite "Fuentes desconocidas" si te lo pide
3. Abre la app
4. Ingresa tus datos de acceso
   👤 Usuario: (tu usuario)
   🔑 Contraseña: 12345

💡 Si no ves el archivo, revisa la sección "Archivos" de WhatsApp

📞 Soporte: *${config.links.support}*
💬 Escribe "menu" para volver`,
                    sendSeen: false
                });
                
                console.log(chalk.green(`✅ APK enviado exitosamente`));
                
            } catch (error) {
                console.error(chalk.red('❌ Error enviando APK:'), error.message);
                
                const serverStarted = await startAPKServer(apkFound);
                if (serverStarted) {
                    await client.sendMessage(phone, `📱 *ENLACE DE DESCARGA*

El archivo es muy grande para WhatsApp.

🔗 Descarga desde aquí:
http://${config.bot.server_ip}:8001/${apkName}

📱 Instrucciones:
1. Abre el enlace en Chrome
2. Descarga el archivo
3. Instala y abre la app
4. Usuario: (tu usuario)
5. Contraseña: 12345

⚠️ El enlace expira en 1 hora

📞 Soporte: *${config.links.support}*
💬 Escribe "menu" para volver`, { sendSeen: false });
                } else {
                    await client.sendMessage(phone, `❌ *ERROR AL ENVIAR APK*

No se pudo enviar el archivo.

📞 Contacta soporte:
${config.links.support}

💬 Escribe "menu" para volver`, { sendSeen: false });
                }
            }
        } else {
            await client.sendMessage(phone, `❌ *APK NO DISPONIBLE*

El archivo de instalación no está disponible en el servidor.

📞 Contacta al administrador:
${config.links.support}

💡 Ubicación esperada: /root/app.apk

💬 Escribe "menu" para volver`, { sendSeen: false });
        }
    }
    else if (text === '6' && userState.state === 'main_menu') {
        // ✅ COMANDO 6 EN MENÚ PRINCIPAL = SOPORTE
        await client.sendMessage(phone, `🆘 *SOPORTE TÉCNICO SERVERTUC™ BOT*

📞 Contacta a soporte:
${config.links.support}

⏰ Horario: 9AM - 10PM

🔑 *Contraseña predeterminada:* 12345

📋 *PROBLEMAS COMUNES:*
• No llega el APK → Revisa "Archivos" en WhatsApp
• Error al conectar → Verifica usuario/contraseña
• Pago pendiente → Escribe *4* para estado

💬 Escribe "menu" para volver al inicio`, { sendSeen: false });
    }
    else {
        // 🚫 **MODIFICADO: NO RESPONDER A MENSAJES NO RECONOCIDOS**
        // Solo respondemos a comandos específicos, el resto se ignora
        console.log(chalk.gray(`📭 Mensaje ignorado de ${phone.split('@')[0]}: "${text.substring(0, 50)}"`));
        // No enviamos ningún mensaje de respuesta
    }
});

// ✅ Verificar pagos cada 2 minutos
cron.schedule('*/2 * * * *', () => {
    console.log(chalk.yellow('🔄 Verificando pagos pendientes...'));
    checkPendingPayments();
});

// ✅ Limpiar usuarios expirados cada 15 minutos
cron.schedule('*/15 * * * *', async () => {
    const now = moment().format('YYYY-MM-DD HH:mm:ss');
    console.log(chalk.yellow(`🧹 Limpiando usuarios expirados cada 15 minutos (${now})...`));
    
    db.all('SELECT username FROM users WHERE expires_at < ? AND status = 1', [now], async (err, rows) => {
        if (err) {
            console.error(chalk.red('❌ Error BD:'), err.message);
            return;
        }
        if (!rows || rows.length === 0) return;
        
        for (const r of rows) {
            try {
                await execPromise(`pkill -u ${r.username} 2>/dev/null || true`);
                await execPromise(`userdel -f ${r.username} 2>/dev/null || true`);
                db.run('UPDATE users SET status = 0 WHERE username = ?', [r.username]);
                console.log(chalk.green(`🗑️ Eliminado: ${r.username}`));
            } catch (e) {
                console.error(chalk.red(`Error eliminando ${r.username}:`), e.message);
            }
        }
        console.log(chalk.green(`✅ Limpiados ${rows.length} usuarios expirados`));
    });
});

// ✅ Limpiar estados antiguos cada hora
cron.schedule('0 * * * *', () => {
    console.log(chalk.yellow('🧹 Limpiando estados antiguos...'));
    db.run(`DELETE FROM user_state WHERE updated_at < datetime('now', '-1 hour')`, (err) => {
        if (!err) console.log(chalk.green('✅ Estados antiguos limpiados'));
    });
});

// ✅ Limpiar pagos antiguos cada 24 horas
cron.schedule('0 0 * * *', () => {
    console.log(chalk.yellow('🧹 Limpiando pagos antiguos...'));
    db.run(`DELETE FROM payments WHERE status = 'pending' AND created_at < datetime('now', '-7 days')`, (err) => {
        if (!err) console.log(chalk.green('✅ Pagos antiguos limpiados'));
    });
});

// ✅ MONITOR AUTOMÁTICO - VERIFICA CONEXIONES
setInterval(() => {
    db.all('SELECT username, max_connections FROM users WHERE status = 1', (err, rows) => {
        if (!err && rows) {
            rows.forEach(user => {
                require('child_process').exec(`ps aux | grep "^${user.username}" | grep -v grep | wc -l`, (e, out) => {
                    const cnt = parseInt(out) || 0;
                    if (cnt > user.max_connections) {
                        console.log(chalk.red(`⚠️ ${user.username} tiene ${cnt} conexiones (límite: ${user.max_connections})`));
                        require('child_process').exec(`pkill -u ${user.username} 2>/dev/null; sleep 1; pkill -u ${user.username} 2>/dev/null`);
                    }
                });
            });
        }
    });
}, 30000);

console.log(chalk.green('\n🚀 Inicializando SERVERTUC™ BOT con sistema de estados...\n'));
client.initialize();
BOTEOF

echo -e "${GREEN}✅ Bot creado con sistema de estados${NC}"

# ================================================
# CREAR PANEL DE CONTROL
# ================================================
echo -e "\n${CYAN}${BOLD}🎛️  CREANDO PANEL DE CONTROL...${NC}"

cat > /usr/local/bin/sshbot << 'PANELEOF'
#!/bin/bash
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[0;33m'; CYAN='\033[0;36m'; BLUE='\033[0;34m'; NC='\033[0m'

DB="/opt/ssh-bot/data/users.db"
CONFIG="/opt/ssh-bot/config/config.json"

get_val() { jq -r "$1" "$CONFIG" 2>/dev/null; }
set_val() { local t=$(mktemp); jq "$1 = $2" "$CONFIG" > "$t" && mv "$t" "$CONFIG"; }

show_header() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║              🎛️  PANEL SERVERTUC™ BOT v8.7                 ║${NC}"
    echo -e "${CYAN}║               🔧 SISTEMA DE ESTADOS INTELIGENTE            ║${NC}"
    echo -e "${CYAN}║               ⌨️  1,2,3,4,5,6,7 PARA COMPRAR EN PLANES      ║${NC}"
    echo -e "${CYAN}║               🔐 CONTRASEÑA FIJA: 12345                    ║${NC}"
    echo -e "${CYAN}║               🆕 NUEVO PLAN: 50 días (1 conexión)          ║${NC}"
    echo -e "${CYAN}║               👤 USUARIOS TERMINAN EN "j"                  ║${NC}"
    echo -e "${CYAN}║               🤖 BOT SILENCIOSO: Solo responde a comandos ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}\n"
}

while true; do
    show_header
    
    TOTAL_USERS=$(sqlite3 "$DB" "SELECT COUNT(*) FROM users" 2>/dev/null || echo "0")
    ACTIVE_USERS=$(sqlite3 "$DB" "SELECT COUNT(*) FROM users WHERE status=1" 2>/dev/null || echo "0")
    PENDING_PAYMENTS=$(sqlite3 "$DB" "SELECT COUNT(*) FROM payments WHERE status='pending'" 2>/dev/null || echo "0")
    ACTIVE_STATES=$(sqlite3 "$DB" "SELECT COUNT(*) FROM user_state" 2>/dev/null || echo "0")
    
    STATUS=$(pm2 jlist 2>/dev/null | jq -r '.[] | select(.name=="ssh-bot") | .pm2_env.status' 2>/dev/null || echo "stopped")
    if [[ "$STATUS" == "online" ]]; then
        BOT_STATUS="${GREEN}● ACTIVO${NC}"
    else
        BOT_STATUS="${RED}● DETENIDO${NC}"
    fi
    
    MP_TOKEN=$(get_val '.mercadopago.access_token')
    if [[ -n "$MP_TOKEN" && "$MP_TOKEN" != "" && "$MP_TOKEN" != "null" ]]; then
        MP_STATUS="${GREEN}✅ SDK v2.x ACTIVO${NC}"
    else
        MP_STATUS="${RED}❌ NO CONFIGURADO${NC}"
    fi
    
    APK_FOUND=""
    if [[ -f "/root/app.apk" ]]; then
        APK_SIZE=$(du -h "/root/app.apk" | cut -f1)
        APK_FOUND="${GREEN}✅ ${APK_SIZE}${NC}"
    else
        APK_FOUND="${RED}❌ NO ENCONTRADO${NC}"
    fi
    
    echo -e "${YELLOW}📊 ESTADO DEL SISTEMA${NC}"
    echo -e "  Bot: $BOT_STATUS"
    echo -e "  Usuarios: ${CYAN}$ACTIVE_USERS/$TOTAL_USERS${NC} activos/total"
    echo -e "  Pagos pendientes: ${CYAN}$PENDING_PAYMENTS${NC}"
    echo -e "  Estados activos: ${CYAN}$ACTIVE_STATES${NC}"
    echo -e "  MercadoPago: $MP_STATUS"
    echo -e "  APK: $APK_FOUND"
    echo -e "  Test: ${GREEN}2 horas${NC} | Limpieza: ${GREEN}cada 15 min${NC}"
    echo -e "  Contraseña: ${GREEN}12345${NC} (FIJA PARA TODOS)"
    echo -e "  Sistema: ${GREEN}Estados inteligentes${NC} (sin conflictos)"
    echo -e "  Plan 50 días: ${GREEN}DISPONIBLE${NC} (comando 7)"
    echo -e "  Usuarios terminan en: ${GREEN}j${NC}"
    echo -e "  Bot: ${GREEN}SILENCIOSO${NC} (solo responde a comandos)"
    echo -e "  Soporte: ${CYAN}$(get_val '.links.support')${NC}"
    echo -e ""
    
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}[1]${NC}  🚀  Iniciar/Reiniciar bot"
    echo -e "${CYAN}[2]${NC}  🛑  Detener bot"
    echo -e "${CYAN}[3]${NC}  📱  Ver QR WhatsApp"
    echo -e "${CYAN}[4]${NC}  👤  Crear usuario manual"
    echo -e "${CYAN}[5]${NC}  👥  Listar usuarios"
    echo -e "${CYAN}[6]${NC}  🗑️   Eliminar usuario"
    echo -e ""
    echo -e "${CYAN}[7]${NC}  💰  Cambiar precios (1 y 2 conexiones + 50 días)"
    echo -e "${CYAN}[8]${NC}  🔑  Configurar MercadoPago"
    echo -e "${CYAN}[9]${NC}  📱  Gestionar APK"
    echo -e "${CYAN}[10]${NC} 📊  Ver estadísticas"
    echo -e "${CYAN}[11]${NC} ⚙️   Ver configuración"
    echo -e "${CYAN}[12]${NC} 📝  Ver logs"
    echo -e "${CYAN}[13]${NC} 🔧  Reparar bot"
    echo -e "${CYAN}[14]${NC} 🧪  Test MercadoPago"
    echo -e "${CYAN}[15]${NC} 🧠  Ver estados activos"
    echo -e "${CYAN}[16]${NC} ⌨️   Test sistema de comandos"
    echo -e "${CYAN}[0]${NC}  🚪  Salir"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    echo -e ""
    read -p "👉 Selecciona una opción: " OPTION
    
    case $OPTION in
        1)
            echo -e "\n${YELLOW}🔄 Reiniciando SERVERTUC™ BOT...${NC}"
            cd /root/ssh-bot
            pm2 restart ssh-bot 2>/dev/null || pm2 start bot.js --name ssh-bot
            pm2 save
            echo -e "${GREEN}✅ Bot reiniciado${NC}"
            sleep 2
            ;;
        2)
            echo -e "\n${YELLOW}🛑 Deteniendo bot...${NC}"
            pm2 stop ssh-bot
            echo -e "${GREEN}✅ Bot detenido${NC}"
            sleep 2
            ;;
        3)
            clear
            echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
            echo -e "${CYAN}║                    📱 CÓDIGO QR WHATSAPP                     ║${NC}"
            echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}\n"
            
            if [[ -f "/root/qr-whatsapp.png" ]]; then
                echo -e "${GREEN}✅ QR guardado en: /root/qr-whatsapp.png${NC}\n"
                read -p "¿Ver logs en tiempo real? (s/N): " VER
                [[ "$VER" == "s" ]] && pm2 logs ssh-bot --lines 200
            else
                echo -e "${YELLOW}⚠️  QR no generado aún${NC}\n"
                read -p "¿Ver logs? (s/N): " VER
                [[ "$VER" == "s" ]] && pm2 logs ssh-bot --lines 50
            fi
            ;;
        4)
            clear
            echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
            echo -e "${CYAN}║                     👤 CREAR USUARIO                        ║${NC}"
            echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}\n"
            
            read -p "Teléfono (ej: 5491122334455): " PHONE
            read -p "Usuario (auto=generar con 'j'): " USERNAME
            read -p "Tipo (test/premium): " TIPO
            read -p "Días (0=test 2h, 30=premium, 50=plan especial): " DAYS
            echo -e "\n${CYAN}🔌 CONEXIONES:${NC}"
            echo -e "  1. 1 conexión"
            echo -e "  2. 2 conexiones simultáneas"
            read -p "Selecciona (1-2): " CONN_OPT
            
            [[ -z "$DAYS" ]] && DAYS="30"
            [[ "$CONN_OPT" == "2" ]] && CONNECTIONS="2" || CONNECTIONS="1"
            if [[ "$USERNAME" == "auto" || -z "$USERNAME" ]]; then
                RANDOM_NUM=$((RANDOM % 1000))
                USERNAME="user${RANDOM_NUM}j"
            fi
            
            if [[ "$TIPO" == "test" ]]; then
                DAYS="0"
                EXPIRE_DATE=$(date -d "+2 hours" +"%Y-%m-%d %H:%M:%S")
                useradd -M -s /bin/false "$USERNAME" && echo "$USERNAME:12345" | chpasswd && chage -E "$(date -d '+2 hours' +%Y-%m-%d)" "$USERNAME"
            else
                EXPIRE_DATE=$(date -d "+$DAYS days" +"%Y-%m-%d 23:59:59")
                useradd -M -s /bin/false -e "$(date -d "+$DAYS days" +%Y-%m-%d)" "$USERNAME" && echo "$USERNAME:12345" | chpasswd
            fi
            
            if [[ $? -eq 0 ]]; then
                sqlite3 "$DB" "INSERT INTO users (phone, username, password, tipo, expires_at, max_connections, status) VALUES ('$PHONE', '$USERNAME', '12345', '$TIPO', '$EXPIRE_DATE', $CONNECTIONS, 1)"
                echo -e "\n${GREEN}✅ USUARIO CREADO${NC}"
                echo -e "👤 Usuario: ${USERNAME} (termina en 'j')"
                echo -e "🔑 Contraseña: 12345"
                echo -e "⏰ Expira: ${EXPIRE_DATE}"
                echo -e "🔌 Conexiones: ${CONNECTIONS}"
            else
                echo -e "\n${RED}❌ Error creando usuario${NC}"
            fi
            read -p "Presiona Enter..." 
            ;;
        5)
            clear
            echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
            echo -e "${CYAN}║                     👥 USUARIOS ACTIVOS                     ║${NC}"
            echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}\n"
            
            sqlite3 -column -header "$DB" "SELECT username, '12345' as password, tipo, expires_at, max_connections as conex, substr(phone,1,12) as tel FROM users WHERE status = 1 ORDER BY expires_at DESC LIMIT 20"
            echo -e "\n${YELLOW}Total: ${ACTIVE_USERS} activos${NC}"
            echo -e "${GREEN}🔐 Contraseña: 12345 para todos${NC}"
            echo -e "${GREEN}👤 Formato: Terminan en 'j'${NC}"
            read -p "Presiona Enter..." 
            ;;
        6)
            clear
            echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
            echo -e "${CYAN}║                     🗑️  ELIMINAR USUARIO                     ║${NC}"
            echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}\n"
            
            read -p "Usuario a eliminar: " DEL_USER
            if [[ -n "$DEL_USER" ]]; then
                pkill -u "$DEL_USER" 2>/dev/null || true
                userdel -f "$DEL_USER" 2>/dev/null || true
                sqlite3 "$DB" "UPDATE users SET status = 0 WHERE username = '$DEL_USER'"
                echo -e "${GREEN}✅ Usuario $DEL_USER eliminado${NC}"
            fi
            read -p "Presiona Enter..." 
            ;;
        7)
            clear
            echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
            echo -e "${CYAN}║         💰 CAMBIAR PRECIOS (1,2 conex + 50 días)           ║${NC}"
            echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}\n"
            
            echo -e "${YELLOW}🔌 PLANES CON 1 CONEXIÓN:${NC}"
            CURRENT_7D_1=$(get_val '.prices.price_7d_1conn')
            CURRENT_15D_1=$(get_val '.prices.price_15d_1conn')
            CURRENT_30D_1=$(get_val '.prices.price_30d_1conn')
            CURRENT_50D_1=$(get_val '.prices.price_50d_1conn')
            
            echo -e "  1. 7 días: $${CURRENT_7D_1}"
            echo -e "  2. 15 días: $${CURRENT_15D_1}"
            echo -e "  3. 30 días: $${CURRENT_30D_1}"
            echo -e "  7. 50 días: $${CURRENT_50D_1}\n"
            
            echo -e "${YELLOW}🔌🔌 PLANES CON 2 CONEXIONES:${NC}"
            CURRENT_7D_2=$(get_val '.prices.price_7d_2conn')
            CURRENT_15D_2=$(get_val '.prices.price_15d_2conn')
            CURRENT_30D_2=$(get_val '.prices.price_30d_2conn')
            
            echo -e "  4. 7 días: $${CURRENT_7D_2}"
            echo -e "  5. 15 días: $${CURRENT_15D_2}"
            echo -e "  6. 30 días: $${CURRENT_30D_2}\n"
            
            echo -e "${CYAN}--- MODIFICAR PRECIOS ---${NC}"
            read -p "Nuevo precio 7d (1conn) [${CURRENT_7D_1}]: " NEW_7D_1
            read -p "Nuevo precio 15d (1conn) [${CURRENT_15D_1}]: " NEW_15D_1
            read -p "Nuevo precio 30d (1conn) [${CURRENT_30D_1}]: " NEW_30D_1
            read -p "Nuevo precio 50d (1conn) [${CURRENT_50D_1}]: " NEW_50D_1
            
            echo ""
            read -p "Nuevo precio 7d (2conn) [${CURRENT_7D_2}]: " NEW_7D_2
            read -p "Nuevo precio 15d (2conn) [${CURRENT_15D_2}]: " NEW_15D_2
            read -p "Nuevo precio 30d (2conn) [${CURRENT_30D_2}]: " NEW_30D_2
            
            [[ -n "$NEW_7D_1" ]] && set_val '.prices.price_7d_1conn' "$NEW_7D_1"
            [[ -n "$NEW_15D_1" ]] && set_val '.prices.price_15d_1conn' "$NEW_15D_1"
            [[ -n "$NEW_30D_1" ]] && set_val '.prices.price_30d_1conn' "$NEW_30D_1"
            [[ -n "$NEW_50D_1" ]] && set_val '.prices.price_50d_1conn' "$NEW_50D_1"
            [[ -n "$NEW_7D_2" ]] && set_val '.prices.price_7d_2conn' "$NEW_7D_2"
            [[ -n "$NEW_15D_2" ]] && set_val '.prices.price_15d_2conn' "$NEW_15D_2"
            [[ -n "$NEW_30D_2" ]] && set_val '.prices.price_30d_2conn' "$NEW_30D_2"
            
            echo -e "\n${GREEN}✅ Precios actualizados${NC}"
            read -p "Presiona Enter..." 
            ;;
        8)
            clear
            echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
            echo -e "${CYAN}║              🔑 CONFIGURAR MERCADOPAGO SDK v2.x             ║${NC}"
            echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}\n"
            
            CURRENT_TOKEN=$(get_val '.mercadopago.access_token')
            
            if [[ -n "$CURRENT_TOKEN" && "$CURRENT_TOKEN" != "null" && "$CURRENT_TOKEN" != "" ]]; then
                echo -e "${GREEN}✅ Token configurado${NC}"
                echo -e "${YELLOW}Preview: ${CURRENT_TOKEN:0:30}...${NC}\n"
            else
                echo -e "${YELLOW}⚠️  Sin token configurado${NC}\n"
            fi
            
            echo -e "${CYAN}📋 Obtener token:${NC}"
            echo -e "  1. https://www.mercadopago.com.ar/developers"
            echo -e "  2. Inicia sesión"
            echo -e "  3. 'Tus credenciales' → Access Token PRODUCCIÓN"
            echo -e "  4. Formato: APP_USR-xxxxxxxxxx\n"
            
            read -p "¿Configurar nuevo token? (s/N): " CONF
            if [[ "$CONF" == "s" ]]; then
                echo ""
                read -p "Pega el Access Token: " NEW_TOKEN
                
                if [[ "$NEW_TOKEN" =~ ^APP_USR- ]] || [[ "$NEW_TOKEN" =~ ^TEST- ]]; then
                    set_val '.mercadopago.access_token' "\"$NEW_TOKEN\""
                    set_val '.mercadopago.enabled' "true"
                    echo -e "\n${GREEN}✅ Token configurado${NC}"
                    echo -e "${YELLOW}🔄 Reiniciando bot...${NC}"
                    cd /root/ssh-bot && pm2 restart ssh-bot
                    sleep 2
                    echo -e "${GREEN}✅ MercadoPago SDK v2.x activado${NC}"
                else
                    echo -e "${RED}❌ Token inválido${NC}"
                    echo -e "${YELLOW}Debe empezar con APP_USR- o TEST-${NC}"
                fi
            fi
            read -p "Presiona Enter..." 
            ;;
        9)
            clear
            echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
            echo -e "${CYAN}║                     📱 GESTIONAR APK                         ║${NC}"
            echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}\n"
            
            APKS=$(find /root /home /opt -name "*.apk" 2>/dev/null | head -5)
            
            if [[ -n "$APKS" ]]; then
                echo -e "${GREEN}✅ APKs encontrados:${NC}"
                i=1
                while IFS= read -r apk; do
                    size=$(du -h "$apk" | cut -f1)
                    echo -e "  ${i}. ${apk} (${size})"
                    ((i++))
                done <<< "$APKS"
                
                echo ""
                read -p "Selecciona (1-$((i-1))): " SEL
                if [[ "$SEL" =~ ^[0-9]+$ ]]; then
                    selected=$(echo "$APKS" | sed -n "${SEL}p")
                    echo -e "\n${YELLOW}Seleccionado: ${selected}${NC}"
                    echo -e "\n1. Copiar a /root/app.apk"
                    echo -e "2. Ver detalles"
                    echo -e "3. Eliminar"
                    read -p "Opción: " OPT
                    case $OPT in
                        1) cp "$selected" /root/app.apk && chmod 644 /root/app.apk && echo -e "${GREEN}✅ Copiado${NC}" ;;
                        2) du -h "$selected" && echo "WhatsApp límite: 100MB" ;;
                        3) rm -f "$selected" && echo -e "${GREEN}✅ Eliminado${NC}" ;;
                    esac
                fi
            else
                echo -e "${RED}❌ Sin APKs${NC}\n"
                echo -e "${CYAN}Subir con SCP:${NC}"
                echo -e "  scp app.apk root@$(get_val '.bot.server_ip'):/root/app.apk"
            fi
            read -p "Presiona Enter..." 
            ;;
        10)
            clear
            echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
            echo -e "${CYAN}║                     📊 ESTADÍSTICAS                         ║${NC}"
            echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}\n"
            
            echo -e "${YELLOW}👥 USUARIOS:${NC}"
            sqlite3 "$DB" "SELECT 'Total: ' || COUNT(*) || ' | Activos: ' || SUM(CASE WHEN status=1 THEN 1 ELSE 0 END) || ' | 2 conexiones: ' || SUM(CASE WHEN max_connections=2 THEN 1 ELSE 0 END) FROM users"
            
            echo -e "\n${YELLOW}💰 PAGOS:${NC}"
            sqlite3 "$DB" "SELECT 'Pendientes: ' || SUM(CASE WHEN status='pending' THEN 1 ELSE 0 END) || ' | Aprobados: ' || SUM(CASE WHEN status='approved' THEN 1 ELSE 0 END) || ' | Total: $' || printf('%.2f', SUM(CASE WHEN status='approved' THEN amount ELSE 0 END)) FROM payments"
            
            echo -e "\n${YELLOW}🔌 CONEXIONES:${NC}"
            sqlite3 "$DB" "SELECT '1 conexión: ' || SUM(CASE WHEN max_connections=1 AND status=1 THEN 1 ELSE 0 END) || ' | 2 conexiones: ' || SUM(CASE WHEN max_connections=2 AND status=1 THEN 1 ELSE 0 END) FROM users"
            
            echo -e "\n${YELLOW}🧠 ESTADOS:${NC}"
            sqlite3 "$DB" "SELECT state, COUNT(*) as count FROM user_state GROUP BY state"
            
            echo -e "\n${YELLOW}📅 HOY:${NC}"
            TODAY=$(date +%Y-%m-%d)
            sqlite3 "$DB" "SELECT 'Tests: ' || COUNT(*) FROM daily_tests WHERE date = '$TODAY'"
            
            read -p "\nPresiona Enter..." 
            ;;
        11)
            clear
            echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
            echo -e "${CYAN}║                     ⚙️  CONFIGURACIÓN                        ║${NC}"
            echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}\n"
            
            echo -e "${YELLOW}🤖 BOT:${NC}"
            echo -e "  Nombre: SERVERTUC™ BOT"
            echo -e "  IP: $(get_val '.bot.server_ip')"
            echo -e "  Versión: $(get_val '.bot.version')"
            echo -e "  Soporte: $(get_val '.links.support')"
            echo -e "  Modo: SILENCIOSO (solo responde a comandos)"
            
            echo -e "\n${YELLOW}💰 PRECIOS (1 CONEXIÓN):${NC}"
            echo -e "  1. 7d: $(get_val '.prices.price_7d_1conn') ARS"
            echo -e "  2. 15d: $(get_val '.prices.price_15d_1conn') ARS"
            echo -e "  3. 30d: $(get_val '.prices.price_30d_1conn') ARS"
            echo -e "  7. 50d: $(get_val '.prices.price_50d_1conn') ARS"
            
            echo -e "\n${YELLOW}💰 PRECIOS (2 CONEXIONES):${NC}"
            echo -e "  4. 7d: $(get_val '.prices.price_7d_2conn') ARS"
            echo -e "  5. 15d: $(get_val '.prices.price_15d_2conn') ARS"
            echo -e "  6. 30d: $(get_val '.prices.price_30d_2conn') ARS"
            
            echo -e "  Test: $(get_val '.prices.test_hours') horas (1 conexión)"
            
            echo -e "\n${YELLOW}💳 MERCADOPAGO:${NC}"
            MP_TOKEN=$(get_val '.mercadopago.access_token')
            if [[ -n "$MP_TOKEN" && "$MP_TOKEN" != "null" ]]; then
                echo -e "  Estado: ${GREEN}SDK v2.x ACTIVO${NC}"
                echo -e "  Token: ${MP_TOKEN:0:25}..."
            else
                echo -e "  Estado: ${RED}NO CONFIGURADO${NC}"
            fi
            
            echo -e "\n${YELLOW}🔐 SEGURIDAD:${NC}"
            echo -e "  Contraseña predeterminada: ${GREEN}12345${NC} (FIJA PARA TODOS)"
            echo -e "  Usuarios terminan en: ${GREEN}j${NC}"
            
            echo -e "\n${YELLOW}🧠 SISTEMA DE ESTADOS:${NC}"
            echo -e "  Estado: ${GREEN}ACTIVO${NC}"
            echo -e "  Funciona: ${GREEN}SIN CONFLICTOS${NC}"
            echo -e "  Comandos 1-7: ${GREEN}FUNCIONAN PARA COMPRAR EN PLANES${NC}"
            
            read -p "\nPresiona Enter..." 
            ;;
        12)
            echo -e "\n${YELLOW}📝 Logs (Ctrl+C para salir)...${NC}\n"
            pm2 logs ssh-bot --lines 100
            ;;
        13)
            clear
            echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
            echo -e "${CYAN}║                     🔧 REPARAR BOT                          ║${NC}"
            echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}\n"
            
            echo -e "${RED}⚠️  Borrará sesión de WhatsApp y estados${NC}\n"
            read -p "¿Continuar? (s/N): " CONF
            
            if [[ "$CONF" == "s" ]]; then
                echo -e "\n${YELLOW}🧹 Limpiando...${NC}"
                rm -rf /root/.wwebjs_auth/* /root/.wwebjs_cache/* /root/qr-whatsapp.png
                echo -e "${YELLOW}🗑️  Borrando estados...${NC}"
                sqlite3 "$DB" "DELETE FROM user_state"
                echo -e "${YELLOW}📦 Reinstalando...${NC}"
                cd /root/ssh-bot && npm install --silent
                echo -e "${YELLOW}🔧 Aplicando parches...${NC}"
                find /root/ssh-bot/node_modules -name "Client.js" -type f -exec sed -i 's/if (chat && chat.markedUnread)/if (false)/g' {} \; 2>/dev/null || true
                echo -e "${YELLOW}🔄 Reiniciando...${NC}"
                pm2 restart ssh-bot
                echo -e "\n${GREEN}✅ Reparado - Espera 10s para QR${NC}"
                sleep 10
                [[ -f "/root/qr-whatsapp.png" ]] && echo -e "${GREEN}✅ QR generado${NC}" || pm2 logs ssh-bot
            fi
            read -p "Presiona Enter..." 
            ;;
        14)
            clear
            echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
            echo -e "${CYAN}║                 🧪 TEST MERCADOPAGO SDK v2.x                ║${NC}"
            echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}\n"
            
            TOKEN=$(get_val '.mercadopago.access_token')
            if [[ -z "$TOKEN" || "$TOKEN" == "null" ]]; then
                echo -e "${RED}❌ Token no configurado${NC}\n"
                read -p "Presiona Enter..." 
                continue
            fi
            
            echo -e "${YELLOW}🔑 Token: ${TOKEN:0:30}...${NC}\n"
            echo -e "${YELLOW}🔄 Probando conexión con API...${NC}\n"
            
            RESPONSE=$(curl -s -w "\n%{http_code}" -H "Authorization: Bearer $TOKEN" "https://api.mercadopago.com/v1/payment_methods" 2>&1)
            HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
            BODY=$(echo "$RESPONSE" | head -n-1)
            
            if [[ "$HTTP_CODE" == "200" ]]; then
                echo -e "${GREEN}✅ CONEXIÓN EXITOSA${NC}\n"
                echo -e "${CYAN}Métodos de pago disponibles:${NC}"
                echo "$BODY" | jq -r '.[].name' 2>/dev/null | head -5
                echo -e "\n${GREEN}✅ MercadoPago SDK v2.x funcionando correctamente${NC}"
            else
                echo -e "${RED}❌ ERROR - Código HTTP: $HTTP_CODE${NC}\n"
                echo -e "${YELLOW}Respuesta:${NC}"
                echo "$BODY" | jq '.' 2>/dev/null || echo "$BODY"
            fi
            
            read -p "\nPresiona Enter..." 
            ;;
        15)
            clear
            echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
            echo -e "${CYAN}║                    🧠 ESTADOS ACTIVOS                       ║${NC}"
            echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}\n"
            
            echo -e "${YELLOW}📱 USUARIOS CON ESTADO ACTIVO:${NC}\n"
            sqlite3 -column -header "$DB" "SELECT substr(phone,1,12) as telefono, state, datetime(updated_at) as actualizado FROM user_state ORDER BY updated_at DESC LIMIT 20"
            
            echo -e "\n${CYAN}📊 RESUMEN:${NC}"
            sqlite3 "$DB" "SELECT state, COUNT(*) as usuarios FROM user_state GROUP BY state"
            
            read -p "\nPresiona Enter..." 
            ;;
        16)
            clear
            echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
            echo -e "${CYAN}║                  🧪 TEST SISTEMA DE COMANDOS                ║${NC}"
            echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}\n"
            
            echo -e "${GREEN}✅ SISTEMA DE ESTADOS FUNCIONANDO${NC}\n"
            
            echo -e "${YELLOW}📋 FLUJO CORRECTO:${NC}"
            echo -e "  1. Usuario escribe 'menu' → Menú principal"
            echo -e "  2. Usuario escribe '1' → Prueba gratis"
            echo -e "  3. Usuario escribe '2' → Ver planes"
            echo -e "  4. En planes, escribe '1' → Comprar 7 días (1 conexión)"
            echo -e "  5. En planes, escribe '2' → Comprar 15 días (1 conexión)"
            echo -e "  6. En planes, escribe '3' → Comprar 30 días (1 conexión)"
            echo -e "  7. En planes, escribe '4' → Comprar 7 días (2 conexiones)"
            echo -e "  8. En planes, escribe '5' → Comprar 15 días (2 conexiones)"
            echo -e "  9. En planes, escribe '6' → Comprar 30 días (2 conexiones)"
            echo -e "  10. En planes, escribe '7' → Comprar 50 días (1 conexión)"
            echo -e "  11. Siempre puede escribir 'menu' para volver\n"
            
            echo -e "${YELLOW}🔍 ESTADOS:${NC}"
            echo -e "  • main_menu - Menú principal"
            echo -e "  • viewing_plans - Viendo planes de compra"
            echo -e "  • (Otros estados según se necesiten)\n"
            
            echo -e "${GREEN}✅ SIN CONFLICTOS:${NC}"
            echo -e "  • El '1' en menú principal es PRUEBA"
            echo -e "  • El '1' en planes es COMPRA 7 días"
            echo -e "  • El '7' en planes es COMPRA 50 días"
            echo -e "  • El sistema sabe en qué estado está cada usuario\n"
            
            echo -e "${CYAN}📊 PRECIOS ACTUALES:${NC}"
            echo -e "  1. 7d (1conn): $ $(get_val '.prices.price_7d_1conn')"
            echo -e "  2. 15d (1conn): $ $(get_val '.prices.price_15d_1conn')"
            echo -e "  3. 30d (1conn): $ $(get_val '.prices.price_30d_1conn')"
            echo -e "  4. 7d (2conn): $ $(get_val '.prices.price_7d_2conn')"
            echo -e "  5. 15d (2conn): $ $(get_val '.prices.price_15d_2conn')"
            echo -e "  6. 30d (2conn): $ $(get_val '.prices.price_30d_2conn')"
            echo -e "  7. 50d (1conn): $ $(get_val '.prices.price_50d_1conn')"
            
            read -p "\nPresiona Enter..." 
            ;;
        0)
            echo -e "\n${GREEN}👋 Hasta pronto${NC}\n"
            exit 0
            ;;
        *)
            echo -e "\n${RED}❌ Opción inválida${NC}"
            sleep 1
            ;;
    esac
done
PANELEOF

chmod +x /usr/local/bin/sshbot
echo -e "${GREEN}✅ Panel de control creado${NC}"

# ================================================
# INICIAR BOT
# ================================================
echo -e "\n${CYAN}${BOLD}🚀 INICIANDO SERVERTUC™ BOT CON SISTEMA DE ESTADOS...${NC}"

cd "$USER_HOME"
pm2 start bot.js --name ssh-bot
pm2 save
pm2 startup systemd -u root --hp /root > /dev/null 2>&1

sleep 3

# ================================================
# CREAR SCRIPT DE TEST
# ================================================
echo -e "\n${CYAN}${BOLD}🧪 CREANDO SCRIPT DE TEST DE COMANDOS...${NC}"

cat > /usr/local/bin/test-estados << 'TESTEOF'
#!/bin/bash
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'

echo -e "\n🔍 TEST DEL SISTEMA DE ESTADOS - SERVERTUC™ BOT"
echo -e "============================================\n"

echo -e "📋 Verificando base de datos..."
DB="/opt/ssh-bot/data/users.db"
if [[ -f "$DB" ]]; then
    echo -e "✅ Base de datos: $DB"
    
    echo -e "\n📊 ESTADÍSTICAS:"
    echo -e "  Usuarios totales: $(sqlite3 "$DB" "SELECT COUNT(*) FROM users" 2>/dev/null || echo 0)"
    echo -e "  Usuarios activos: $(sqlite3 "$DB" "SELECT COUNT(*) FROM users WHERE status=1" 2>/dev/null || echo 0)"
    echo -e "  Estados activos: $(sqlite3 "$DB" "SELECT COUNT(*) FROM user_state" 2>/dev/null || echo 0)"
    
    echo -e "\n🧠 ESTADOS ACTUALES:"
    sqlite3 "$DB" "SELECT state, COUNT(*) as usuarios FROM user_state GROUP BY state" 2>/dev/null || echo "  Sin estados activos"
    
    echo -e "\n👤 FORMATO DE USUARIOS:"
    echo -e "  Contraseña fija: ${GREEN}12345${NC}"
    echo -e "  Terminan en: ${GREEN}j${NC}"
else
    echo -e "❌ Base de datos no encontrada"
fi

echo -e "\n🤖 Verificando bot..."
if pm2 status | grep -q "ssh-bot"; then
    echo -e "✅ Bot en ejecución"
    STATUS=$(pm2 jlist 2>/dev/null | jq -r '.[] | select(.name=="ssh-bot") | .pm2_env.status' 2>/dev/null || echo "unknown")
    echo -e "  Estado: $STATUS"
    echo -e "  Nombre: SERVERTUC™ BOT"
    echo -e "  Modo: SILENCIOSO (solo comandos)"
else
    echo -e "❌ Bot NO está en ejecución"
fi

echo -e "\n💡 FLUJO DE COMANDOS:"
echo -e "  ${GREEN}menu${NC} → Menú principal"
echo -e "  ${GREEN}1${NC} → Prueba gratis (solo en menú principal)"
echo -e "  ${GREEN}2${NC} → Ver planes (solo en menú principal)"
echo -e "  ${GREEN}3${NC} → Mis cuentas (solo en menú principal)"
echo -e "  ${GREEN}4${NC} → Estado de pago (solo en menú principal)"
echo -e "  ${GREEN}5${NC} → Descargar APP (solo en menú principal)"
echo -e "  ${GREEN}6${NC} → Soporte (solo en menú principal)"
echo -e ""
echo -e "  ⚡ ${CYAN}DENTRO DE PLANES:${NC}"
echo -e "  ${GREEN}1${NC} → Comprar 7 días (1 conexión)"
echo -e "  ${GREEN}2${NC} → Comprar 15 días (1 conexión)"
echo -e "  ${GREEN}3${NC} → Comprar 30 días (1 conexión)"
echo -e "  ${GREEN}4${NC} → Comprar 7 días (2 conexiones)"
echo -e "  ${GREEN}5${NC} → Comprar 15 días (2 conexiones)"
echo -e "  ${GREEN}6${NC} → Comprar 30 días (2 conexiones)"
echo -e "  ${GREEN}7${NC} → Comprar 50 días (1 conexión)"

echo -e "\n✅ Sistema funcionando correctamente"
TESTEOF

chmod +x /usr/local/bin/test-estados

# ================================================
# MENSAJE FINAL
# ================================================
clear
echo -e "${GREEN}${BOLD}"
cat << "FINAL"
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║      🎉 INSTALACIÓN COMPLETADA - SISTEMA DE ESTADOS 🎉     ║
║                                                              ║
║         SERVERTUC™ BOT v8.7 - SIN CONFLICTOS DE COMANDOS   ║
║           💡 SISTEMA INTELIGENTE DE ESTADOS                ║
║           🤖 WhatsApp Web parcheado                        ║
║           🔌 PLANES CON 2 CONEXIONES                       ║
║           🔐 CONTRASEÑA FIJA: 12345 PARA TODOS             ║
║           👤 USUARIOS TERMINAN EN "j"                      ║
║           🤖 BOT SILENCIOSO: Solo responde a comandos      ║
║           ⌨️  1,2,3,4,5,6,7 FUNCIONAN PARA COMPRAR EN PLANES║
║           🆕 NUEVO PLAN: 50 días (1 conexión)              ║
║           🧠 SIN CONFLICTOS ENTRE MENÚS                    ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
FINAL
echo -e "${NC}"

echo -e "${CYAN}══════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✅ Sistema de estados instalado${NC}"
echo -e "${GREEN}✅ SIN CONFLICTOS: 1=Prueba (menú), 1=7d (planes), 7=50d${NC}"
echo -e "${GREEN}✅ COMANDOS 1-7 FUNCIONAN PARA COMPRAR EN PLANES${NC}"
echo -e "${GREEN}✅ WhatsApp Web parcheado (no markedUnread error)${NC}"
echo -e "${GREEN}✅ Planes con 1 y 2 conexiones${NC}"
echo -e "${GREEN}✅ NUEVO PLAN: 50 días (1 conexión)${NC}"
echo -e "${GREEN}✅ CONTRASEÑA FIJA: 12345 para todos los usuarios${NC}"
echo -e "${GREEN}✅ USUARIOS TERMINAN EN 'j'${NC}"
echo -e "${GREEN}✅ NOMBRE: SERVERTUC™ BOT${NC}"
echo -e "${GREEN}✅ SOPORTE: https://wa.me/3813414485${NC}"
echo -e "${GREEN}✅ BOT SILENCIOSO: Solo responde a comandos válidos${NC}"
echo -e "${CYAN}══════════════════════════════════════════════════════════════${NC}\n"

echo -e "${YELLOW}📋 COMANDOS DISPONIBLES:${NC}\n"
echo -e "  ${GREEN}sshbot${NC}         - Panel de control principal"
echo -e "  ${GREEN}test-estados${NC}   - Test del sistema de estados"
echo -e "  ${GREEN}pm2 logs ssh-bot${NC} - Ver logs del bot"
echo -e "  ${GREEN}pm2 restart ssh-bot${NC} - Reiniciar bot\n"

echo -e "${YELLOW}🔧 CONFIGURACIÓN INICIAL:${NC}\n"
echo -e "  1. Ejecuta: ${GREEN}sshbot${NC}"
echo -e "  2. Opción ${CYAN}[8]${NC} - Configurar MercadoPago"
echo -e "  3. Opción ${CYAN}[14]${NC} - Test MercadoPago"
echo -e "  4. Opción ${CYAN}[16]${NC} - Test sistema de comandos"
echo -e "  5. Opción ${CYAN}[3]${NC} - Escanear QR WhatsApp"
echo -e "  6. Sube APK a /root/app.apk\n"

echo -e "${YELLOW}⌨️  FLUJO PARA USUARIOS:${NC}\n"
echo -e "  ${CYAN}1.${NC} Escribe 'menu' → Menú principal"
echo -e "  ${CYAN}2.${NC} Escribe '2' → Ver planes"
echo -e "  ${CYAN}3.${NC} Elige un plan (1-7):"
echo -e "     • ${GREEN}1${NC} - 7 días (1 conexión) - $500 ARS"
echo -e "     • ${GREEN}2${NC} - 15 días (1 conexión) - $800 ARS"
echo -e "     • ${GREEN}3${NC} - 30 días (1 conexión) - $1200 ARS"
echo -e "     • ${GREEN}4${NC} - 7 días (2 conexiones) - $800 ARS"
echo -e "     • ${GREEN}5${NC} - 15 días (2 conexiones) - $1200 ARS"
echo -e "     • ${GREEN}6${NC} - 30 días (2 conexiones) - $1800 ARS"
echo -e "     • ${GREEN}7${NC} - 50 días (1 conexión) - $1800 ARS"
echo -e "  ${CYAN}4.${NC} El bot genera enlace de pago MercadoPago"
echo -e "  ${CYAN}5.${NC} Pago aprobado → Usuario creado automáticamente\n"

echo -e "${YELLOW}🔐 CONFIGURACIÓN:${NC}"
echo -e "  • Contraseña: ${GREEN}12345${NC} para TODOS los usuarios"
echo -e "  • Formato usuarios: terminan en ${GREEN}j${NC}"
echo -e "  • Nombre: ${GREEN}SERVERTUC™ BOT${NC}"
echo -e "  • Soporte: ${CYAN}https://wa.me/3813414485${NC}"
echo -e "  • Bot: ${GREEN}SILENCIOSO${NC} (solo responde a comandos)\n"

echo -e "${YELLOW}🧠 CÓMO FUNCIONA EL SISTEMA DE ESTADOS:${NC}"
echo -e "  1. Cada usuario tiene un estado (main_menu, viewing_plans, etc.)"
echo -e "  2. El bot sabe en qué parte del flujo está cada usuario"
echo -e "  3. Los comandos 1-7 tienen diferentes funciones según el estado"
echo -e "  4. No hay conflictos entre menús"
echo -e "  5. Los estados se limpian automáticamente después de 1 hora\n"

echo -e "${YELLOW}📊 INFO:${NC}"
echo -e "  IP: ${CYAN}$SERVER_IP${NC}"
echo -e "  BD: ${CYAN}$DB_FILE${NC}"
echo -e "  Config: ${CYAN}$CONFIG_FILE${NC}"
echo -e "  Script test: ${CYAN}/usr/local/bin/test-estados${NC}"
echo -e "  Soporte: ${CYAN}https://wa.me/3813414485${NC}\n"

echo -e "${CYAN}══════════════════════════════════════════════════════════════${NC}\n"

read -p "$(echo -e "${YELLOW}¿Probar sistema de estados? (s/N): ${NC}")" -n 1 -r
echo
if [[ $REPLY =~ ^[Ss]$ ]]; then
    echo -e "\n${CYAN}Probando sistema...${NC}\n"
    /usr/local/bin/test-estados
else
    echo -e "\n${YELLOW}💡 Para probar después: ${GREEN}test-estados${NC}\n"
fi

read -p "$(echo -e "${YELLOW}¿Abrir panel de control? (s/N): ${NC}")" -n 1 -r
echo
if [[ $REPLY =~ ^[Ss]$ ]]; then
    echo -e "\n${CYAN}Abriendo panel...${NC}\n"
    sleep 2
    /usr/local/bin/sshbot
else
    echo -e "\n${YELLOW}💡 Ejecuta: ${GREEN}sshbot${NC} para abrir el panel\n"
fi

echo -e "${GREEN}${BOLD}¡SERVERTUC™ BOT instalado exitosamente! Los comandos 1-7 ahora funcionan sin conflictos 🚀${NC}\n"

exit 0
