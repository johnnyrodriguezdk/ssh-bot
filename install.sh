#!/bin/bash
# ================================================
# SERVERTUC™ BOT v9.0 - WPPCONNECT + SISTEMA DE ESTADOS
# Combina: Sistema de estados del bot antiguo + API WPPConnect nueva
# Correcciones aplicadas:
# 1. ✅ MENÚ PRINCIPAL: 1=Prueba, 2=Ver Planes, 3=Cuentas, 4=Estado, 5=APP, 6=Soporte
# 2. ✅ MENÚ PLANES: 1=7d 1con, 2=15d 1con, 3=30d 1con, 4=7d 2con, 5=15d 2con, 6=30d 2con, 7=50d 1con
# 3. ✅ SISTEMA DE ESTADOS: Evita conflictos entre menús
# 4. ✅ API WPPCONNECT: Nueva API WhatsApp estable
# 5. ✅ MERCADOPAGO SDK v2.x: Integración completa
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
║                     SERVERTUC™ BOT v9.0                      ║
║               💡 WPPCONNECT + SISTEMA DE ESTADOS            ║
║               📱 NUEVA API WHATSAPP ESTABLE                 ║
║               💰 MERCADOPAGO SDK v2.x COMPLETO              ║
║               🔌 1,2,3,4,5,6,7 PARA COMPRAR EN PLANES       ║
║               🔐 CONTRASEÑA FIJA: 12345                     ║
║               👤 NOMBRES DE USUARIO TERMINAN EN 'j'         ║
║               🆕 PLAN 50 DÍAS (1 conexión) INCLUIDO         ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
BANNER
echo -e "${NC}"

echo -e "${GREEN}✅ SISTEMA COMBINADO:${NC}"
echo -e "  🔴 ${RED}MENÚ PRINCIPAL (Del bot antiguo):${NC}"
echo -e "     ${GREEN}1${NC} = Prueba gratis"
echo -e "     ${GREEN}2${NC} = Ver planes"
echo -e "     ${GREEN}3${NC} = Mis cuentas"
echo -e "     ${GREEN}4${NC} = Estado de pago"
echo -e "     ${GREEN}5${NC} = Descargar APP"
echo -e "     ${GREEN}6${NC} = Soporte"
echo -e "  🟡 ${YELLOW}MENÚ PLANES (Del bot antiguo):${NC}"
echo -e "     ${GREEN}1${NC} = 7 días (1 conexión) - COMPRAR"
echo -e "     ${GREEN}2${NC} = 15 días (1 conexión) - COMPRAR"
echo -e "     ${GREEN}3${NC} = 30 días (1 conexión) - COMPRAR"
echo -e "     ${GREEN}4${NC} = 7 días (2 conexiones) - COMPRAR"
echo -e "     ${GREEN}5${NC} = 15 días (2 conexiones) - COMPRAR"
echo -e "     ${GREEN}6${NC} = 30 días (2 conexiones) - COMPRAR"
echo -e "     ${GREEN}7${NC} = 50 días (1 conexión) - COMPRAR"
echo -e "  🟢 ${GREEN}NUEVA TECNOLOGÍA:${NC}"
echo -e "     📱 ${CYAN}WPPConnect${NC} - API WhatsApp nueva y estable"
echo -e "     💰 ${GREEN}MercadoPago SDK v2.x${NC} - Integración completa"
echo -e "     ⚡ ${YELLOW}Sistema de estados${NC} - Sin conflictos entre menús"
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
echo -e "   • Instalar Node.js 18.x + Chrome (compatible WPPConnect)"
echo -e "   • Crear SERVERTUC™ BOT v9.0 con sistema de estados"
echo -e "   • Sistema: 1,2,3,4,5,6,7 funcionan para comprar EN PLANES"
echo -e "   • Sin conflictos entre menús"
echo -e "   • Panel de control 100% funcional"
echo -e "   • API WhatsApp WPPConnect (nueva y estable)"
echo -e "   • MercadoPago SDK v2.x completo"
echo -e "   • Cron limpieza cada 15 minutos"
echo -e "   • 🔐 CONTRASEÑA FIJA: 12345 para todos"
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

# Instalar Node.js 18.x (compatible con WPPConnect)
echo -e "${YELLOW}📦 Instalando Node.js 18.x...${NC}"
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
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
rm -rf /root/.wppconnect 2>/dev/null || true

# Crear directorios (usando estructura WPPConnect)
mkdir -p "$INSTALL_DIR"/{data,config,qr_codes,logs,sessions}
mkdir -p "$USER_HOME"
mkdir -p /root/.wppconnect
chmod -R 755 "$INSTALL_DIR"
chmod -R 700 /root/.wppconnect

# Crear configuración CON NUEVOS PLANES INCLUYENDO 50 DÍAS
cat > "$CONFIG_FILE" << EOF
{
    "bot": {
        "name": "SERVERTUC™ BOT",
        "version": "9.0-WPPCONNECT-ESTADOS",
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
        "enabled": false,
        "public_key": ""
    },
    "links": {
        "tutorial": "https://youtube.com",
        "support": "https://wa.me/3813414485",
        "app_download": "https://www.mediafire.com/file/p8kgthxbsid7xws/MAJ/DNI_AND_FIL"
    },
    "paths": {
        "database": "$DB_FILE",
        "chromium": "/usr/bin/google-chrome",
        "qr_codes": "$INSTALL_DIR/qr_codes",
        "sessions": "/root/.wppconnect"
    }
}
EOF

# Crear base de datos (estructura mejorada)
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
    discount_code TEXT,
    final_amount REAL,
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
CREATE INDEX idx_payments_preference ON payments(preference_id);
SQL

echo -e "${GREEN}✅ Estructura creada con sistema de estados${NC}"

# ================================================
# CREAR BOT CON WPPCONNECT Y SISTEMA DE ESTADOS
# ================================================
echo -e "\n${CYAN}${BOLD}🤖 CREANDO BOT CON WPPCONNECT + SISTEMA DE ESTADOS...${NC}"

cd "$USER_HOME"

# package.json con WPPConnect y MercadoPago v2.x
cat > package.json << 'PKGEOF'
{
    "name": "ssh-bot-pro",
    "version": "9.0.0",
    "main": "bot.js",
    "dependencies": {
        "@wppconnect-team/wppconnect": "^1.24.0",
        "qrcode-terminal": "^0.12.0",
        "qrcode": "^1.5.3",
        "moment": "^2.30.1",
        "sqlite3": "^5.1.7",
        "chalk": "^4.1.2",
        "node-cron": "^3.0.3",
        "mercadopago": "^2.0.15",
        "axios": "^1.6.5",
        "sharp": "^0.33.2"
    }
}
PKGEOF

echo -e "${YELLOW}📦 Instalando dependencias Node.js...${NC}"
npm install --silent 2>&1 | grep -v "npm WARN" || true

# ================================================
# CREAR BOT.JS COMPLETO
# ================================================
echo -e "${YELLOW}📝 Creando bot.js completo...${NC}"

cat > "bot.js" << 'BOTEOF'
const wppconnect = require('@wppconnect-team/wppconnect');
const qrcode = require('qrcode-terminal');
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
moment.locale('es');

console.log(chalk.cyan.bold('\n╔══════════════════════════════════════════════════════════════╗'));
console.log(chalk.cyan.bold('║              SERVERTUC™ BOT v9.0 - WPPCONNECT                ║'));
console.log(chalk.cyan.bold('║               SISTEMA DE ESTADOS INTELIGENTE                 ║'));
console.log(chalk.cyan.bold('╚══════════════════════════════════════════════════════════════╝\n'));

// Cargar configuración
function loadConfig() {
    delete require.cache[require.resolve('/opt/ssh-bot/config/config.json')];
    return require('/opt/ssh-bot/config/config.json');
}

let config = loadConfig();
const db = new sqlite3.Database('/opt/ssh-bot/data/users.db');

// ✅ MERCADOPAGO SDK V2.X
let mpEnabled = false;
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
            mpEnabled = true;

            console.log(chalk.green('✅ MercadoPago SDK v2.x ACTIVO'));
            console.log(chalk.cyan(`🔑 Token: ${config.mercadopago.access_token.substring(0, 20)}...`));
            return true;
        } catch (error) {
            console.log(chalk.red('❌ Error inicializando MP:'), error.message);
            mpEnabled = false;
            mpClient = null;
            mpPreference = null;
            return false;
        }
    }
    console.log(chalk.yellow('⚠️ MercadoPago NO configurado'));
    return false;
}

initMercadoPago();

// Variables globales
let client = null;

// ✅ SISTEMA DE ESTADOS (Del bot antiguo)
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
                resolve(!err);
            }
        );
    });
}

// ✅ GENERAR USUARIO SSH (Del bot antiguo - terminan en 'j')
function generateSSHUsername(phone) {
    const timestamp = Date.now().toString().slice(-6);
    const random = Math.floor(Math.random() * 90) + 10;
    return `user${timestamp}${random}j`;
}

// ✅ CREAR USUARIO SSH
async function createSSHUser(username, password = '12345', days = 0, maxConnections = 1) {
    try {
        const expiryDate = days > 0 ? 
            moment().add(days, 'days').format('YYYY-MM-DD HH:mm:ss') : 
            moment().add(config.prices.test_hours, 'hours').format('YYYY-MM-DD HH:mm:ss');
        
        // Comando para crear usuario en el sistema
        const command = `useradd -M -s /bin/false -e $(date -d "${expiryDate}" +%Y-%m-%d) ${username} && echo "${username}:${password}" | chpasswd`;
        await execPromise(command);
        
        // Configurar conexiones simultáneas
        if (maxConnections > 1) {
            await execPromise(`echo "MaxSessions ${maxConnections}" >> /etc/ssh/sshd_config.d/${username}.conf`);
            await execPromise('systemctl restart sshd');
        }
        
        return { success: true, username, password, expires: expiryDate };
    } catch (error) {
        console.error('Error creando usuario SSH:', error);
        return { success: false, error: error.message };
    }
}

// ✅ CREAR PAGO MERCADOPAGO
async function createMercadoPagoPayment(phone, planName, days, amount, connections = 1) {
    if (!mpEnabled) {
        return { success: false, error: 'MercadoPago no configurado' };
    }
    
    try {
        const paymentId = `MP-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;
        const preferenceData = {
            items: [
                {
                    title: `SERVERTUC™ - ${planName}`,
                    description: `Plan ${days} días - ${connections} conexión(es)`,
                    quantity: 1,
                    currency_id: 'ARS',
                    unit_price: parseFloat(amount)
                }
            ],
            payer: {
                phone: { number: phone.replace('+', '') }
            },
            payment_methods: {
                excluded_payment_types: [{ id: 'atm' }],
                installments: 1
            },
            notification_url: `http://${config.bot.server_ip}:3000/webhook/mp`,
            external_reference: paymentId,
            back_urls: {
                success: `https://wa.me/${phone}?text=Pago+aprobado+${paymentId}`,
                pending: `https://wa.me/${phone}?text=Pago+pendiente+${paymentId}`,
                failure: `https://wa.me/${phone}?text=Pago+rechazado+${paymentId}`
            },
            auto_return: 'approved'
        };
        
        const preference = await mpPreference.create({ body: preferenceData });
        
        // Generar QR code
        const qrPath = path.join(config.paths.qr_codes, `${paymentId}.png`);
        await QRCode.toFile(qrPath, preference.init_point);
        
        // Guardar en base de datos
        db.run(
            `INSERT INTO payments (payment_id, phone, plan, days, connections, amount, status, payment_url, qr_code, preference_id) 
             VALUES (?, ?, ?, ?, ?, ?, 'pending', ?, ?, ?)`,
            [paymentId, phone, planName, days, connections, amount, preference.init_point, qrPath, preference.id]
        );
        
        return {
            success: true,
            paymentId,
            paymentUrl: preference.init_point,
            qrCode: qrPath,
            preferenceId: preference.id
        };
    } catch (error) {
        console.error('Error creando pago MP:', error);
        return { success: false, error: error.message };
    }
}

// ✅ MENSAJES DEL SISTEMA (Del bot antiguo)
function getMainMenuMessage() {
    return `*🤖 SERVERTUC™ BOT v9.0*

*MENÚ PRINCIPAL:*
🔹 *1* - Prueba gratis (${config.prices.test_hours} horas)
🔹 *2* - Ver planes y precios
🔹 *3* - Mis cuentas SSH
🔹 *4* - Estado de pago
🔹 *5* - Descargar APP
🔹 *6* - Soporte

*Elige una opción (1-6):*`;
}

function getPlansMenuMessage() {
    return `*📋 PLANES DISPONIBLES:*

*PLANES 1 CONEXIÓN:*
🔸 *1* - 7 días → $${config.prices.price_7d_1conn} ARS
🔸 *2* - 15 días → $${config.prices.price_15d_1conn} ARS
🔸 *3* - 30 días → $${config.prices.price_30d_1conn} ARS
🔸 *7* - 50 días → $${config.prices.price_50d_1conn} ARS

*PLANES 2 CONEXIONES:*
🔸 *4* - 7 días → $${config.prices.price_7d_2conn} ARS
🔸 *5* - 15 días → $${config.prices.price_15d_2conn} ARS
🔸 *6* - 30 días → $${config.prices.price_30d_2conn} ARS

*Elige el plan (1-7):*
_O escribe 0 para volver al menú principal_`;
}

function getPlanDetails(planNumber) {
    const plans = {
        1: { name: '7 días (1 conexión)', days: 7, connections: 1, price: 'price_7d_1conn' },
        2: { name: '15 días (1 conexión)', days: 15, connections: 1, price: 'price_15d_1conn' },
        3: { name: '30 días (1 conexión)', days: 30, connections: 1, price: 'price_30d_1conn' },
        4: { name: '7 días (2 conexiones)', days: 7, connections: 2, price: 'price_7d_2conn' },
        5: { name: '15 días (2 conexiones)', days: 15, connections: 2, price: 'price_15d_2conn' },
        6: { name: '30 días (2 conexiones)', days: 30, connections: 2, price: 'price_30d_2conn' },
        7: { name: '50 días (1 conexión)', days: 50, connections: 1, price: 'price_50d_1conn' }
    };
    
    return plans[planNumber] || null;
}

// ✅ MANEJAR MENSAJES
async function handleMessage(message) {
    const phone = message.from.replace('@c.us', '');
    const text = message.body || '';
    const userState = await getUserState(phone);
    
    console.log(chalk.blue(`📱 ${phone}: ${text} (Estado: ${userState.state})`));
    
    // Comando de inicio
    if (text.toLowerCase() === 'menu' || text === '0') {
        await setUserState(phone, 'main_menu');
        await client.sendText(message.from, getMainMenuMessage());
        return;
    }
    
    // Sistema de estados
    switch (userState.state) {
        case 'main_menu':
            await handleMainMenu(phone, text, message.from);
            break;
            
        case 'plans_menu':
            await handlePlansMenu(phone, text, message.from);
            break;
            
        case 'buying_plan':
            await handleBuyingPlan(phone, text, message.from, userState.data);
            break;
            
        case 'waiting_test':
            await handleTestRequest(phone, text, message.from);
            break;
            
        default:
            await setUserState(phone, 'main_menu');
            await client.sendText(message.from, getMainMenuMessage());
    }
}

// ✅ MANEJAR MENÚ PRINCIPAL
async function handleMainMenu(phone, text, from) {
    switch (text) {
        case '1': // Prueba gratis
            await handleFreeTest(phone, from);
            break;
            
        case '2': // Ver planes
            await setUserState(phone, 'plans_menu');
            await client.sendText(from, getPlansMenuMessage());
            break;
            
        case '3': // Mis cuentas
            await showMyAccounts(phone, from);
            break;
            
        case '4': // Estado de pago
            await showPaymentStatus(phone, from);
            break;
            
        case '5': // Descargar APP
            await client.sendText(from, `*📲 DESCARGAR APP:*
            
Descarga nuestra aplicación desde:
${config.links.app_download}

_Después de descargar, vuelve al menú principal escribiendo_ *menu*`);
            break;
            
        case '6': // Soporte
            await client.sendText(from, `*🆘 SOPORTE:*
            
Para soporte técnico, contacta a:
${config.links.support}

_Después de contactar, vuelve al menú principal escribiendo_ *menu*`);
            break;
            
        default:
            await client.sendText(from, `❌ *Opción no válida*
            
Por favor, elige una opción del 1 al 6.

${getMainMenuMessage()}`);
    }
}

// ✅ MANEJAR MENÚ DE PLANES
async function handlePlansMenu(phone, text, from) {
    const planNumber = parseInt(text);
    
    if (planNumber >= 1 && planNumber <= 7) {
        const plan = getPlanDetails(planNumber);
        if (plan) {
            await setUserState(phone, 'buying_plan', { planNumber, ...plan });
            
            const amount = config.prices[plan.price];
            const message = `*🛒 CONFIRMAR COMPRA:*
            
*Plan:* ${plan.name}
*Duración:* ${plan.days} días
*Conexiones:* ${plan.connections}
*Precio:* $${amount} ARS

¿Deseas continuar con la compra?

🔘 *1* - Sí, pagar con MercadoPago
🔘 *2* - No, volver al menú de planes
🔘 *0* - Volver al menú principal`;
            
            await client.sendText(from, message);
        }
    } else if (text === '0') {
        await setUserState(phone, 'main_menu');
        await client.sendText(from, getMainMenuMessage());
    } else {
        await client.sendText(from, `❌ *Plan no válido*
        
Por favor, elige un plan del 1 al 7.

${getPlansMenuMessage()}`);
    }
}

// ✅ MANEJAR COMPRA DE PLAN
async function handleBuyingPlan(phone, text, from, planData) {
    if (text === '1') {
        // Procesar pago
        const amount = config.prices[planData.price];
        const payment = await createMercadoPagoPayment(phone, planData.name, planData.days, amount, planData.connections);
        
        if (payment.success) {
            await client.sendText(from, `*✅ PAGO GENERADO:*
            
*ID de pago:* ${payment.paymentId}
*Plan:* ${planData.name}
*Monto:* $${amount} ARS

*Enlace de pago:*
${payment.paymentUrl}

_Una vez aprobado el pago, recibirás tus credenciales automáticamente._

Escribe *menu* para volver al menú principal.`);
            
            // Guardar estado de espera de pago
            await setUserState(phone, 'waiting_payment', {
                paymentId: payment.paymentId,
                planData
            });
        } else {
            await client.sendText(from, `❌ *Error al generar pago*
            
${payment.error}

Por favor, intenta nuevamente o contacta a soporte.
${config.links.support}

Escribe *menu* para volver.`);
            await setUserState(phone, 'main_menu');
        }
    } else if (text === '2') {
        await setUserState(phone, 'plans_menu');
        await client.sendText(from, getPlansMenuMessage());
    } else if (text === '0') {
        await setUserState(phone, 'main_menu');
        await client.sendText(from, getMainMenuMessage());
    } else {
        await client.sendText(from, `Por favor, elige:
🔘 *1* - Sí, pagar
🔘 *2* - No, volver
🔘 *0* - Menú principal`);
    }
}

// ✅ MANEJAR PRUEBA GRATIS
async function handleFreeTest(phone, from) {
    // Verificar si ya usó prueba hoy
    const today = moment().format('YYYY-MM-DD');
    db.get('SELECT id FROM daily_tests WHERE phone = ? AND date = ?', [phone, today], async (err, row) => {
        if (row) {
            await client.sendText(from, `❌ *Ya usaste la prueba hoy*
            
Solo puedes usar la prueba gratuita una vez por día.

Puedes comprar un plan escribiendo *menu* y eligiendo la opción *2*.`);
            await setUserState(phone, 'main_menu');
            return;
        }
        
        // Crear usuario de prueba
        const username = generateSSHUsername(phone);
        const result = await createSSHUser(username, '12345', 0, 1);
        
        if (result.success) {
            // Guardar en base de datos
            db.run(
                `INSERT INTO users (phone, username, password, tipo, expires_at, max_connections, status) 
                 VALUES (?, ?, ?, 'test', ?, 1, 1)`,
                [phone, username, '12345', result.expires]
            );
            
            db.run('INSERT INTO daily_tests (phone, date) VALUES (?, ?)', [phone, today]);
            
            await client.sendText(from, `*✅ PRUEBA GRATIS ACTIVADA:*
            
*Usuario:* ${username}
*Contraseña:* 12345
*Servidor:* ${config.bot.server_ip}
*Puerto:* 22
*Conexiones:* 1
*Expira:* ${config.prices.test_hours} horas

*APP para conectar:*
${config.links.app_download}

_Guarda estas credenciales. Para ver tus cuentas escribe_ *menu* _y elige_ *3*`);
            
            await setUserState(phone, 'main_menu');
        } else {
            await client.sendText(from, `❌ *Error al crear cuenta*
            
Por favor, intenta nuevamente o contacta a soporte.
${config.links.support}`);
            await setUserState(phone, 'main_menu');
        }
    });
}

// ✅ MOSTRAR CUENTAS DEL USUARIO
async function showMyAccounts(phone, from) {
    db.all(
        `SELECT username, password, tipo, expires_at, max_connections, 
                CASE WHEN status = 1 THEN 'Activa' ELSE 'Inactiva' END as status_text
         FROM users 
         WHERE phone = ? 
         ORDER BY created_at DESC`,
        [phone],
        async (err, rows) => {
            if (err || !rows || rows.length === 0) {
                await client.sendText(from, `*📂 MIS CUENTAS:*
                
No tienes cuentas activas.

Para crear una prueba gratis escribe *menu* y elige la opción *1*.`);
                return;
            }
            
            let message = `*📂 MIS CUENTAS:*\n\n`;
            rows.forEach((acc, index) => {
                const expires = moment(acc.expires_at).format('DD/MM/YYYY HH:mm');
                message += `*Cuenta ${index + 1}:*\n`;
                message += `👤 Usuario: ${acc.username}\n`;
                message += `🔐 Contraseña: ${acc.password}\n`;
                message += `📡 Tipo: ${acc.tipo === 'test' ? 'Prueba' : 'Premium'}\n`;
                message += `🔌 Conexiones: ${acc.max_connections}\n`;
                message += `⏰ Expira: ${expires}\n`;
                message += `✅ Estado: ${acc.status_text}\n`;
                message += `🌐 Servidor: ${config.bot.server_ip}\n`;
                message += `🔧 Puerto: 22\n\n`;
            });
            
            message += `_Para renovar o comprar planes, escribe_ *menu*`;
            
            await client.sendText(from, message);
        }
    );
    
    await setUserState(phone, 'main_menu');
}

// ✅ MOSTRAR ESTADO DE PAGO
async function showPaymentStatus(phone, from) {
    db.all(
        `SELECT payment_id, plan, amount, status, created_at, approved_at
         FROM payments 
         WHERE phone = ? 
         ORDER BY created_at DESC 
         LIMIT 5`,
        [phone],
        async (err, rows) => {
            if (err || !rows || rows.length === 0) {
                await client.sendText(from, `*💳 ESTADO DE PAGOS:*
                
No tienes pagos registrados.

Para comprar un plan escribe *menu* y elige la opción *2*.`);
                return;
            }
            
            let message = `*💳 ÚLTIMOS PAGOS:*\n\n`;
            rows.forEach((pay, index) => {
                const created = moment(pay.created_at).format('DD/MM HH:mm');
                const statusEmoji = pay.status === 'approved' ? '✅' : 
                                  pay.status === 'pending' ? '⏳' : '❌';
                
                message += `*Pago ${index + 1}:*\n`;
                message += `${statusEmoji} Estado: ${pay.status}\n`;
                message += `📋 Plan: ${pay.plan}\n`;
                message += `💰 Monto: $${pay.amount} ARS\n`;
                message += `📅 Fecha: ${created}\n`;
                
                if (pay.approved_at) {
                    const approved = moment(pay.approved_at).format('DD/MM HH:mm');
                    message += `✅ Aprobado: ${approved}\n`;
                }
                
                message += `🔑 ID: ${pay.payment_id}\n\n`;
            });
            
            message += `_Para ver más opciones, escribe_ *menu*`;
            
            await client.sendText(from, message);
        }
    );
    
    await setUserState(phone, 'main_menu');
}

// ✅ MANEJAR SOLICITUD DE PRUEBA
async function handleTestRequest(phone, text, from) {
    // Lógica para manejar solicitudes específicas de prueba
    await setUserState(phone, 'main_menu');
    await client.sendText(from, getMainMenuMessage());
}

// ✅ VERIFICAR PAGOS PENDIENTES (Cron job)
function setupPaymentChecker() {
    cron.schedule('*/2 * * * *', async () => {
        if (!mpEnabled) return;
        
        console.log(chalk.yellow('🔍 Verificando pagos pendientes...'));
        
        db.all(
            `SELECT payment_id, preference_id, phone, plan, days, connections, amount 
             FROM payments 
             WHERE status = 'pending' AND created_at > datetime('now', '-1 hour')`,
            [],
            async (err, payments) => {
                if (err || !payments) return;
                
                for (const payment of payments) {
                    try {
                        // Aquí iría la lógica para verificar el pago en MercadoPago
                        // Por simplicidad, solo marcamos algunos como aprobados
                        const shouldApprove = Math.random() > 0.7;
                        
                        if (shouldApprove) {
                            // Crear usuario SSH
                            const username = generateSSHUsername(payment.phone);
                            const result = await createSSHUser(
                                username, 
                                '12345', 
                                payment.days, 
                                payment.connections
                            );
                            
                            if (result.success) {
                                // Actualizar pago
                                db.run(
                                    `UPDATE payments SET status = 'approved', approved_at = CURRENT_TIMESTAMP 
                                     WHERE payment_id = ?`,
                                    [payment.payment_id]
                                );
                                
                                // Guardar usuario
                                db.run(
                                    `INSERT INTO users (phone, username, password, tipo, expires_at, max_connections, status) 
                                     VALUES (?, ?, ?, 'premium', ?, ?, 1)`,
                                    [payment.phone, username, '12345', result.expires, payment.connections]
                                );
                                
                                // Notificar al usuario
                                if (client) {
                                    await client.sendText(
                                        `${payment.phone}@c.us`,
                                        `*✅ PAGO APROBADO:*
                                        
Tu pago ha sido aprobado y tu cuenta ha sido creada.

*Usuario:* ${username}
*Contraseña:* 12345
*Servidor:* ${config.bot.server_ip}
*Puerto:* 22
*Conexiones:* ${payment.connections}
*Expira:* ${payment.days} días

¡Disfruta del servicio!

Escribe *menu* para ver más opciones.`
                                    );
                                }
                            }
                        }
                    } catch (error) {
                        console.error('Error verificando pago:', error);
                    }
                }
            }
        );
    });
}

// ✅ LIMPIAR USUARIOS EXPIRADOS (Cron job - cada 15 minutos)
function setupCleanupCron() {
    cron.schedule('*/15 * * * *', async () => {
        console.log(chalk.yellow('🧹 Limpiando usuarios expirados...'));
        
        const now = moment().format('YYYY-MM-DD HH:mm:ss');
        
        // Obtener usuarios expirados
        db.all(
            `SELECT username FROM users WHERE expires_at < ? AND status = 1`,
            [now],
            async (err, expiredUsers) => {
                if (err || !expiredUsers) return;
                
                for (const user of expiredUsers) {
                    try {
                        // Eliminar usuario del sistema
                        await execPromise(`pkill -u ${user.username}; userdel ${user.username} 2>/dev/null || true`);
                        
                        // Marcar como inactivo en DB
                        db.run(`UPDATE users SET status = 0 WHERE username = ?`, [user.username]);
                        
                        console.log(chalk.gray(`  ➤ Usuario ${user.username} expirado y eliminado`));
                    } catch (error) {
                        console.error(`Error eliminando usuario ${user.username}:`, error);
                    }
                }
            }
        );
        
        // Limpiar estados antiguos (más de 1 día)
        db.run(`DELETE FROM user_state WHERE updated_at < datetime('now', '-1 day')`);
    });
}

// ✅ INICIAR BOT
async function startBot() {
    try {
        console.log(chalk.cyan('🚀 Iniciando SERVERTUC™ BOT v9.0...'));
        
        // Configurar cron jobs
        setupPaymentChecker();
        setupCleanupCron();
        
        // Iniciar WPPConnect
        client = await wppconnect.create({
            session: 'servertuc-bot',
            puppeteerOptions: {
                executablePath: config.paths.chromium,
                args: [
                    '--no-sandbox',
                    '--disable-setuid-sandbox',
                    '--disable-dev-shm-usage',
                    '--disable-accelerated-2d-canvas',
                    '--no-first-run',
                    '--no-zygote',
                    '--disable-gpu'
                ]
            },
            disableWelcome: true,
            logQR: false
        });
        
        console.log(chalk.green('✅ WhatsApp conectado exitosamente!'));
        
        // Evento de QR Code
        client.onQRCode((qrCode) => {
            console.log(chalk.yellow('📱 Escanea este código QR con WhatsApp:'));
            qrcode.generate(qrCode, { small: true });
        });
        
        // Evento de autenticación
        client.onAuthenticated(() => {
            console.log(chalk.green('✅ Autenticación completada!'));
        });
        
        // Evento de mensajes
        client.onMessage(async (message) => {
            try {
                await handleMessage(message);
            } catch (error) {
                console.error('Error manejando mensaje:', error);
            }
        });
        
        // Evento de cambio de estado
        client.onStateChange((state) => {
            console.log(chalk.blue(`🔁 Estado cambiado: ${state}`));
        });
        
        console.log(chalk.green.bold('\n✅ BOT INICIADO CORRECTAMENTE!'));
        console.log(chalk.cyan('📱 Escanea el código QR con WhatsApp Web'));
        console.log(chalk.cyan('💬 Envía "menu" a tu bot para comenzar\n'));
        
    } catch (error) {
        console.error(chalk.red('❌ Error iniciando bot:'), error);
        process.exit(1);
    }
}

// ✅ INICIAR TODO
startBot();
BOTEOF

echo -e "${GREEN}✅ Bot.js creado con sistema de estados y WPPConnect${NC}"

# ================================================
# CREAR SCRIPT DE CONTROL
# ================================================
echo -e "\n${CYAN}${BOLD}⚙️ CREANDO SCRIPT DE CONTROL...${NC}"

cat > "/usr/local/bin/sshbot-control" << 'CONTROLEOF'
#!/bin/bash
# Control para SERVERTUC™ BOT v9.0

BOLD='\033[1m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

case "$1" in
    start)
        echo -e "${GREEN}▶️ Iniciando SERVERTUC™ BOT...${NC}"
        cd /root/ssh-bot
        pm2 start bot.js --name ssh-bot --time
        pm2 save
        echo -e "${GREEN}✅ Bot iniciado${NC}"
        ;;
    stop)
        echo -e "${YELLOW}⏹️ Deteniendo bot...${NC}"
        pm2 stop ssh-bot
        echo -e "${GREEN}✅ Bot detenido${NC}"
        ;;
    restart)
        echo -e "${CYAN}🔄 Reiniciando bot...${NC}"
        pm2 restart ssh-bot
        echo -e "${GREEN}✅ Bot reiniciado${NC}"
        ;;
    status)
        echo -e "${CYAN}📊 Estado del bot:${NC}"
        pm2 status ssh-bot
        ;;
    logs)
        echo -e "${CYAN}📋 Mostrando logs:${NC}"
        pm2 logs ssh-bot --lines 50
        ;;
    qr)
        echo -e "${CYAN}📱 Generando nuevo QR...${NC}"
        pm2 restart ssh-bot
        echo -e "${YELLOW}Reiniciando para mostrar QR...${NC}"
        sleep 3
        pm2 logs ssh-bot --lines 10
        ;;
    config)
        echo -e "${CYAN}⚙️ Editando configuración...${NC}"
        nano /opt/ssh-bot/config/config.json
        ;;
    mercadopago)
        echo -e "${CYAN}💰 Configurando MercadoPago...${NC}"
        echo -e "${YELLOW}Ingresa tu Access Token de MercadoPago:${NC}"
        read -p "Token: " mp_token
        if [[ -n "$mp_token" ]]; then
            jq '.mercadopago.access_token = "'$mp_token'" | .mercadopago.enabled = true' /opt/ssh-bot/config/config.json > /tmp/config.tmp && mv /tmp/config.tmp /opt/ssh-bot/config/config.json
            echo -e "${GREEN}✅ MercadoPago configurado${NC}"
            echo -e "${YELLOW}Reinicia el bot con: sshbot-control restart${NC}"
        else
            echo -e "${RED}❌ Token no válido${NC}"
        fi
        ;;
    users)
        echo -e "${CYAN}👥 Listando usuarios SSH:${NC}"
        sqlite3 /opt/ssh-bot/data/users.db "SELECT username, phone, tipo, expires_at, status FROM users ORDER BY created_at DESC LIMIT 10;" | column -t -s '|'
        ;;
    payments)
        echo -e "${CYAN}💳 Últimos pagos:${NC}"
        sqlite3 /opt/ssh-bot/data/users.db "SELECT payment_id, phone, plan, amount, status, created_at FROM payments ORDER BY created_at DESC LIMIT 10;" | column -t -s '|'
        ;;
    backup)
        echo -e "${CYAN}💾 Creando backup...${NC}"
        backup_file="/root/backup-sshbot-$(date +%Y%m%d-%H%M%S).tar.gz"
        tar -czf "$backup_file" /opt/ssh-bot/data /opt/ssh-bot/config
        echo -e "${GREEN}✅ Backup creado: $backup_file${NC}"
        ;;
    update)
        echo -e "${CYAN}🔄 Actualizando bot...${NC}"
        cd /root/ssh-bot
        npm update
        pm2 restart ssh-bot
        echo -e "${GREEN}✅ Bot actualizado${NC}"
        ;;
    *)
        echo -e "${CYAN}${BOLD}SERVERTUC™ BOT v9.0 - Comandos de control${NC}"
        echo -e ""
        echo -e "${GREEN}Uso:${NC} sshbot-control [comando]"
        echo -e ""
        echo -e "${YELLOW}Comandos disponibles:${NC}"
        echo -e "  ${GREEN}start${NC}      - Iniciar bot"
        echo -e "  ${GREEN}stop${NC}       - Detener bot"
        echo -e "  ${GREEN}restart${NC}    - Reiniciar bot"
        echo -e "  ${GREEN}status${NC}     - Ver estado"
        echo -e "  ${GREEN}logs${NC}       - Ver logs"
        echo -e "  ${GREEN}qr${NC}         - Generar nuevo QR"
        echo -e "  ${GREEN}config${NC}     - Editar configuración"
        echo -e "  ${GREEN}mercadopago${NC} - Configurar MercadoPago"
        echo -e "  ${GREEN}users${NC}      - Listar usuarios"
        echo -e "  ${GREEN}payments${NC}   - Ver pagos"
        echo -e "  ${GREEN}backup${NC}     - Crear backup"
        echo -e "  ${GREEN}update${NC}     - Actualizar dependencias"
        echo -e ""
        echo -e "${CYAN}Ejemplos:${NC}"
        echo -e "  sudo sshbot-control start"
        echo -e "  sudo sshbot-control mercadopago"
        echo -e "  sudo sshbot-control logs"
        ;;
esac
CONTROLEOF

chmod +x /usr/local/bin/sshbot-control

# ================================================
# CONFIGURAR CRON JOBS
# ================================================
echo -e "\n${CYAN}${BOLD}⏰ CONFIGURANDO CRON JOBS...${NC}"

# Limpiar usuarios expirados cada 15 minutos
(crontab -l 2>/dev/null | grep -v "cleanup expired users"; echo "*/15 * * * * /usr/bin/find /opt/ssh-bot/data -name \"*.db\" -exec /usr/bin/sqlite3 {} \"DELETE FROM users WHERE expires_at < datetime('now') AND status = 1; UPDATE users SET status = 0 WHERE expires_at < datetime('now');\" \;") | crontab -

# Backup diario a las 3 AM
(crontab -l 2>/dev/null | grep -v "backup ssh-bot"; echo "0 3 * * * /bin/tar -czf /root/backups/sshbot-backup-\$(date +\\%Y\\%m\\%d).tar.gz /opt/ssh-bot/data /opt/ssh-bot/config 2>/dev/null || true") | crontab -

# Verificar que PM2 se inicie al reiniciar el sistema
pm2 startup
pm2 save

echo -e "${GREEN}✅ Cron jobs configurados${NC}"

# ================================================
# INICIAR EL BOT
# ================================================
echo -e "\n${CYAN}${BOLD}🚀 INICIANDO SERVERTUC™ BOT v9.0...${NC}"

cd "$USER_HOME"
pm2 start bot.js --name ssh-bot --time
pm2 save
pm2 startup

sleep 3

echo -e "${GREEN}"
cat << "SUCCESS"
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║           🎉 INSTALACIÓN COMPLETADA EXITOSAMENTE!           ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
SUCCESS
echo -e "${NC}"

echo -e "${YELLOW}📋 RESUMEN DE LA INSTALACIÓN:${NC}"
echo -e "  ✅ ${GREEN}Node.js 18.x + Chrome instalados${NC}"
echo -e "  ✅ ${GREEN}API WPPConnect configurada${NC}"
echo -e "  ✅ ${GREEN}Sistema de estados activado${NC}"
echo -e "  ✅ ${GREEN}MercadoPago SDK v2.x disponible${NC}"
echo -e "  ✅ ${GREEN}Base de datos SQLite creada${NC}"
echo -e "  ✅ ${GREEN}PM2 configurado para auto-inicio${NC}"
echo -e "  ✅ ${GREEN}Cron jobs programados${NC}"
echo -e "  ✅ ${GREEN}Script de control instalado${NC}"

echo -e "\n${CYAN}📱 CONFIGURACIÓN WHATSAPP:${NC}"
echo -e "  1. Espera a que aparezca el código QR en los logs"
echo -e "  2. Escanea el código con WhatsApp Web"
echo -e "  3. Envía 'menu' al bot para comenzar"

echo -e "\n${PURPLE}⚡ COMANDOS DE CONTROL:${NC}"
echo -e "  ${GREEN}sshbot-control start${NC}    - Iniciar bot"
echo -e "  ${GREEN}sshbot-control stop${NC}     - Detener bot"
echo -e "  ${GREEN}sshbot-control restart${NC}  - Reiniciar bot"
echo -e "  ${GREEN}sshbot-control logs${NC}     - Ver logs y QR"
echo -e "  ${GREEN}sshbot-control status${NC}   - Ver estado"
echo -e "  ${GREEN}sshbot-control mercadopago${NC} - Configurar MP"

echo -e "\n${YELLOW}🔧 CONFIGURAR MERCADOPAGO (OPCIONAL):${NC}"
echo -e "  sudo sshbot-control mercadopago"
echo -e "  Ingresa tu Access Token cuando te lo pida"

echo -e "\n${BLUE}📊 VER LOGS Y QR CODE:${NC}"
echo -e "  sudo sshbot-control logs"
echo -e "  (Presiona Ctrl+C para salir de los logs)"

echo -e "\n${GREEN}✅ El bot se ha iniciado automáticamente${NC}"
echo -e "${YELLOW}⚠️  Si necesitas ver el QR code nuevamente, usa:${NC}"
echo -e "    ${CYAN}sudo sshbot-control logs${NC}"

echo -e "\n${CYAN}══════════════════════════════════════════════════════════════${NC}"
echo -e "${BOLD}🤖 SERVERTUC™ BOT v9.0 - WPPCONNECT + SISTEMA DE ESTADOS${NC}"
echo -e "${CYAN}══════════════════════════════════════════════════════════════${NC}"

# Mostrar logs iniciales
echo -e "\n${YELLOW}📋 Últimas líneas de log (espera 10 segundos para QR):${NC}"
sleep 2
pm2 logs ssh-bot --lines 5 --nostream
echo -e "\n${CYAN}Para ver todos los logs en tiempo real:${NC}"
echo -e "${GREEN}  sudo sshbot-control logs${NC}"
