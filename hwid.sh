#!/bin/bash
# ================================================
# SSH BOT HWID - MENÚ COMPLETO (basado en mgvpn)
# Versión modificada: tolera error de PM2 si el proceso no existe
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

# Banner
clear
echo -e "${CYAN}${BOLD}"
cat << "BANNER"
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║     ███████╗███████╗██╗  ██╗    ██████╗  ██████╗ ████████╗  ║
║     ██╔════╝██╔════╝██║  ██║    ██╔══██╗██╔═══██╗╚══██╔══╝  ║
║     ███████╗███████╗███████║    ██████╔╝██║   ██║   ██║     ║
║     ╚════██║╚════██║██╔══██║    ██╔══██╗██║   ██║   ██║     ║
║     ███████║███████║██║  ██║    ██████╔╝╚██████╔╝   ██║     ║
║     ╚══════╝╚══════╝╚═╝  ╚═╝    ╚═════╝  ╚═════╝    ╚═╝     ║
╠══════════════════════════════════════════════════════════════╣
║                                                              ║
║              🤖 SSH BOT HWID - MENÚ COMPLETO                ║
║               📱 PRIMERO NOMBRE, LUEGO HWID                 ║
║               💰 MERCADOPAGO SDK v2.x INTEGRADO             ║
║               📋 MENÚ: 1=Prueba, 2=Planes, 3=Mis HWIDs      ║
║                     4=Estado pago, 5=APP, 6=Soporte         ║
║               🆕 PLANES: 1=7d, 2=15d, 3=30d, 4=7d(2c),      ║
║                        5=15d(2c), 6=30d(2c), 7=50d(1c)      ║
║               ⏰ NOTIFICACIONES DE VENCIMIENTO              ║
║               ✅ QR CORREGIDO - AUTO CLOSE DESACTIVADO      ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
BANNER
echo -e "${NC}"

# Verificar root
if [[ $EUID -ne 0 ]]; then
    echo -e "${RED}${BOLD}❌ ERROR: Debes ejecutar como root${NC}"
    exit 1
fi

# --- ELIMINAR CONFLICTOS DE NODE.JS ---
echo -e "\n${CYAN}${BOLD}🔧 Verificando conflictos de Node.js...${NC}"
if dpkg -l | grep -q libnode72; then
    echo -e "${YELLOW}⚠️  Eliminando paquete conflictivo libnode72...${NC}"
    apt-get remove --purge -y libnode72 nodejs
    apt-get autoremove -y
    apt-get clean
fi

# Detectar IP
echo -e "\n${CYAN}${BOLD}🔍 DETECTANDO IP DEL SERVIDOR...${NC}"
SERVER_IP=$(curl -4 -s --max-time 10 ifconfig.me 2>/dev/null || hostname -I | awk '{print $1}' || echo "127.0.0.1")
if [[ -z "$SERVER_IP" || "$SERVER_IP" == "127.0.0.1" ]]; then
    read -p "📝 Ingresa la IP del servidor manualmente: " SERVER_IP
fi
echo -e "${GREEN}✅ IP detectada: ${CYAN}$SERVER_IP${NC}\n"

# Preguntar nombre del bot
read -p "$(echo -e "${YELLOW}🤖 Nombre para tu bot (ej: Mi Bot VPN): ${NC}")" BOT_NAME
if [[ -z "$BOT_NAME" ]]; then
    BOT_NAME="SSH Bot HWID"
    echo -e "${YELLOW}⚠️ Usando nombre por defecto: ${CYAN}$BOT_NAME${NC}"
fi
echo ""

# Confirmar instalación
echo -e "${YELLOW}⚠️  ESTE INSTALADOR HARÁ:${NC}"
echo -e "   • Instalar Node.js 18.x + Chrome"
echo -e "   • Crear bot con sistema HWID (mgvpn) y menú completo"
echo -e "   • Configurar MercadoPago SDK v2.x"
echo -e "   • Activar notificaciones de vencimiento"
echo -e "   • Instalar panel de control 'sshbot'"
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
apt-get update -y
apt-get upgrade -y

# 1. Detener y eliminar el bot de PM2 (ignorar si no existe)
pm2 delete ssh-bot 2>/dev/null || true
pm2 save

# 2. Matar procesos de Chrome/Chromium
pkill -f chrome
pkill -f chromium

# 3. Eliminar directorios de instalación
rm -rf /opt/ssh-bot
rm -rf /root/ssh-bot
rm -rf /root/.wppconnect
rm -rf /root/.pm2/logs/ssh-bot*

# 4. Opcional: eliminar también tokens de sesión
rm -rf /root/ssh-bot/tokens

# 5. Reiniciar PM2
pm2 kill

# Node.js 18.x
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt-get install -y nodejs gcc g++ make

# Chrome/Chromium
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list
apt-get update -y
apt-get install -y google-chrome-stable

# Dependencias del sistema
apt-get install -y \
    git curl wget sqlite3 jq \
    build-essential libcairo2-dev \
    libpango1.0-dev libjpeg-dev \
    libgif-dev librsvg2-dev \
    python3 python3-pip ffmpeg \
    unzip cron ufw

# Configurar firewall
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow 8001/tcp
ufw allow 3000/tcp
ufw --force enable

# PM2
npm install -g pm2
pm2 update

echo -e "${GREEN}✅ Dependencias instaladas${NC}"

# ================================================
# PREPARAR ESTRUCTURA (basada en mgvpn)
# ================================================
echo -e "\n${CYAN}${BOLD}📁 CREANDO ESTRUCTURA...${NC}"

INSTALL_DIR="/opt/sshbot-pro"
USER_HOME="/root/sshbot-pro"
DB_FILE="$INSTALL_DIR/data/hwid.db"
CONFIG_FILE="$INSTALL_DIR/config/config.json"

# Limpiar anterior
pm2 delete sshbot-pro 2>/dev/null || true
rm -rf "$INSTALL_DIR" "$USER_HOME" 2>/dev/null || true
rm -rf /root/.wppconnect 2>/dev/null || true

# Crear directorios
mkdir -p "$INSTALL_DIR"/{data,config,sessions,logs,qr_codes}
mkdir -p "$USER_HOME"
mkdir -p /root/.wppconnect
chmod -R 755 "$INSTALL_DIR"
chmod -R 700 /root/.wppconnect

# Configuración con precios completos (7 opciones)
cat > "$CONFIG_FILE" << EOF
{
    "bot": {
        "name": "$BOT_NAME",
        "version": "3.0-HWID-MENU-COMPLETO",
        "server_ip": "$SERVER_IP"
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
        "app_download": "https://www.mediafire.com/file/18tnc70qr2771lu/MGVPN.apk/file",
        "support": "https://wa.me/543435071016"
    },
    "paths": {
        "database": "$DB_FILE",
        "qr_codes": "$INSTALL_DIR/qr_codes",
        "sessions": "/root/.wppconnect",
        "chromium": "/usr/bin/google-chrome"
    }
}
EOF

# Base de datos HWID (mgvpn) con campo max_connections añadido
sqlite3 "$DB_FILE" << 'SQL'
CREATE TABLE hwid_users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    phone TEXT,
    nombre TEXT,
    hwid TEXT UNIQUE,
    tipo TEXT DEFAULT 'test',
    expires_at DATETIME,
    status INTEGER DEFAULT 1,
    max_connections INTEGER DEFAULT 1,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE daily_tests (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    phone TEXT,
    nombre TEXT,
    date DATE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(phone, date)
);
CREATE TABLE payments (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    payment_id TEXT UNIQUE,
    phone TEXT,
    nombre TEXT,
    plan TEXT,
    days INTEGER,
    connections INTEGER DEFAULT 1,
    amount REAL,
    status TEXT DEFAULT 'pending',
    payment_url TEXT,
    qr_code TEXT,
    preference_id TEXT,
    hwid TEXT,
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
CREATE TABLE hwid_attempts (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    hwid TEXT,
    phone TEXT,
    nombre TEXT,
    action TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_hwid_users_hwid ON hwid_users(hwid);
CREATE INDEX idx_hwid_users_status ON hwid_users(status);
CREATE INDEX idx_payments_hwid ON payments(hwid);
CREATE INDEX idx_payments_status ON payments(status);
SQL

echo -e "${GREEN}✅ Estructura HWID creada${NC}"

# ================================================
# CREAR BOT CON MENÚ COMPLETO (basado en mgvpn + menú mejorado)
# ================================================
echo -e "\n${CYAN}${BOLD}🤖 CREANDO BOT CON MENÚ COMPLETO Y SISTEMA HWID...${NC}"

cd "$USER_HOME"

# package.json
cat > package.json << 'PKGEOF'
{
    "name": "sshbot-pro-hwid",
    "version": "3.0.0",
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
        "axios": "^1.6.5"
    }
}
PKGEOF

echo -e "${YELLOW}📦 Instalando dependencias...${NC}"
npm install --silent 2>&1 | grep -v "npm WARN" || true

# ================================================
# BOT.JS: base mgvpn con menú completo (corregido QR)
# ================================================
echo -e "${YELLOW}📝 Creando bot.js con menú completo...${NC}"

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
console.log(chalk.cyan.bold('║              __BOT_NAME__ - HWID + MENÚ COMPLETO             ║'));
console.log(chalk.cyan.bold('║               SISTEMA: PRIMERO NOMBRE, LUEGO HWID            ║'));
console.log(chalk.cyan.bold('║               ⏰ NOTIFICACIONES DE VENCIMIENTO                ║'));
console.log(chalk.cyan.bold('╚══════════════════════════════════════════════════════════════╝\n'));

// Cargar configuración
function loadConfig() {
    delete require.cache[require.resolve('/opt/sshbot-pro/config/config.json')];
    return require('/opt/sshbot-pro/config/config.json');
}

let config = loadConfig();
const db = new sqlite3.Database('/opt/sshbot-pro/data/hwid.db');

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
            return true;
        } catch (error) {
            console.log(chalk.red('❌ Error inicializando MP:'), error.message);
            mpEnabled = false;
            return false;
        }
    }
    console.log(chalk.yellow('⚠️ MercadoPago NO configurado'));
    return false;
}

initMercadoPago();

let client = null;

// ✅ FUNCIONES HWID (mgvpn)
function validateHWID(hwid) {
    const hwidRegex = /^APP-[A-F0-9]{16}$/;
    return hwidRegex.test(hwid);
}

function normalizeHWID(hwid) {
    hwid = hwid.trim().toUpperCase();
    if (!hwid.startsWith('APP-')) {
        hwid = 'APP-' + hwid.replace(/[^A-F0-9]/g, '');
    }
    return hwid;
}

function isHWIDActive(hwid) {
    return new Promise((resolve) => {
        db.get('SELECT * FROM hwid_users WHERE hwid = ? AND status = 1 AND expires_at > datetime("now")', 
            [hwid], (err, row) => {
            resolve(!err && row);
        });
    });
}

function getHWIDInfo(hwid) {
    return new Promise((resolve) => {
        db.get('SELECT * FROM hwid_users WHERE hwid = ?', [hwid], (err, row) => {
            if (err || !row) resolve(null);
            else resolve(row);
        });
    });
}

async function registerHWID(phone, nombre, hwid, days, tipo = 'premium', connections = 1) {
    try {
        const existing = await new Promise((resolve) => {
            db.get('SELECT hwid FROM hwid_users WHERE hwid = ?', [hwid], (err, row) => {
                resolve(row);
            });
        });

        if (existing) {
            return { success: false, error: 'HWID ya registrado en el sistema' };
        }

        let expireFull;
        if (days === 0) {
            expireFull = moment().add(config.prices.test_hours, 'hours').format('YYYY-MM-DD HH:mm:ss');
        } else {
            expireFull = moment().add(days, 'days').format('YYYY-MM-DD 23:59:59');
        }

        await new Promise((resolve, reject) => {
            db.run(
                `INSERT INTO hwid_users (phone, nombre, hwid, tipo, expires_at, max_connections, status) 
                 VALUES (?, ?, ?, ?, ?, ?, 1)`,
                [phone, nombre, hwid, tipo, expireFull, connections],
                function(err) {
                    if (err) reject(err);
                    else resolve(this.lastID);
                }
            );
        });

        db.run(`INSERT INTO hwid_attempts (hwid, phone, nombre, action) VALUES (?, ?, ?, 'registered')`, 
            [hwid, phone, nombre]);

        return { 
            success: true, 
            hwid,
            nombre,
            expires: expireFull,
            tipo,
            connections
        };

    } catch (error) {
        console.error(chalk.red('❌ Error registrando HWID:'), error.message);
        return { success: false, error: error.message };
    }
}

function canCreateTest(phone) {
    return new Promise((resolve) => {
        const today = moment().format('YYYY-MM-DD');
        db.get('SELECT COUNT(*) as count FROM daily_tests WHERE phone = ? AND date = ?', 
            [phone, today], (err, row) => resolve(!err && row && row.count === 0));
    });
}

function registerTest(phone, nombre) {
    db.run('INSERT OR IGNORE INTO daily_tests (phone, nombre, date) VALUES (?, ?, ?)', 
        [phone, nombre, moment().format('YYYY-MM-DD')]);
}

// ✅ SISTEMA DE ESTADOS
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

// ✅ FUNCIONES MP (mgvpn)
async function createMercadoPagoPayment(phone, planName, days, amount, connections = 1) {
    try {
        if (!mpEnabled || !mpPreference) {
            return { success: false, error: 'MercadoPago no configurado' };
        }

        const phoneClean = phone.replace('@c.us', '');
        const paymentId = `HWID-${phoneClean}-${days}d-${Date.now()}`;

        const expirationDate = moment().add(24, 'hours');
        const isoDate = expirationDate.toISOString();

        const preferenceData = {
            items: [{
                title: `${config.bot.name} - ${planName}`,
                description: `Activación HWID SSH por ${days} días - ${connections} conexión(es)`,
                quantity: 1,
                currency_id: config.prices.currency || 'ARS',
                unit_price: parseFloat(amount)
            }],
            external_reference: paymentId,
            expires: true,
            expiration_date_from: moment().toISOString(),
            expiration_date_to: isoDate,
            back_urls: {
                success: `https://wa.me/${phoneClean}?text=Ya%20pague%20hwid`,
                failure: `https://wa.me/${phoneClean}?text=Pago%20fallido%20hwid`,
                pending: `https://wa.me/${phoneClean}?text=Pago%20pendiente%20hwid`
            },
            auto_return: 'approved',
            statement_descriptor: 'HWID SSH'
        };

        const response = await mpPreference.create({ body: preferenceData });

        if (response && response.id) {
            const paymentUrl = response.init_point;
            const qrPath = `${config.paths.qr_codes}/${paymentId}.png`;

            await QRCode.toFile(qrPath, paymentUrl, { width: 400, margin: 2 });

            db.run(
                `INSERT INTO payments (payment_id, phone, plan, days, connections, amount, status, payment_url, qr_code, preference_id) 
                 VALUES (?, ?, ?, ?, ?, ?, 'pending', ?, ?, ?)`,
                [paymentId, phone, planName, days, connections, amount, paymentUrl, qrPath, response.id]
            );

            return { 
                success: true, 
                paymentId, 
                paymentUrl, 
                qrPath,
                amount: parseFloat(amount)
            };
        }

        throw new Error('Respuesta inválida de MercadoPago');

    } catch (error) {
        console.error(chalk.red('❌ Error MercadoPago:'), error.message);
        return { success: false, error: error.message };
    }
}

// ✅ VERIFICAR PAGOS PENDIENTES
async function checkPendingPayments() {
    if (!mpEnabled) return;

    db.all('SELECT * FROM payments WHERE status = "pending" AND created_at > datetime("now", "-48 hours")', 
        async (err, payments) => {
        if (err || !payments || payments.length === 0) return;

        for (const payment of payments) {
            try {
                const url = `https://api.mercadopago.com/v1/payments/search?external_reference=${payment.payment_id}`;
                const response = await axios.get(url, {
                    headers: { 
                        'Authorization': `Bearer ${config.mercadopago.access_token}`
                    },
                    timeout: 15000
                });

                if (response.data && response.data.results && response.data.results.length > 0) {
                    const mpPayment = response.data.results[0];

                    if (mpPayment.status === 'approved') {
                        console.log(chalk.green(`✅ PAGO APROBADO: ${payment.payment_id}`));

                        db.run(`UPDATE payments SET status = 'approved', approved_at = CURRENT_TIMESTAMP WHERE payment_id = ?`, 
                            [payment.payment_id]);

                        if (client) {
                            await client.sendText(payment.phone, 
                                `*✅ PAGO CONFIRMADO*

Tu pago ha sido aprobado.

*📝 PRIMERO, ESCRIBE TU NOMBRE:*
Para continuar con la activación, dime tu nombre.`);

                            await setUserState(payment.phone, 'awaiting_payment_nombre', { 
                                payment_id: payment.payment_id,
                                planData: {
                                    days: payment.days,
                                    connections: payment.connections,
                                    name: payment.plan
                                }
                            });
                        }
                    }
                }
            } catch (error) {
                console.error(chalk.red(`❌ Error verificando ${payment.payment_id}:`), error.message);
            }
        }
    });
}

// ✅ NOTIFICACIONES DE VENCIMIENTO
async function checkExpiringHWIDs() {
    try {
        const expiringSoon = await new Promise((resolve, reject) => {
            db.all(`
                SELECT * FROM hwid_users 
                WHERE status = 1 
                AND expires_at > datetime('now') 
                AND expires_at < datetime('now', '+1 day')
                AND tipo = 'premium'
            `, (err, rows) => {
                if (err) reject(err);
                else resolve(rows || []);
            });
        });

        for (const hwid of expiringSoon) {
            const hoursLeft = moment(hwid.expires_at).diff(moment(), 'hours');
            const message = `⏰ *RECORDATORIO DE VENCIMIENTO*

Hola *${hwid.nombre}*, tu acceso expirará en aproximadamente *${hoursLeft} horas*.

🔐 *HWID:* ${hwid.hwid}
⏰ *Fecha de vencimiento:* ${moment(hwid.expires_at).format('DD/MM/YYYY HH:mm')}

💰 Para renovar, escribe *menu* y elige *2* (Planes).`;

            if (client) {
                await client.sendText(hwid.phone, message);
            }
        }
    } catch (error) {
        console.error(chalk.red('❌ Error en notificaciones de vencimiento:'), error.message);
    }
}

// ================================================
// MENSAJES DEL MENÚ COMPLETO
// ================================================
function getMainMenuMessage() {
    return `*🤖 ${config.bot.name}*

*MENÚ PRINCIPAL:*
🔹 *1* - Prueba gratis (${config.prices.test_hours} horas)
🔹 *2* - Ver planes y precios
🔹 *3* - Mis HWIDs activos
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

// ================================================
// MANEJADORES DE MENSAJES (basado en mgvpn + menú nuevo)
// ================================================
async function handleMessage(message) {
    try {
        const text = message.body.toLowerCase().trim();
        const from = message.from;
        const phone = from.replace('@c.us', '');

        console.log(chalk.cyan(`📩 [${from}]: ${text.substring(0, 30)}`));

        const userState = await getUserState(phone);

        // Comando menu/volver
        if (['menu', 'hola', 'start', 'hi', 'volver', '0'].includes(text)) {
            await setUserState(phone, 'main_menu');
            await client.sendText(from, getMainMenuMessage());
            return;
        }

        // Estados
        switch (userState.state) {
            case 'main_menu':
                await handleMainMenu(phone, text, from);
                break;
            case 'plans_menu':
                await handlePlansMenu(phone, text, from);
                break;
            case 'buying_plan':
                await handleBuyingPlan(phone, text, from, userState.data);
                break;
            case 'awaiting_test_nombre':
                await handleTestNombre(phone, text, from);
                break;
            case 'awaiting_test_hwid':
                await handleTestHWID(phone, text, from, userState.data);
                break;
            case 'awaiting_payment_nombre':
                await handlePaymentNombre(phone, text, from, userState.data);
                break;
            case 'awaiting_payment_hwid':
                await handlePaymentHWID(phone, text, from, userState.data);
                break;
            default:
                await setUserState(phone, 'main_menu');
                await client.sendText(from, getMainMenuMessage());
        }
    } catch (error) {
        console.error(chalk.red('❌ Error procesando mensaje:'), error.message);
    }
}

async function handleMainMenu(phone, text, from) {
    switch (text) {
        case '1': // Prueba gratis
            await handleFreeTestStart(phone, from);
            break;
        case '2': // Ver planes
            await setUserState(phone, 'plans_menu');
            await client.sendText(from, getPlansMenuMessage());
            break;
        case '3': // Mis HWIDs
            await showMyHWIDs(phone, from);
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

async function handleBuyingPlan(phone, text, from, planData) {
    if (text === '1') {
        const amount = config.prices[planData.price];
        const payment = await createMercadoPagoPayment(phone, planData.name, planData.days, amount, planData.connections);

        if (payment.success) {
            await client.sendText(from, `*✅ PAGO GENERADO:*

*ID de pago:* ${payment.paymentId}
*Plan:* ${planData.name}
*Monto:* $${amount} ARS

*Enlace de pago:*
${payment.paymentUrl}

⏰ *DESPUÉS DE PAGAR:*
1. Espera la confirmación (2-3 minutos)
2. Te pediremos tu nombre
3. Luego tu HWID
4. Se activará automáticamente

Escribe *menu* para volver al menú principal.`);

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

async function handleFreeTestStart(phone, from) {
    const canTest = await canCreateTest(phone);

    if (!canTest) {
        await client.sendText(from, `❌ *YA USASTE TU PRUEBA HOY*

Solo puedes usar la prueba gratuita una vez por día.

⏳ Vuelve mañana o compra un plan escribiendo *menu* y eligiendo *2*.`);
        await setUserState(phone, 'main_menu');
        return;
    }

    await setUserState(phone, 'awaiting_test_nombre');
    await client.sendText(from, `⏳ *PRUEBA GRATUITA - ${config.prices.test_hours} HORAS*

Primero, dime tu nombre:`);
}

async function handleTestNombre(phone, text, from) {
    const nombre = text.trim();

    if (nombre.length < 2) {
        await client.sendText(from, '❌ El nombre debe tener al menos 2 caracteres. Intenta de nuevo:');
        return;
    }

    await setUserState(phone, 'awaiting_test_hwid', { nombre });

    await client.sendText(from, `✅ Gracias *${nombre}*

Ahora envía tu HWID para activar la prueba (${config.prices.test_hours} horas):

Formato: *APP-E3E4D5CBB7636907*

📱 *¿CÓMO OBTENER TU HWID?*
1. Abre la aplicación
2. Toca el botón de WhatsApp
3. Envía el HWID que aparece

⏳ Una prueba por día`);
}

async function handleTestHWID(phone, text, from, data) {
    const rawHwid = text;
    const hwid = normalizeHWID(rawHwid);
    const nombre = data.nombre;

    if (!validateHWID(hwid)) {
        await client.sendText(from, `❌ *HWID INVÁLIDO*

Formato correcto: *APP-E3E4D5CBB7636907*

Envía el HWID nuevamente o escribe *MENU* para volver`);
        return;
    }

    const active = await isHWIDActive(hwid);
    if (active) {
        await client.sendText(from, `❌ *ESTE HWID YA ESTÁ ACTIVO*

Si crees que es un error, contacta soporte.`);
        await setUserState(phone, 'main_menu');
        return;
    }

    await client.sendText(from, '⏳ Activando prueba...');

    const result = await registerHWID(phone, nombre, hwid, 0, 'test', 1);

    if (result.success) {
        registerTest(phone, nombre);

        const expireTime = moment(result.expires).format('HH:mm DD/MM/YYYY');

        await client.sendText(from, `*✅ PRUEBA ACTIVADA*

👤 *Nombre:* ${nombre}
🔐 *HWID:* ${hwid}
⏰ *Expira:* ${expireTime}
⚡ *Tipo:* PRUEBA (${config.prices.test_hours} horas)

📱 Abre la aplicación y ya puedes conectarte

Escribe *menu* para ver más opciones.`);

        console.log(chalk.green(`✅ HWID test: ${hwid} - ${nombre}`));
    } else {
        await client.sendText(from, `❌ *Error:* ${result.error}`);
    }

    await setUserState(phone, 'main_menu');
}

async function handlePaymentNombre(phone, text, from, data) {
    const nombre = text.trim();

    if (nombre.length < 2) {
        await client.sendText(from, '❌ El nombre debe tener al menos 2 caracteres. Intenta de nuevo:');
        return;
    }

    data.nombre = nombre;
    await setUserState(phone, 'awaiting_payment_hwid', data);

    await client.sendText(from, `✅ Gracias *${nombre}*

Ahora envía tu HWID:
Formato: *APP-E3E4D5CBB7636907*

📱 *¿CÓMO OBTENER TU HWID?*
1. Abre la aplicación
2. Toca el botón de WhatsApp
3. Envía el HWID que aparece`);
}

async function handlePaymentHWID(phone, text, from, data) {
    const rawHwid = text;
    const hwid = normalizeHWID(rawHwid);
    const nombre = data.nombre;
    const planData = data.planData;

    if (!validateHWID(hwid)) {
        await client.sendText(from, `❌ *HWID INVÁLIDO*

Formato correcto: *APP-E3E4D5CBB7636907*

Envía el HWID nuevamente:`);
        return;
    }

    const active = await isHWIDActive(hwid);
    if (active) {
        await client.sendText(from, `❌ *ESTE HWID YA ESTÁ ACTIVO*

Si es tuyo, contacta soporte.`);
        return;
    }

    await client.sendText(from, '⏳ Activando tu HWID premium...');

    const result = await registerHWID(
        phone, 
        nombre,
        hwid, 
        planData.days, 
        'premium',
        planData.connections
    );

    if (result.success) {
        db.run(`UPDATE payments SET hwid = ?, nombre = ? WHERE payment_id = ?`,
            [hwid, nombre, data.paymentId]);

        const expireDate = moment(result.expires).format('DD/MM/YYYY HH:mm');

        await client.sendText(from, `*✅ ¡ACTIVACIÓN COMPLETADA!*

👤 *Nombre:* ${nombre}
🔐 *HWID:* ${hwid}
⏰ *Válido hasta:* ${expireDate}
🔌 *Conexiones:* ${planData.connections}

¡Ya puedes usar la aplicación!

Escribe *menu* para ver más opciones.`);

        console.log(chalk.green(`✅ HWID premium: ${hwid} - ${nombre} (${planData.days} días)`));
    } else {
        await client.sendText(from, `❌ *Error:* ${result.error}`);
    }

    await setUserState(phone, 'main_menu');
}

async function showMyHWIDs(phone, from) {
    db.all(
        `SELECT nombre, hwid, tipo, expires_at, max_connections,
                CASE WHEN status = 1 AND expires_at > datetime('now') THEN 'Activo' ELSE 'Inactivo' END as status_text
         FROM hwid_users 
         WHERE phone = ? 
         ORDER BY created_at DESC`,
        [phone],
        async (err, rows) => {
            if (err || !rows || rows.length === 0) {
                await client.sendText(from, `*📂 MIS HWIDs:*

No tienes HWIDs activos.

Para crear una prueba gratis escribe *menu* y elige la opción *1*.`);
                return;
            }

            let message = `*📂 MIS HWIDs ACTIVOS:*\n\n`;
            rows.forEach((hwid, index) => {
                const expires = moment(hwid.expires_at).format('DD/MM/YYYY HH:mm');
                message += `*HWID ${index + 1}:*\n`;
                message += `👤 Nombre: ${hwid.nombre}\n`;
                message += `🔐 Código: ${hwid.hwid}\n`;
                message += `📡 Tipo: ${hwid.tipo === 'test' ? 'Prueba' : 'Premium'}\n`;
                message += `🔌 Conexiones: ${hwid.max_connections}\n`;
                message += `⏰ Expira: ${expires}\n`;
                message += `✅ Estado: ${hwid.status_text}\n\n`;
            });

            message += `_Para renovar o comprar planes, escribe_ *menu*`;

            await client.sendText(from, message);
        }
    );

    await setUserState(phone, 'main_menu');
}

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

// ================================================
// CRON JOBS
// ================================================
function setupCronJobs() {
    // Verificar pagos cada 2 minutos
    cron.schedule('*/2 * * * *', () => {
        console.log(chalk.yellow('🔍 Verificando pagos pendientes...'));
        checkPendingPayments();
    });

    // Notificaciones de vencimiento cada hora
    cron.schedule('0 * * * *', () => {
        console.log(chalk.yellow('⏰ Verificando HWIDs próximos a vencer...'));
        checkExpiringHWIDs();
    });

    // Limpiar HWIDs expirados cada 15 minutos
    cron.schedule('*/15 * * * *', async () => {
        const now = moment().format('YYYY-MM-DD HH:mm:ss');
        console.log(chalk.yellow('🧹 Limpiando HWIDs expirados...'));
        db.run('UPDATE hwid_users SET status = 0 WHERE expires_at < ? AND status = 1', [now]);
    });

    // Limpiar estados antiguos cada hora
    cron.schedule('0 * * * *', () => {
        db.run(`DELETE FROM user_state WHERE updated_at < datetime('now', '-1 hour')`);
    });
}

// ================================================
// INICIAR BOT
// ================================================
async function startBot() {
    try {
        console.log(chalk.cyan(`🚀 Iniciando ${config.bot.name}...`));

        setupCronJobs();

        client = await wppconnect.create({
            session: 'sshbot-pro-hwid',
            headless: true,
            devtools: false,
            useChrome: true,
            debug: false,
            logQR: true,
            autoClose: 0, // Desactivar cierre automático
            browserWS: '',
            browserArgs: [
                '--no-sandbox',
                '--disable-setuid-sandbox',
                '--disable-dev-shm-usage',
                '--disable-accelerated-2d-canvas',
                '--no-first-run',
                '--no-zygote',
                '--disable-gpu',
                '--window-size=1920,1080'
            ],
            puppeteerOptions: {
                executablePath: config.paths.chromium || '/usr/bin/google-chrome',
                headless: 'new',
                args: ['--no-sandbox', '--disable-setuid-sandbox']
            },
            disableWelcome: true,
            updatesLog: false,
            folderNameToken: '/root/.wppconnect'
        });

        console.log(chalk.green('✅ WhatsApp conectado exitosamente!'));

        // QR Code handler
        client.onQRCode((qrCode) => {
            console.log(chalk.yellow('\n📱 ESCANEA ESTE CÓDIGO QR CON WHATSAPP:\n'));
            qrcode.generate(qrCode, { small: true });
            console.log(chalk.cyan('\n🔗 O usa este enlace (si el QR no aparece):'));
            console.log(chalk.cyan(`https://api.qrserver.com/v1/create-qr-code/?size=300x300&data=${encodeURIComponent(qrCode)}`));
        });

        client.onAuthenticated(() => {
            console.log(chalk.green('✅ Autenticación completada!'));
        });

        client.onStateChange((state) => {
            console.log(chalk.blue(`🔁 Estado: ${state}`));
        });

        client.onMessage(handleMessage);

        console.log(chalk.green.bold('\n✅ BOT INICIADO CORRECTAMENTE!'));
        console.log(chalk.cyan('📱 Escanea el código QR con WhatsApp Web'));
        console.log(chalk.cyan('💬 Envía "menu" a tu bot para comenzar\n'));

    } catch (error) {
        console.error(chalk.red('❌ Error iniciando bot:'), error);
        console.log(chalk.yellow('🔄 Reintentando en 10 segundos...'));
        setTimeout(startBot, 10000);
    }
}

startBot();

process.on('SIGINT', async () => {
    console.log(chalk.yellow('\n🛑 Cerrando bot...'));
    if (client) {
        await client.close();
    }
    process.exit();
});
BOTEOF

# Reemplazar la marca __BOT_NAME__
sed -i "s|__BOT_NAME__|$BOT_NAME|g" bot.js

echo -e "${GREEN}✅ Bot.js creado con menú completo y sistema HWID${NC}"

# ================================================
# CREAR PANEL DE CONTROL (sshbot)
# ================================================
echo -e "\n${CYAN}${BOLD}⚙️ CREANDO PANEL DE CONTROL...${NC}"

cat > "/usr/local/bin/sshbot" << 'CONTROLEOF'
#!/bin/bash
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; BLUE='\033[0;34m'; PURPLE='\033[0;35m'; NC='\033[0m'

DB="/opt/sshbot-pro/data/hwid.db"
CONFIG="/opt/sshbot-pro/config/config.json"

get_val() { jq -r "$1" "$CONFIG" 2>/dev/null; }
set_val() { local t=$(mktemp); jq "$1 = $2" "$CONFIG" > "$t" && mv "$t" "$CONFIG"; }

test_mercadopago() {
    local TOKEN="$1"
    echo -e "${YELLOW}🔄 Probando conexión con MercadoPago...${NC}"
    RESPONSE=$(curl -s -w "\n%{http_code}" -H "Authorization: Bearer $TOKEN" "https://api.mercadopago.com/v1/payment_methods" 2>/dev/null)
    HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
    if [[ "$HTTP_CODE" == "200" ]]; then
        echo -e "${GREEN}✅ CONEXIÓN EXITOSA${NC}"
        return 0
    else
        echo -e "${RED}❌ ERROR - Código: $HTTP_CODE${NC}"
        return 1
    fi
}

show_header() {
    clear
    BOT_NAME=$(get_val '.bot.name')
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║           🎛️  PANEL SSH BOT - VERSIÓN HWID                 ║${NC}"
    echo -e "${CYAN}║           🤖 ${BOT_NAME}                                    ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}\n"
}

while true; do
    show_header

    TOTAL_HWID=$(sqlite3 "$DB" "SELECT COUNT(*) FROM hwid_users" 2>/dev/null || echo "0")
    ACTIVE_HWID=$(sqlite3 "$DB" "SELECT COUNT(*) FROM hwid_users WHERE status=1" 2>/dev/null || echo "0")
    PENDING_PAYMENTS=$(sqlite3 "$DB" "SELECT COUNT(*) FROM payments WHERE status='pending'" 2>/dev/null || echo "0")
    APPROVED_PAYMENTS=$(sqlite3 "$DB" "SELECT COUNT(*) FROM payments WHERE status='approved'" 2>/dev/null || echo "0")
    TESTS_TODAY=$(sqlite3 "$DB" "SELECT COUNT(*) FROM daily_tests WHERE date = date('now')" 2>/dev/null || echo "0")

    STATUS=$(pm2 jlist 2>/dev/null | jq -r '.[] | select(.name=="sshbot-pro") | .pm2_env.status' 2>/dev/null || echo "stopped")
    if [[ "$STATUS" == "online" ]]; then
        BOT_STATUS="${GREEN}● ACTIVO${NC}"
    else
        BOT_STATUS="${RED}● DETENIDO${NC}"
    fi

    MP_TOKEN=$(get_val '.mercadopago.access_token')
    if [[ -n "$MP_TOKEN" && "$MP_TOKEN" != "" && "$MP_TOKEN" != "null" ]]; then
        MP_STATUS="${GREEN}✅ CONFIGURADO${NC}"
    else
        MP_STATUS="${RED}❌ NO CONFIGURADO${NC}"
    fi

    echo -e "${YELLOW}📊 ESTADO DEL SISTEMA${NC}"
    echo -e "  Bot: $BOT_STATUS"
    echo -e "  HWIDs: ${CYAN}$ACTIVE_HWID/$TOTAL_HWID${NC} activos/total"
    echo -e "  Tests hoy: ${CYAN}$TESTS_TODAY${NC}"
    echo -e "  Pagos: ${CYAN}$PENDING_PAYMENTS${NC} pend | ${GREEN}$APPROVED_PAYMENTS${NC} aprob"
    echo -e "  MercadoPago: $MP_STATUS"
    echo -e "  IP: $(get_val '.bot.server_ip')"
    echo -e "  ⏱️  Prueba: ${YELLOW}$(get_val '.prices.test_hours') HORAS${NC}"
    echo -e ""

    echo -e "${YELLOW}💰 PRECIOS ACTUALES:${NC}"
    echo -e "  7d 1c: $ $(get_val '.prices.price_7d_1conn') | 15d 1c: $ $(get_val '.prices.price_15d_1conn')"
    echo -e "  30d 1c: $ $(get_val '.prices.price_30d_1conn') | 50d 1c: $ $(get_val '.prices.price_50d_1conn')"
    echo -e "  7d 2c: $ $(get_val '.prices.price_7d_2conn') | 15d 2c: $ $(get_val '.prices.price_15d_2conn')"
    echo -e "  30d 2c: $ $(get_val '.prices.price_30d_2conn')"
    echo -e ""

    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}[1]${NC} 🚀  Iniciar/Reiniciar bot"
    echo -e "${CYAN}[2]${NC} 🛑  Detener bot"
    echo -e "${CYAN}[3]${NC} 📱  Ver logs y QR"
    echo -e "${CYAN}[4]${NC} 🔐  Registrar HWID manual"
    echo -e "${CYAN}[5]${NC} 👥  Listar HWIDs activos"
    echo -e "${CYAN}[6]${NC} 💰  Cambiar precios"
    echo -e "${CYAN}[7]${NC} 🔑  Configurar MercadoPago"
    echo -e "${CYAN}[8]${NC} 🧪  Test MercadoPago"
    echo -e "${CYAN}[9]${NC} 📊  Estadísticas"
    echo -e "${CYAN}[10]${NC} 🔄 Limpiar sesión WhatsApp"
    echo -e "${CYAN}[11]${NC} 💳 Ver pagos"
    echo -e "${CYAN}[12]${NC} 🔍 Buscar HWID"
    echo -e "${CYAN}[13]${NC} 🧪 Ver tests de hoy"
    echo -e "${CYAN}[0]${NC} 🚪  Salir"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e ""

    read -p "👉 Selecciona: " OPTION

    case $OPTION in
        1)
            echo -e "\n${YELLOW}🔄 Reiniciando...${NC}"
            cd /root/sshbot-pro
            pm2 restart sshbot-pro 2>/dev/null || pm2 start bot.js --name sshbot-pro
            pm2 save
            echo -e "${GREEN}✅ Bot reiniciado${NC}"
            sleep 2
            ;;
        2)
            echo -e "\n${YELLOW}🛑 Deteniendo...${NC}"
            pm2 stop sshbot-pro
            echo -e "${GREEN}✅ Bot detenido${NC}"
            sleep 2
            ;;
        3)
            echo -e "\n${YELLOW}📱 Mostrando logs...${NC}"
            pm2 logs sshbot-pro --lines 100
            ;;
        4)
            clear
            echo -e "${CYAN}🔐 REGISTRAR HWID MANUAL${NC}\n"

            read -p "Teléfono (ej: 5491122334455): " PHONE
            read -p "Nombre del usuario: " NOMBRE
            read -p "HWID (formato: APP-E3E4D5CBB7636907): " HWID
            read -p "Tipo (test/premium): " TIPO
            read -p "Días (0=test, 7,15,30,50): " DAYS
            read -p "Conexiones (1 o 2): " CONN

            [[ -z "$DAYS" ]] && DAYS="30"
            [[ -z "$CONN" ]] && CONN="1"

            HWID=$(echo "$HWID" | tr 'a-z' 'A-Z')
            if [[ ! "$HWID" =~ ^APP-[A-F0-9]{16}$ ]]; then
                echo -e "\n${RED}❌ Formato HWID inválido${NC}"
                read -p "Presiona Enter..."
                continue
            fi

            if [[ "$TIPO" == "test" ]]; then
                DAYS="0"
                EXPIRE_DATE=$(date -d "+$(get_val '.prices.test_hours') hours" +"%Y-%m-%d %H:%M:%S")
            else
                EXPIRE_DATE=$(date -d "+$DAYS days" +"%Y-%m-%d 23:59:59")
            fi

            sqlite3 "$DB" "INSERT INTO hwid_users (phone, nombre, hwid, tipo, expires_at, max_connections, status) VALUES ('$PHONE', '$NOMBRE', '$HWID', '$TIPO', '$EXPIRE_DATE', $CONN, 1)"

            if [[ $? -eq 0 ]]; then
                echo -e "\n${GREEN}✅ HWID REGISTRADO${NC}"
                echo -e "📱 Teléfono: ${PHONE}"
                echo -e "👤 Nombre: ${NOMBRE}"
                echo -e "🔐 HWID: ${HWID}"
                echo -e "⏰ Expira: ${EXPIRE_DATE}"
                echo -e "🔌 Conexiones: ${CONN}"
            else
                echo -e "\n${RED}❌ Error (puede que el HWID ya exista)${NC}"
            fi
            read -p "Presiona Enter..."
            ;;
        5)
            clear
            echo -e "${CYAN}👥 HWIDs ACTIVOS${NC}\n"

            sqlite3 -column -header "$DB" "SELECT nombre, hwid, phone, tipo, max_connections, expires_at FROM hwid_users WHERE status = 1 ORDER BY expires_at DESC LIMIT 20"
            echo -e "\n${YELLOW}Total activos: ${ACTIVE_HWID}${NC}"
            read -p "Presiona Enter..."
            ;;
        6)
            clear
            echo -e "${CYAN}💰 CAMBIAR PRECIOS${NC}\n"

            CURRENT_7D1=$(get_val '.prices.price_7d_1conn')
            CURRENT_15D1=$(get_val '.prices.price_15d_1conn')
            CURRENT_30D1=$(get_val '.prices.price_30d_1conn')
            CURRENT_50D1=$(get_val '.prices.price_50d_1conn')
            CURRENT_7D2=$(get_val '.prices.price_7d_2conn')
            CURRENT_15D2=$(get_val '.prices.price_15d_2conn')
            CURRENT_30D2=$(get_val '.prices.price_30d_2conn')

            echo -e "${YELLOW}Precios actuales (1 conexión):${NC}"
            echo -e "  7 días: $${CURRENT_7D1} | 15 días: $${CURRENT_15D1} | 30 días: $${CURRENT_30D1} | 50 días: $${CURRENT_50D1}"
            echo -e "${YELLOW}Precios actuales (2 conexiones):${NC}"
            echo -e "  7 días: $${CURRENT_7D2} | 15 días: $${CURRENT_15D2} | 30 días: $${CURRENT_30D2}\n"

            read -p "Nuevo precio 7d 1c [${CURRENT_7D1}]: " NEW_7D1
            read -p "Nuevo precio 15d 1c [${CURRENT_15D1}]: " NEW_15D1
            read -p "Nuevo precio 30d 1c [${CURRENT_30D1}]: " NEW_30D1
            read -p "Nuevo precio 50d 1c [${CURRENT_50D1}]: " NEW_50D1
            read -p "Nuevo precio 7d 2c [${CURRENT_7D2}]: " NEW_7D2
            read -p "Nuevo precio 15d 2c [${CURRENT_15D2}]: " NEW_15D2
            read -p "Nuevo precio 30d 2c [${CURRENT_30D2}]: " NEW_30D2

            [[ -n "$NEW_7D1" ]] && set_val '.prices.price_7d_1conn' "$NEW_7D1"
            [[ -n "$NEW_15D1" ]] && set_val '.prices.price_15d_1conn' "$NEW_15D1"
            [[ -n "$NEW_30D1" ]] && set_val '.prices.price_30d_1conn' "$NEW_30D1"
            [[ -n "$NEW_50D1" ]] && set_val '.prices.price_50d_1conn' "$NEW_50D1"
            [[ -n "$NEW_7D2" ]] && set_val '.prices.price_7d_2conn' "$NEW_7D2"
            [[ -n "$NEW_15D2" ]] && set_val '.prices.price_15d_2conn' "$NEW_15D2"
            [[ -n "$NEW_30D2" ]] && set_val '.prices.price_30d_2conn' "$NEW_30D2"

            echo -e "\n${GREEN}✅ Precios actualizados${NC}"
            read -p "Presiona Enter..."
            ;;
        7)
            clear
            echo -e "${CYAN}🔑 CONFIGURAR MERCADOPAGO${NC}\n"

            CURRENT_TOKEN=$(get_val '.mercadopago.access_token')

            if [[ -n "$CURRENT_TOKEN" && "$CURRENT_TOKEN" != "null" && "$CURRENT_TOKEN" != "" ]]; then
                echo -e "${GREEN}✅ Token configurado${NC}"
                echo -e "${YELLOW}Preview: ${CURRENT_TOKEN:0:30}...${NC}\n"
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
                    cd /root/sshbot-pro && pm2 restart sshbot-pro
                    sleep 2
                    echo -e "${GREEN}✅ MercadoPago activado${NC}"
                else
                    echo -e "${RED}❌ Token inválido${NC}"
                fi
            fi
            read -p "Presiona Enter..."
            ;;
        8)
            clear
            echo -e "${CYAN}🧪 TEST MERCADOPAGO${NC}\n"

            TOKEN=$(get_val '.mercadopago.access_token')
            if [[ -z "$TOKEN" || "$TOKEN" == "null" ]]; then
                echo -e "${RED}❌ Token no configurado${NC}\n"
                read -p "Presiona Enter..."
                continue
            fi

            test_mercadopago "$TOKEN"

            read -p "\nPresiona Enter..."
            ;;
        9)
            clear
            echo -e "${CYAN}📊 ESTADÍSTICAS${NC}\n"

            echo -e "${YELLOW}🔐 HWIDs:${NC}"
            sqlite3 "$DB" "SELECT 'Total: ' || COUNT(*) || ' | Activos: ' || SUM(CASE WHEN status=1 THEN 1 ELSE 0 END) || ' | Tests hoy: ' || (SELECT COUNT(*) FROM daily_tests WHERE date = date('now')) FROM hwid_users"

            echo -e "\n${YELLOW}💰 PAGOS:${NC}"
            sqlite3 "$DB" "SELECT 'Pendientes: ' || SUM(CASE WHEN status='pending' THEN 1 ELSE 0 END) || ' | Aprobados: ' || SUM(CASE WHEN status='approved' THEN 1 ELSE 0 END) || ' | Total: $' || printf('%.2f', SUM(CASE WHEN status='approved' THEN amount ELSE 0 END)) FROM payments"

            echo -e "\n${YELLOW}📅 PLANES VENDIDOS:${NC}"
            sqlite3 "$DB" "SELECT '7d: ' || SUM(CASE WHEN plan LIKE '%7 días%' THEN 1 ELSE 0 END) || ' | 15d: ' || SUM(CASE WHEN plan LIKE '%15 días%' THEN 1 ELSE 0 END) || ' | 30d: ' || SUM(CASE WHEN plan LIKE '%30 días%' THEN 1 ELSE 0 END) || ' | 50d: ' || SUM(CASE WHEN plan LIKE '%50 días%' THEN 1 ELSE 0 END) FROM payments WHERE status='approved'"

            echo -e "\n${YELLOW}💸 INGRESOS HOY:${NC}"
            sqlite3 "$DB" "SELECT 'Hoy: $' || printf('%.2f', SUM(CASE WHEN date(created_at) = date('now') THEN amount ELSE 0 END)) FROM payments WHERE status='approved'"

            read -p "\nPresiona Enter..."
            ;;
        10)
            echo -e "\n${YELLOW}🧹 Limpiando sesión WhatsApp...${NC}"
            pm2 stop sshbot-pro
            rm -rf /root/.wppconnect/*
            echo -e "${GREEN}✅ Sesión limpiada. Reinicia el bot para generar nuevo QR.${NC}"
            sleep 2
            ;;
        11)
            clear
            echo -e "${CYAN}💳 PAGOS${NC}\n"

            echo -e "${YELLOW}Pagos pendientes:${NC}"
            sqlite3 -column -header "$DB" "SELECT payment_id, phone, plan, amount, created_at FROM payments WHERE status='pending' ORDER BY created_at DESC LIMIT 10"

            echo -e "\n${YELLOW}Pagos aprobados:${NC}"
            sqlite3 -column -header "$DB" "SELECT payment_id, phone, nombre, plan, amount, approved_at, hwid FROM payments WHERE status='approved' ORDER BY approved_at DESC LIMIT 10"

            read -p "\nPresiona Enter..."
            ;;
        12)
            clear
            echo -e "${CYAN}🔍 BUSCAR HWID${NC}\n"
            read -p "Ingresa HWID, nombre o teléfono: " SEARCH

            echo -e "\n${YELLOW}Resultados:${NC}"
            sqlite3 -column -header "$DB" "SELECT nombre, hwid, phone, tipo, max_connections, expires_at, status FROM hwid_users WHERE hwid LIKE '%$SEARCH%' OR phone LIKE '%$SEARCH%' OR nombre LIKE '%$SEARCH%'"

            read -p "\nPresiona Enter..."
            ;;
        13)
            clear
            echo -e "${CYAN}🧪 TESTS DE HOY${NC}\n"

            sqlite3 -column -header "$DB" "SELECT nombre, phone, created_at FROM daily_tests WHERE date = date('now') ORDER BY created_at DESC"

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
CONTROLEOF

chmod +x /usr/local/bin/sshbot
ln -sf /usr/local/bin/sshbot /usr/local/bin/sshbot-control 2>/dev/null || true

# ================================================
# CONFIGURAR CRON Y PM2
# ================================================
pm2 startup
pm2 save

# ================================================
# INICIAR BOT
# ================================================
echo -e "\n${CYAN}${BOLD}🚀 INICIANDO BOT...${NC}"
cd "$USER_HOME"
pm2 start bot.js --name sshbot-pro --time
pm2 save

sleep 3

# ================================================
# MENSAJE FINAL
# ================================================
clear
echo -e "${GREEN}${BOLD}"
cat << "FINAL"
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║          🎉 INSTALACIÓN COMPLETADA EXITOSAMENTE! 🎉         ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
FINAL
echo -e "${NC}"

echo -e "${CYAN}══════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✅ BOT HWID CON MENÚ COMPLETO INSTALADO${NC}"
echo -e "${GREEN}✅ Nombre del bot: ${CYAN}$BOT_NAME${NC}"
echo -e "${GREEN}✅ IP del servidor: ${CYAN}$SERVER_IP${NC}"
echo -e "${GREEN}✅ QR CORREGIDO - Auto Close desactivado${NC}"
echo -e "${CYAN}══════════════════════════════════════════════════════════════${NC}\n"

echo -e "${YELLOW}📋 COMANDOS PRINCIPALES:${NC}\n"
echo -e "  ${GREEN}sshbot${NC}         - Panel de control completo"
echo -e "  ${GREEN}pm2 logs sshbot-pro${NC} - Ver logs y QR del bot"
echo -e "  ${GREEN}pm2 restart sshbot-pro${NC} - Reiniciar el bot"
echo -e "\n"

read -p "$(echo -e "${YELLOW}¿Ver logs ahora? (s/N): ${NC}")" -n 1 -r
echo
if [[ $REPLY =~ ^[Ss]$ ]]; then
    echo -e "\n${CYAN}Mostrando logs...${NC}"
    echo -e "${YELLOW}📱 Escanea el QR cuando aparezca...${NC}\n"
    sleep 2
    pm2 logs sshbot-pro
fi

exit 0
