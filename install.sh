#!/bin/bash
# ================================================
# SSH BOT PRO v8.6 - CON INTELIGENCIA ARTIFICIAL
# Funcionalidades agregadas:
# 1. ✅ Asistente IA con Google Gemini
# 2. ✅ Analizador de comportamiento de usuarios
# 3. ✅ Sistema de alertas de seguridad
# 4. ✅ Detección de comportamiento sospechoso
# Correcciones aplicadas:
# 5. ✅ Validación token MercadoPago FIXED
# 6. ✅ Fechas ISO 8601 correctas (MP SDK v2.x)
# 7. ✅ Parche error markedUnread de WhatsApp Web
# 8. ✅ Inicialización MP SDK corregida
# 9. ✅ Panel de control funcionando 100%
# AJUSTES ESPECÍFICOS:
# 10. ✅ Test cambiado a 2 horas
# 11. ✅ Cron limpieza cambiado a cada 15 minutos
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
║     ███████╗███████╗██║  ██║    ██████╗  ██████╗ ████████╗  ║
║     ██╔════╝██╔════╝██║  ██║    ██╔══██╗██╔═══██╗╚══██╔══╝  ║
║     ███████╗███████╗███████║    ██████╔╝██║   ██║   ██║     ║
║     ╚════██║╚════██║██╔══██║    ██╔══██╗██║   ██║   ██║     ║
║     ███████║███████║██║  ██║    ██████╔╝╚██████╔╝   ██║     ║
║     ╚══════╝╚══════╝╚═╝  ╚═╝    ╚═════╝  ╚═════╝    ╚═╝     ║
╠══════════════════════════════════════════════════════════════╣
║                                                              ║
║           🚀 SSH BOT PRO v8.6 - IA INTEGRADA               ║
║               🤖 Google Gemini AI + Análisis de Comportamiento ║
║               💳 MercadoPago SDK v2.x FULLY FIXED           ║
║               📅 ISO 8601 Dates Corrected                   ║
║               🔑 Token Validation Fixed                      ║
║               🤖 WhatsApp markedUnread Patched              ║
║               📱 APK Auto + 2h Test                         ║
║               🚨 Sistema de alertas de seguridad           ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
BANNER
echo -e "${NC}"

echo -e "${GREEN}✅ FUNCIONALIDADES DE IA AGREGADAS:${NC}"
echo -e "  🤖 ${CYAN}Asistente IA:${NC} Google Gemini Pro integrado"
echo -e "  📊 ${CYAN}Analizador:${NC} Comportamiento y riesgo de usuarios"
echo -e "  🚨 ${CYAN}Alertas:${NC} Sistema automático de seguridad"
echo -e "  🔍 ${CYAN}Detección:${NC} Comportamiento sospechoso y fraudes"
echo -e "${GREEN}✅ CORRECCIONES APLICADAS:${NC}"
echo -e "  🔴 ${RED}FIX 1:${NC} Validación token MP corregida"
echo -e "  🟡 ${YELLOW}FIX 2:${NC} Fechas ISO 8601 para MP v2.x"
echo -e "  🟢 ${GREEN}FIX 3:${NC} Parche error 'markedUnread' WhatsApp"
echo -e "  🔵 ${BLUE}FIX 4:${NC} Inicialización MP SDK corregida"
echo -e "  🟣 ${PURPLE}FIX 5:${NC} Panel de control 100% funcional"
echo -e "  ⏰ ${CYAN}FIX 6:${NC} Test ajustado a 2 horas"
echo -e "  ⚡ ${CYAN}FIX 7:${NC} Cron limpieza cada 15 minutos"
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
echo -e "   • Instalar Node.js 20.x + Chrome + Dependencias IA"
echo -e "   • Crear SSH Bot Pro v8.6 CON INTELIGENCIA ARTIFICIAL"
echo -e "   • 🤖 Integrar Google Gemini AI con tu API Key"
echo -e "   • 📊 Sistema de análisis de comportamiento"
echo -e "   • 🚨 Alertas automáticas de seguridad"
echo -e "   • Aplicar parche error WhatsApp Web"
echo -e "   • Configurar fechas ISO 8601 correctas"
echo -e "   • Panel de control 100% funcional con opciones IA"
echo -e "   • APK automático + Test 2h"
echo -e "   • Cron limpieza cada 15 minutos"
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
echo -e "\n${CYAN}${BOLD}📦 INSTALANDO DEPENDENCIAS (INCLUYENDO IA)...${NC}"

echo -e "${YELLOW}🔄 Actualizando sistema...${NC}"
export DEBIAN_FRONTEND=noninteractive
apt-get update -qq > /dev/null 2>&1

echo -e "${YELLOW}📥 Instalando paquetes básicos...${NC}"
apt-get install -y -qq \
    curl wget git unzip \
    sqlite3 jq nano htop \
    cron build-essential \
    ca-certificates gnupg \
    software-properties-common \
    libgbm-dev libxshmfence-dev \
    sshpass at \
    libnotify-bin \
    > /dev/null 2>&1

# Habilitar servicio 'at'
systemctl enable atd 2>/dev/null || true
systemctl start atd 2>/dev/null || true

# Google Chrome
echo -e "${YELLOW}🌐 Instalando Google Chrome...${NC}"
if ! command -v google-chrome &> /dev/null; then
    wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/chrome.deb
    apt-get install -y -qq /tmp/chrome.deb > /dev/null 2>&1
    rm -f /tmp/chrome.deb
fi

# Node.js 20.x
echo -e "${YELLOW}🟢 Instalando Node.js 20.x...${NC}"
if ! command -v node &> /dev/null; then
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - > /dev/null 2>&1
    apt-get install -y -qq nodejs > /dev/null 2>&1
fi

# PM2 global
echo -e "${YELLOW}⚡ Instalando PM2...${NC}"
npm install -g pm2 --silent > /dev/null 2>&1

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

# Crear configuración con IA
cat > "$CONFIG_FILE" << EOF
{
    "bot": {
        "name": "SSH Bot Pro",
        "version": "8.6-IA-EDITION",
        "server_ip": "$SERVER_IP",
        "google_ai_key": "AIzaSyBojMPaBM6NpRbXQP7sC9D9aXc2XZmI8_Q"
    },
    "prices": {
        "test_hours": 2,
        "price_7d": 500.00,
        "price_15d": 800.00,
        "price_30d": 1200.00,
        "currency": "ARS"
    },
    "mercadopago": {
        "access_token": "",
        "enabled": false
    },
    "ai": {
        "enabled": true,
        "provider": "google_gemini",
        "model": "gemini-pro",
        "max_tokens": 1000
    },
    "behavior_analysis": {
        "enabled": true,
        "risk_monitoring": true,
        "alert_system": true
    },
    "links": {
        "tutorial": "https://youtube.com",
        "support": "https://t.me/soporte"
    },
    "paths": {
        "database": "$DB_FILE",
        "chromium": "/usr/bin/google-chrome",
        "qr_codes": "$INSTALL_DIR/qr_codes"
    }
}
EOF

# Crear base de datos con tablas de IA
sqlite3 "$DB_FILE" << 'SQL'
CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    phone TEXT,
    username TEXT UNIQUE,
    password TEXT,
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
-- TABLAS DE INTELIGENCIA ARTIFICIAL
CREATE TABLE user_behavior (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    phone TEXT,
    username TEXT,
    action_type TEXT,
    details TEXT,
    risk_score INTEGER DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (phone) REFERENCES users(phone)
);
CREATE TABLE ai_conversations (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    phone TEXT,
    user_query TEXT,
    ai_response TEXT,
    context TEXT,
    tokens_used INTEGER DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE risk_alerts (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    phone TEXT,
    username TEXT,
    alert_type TEXT,
    severity TEXT CHECK(severity IN ('low', 'medium', 'high', 'critical')),
    description TEXT,
    resolved BOOLEAN DEFAULT 0,
    resolved_at DATETIME,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
-- ÍNDICES
CREATE INDEX idx_users_phone ON users(phone);
CREATE INDEX idx_users_status ON users(status);
CREATE INDEX idx_payments_status ON payments(status);
CREATE INDEX idx_behavior_phone ON user_behavior(phone);
CREATE INDEX idx_behavior_risk ON user_behavior(risk_score);
CREATE INDEX idx_ai_conversations_phone ON ai_conversations(phone);
CREATE INDEX idx_ai_conversations_time ON ai_conversations(created_at);
CREATE INDEX idx_alerts_severity ON risk_alerts(severity);
CREATE INDEX idx_alerts_resolved ON risk_alerts(resolved);
CREATE INDEX idx_alerts_time ON risk_alerts(created_at);
SQL

echo -e "${GREEN}✅ Estructura creada con tablas de IA${NC}"

# ================================================
# CREAR BOT CON INTELIGENCIA ARTIFICIAL
# ================================================
echo -e "\n${CYAN}${BOLD}🤖 CREANDO BOT CON INTELIGENCIA ARTIFICIAL...${NC}"

cd "$USER_HOME"

# package.json con todas las dependencias de IA
cat > package.json << 'PKGEOF'
{
    "name": "ssh-bot-pro-ia",
    "version": "8.6.0",
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
        "axios": "^1.6.5",
        "@google/generative-ai": "^0.8.0",
        "compromise": "^14.0.0",
        "node-notifier": "^10.0.1"
    }
}
PKGEOF

echo -e "${YELLOW}📦 Instalando paquetes Node.js (incluyendo IA)...${NC}"
npm install --silent 2>&1 | grep -v "npm WARN" || true

# ✅ APLICAR PARCHE PARA ERROR markedUnread (FIX 3)
echo -e "${YELLOW}🔧 Aplicando parche para error WhatsApp Web...${NC}"
find node_modules/whatsapp-web.js -name "Client.js" -type f -exec sed -i 's/if (chat && chat.markedUnread)/if (false \&\& chat.markedUnread)/g' {} \; 2>/dev/null || true
find node_modules/whatsapp-web.js -name "Client.js" -type f -exec sed -i 's/const sendSeen = async (chatId) => {/const sendSeen = async (chatId) => { console.log("[DEBUG] sendSeen deshabilitado"); return;/g' {} \; 2>/dev/null || true

echo -e "${GREEN}✅ Parche markedUnread aplicado${NC}"

# Crear bot.js CON INTELIGENCIA ARTIFICIAL
echo -e "${YELLOW}📝 Creando bot.js con IA y análisis de comportamiento...${NC}"

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

// MÓDULOS DE INTELIGENCIA ARTIFICIAL
const { GoogleGenerativeAI } = require("@google/generative-ai");
const nlp = require("compromise");
const notifier = require('node-notifier');

const execPromise = util.promisify(exec);

function loadConfig() {
    delete require.cache[require.resolve('/opt/ssh-bot/config/config.json')];
    return require('/opt/ssh-bot/config/config.json');
}

let config = loadConfig();
const db = new sqlite3.Database(config.paths.database);

// ✅ FIX 4: MERCADOPAGO SDK V2.X - INICIALIZACIÓN CORRECTA
let mpClient = null;
let mpPreference = null;

function initMercadoPago() {
    config = loadConfig();
    if (config.mercadopago.access_token && config.mercadopago.access_token !== '') {
        try {
            const { MercadoPagoConfig, Preference } = require('mercadopago');
            
            // ✅ Cliente SDK v2.x
            mpClient = new MercadoPagoConfig({ 
                accessToken: config.mercadopago.access_token,
                options: { timeout: 5000, idempotencyKey: true }
            });
            
            // ✅ Cliente de preferencias
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

// ================================================
// SISTEMA DE INTELIGENCIA ARTIFICIAL
// ================================================

let genAI = null;
let iaModel = null;
let iaEnabled = false;

// Configuración de análisis de comportamiento
const BEHAVIOR_CONFIG = {
    // Puntos de riesgo por acción
    riskScores: {
        multiple_test_requests: 30,
        rapid_menu_access: 10,
        payment_retry: 25,
        connection_abuse: 50,
        suspicious_keywords: 20,
        frequent_support: 15,
        test_expiry_abuse: 40,
        negative_sentiment: 15,
        ai_consultation: 5,
        test_created: 5,
        purchase_attempt: 10,
        accounts_check: 3,
        payment_status_check: 3,
        app_download_request: 5,
        support_request: 8
    },
    
    // Límites para alertas
    thresholds: {
        high_risk: 70,
        medium_risk: 40,
        low_risk: 20,
        rapid_actions: 5,
        max_daily_tests: 3
    },
    
    // Palabras clave sospechosas
    suspiciousKeywords: [
        'hack', 'crack', 'free', 'premium gratis', 'bypass',
        'exploit', 'violar', 'truco', 'trampa', 'ilegal',
        'estafar', 'robar', 'cuenta ajena', 'shared account',
        'crackear', 'violación', 'piratear', 'conseguir gratis'
    ]
};

// Inicializar Google Gemini AI
function initGoogleAI() {
    try {
        const apiKey = config.bot.google_ai_key || process.env.GOOGLE_AI_API_KEY || '';
        
        if (!apiKey || apiKey === '' || apiKey === 'AIzaSyBojMPaBM6NpRbXQP7sC9D9aXc2XZmI8_Q') {
            console.log(chalk.yellow('⚠️ Google AI API KEY no configurada - IA deshabilitada'));
            iaEnabled = false;
            return false;
        }
        
        genAI = new GoogleGenerativeAI(apiKey);
        iaModel = genAI.getGenerativeModel({ model: "gemini-pro" });
        iaEnabled = true;
        
        console.log(chalk.green('✅ Google Gemini AI inicializado'));
        console.log(chalk.cyan('🤖 Modelo: gemini-pro'));
        return true;
    } catch (error) {
        console.log(chalk.red('❌ Error inicializando Google AI:'), error.message);
        iaEnabled = false;
        return false;
    }
}

// Inicializar IA al arrancar
initGoogleAI();

console.log(chalk.cyan.bold('\n╔══════════════════════════════════════════════════════════════╗'));
console.log(chalk.cyan.bold('║      🤖 SSH BOT PRO v8.6 - IA EDITION                       ║'));
console.log(chalk.cyan.bold('║         🤖 Asistente IA + 📊 Análisis de Comportamiento     ║'));
console.log(chalk.cyan.bold('╚══════════════════════════════════════════════════════════════╝\n'));
console.log(chalk.yellow(`📍 IP: ${config.bot.server_ip}`));
console.log(chalk.yellow(`💳 MercadoPago: ${mpEnabled ? '✅ SDK v2.x ACTIVO' : '❌ NO CONFIGURADO'}`));
console.log(chalk.magenta(`🤖 Google Gemini AI: ${iaEnabled ? '✅ CONFIGURADO' : '❌ NO CONFIGURADO'}`));
console.log(chalk.magenta('📊 Análisis de Comportamiento: ✅ ACTIVO'));
console.log(chalk.magenta('🚨 Sistema de Alertas: ✅ ACTIVADO'));
console.log(chalk.green('✅ WhatsApp Web parcheado (no markedUnread error)'));
console.log(chalk.green('✅ Fechas ISO 8601 corregidas'));
console.log(chalk.green('✅ APK automático desde /root'));
console.log(chalk.green('✅ Test 2 horas exactas'));
console.log(chalk.green('✅ Limpieza cada 15 minutos'));
console.log(chalk.green('✅ MOD: Solicita nombre personalizado'));
console.log(chalk.green('✅ MOD: Usuarios terminan en "j"'));
console.log(chalk.green('✅ MOD: Contraseña siempre "12345"'));

// ================================================
// FUNCIONES DE ANÁLISIS DE COMPORTAMIENTO
// ================================================

// Registrar comportamiento de usuario
async function logUserBehavior(phone, actionType, details = {}) {
    try {
        // Calcular puntaje de riesgo
        let riskScore = BEHAVIOR_CONFIG.riskScores[actionType] || 0;
        
        // Análisis de texto para palabras sospechosas
        if (details.message) {
            const message = details.message.toLowerCase();
            const foundKeywords = BEHAVIOR_CONFIG.suspiciousKeywords.filter(keyword => 
                message.includes(keyword.toLowerCase())
            );
            
            if (foundKeywords.length > 0) {
                riskScore += BEHAVIOR_CONFIG.riskScores.suspicious_keywords;
                details.keywords_found = foundKeywords;
            }
        }
        
        // Insertar registro
        db.run(
            `INSERT INTO user_behavior (phone, username, action_type, details, risk_score) VALUES (?, ?, ?, ?, ?)`,
            [phone, details.username || null, actionType, JSON.stringify(details), riskScore],
            (err) => {
                if (err) console.error(chalk.red('❌ Error registrando comportamiento:'), err.message);
            }
        );
        
        // Verificar si necesita alerta
        await checkRiskAlerts(phone, riskScore, actionType, details);
        
        return riskScore;
    } catch (error) {
        console.error(chalk.red('❌ Error en logUserBehavior:'), error.message);
        return 0;
    }
}

// Verificar alertas de riesgo
async function checkRiskAlerts(phone, riskScore, actionType, details) {
    try {
        let alertSeverity = null;
        let alertDescription = '';
        
        if (riskScore >= BEHAVIOR_CONFIG.thresholds.high_risk) {
            alertSeverity = 'high';
            alertDescription = `Alto riesgo detectado (Score: ${riskScore}) - Acción: ${actionType}`;
        } else if (riskScore >= BEHAVIOR_CONFIG.thresholds.medium_risk) {
            alertSeverity = 'medium';
            alertDescription = `Riesgo medio detectado (Score: ${riskScore}) - Acción: ${actionType}`;
        } else if (riskScore >= BEHAVIOR_CONFIG.thresholds.low_risk) {
            alertSeverity = 'low';
            alertDescription = `Riesgo bajo detectado (Score: ${riskScore}) - Acción: ${actionType}`;
        }
        
        if (alertSeverity) {
            // Insertar alerta
            db.run(
                `INSERT INTO risk_alerts (phone, username, alert_type, severity, description) VALUES (?, ?, ?, ?, ?)`,
                [phone, details.username || null, actionType, alertSeverity, alertDescription],
                (err) => {
                    if (err) {
                        console.error(chalk.red('❌ Error creando alerta:'), err.message);
                    } else {
                        console.log(chalk.yellow(`⚠️ Alerta ${alertSeverity}: ${alertDescription}`));
                        
                        // Notificación para admin (solo high)
                        if (alertSeverity === 'high') {
                            sendAdminAlert(phone, alertDescription, alertSeverity);
                        }
                    }
                }
            );
        }
        
        // Verificar comportamiento rápido (posible bot)
        const rapidActions = await checkRapidActions(phone);
        if (rapidActions >= BEHAVIOR_CONFIG.thresholds.rapid_actions) {
            db.run(
                `INSERT INTO risk_alerts (phone, alert_type, severity, description) VALUES (?, 'rapid_actions', 'medium', ?)`,
                [phone, `Comportamiento rápido detectado: ${rapidActions} acciones en 2 minutos`]
            );
        }
        
    } catch (error) {
        console.error(chalk.red('❌ Error en checkRiskAlerts:'), error.message);
    }
}

// Verificar acciones rápidas
async function checkRapidActions(phone) {
    return new Promise((resolve) => {
        const twoMinutesAgo = moment().subtract(2, 'minutes').format('YYYY-MM-DD HH:mm:ss');
        
        db.get(
            `SELECT COUNT(*) as count FROM user_behavior WHERE phone = ? AND created_at > ?`,
            [phone, twoMinutesAgo],
            (err, row) => {
                if (err || !row) resolve(0);
                else resolve(row.count);
            }
        );
    });
}

// Enviar alerta a admin
function sendAdminAlert(phone, description, severity) {
    console.log(chalk.bgRed.white.bold(`\n🚨 ALERTA DE SEGURIDAD ${severity.toUpperCase()} 🚨`));
    console.log(chalk.red(`📞 Usuario: ${phone}`));
    console.log(chalk.red(`📝 Descripción: ${description}`));
    console.log(chalk.red(`⏰ Hora: ${moment().format('DD/MM/YYYY HH:mm:ss')}\n`));
    
    // Notificación del sistema
    try {
        notifier.notify({
            title: `🚨 SSH Bot Alert - ${severity.toUpperCase()}`,
            message: `${description}\nUsuario: ${phone}`,
            sound: true,
            wait: true
        });
    } catch (error) {
        // Silenciar error si no hay sistema de notificaciones
    }
}

// ================================================
// ASISTENTE DE IA CON GEMINI
// ================================================

async function consultarIA(prompt, phone, contexto = '') {
    try {
        if (!iaEnabled || !iaModel) {
            if (!initGoogleAI()) {
                return getFallbackResponse(prompt);
            }
        }
        
        // Obtener contexto del usuario
        const userContext = await getUserContext(phone);
        
        const promptCompleto = `
        Eres "SSH-Assist", un asistente especializado en servicios SSH, VPN y gestión de usuarios.
        
        CONTEXTO DEL SISTEMA:
        - Servicio: SSH/VPN con planes premium
        - Bot de WhatsApp automatizado
        - Funciones: Creación de usuarios, pagos con MercadoPago, soporte
        - Precios: 7d=$${config.prices.price_7d} ARS, 15d=$${config.prices.price_15d} ARS, 30d=$${config.prices.price_30d} ARS
        - Prueba gratuita: 2 horas
        
        CONTEXTO DEL USUARIO:
        ${userContext}
        
        CONTEXTO ADICIONAL:
        ${contexto}
        
        PREGUNTA DEL USUARIO:
        "${prompt}"
        
        INSTRUCCIONES:
        1. Responde en español claro y profesional
        2. Sé conciso pero completo (máximo 300 palabras)
        3. Si es sobre problemas técnicos, da pasos específicos
        4. Si es sobre precios/planes, menciona los actuales
        5. Si no sabes, sugiere contactar soporte humano (opción 6)
        6. NO inventes funciones que no existan
        7. Mantén un tono amable pero profesional
        8. Incluye emojis relevantes para hacerlo más amigable
        
        RESPUESTA:`;
        
        // Registrar consulta
        db.run(
            `INSERT INTO ai_conversations (phone, user_query, context) VALUES (?, ?, ?)`,
            [phone, prompt, contexto],
            (err) => {
                if (err) console.error(chalk.red('❌ Error registrando consulta IA:'), err.message);
            }
        );
        
        const result = await iaModel.generateContent(promptCompleto);
        const response = await result.response;
        const aiResponse = response.text();
        
        // Registrar respuesta
        db.run(
            `UPDATE ai_conversations SET ai_response = ? WHERE id = (SELECT MAX(id) FROM ai_conversations WHERE phone = ?)`,
            [aiResponse, phone],
            (err) => {
                if (err) console.error(chalk.red('❌ Error actualizando respuesta IA:'), err.message);
            }
        );
        
        // Análisis de sentimiento básico
        const sentiment = analyzeSentiment(prompt);
        if (sentiment === 'negative') {
            await logUserBehavior(phone, 'negative_sentiment', { 
                message: prompt, 
                sentiment: 'negative',
                ai_query: true 
            });
        }
        
        return aiResponse;
        
    } catch (error) {
        console.error(chalk.red('❌ Error consultando IA:'), error.message);
        
        // Registrar error
        db.run(
            `INSERT INTO logs (type, message, data) VALUES ('ai_error', ?, ?)`,
            [error.message, JSON.stringify({ prompt, phone })]
        );
        
        return getFallbackResponse(prompt);
    }
}

// Obtener contexto del usuario
async function getUserContext(phone) {
    return new Promise((resolve) => {
        db.get(
            `SELECT 
                COUNT(*) as total_services,
                SUM(CASE WHEN tipo = 'premium' THEN 1 ELSE 0 END) as premium_services,
                MAX(expires_at) as last_expiry,
                (SELECT status FROM payments WHERE phone = ? ORDER BY created_at DESC LIMIT 1) as last_payment_status
             FROM users WHERE phone = ? AND status = 1`,
            [phone, phone],
            (err, row) => {
                if (err || !row) {
                    resolve("Usuario nuevo o sin servicios activos.");
                    return;
                }
                
                let context = "";
                context += `Servicios activos: ${row.total_services}. `;
                if (row.premium_services > 0) {
                    context += `Servicios premium: ${row.premium_services}. `;
                }
                if (row.last_expiry) {
                    const expires = moment(row.last_expiry);
                    if (expires.isAfter(moment())) {
                        context += `Servicio vigente hasta: ${expires.format('DD/MM/YYYY')}. `;
                    } else {
                        context += `Último servicio expiró: ${expires.format('DD/MM/YYYY')}. `;
                    }
                }
                if (row.last_payment_status) {
                    context += `Estado último pago: ${row.last_payment_status}. `;
                }
                
                // Obtener última interacción
                db.get(
                    `SELECT action_type, created_at FROM user_behavior 
                     WHERE phone = ? ORDER BY created_at DESC LIMIT 1`,
                    [phone],
                    (err, behavior) => {
                        if (!err && behavior) {
                            const lastAction = moment(behavior.created_at);
                            const hoursAgo = moment().diff(lastAction, 'hours');
                            context += `Última interacción: hace ${hoursAgo} horas (${behavior.action_type}).`;
                        }
                        resolve(context);
                    }
                );
            }
        );
    });
}

// Respuestas de fallback cuando IA no está disponible
function getFallbackResponse(prompt) {
    const promptLower = prompt.toLowerCase();
    
    const responses = {
        'precio|cost|valor|cuánto': `💎 *PRECIOS ACTUALES:*\n\n🥉 7 días: $${config.prices.price_7d} ARS\n🥈 15 días: $${config.prices.price_15d} ARS\n🥇 30 días: $${config.prices.price_30d} ARS\n\n🆓 *Prueba GRATIS:* 2 horas\n\n💳 *Pagos:* MercadoPago\n⚡ *Activación:* Inmediata tras pago aprobado\n\n📝 *Para comprar:* Escribe "comprar7", "comprar15" o "comprar30"`,
        
        'cómo funciona|funciona|usar': `📱 *CÓMO FUNCIONA:*\n\n1️⃣ Escribe *"menu"* para ver todas las opciones\n2️⃣ Elige *"1"* para prueba GRATIS de 2 horas ⚡\n3️⃣ O elige *"2"* para ver planes premium y precios\n4️⃣ Sigue las instrucciones para pagar con MercadoPago\n5️⃣ Recibirás usuario y contraseña automáticamente\n6️⃣ Descarga la app con la opción *"5"*\n7️⃣ ¡Conéctate y disfruta! 🎉\n\n💡 *Consejo:* La prueba gratuita es ideal para probar la velocidad`,
        
        'problema|error|no funciona|lento': `🔧 *SOLUCIÓN DE PROBLEMAS:*\n\n⚠️ *Sigue estos pasos:*\n\n1️⃣ **Reinicia** la aplicación SSH/VPN\n2️⃣ **Verifica** usuario y contraseña (opción 3)\n3️⃣ **Confirma** que el servicio no haya expirado\n4️⃣ **Prueba** con datos móviles si usas WiFi\n5️⃣ **Reinstala** la app si persiste (opción 5)\n\n📊 *Si el problema es velocidad:*\n• Prueba en diferentes horas\n• Cambia de servidor si la app lo permite\n• Verifica tu conexión a internet\n\n🆘 *Si nada funciona:*\nEscribe *"6"* para soporte técnico humano`,
        
        'app|descarg|instalar|aplicaci': `📥 *DESCARGAR E INSTALAR APP:*\n\n1️⃣ Escribe *"5"* en el chat\n2️⃣ Te enviaré el archivo APK automáticamente\n3️⃣ **Permite** "Fuentes desconocidas" en tu Android\n4️⃣ **Abre** el archivo para instalar\n5️⃣ **Inicia** la app e ingresa tus datos:\n   • Usuario: [el que te di]\n   • Contraseña: 12345\n6️⃣ **Conéctate** y ¡listo! 🚀\n\n📱 *Dispositivos Apple (iPhone/iPad):*\nNecesitas una app diferente del App Store\nEscribe *"6"* para ayuda específica`,
        
        'soporte|ayuda|contact|hablar': `🆘 *SOPORTE TÉCNICO HUMANO:*\n\nPara atención personalizada:\n1️⃣ Escribe *"6"* en el chat principal\n2️⃣ Te daré el enlace directo al canal de soporte\n3️⃣ Un técnico te atenderá en horario laboral\n\n⏰ *Horario de atención:*\n• Lunes a Viernes: 9:00 - 22:00\n• Sábados: 10:00 - 20:00\n• Domingos: 12:00 - 18:00\n\n📍 *Zona horaria:* GMT-3 (Argentina)`,
        
        'default': `🤖 *ASISTENTE AUTOMÁTICO*\n\n⚠️ *Mi sistema de IA tiene un problema temporal*\n\n📋 *Por favor usa las opciones del menú:*\n\n🆓 *1* - Prueba GRATIS (2 horas)\n💰 *2* - Ver planes y precios premium\n👤 *3* - Tus cuentas activas\n💳 *4* - Estado de tus pagos\n📱 *5* - Descargar aplicación\n🆘 *6* - Soporte técnico humano\n\n🔁 *O intenta reformular tu pregunta más simple*\n\n🙏 Disculpa las molestias`
    };
    
    for (const [key, response] of Object.entries(responses)) {
        if (key !== 'default' && new RegExp(key).test(promptLower)) {
            return response;
        }
    }
    
    return responses.default;
}

// Análisis de sentimiento básico
function analyzeSentiment(text) {
    const positiveWords = ['gracias', 'bueno', 'excelente', 'perfecto', 'bien', 'genial', 'ok', 'funciona', 'rápido', 'contento'];
    const negativeWords = ['mal', 'horrible', 'pésimo', 'error', 'no funciona', 'lento', 'problema', 'queja', 'decepcionado', 'pésima'];
    
    const textLower = text.toLowerCase();
    let positive = 0;
    let negative = 0;
    
    positiveWords.forEach(word => {
        if (textLower.includes(word)) positive++;
    });
    
    negativeWords.forEach(word => {
        if (textLower.includes(word)) negative++;
    });
    
    if (negative > positive) return 'negative';
    if (positive > negative) return 'positive';
    return 'neutral';
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
    authStrategy: new LocalAuth({dataPath: '/root/.wwebjs_auth', clientId: 'ssh-bot-v86'}),
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
    console.log(chalk.cyan('🤖 Asistente IA: Opción 7 o escribe "ia [tu pregunta]"'));
    console.log(chalk.cyan('📊 Análisis: Monitoreo activo de comportamiento\n'));
    console.log(chalk.cyan('💬 Envía "menu" a tu WhatsApp\n'));
    qrCount = 0;
});
client.on('auth_failure', (m) => console.log(chalk.red('❌ Error auth:'), m));
client.on('disconnected', (r) => console.log(chalk.yellow('⚠️ Desconectado:'), r));

function generateUsername() {
    return 'user' + Math.random().toString(36).substr(2, 6);
}

function generatePassword() {
    return '12345';
}

async function createSSHUser(phone, username, password, days, connections = 1, nombrePersonalizado = null) {
    const PASSWORD_FIJA = '12345';
    const SUFIJO = 'j';
    
    if (days === 0) {
        // ✅ USUARIO TEST - 2 HORAS EXACTAS
        const expireFull = moment().add(2, 'hours').format('YYYY-MM-DD HH:mm:ss');
        const expireDate = moment().add(2, 'hours').format('YYYY-MM-DD');
        
        console.log(chalk.yellow(`⌛ Test ${username} expira: ${expireFull} (2 horas)`));
        
        const commands = [
            `useradd -m -s /bin/bash ${username}`,
            `echo "${username}:${PASSWORD_FIJA}" | chpasswd`
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
                [phone, username, PASSWORD_FIJA, tipo, expireFull, 1],
                (err) => err ? reject(err) : resolve({ 
                    username, 
                    password: PASSWORD_FIJA, 
                    expires: expireFull,
                    tipo: 'test',
                    duration: '2 horas'
                }));
        });
    } else {
        // Usuario PREMIUM - días completos
        const expireDate = moment().add(days, 'days').format('YYYY-MM-DD');
        const expireFull = moment().add(days, 'days').format('YYYY-MM-DD 23:59:59');
        
        // Si se proporciona un nombre personalizado, agregar sufijo "j"
        let finalUsername = username;
        if (nombrePersonalizado) {
            // Limpiar caracteres especiales y agregar sufijo "j"
            finalUsername = nombrePersonalizado.replace(/[^a-zA-Z0-9]/g, '').toLowerCase() + SUFIJO;
            console.log(chalk.yellow(`👤 Nombre personalizado: ${nombrePersonalizado} -> ${finalUsername}`));
        } else {
            // Si no hay nombre personalizado, generar uno aleatorio con sufijo
            finalUsername = generateUsername() + SUFIJO;
        }
        
        console.log(chalk.yellow(`⌛ Premium ${finalUsername} expira: ${expireDate}`));
        
        try {
            await execPromise(`useradd -M -s /bin/false -e ${expireDate} ${finalUsername} && echo "${finalUsername}:${PASSWORD_FIJA}" | chpasswd`);
        } catch (error) {
            console.error(chalk.red('❌ Error creando premium:'), error.message);
            throw error;
        }
        
        const tipo = 'premium';
        return new Promise((resolve, reject) => {
            db.run(`INSERT INTO users (phone, username, password, tipo, expires_at, max_connections, status) VALUES (?, ?, ?, ?, ?, ?, 1)`,
                [phone, finalUsername, PASSWORD_FIJA, tipo, expireFull, 1],
                (err) => err ? reject(err) : resolve({ 
                    username: finalUsername, 
                    password: PASSWORD_FIJA, 
                    expires: expireFull,
                    tipo: 'premium',
                    duration: `${days} días`
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

// ✅ FIX 2: MERCADOPAGO SDK V2.X - FECHAS ISO 8601 CORREGIDAS
async function createMercadoPagoPayment(phone, plan, days, amount, connections) {
    try {
        config = loadConfig();
        
        // ✅ Verificar token
        if (!config.mercadopago.access_token || config.mercadopago.access_token === '') {
            console.log(chalk.red('❌ Token MP vacío'));
            return { success: false, error: 'MercadoPago no configurado - Token vacío' };
        }
        
        // ✅ Reinicializar si es necesario
        if (!mpPreference) {
            console.log(chalk.yellow('🔄 Reinicializando MercadoPago...'));
            mpEnabled = initMercadoPago();
            if (!mpEnabled || !mpPreference) {
                return { success: false, error: 'No se pudo inicializar MercadoPago' };
            }
        }
        
        const phoneClean = phone.split('@')[0];
        const paymentId = `PREMIUM-${phoneClean}-${plan}-${Date.now()}`;
        
        console.log(chalk.cyan(`🔄 Creando pago MP: ${paymentId}`));
        
        // ✅ FIX 2: FECHA ISO 8601 CORRECTA PARA SDK v2.x
        const expirationDate = moment().add(24, 'hours');
        const isoDate = expirationDate.toISOString();
        
        // ✅ PREFERENCIA CON SDK V2.X - FECHAS CORREGIDAS
        const preferenceData = {
            items: [{
                title: `SERVICIO PREMIUM ${days} DÍAS`,
                description: `Acceso completo por ${days} días`,
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
            statement_descriptor: 'SERVICIO PREMIUM',
            notification_url: `http://${config.bot.server_ip}:3000/webhook`
        };
        
        console.log(chalk.yellow(`📦 Producto: ${preferenceData.items[0].title}`));
        console.log(chalk.yellow(`💰 Monto: $${amount} ${config.prices.currency}`));
        console.log(chalk.yellow(`📅 Expiración ISO 8601: ${isoDate}`));
        
        // ✅ CREAR PREFERENCIA CON SDK V2.X
        const response = await mpPreference.create({ body: preferenceData });
        
        console.log(chalk.cyan('📄 Respuesta MP recibida'));
        
        if (response && response.id) {
            const paymentUrl = response.init_point;
            const qrPath = `${config.paths.qr_codes}/${paymentId}.png`;
            
            // Generar QR
            await QRCode.toFile(qrPath, paymentUrl, { 
                width: 400,
                margin: 1,
                color: {
                    dark: '#000000',
                    light: '#FFFFFF'
                }
            });
            
            // Guardar en BD
            db.run(
                `INSERT INTO payments (payment_id, phone, plan, days, amount, status, payment_url, qr_code, preference_id) VALUES (?, ?, ?, ?, ?, 'pending', ?, ?, ?)`,
                [paymentId, phone, plan, days, amount, paymentUrl, qrPath, response.id],
                (err) => {
                    if (err) {
                        console.error(chalk.red('❌ Error guardando en BD:'), err.message);
                    }
                }
            );
            
            console.log(chalk.green(`✅ Pago creado exitosamente`));
            console.log(chalk.cyan(`🔗 URL: ${paymentUrl.substring(0, 50)}...`));
            console.log(chalk.cyan(`📱 Preference ID: ${response.id}`));
            
            return { 
                success: true, 
                paymentId, 
                paymentUrl, 
                qrPath,
                preferenceId: response.id
            };
        }
        
        throw new Error('Respuesta inválida de MercadoPago - sin ID de preferencia');
        
    } catch (error) {
        console.error(chalk.red('❌ Error MercadoPago:'), error.message);
        
        // Log detallado
        if (error.cause) {
            console.error(chalk.red('📄 Causa:'), JSON.stringify(error.cause, null, 2));
        }
        if (error.response) {
            console.error(chalk.red('📄 Respuesta:'), JSON.stringify(error.response, null, 2));
        }
        
        // Guardar log en BD
        db.run(
            `INSERT INTO logs (type, message, data) VALUES ('mp_error', ?, ?)`,
            [error.message, JSON.stringify({ stack: error.stack, cause: error.cause })]
        );
        
        return { success: false, error: error.message };
    }
}

async function checkPendingPayments() {
    config = loadConfig();
    if (!config.mercadopago.access_token || config.mercadopago.access_token === '') return;
    
    db.all('SELECT * FROM payments WHERE status = "pending" AND created_at > datetime("now", "-48 hours")', async (err, payments) => {
        if (err || !payments || payments.length === 0) return;
        
        console.log(chalk.yellow(`🔍 Verificando ${payments.length} pagos pendientes...`));
        
        for (const payment of payments) {
            try {
                // ✅ Usar API v1 para búsqueda (más estable)
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
                        
                        // Enviar solicitud de nombre al usuario
                        try {
                            await client.sendMessage(payment.phone, `🎉 *¡PAGO APROBADO!*\n\n💬 *Por favor, responde con tu nombre:*\n(Ejemplo: pedro, maria, juan)\n\n⚠️ *Importante:*\n• Solo letras y números\n• Se añadirá la letra "j" al final\n• Ejemplo: "pedro" → "pedroj"`);
                            
                            // Esperar respuesta del usuario (hasta 2 minutos)
                            let nombreRecibido = null;
                            const waitForName = new Promise((resolve) => {
                                const listener = async (msg) => {
                                    if (msg.from === payment.phone && !msg.body.includes('@')) {
                                        const respuesta = msg.body.trim().toLowerCase();
                                        if (respuesta.length > 2 && respuesta.length < 20 && /^[a-zA-Z0-9]+$/.test(respuesta)) {
                                            nombreRecibido = respuesta;
                                            client.removeListener('message', listener);
                                            resolve(nombreRecibido);
                                        } else {
                                            await client.sendMessage(payment.phone, `⚠️ *Nombre inválido*\n\nPor favor, usa solo letras y números (ejemplo: pedro, maria123)`);
                                        }
                                    }
                                };
                                client.on('message', listener);
                                
                                // Timeout después de 2 minutos
                                setTimeout(() => {
                                    client.removeListener('message', listener);
                                    resolve(null);
                                }, 120000);
                            });
                            
                            nombreRecibido = await waitForName;
                            
                            if (!nombreRecibido) {
                                console.log(chalk.yellow('⚠️ Usuario no respondió con nombre válido, usando nombre aleatorio'));
                                nombreRecibido = null;
                            }
                            
                            const connMap = { '7d': 1, '15d': 1, '30d': 1 };
                            const connections = connMap[payment.plan] || 1;
                            
                            const result = await createSSHUser(payment.phone, generateUsername(), '12345', payment.days, connections, nombreRecibido);
                            
                            // Registrar comportamiento de compra exitosa
                            await logUserBehavior(payment.phone, 'purchase_success', {
                                plan: payment.plan,
                                days: payment.days,
                                amount: payment.amount,
                                username: result.username
                            });
                            
                            db.run(`UPDATE payments SET status = 'approved', approved_at = CURRENT_TIMESTAMP WHERE payment_id = ?`, [payment.payment_id]);
                            
                            const expireDate = moment().add(payment.days, 'days').format('DD/MM/YYYY');
                            
                            const message = `╔══════════════════════════════════════╗
║   🎉 *PAGO CONFIRMADO*               ║
╚══════════════════════════════════════╝

✅ Tu compra ha sido aprobada

📋 *DATOS DE ACCESO:*
👤 Usuario: *${result.username}*
🔑 Contraseña: *12345*

⏰ *VÁLIDO HASTA:* ${expireDate}
🔌 *CONEXIÓN:* 1

📱 *INSTALACIÓN:*
1. Descarga la app (Escribe *5*)
2. Ingresa tus datos
3. ¡Conéctate automáticamente!

🎊 ¡Disfruta del servicio premium!

💬 Soporte: *Escribe 6*`;
                            
                            await client.sendMessage(payment.phone, message, { sendSeen: false });
                            console.log(chalk.green(`✅ Usuario creado y notificado: ${result.username}`));
                            
                        } catch (error) {
                            console.error(chalk.red('❌ Error en creación de usuario:'), error.message);
                            
                            // Crear usuario con nombre aleatorio como fallback
                            try {
                                const username = generateUsername() + 'j';
                                const result = await createSSHUser(payment.phone, username, '12345', payment.days, 1, null);
                                
                                const expireDate = moment().add(payment.days, 'days').format('DD/MM/YYYY');
                                const message = `✅ *PAGO APROBADO*\n\n👤 Usuario: *${result.username}*\n🔑 Contraseña: *12345*\n⏰ Válido hasta: ${expireDate}`;
                                await client.sendMessage(payment.phone, message);
                            } catch (fallbackError) {
                                console.error(chalk.red('❌ Error en fallback:'), fallbackError.message);
                            }
                        }
                    }
                } else {
                    console.log(chalk.gray(`⏳ Sin respuesta para ${payment.payment_id}`));
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
    
    // Registrar acceso al bot
    await logUserBehavior(phone, 'menu_access', { message: text.substring(0, 100) });
    
    // ✅ FIX 3: Enviar mensajes sin error markedUnread
    if (['menu', 'hola', 'start', 'hi', 'inicio'].includes(text)) {
        await client.sendMessage(phone, `╔══════════════════════════════════════╗
║   🤖 *SSH BOT PRO v8.6 + IA*        ║
╚══════════════════════════════════════╝

📋 *MENÚ INTELIGENTE:*

🆓 *1* - Prueba GRATIS (2h)  ⚡
💰 *2* - Planes premium
👤 *3* - Mis cuentas
💳 *4* - Estado de pago
📱 *5* - Descargar APP
🆘 *6* - Soporte humano
🤖 *7* - Asistente IA (Pregunta lo que quieras)

💬 Responde con el número o escribe "ia [tu pregunta]"`, { sendSeen: false });
    }
    else if (text === '1') {
        if (!(await canCreateTest(phone))) {
            await logUserBehavior(phone, 'test_denied', { reason: 'daily_limit' });
            await client.sendMessage(phone, `⚠️ *YA USASTE TU PRUEBA HOY*

⏳ Vuelve mañana
💎 *Escribe 2* para planes premium
🤖 *O escribe "7"* para preguntar al asistente IA`, { sendSeen: false });
            return;
        }
        await client.sendMessage(phone, '⏳ Creando cuenta test...', { sendSeen: false });
        try {
            const username = generateUsername();
            await createSSHUser(phone, username, '12345', 0, 1);
            registerTest(phone);
            
            await logUserBehavior(phone, 'test_created', { 
                username: username,
                hours: 2,
                timestamp: moment().format()
            });
            
            await client.sendMessage(phone, `✅ *PRUEBA ACTIVADA*

👤 Usuario: *${username}*
🔑 Contraseña: *12345*
⏰ Duración: 2 horas  ⚡
🔌 Conexión: 1

📱 *PARA CONECTAR:*
1. Descarga la app (Escribe *5*)
2. Ingresa usuario y contraseña
3. ¡Listo!

💎 ¿Te gustó? *Escribe 2* para planes premium
🤖 Dudas? *Escribe 7* para el asistente IA`, { sendSeen: false });
            
            console.log(chalk.green(`✅ Test creado: ${username}`));
        } catch (error) {
            await logUserBehavior(phone, 'test_error', { error: error.message });
            await client.sendMessage(phone, `❌ Error al crear cuenta: ${error.message}\n\n🆘 Escribe *6* para soporte`, { sendSeen: false });
        }
    }
    else if (text === '2') {
        await logUserBehavior(phone, 'plans_viewed', {});
        await client.sendMessage(phone, `💎 *PLANES PREMIUM*

🥉 *7 días* - $${config.prices.price_7d} ARS
   1 conexión
   _comprar7_

🥈 *15 días* - $${config.prices.price_15d} ARS
   1 conexión
   _comprar15_

🥇 *30 días* - $${config.prices.price_30d} ARS
   1 conexión
   _comprar30_

💳 Pago: MercadoPago
⚡ Activación: 2-5 min
🔄 Renovación: Automática

🤖 *¿Dudas sobre los planes?*
Escribe *"7"* para preguntar al asistente IA`, { sendSeen: false });
    }
    else if (['comprar7', 'comprar15', 'comprar30'].includes(text)) {
        config = loadConfig();
        
        await logUserBehavior(phone, 'purchase_attempt', {
            plan: text,
            timestamp: moment().format()
        });
        
        console.log(chalk.yellow(`🔑 Verificando token MP...`));
        
        if (!config.mercadopago.access_token || config.mercadopago.access_token === '') {
            await client.sendMessage(phone, `❌ *MERCADOPAGO NO CONFIGURADO*

El administrador debe configurar MercadoPago primero.

🤖 *Alternativa:*
Escribe *"7"* para consultar al asistente IA
🆘 O escribe *"6"* para soporte técnico`, { sendSeen: false });
            return;
        }
        
        // Reinicializar MP si es necesario
        if (!mpEnabled || !mpPreference) {
            console.log(chalk.yellow('🔄 Reinicializando MercadoPago...'));
            mpEnabled = initMercadoPago();
        }
        
        if (!mpEnabled || !mpPreference) {
            await client.sendMessage(phone, `❌ *ERROR CON MERCADOPAGO*

El sistema de pagos no está disponible.

🤖 Escribe *"7"* para asistencia
🆘 O escribe *"6"* para soporte técnico`, { sendSeen: false });
            return;
        }
        
        const planMap = {
            'comprar7': { days: 7, amount: config.prices.price_7d, plan: '7d', conn: 1 },
            'comprar15': { days: 15, amount: config.prices.price_15d, plan: '15d', conn: 1 },
            'comprar30': { days: 30, amount: config.prices.price_30d, plan: '30d', conn: 1 }
        };
        
        const p = planMap[text];
        await client.sendMessage(phone, `⏳ Generando pago MercadoPago...

📦 Plan: ${p.days} días
💰 Monto: $${p.amount} ARS
🔌 Conexión: ${p.conn}

⏰ Procesando...`, { sendSeen: false });
        
        try {
            const payment = await createMercadoPagoPayment(phone, p.plan, p.days, p.amount, p.conn);
            
            if (payment.success) {
                await client.sendMessage(phone, `💳 *PAGO GENERADO EXITOSAMENTE*

📦 Plan: ${p.days} días
💰 $${p.amount} ARS
🔌 ${p.conn} conexión

🔗 *ENLACE DE PAGO:*
${payment.paymentUrl}

⏰ Válido: 24 horas
📱 ID: ${payment.paymentId.substring(0, 25)}...

🔄 Verificación automática cada 2 min
✅ Te notificaré cuando se apruebe el pago

💬 Escribe *4* para ver estado del pago
🤖 Dudas? Escribe *7* para IA`, { sendSeen: false });
                
                // Enviar QR si existe
                if (fs.existsSync(payment.qrPath)) {
                    try {
                        const media = MessageMedia.fromFilePath(payment.qrPath);
                        await client.sendMessage(phone, media, { caption: '📱 Escanea con la app de MercadoPago', sendSeen: false });
                        console.log(chalk.green('✅ QR de pago enviado'));
                    } catch (qrError) {
                        console.error(chalk.red('⚠️ Error enviando QR:'), qrError.message);
                    }
                }
            } else {
                await logUserBehavior(phone, 'payment_error', { error: payment.error });
                await client.sendMessage(phone, `❌ *ERROR AL GENERAR PAGO*

Detalles: ${payment.error}

🤖 Escribe *"7"* para asistencia del bot IA
🆘 O escribe *"6"* para soporte técnico humano`, { sendSeen: false });
            }
        } catch (error) {
            console.error(chalk.red('❌ Error en compra:'), error);
            await logUserBehavior(phone, 'purchase_error', { error: error.message });
            await client.sendMessage(phone, `❌ *ERROR INESPERADO*

${error.message}

🤖 Escribe *"7"* para ayuda con el asistente IA
🆘 O escribe *"6"* para soporte técnico`, { sendSeen: false });
        }
    }
    else if (text === '3') {
        await logUserBehavior(phone, 'accounts_check', {
            check_time: moment().format()
        });
        
        db.all(`SELECT username, password, tipo, expires_at, max_connections FROM users WHERE phone = ? AND status = 1 ORDER BY created_at DESC LIMIT 10`, [phone],
            async (err, rows) => {
                if (!rows || rows.length === 0) {
                    await client.sendMessage(phone, `📋 *SIN CUENTAS*

🆓 *1* - Prueba gratis (2 horas)
💰 *2* - Ver planes premium
🤖 *7* - Preguntar al asistente IA`, { sendSeen: false });
                    return;
                }
                let msg = `📋 *TUS CUENTAS ACTIVAS*

`;
                rows.forEach((a, i) => {
                    const tipo = a.tipo === 'premium' ? '💎' : '🆓';
                    const tipoText = a.tipo === 'premium' ? 'PREMIUM' : 'TEST';
                    const expira = moment(a.expires_at).format('DD/MM HH:mm');
                    const expiresIn = moment(a.expires_at).fromNow();
                    
                    msg += `*${i+1}. ${tipo} ${tipoText}*
`;
                    msg += `👤 *${a.username}*
`;
                    msg += `🔑 *${a.password}*
`;
                    msg += `⏰ Expira: ${expira} (${expiresIn})
`;
                    msg += `🔌 ${a.max_connections} conexión

`;
                });
                msg += `📱 Para conectar descarga la app (Escribe *5*)\n`;
                msg += `🤖 ¿Problemas? Escribe *7* para asistencia IA`;
                await client.sendMessage(phone, msg, { sendSeen: false });
            });
    }
    else if (text === '4') {
        await logUserBehavior(phone, 'payment_status_check', {});
        
        db.all(`SELECT plan, amount, status, created_at, payment_url FROM payments WHERE phone = ? ORDER BY created_at DESC LIMIT 5`, [phone],
            async (err, pays) => {
                if (!pays || pays.length === 0) {
                    await client.sendMessage(phone, `💳 *SIN PAGOS REGISTRADOS*

💰 *2* - Ver planes disponibles
🤖 *7* - Preguntar al asistente IA`, { sendSeen: false });
                    return;
                }
                let msg = `💳 *ESTADO DE PAGOS*

`;
                pays.forEach((p, i) => {
                    const emoji = p.status === 'approved' ? '✅' : '⏳';
                    const statusText = p.status === 'approved' ? 'APROBADO' : 'PENDIENTE';
                    const fecha = moment(p.created_at).format('DD/MM HH:mm');
                    msg += `*${i+1}. ${emoji} ${statusText}*
`;
                    msg += `Plan: ${p.plan} | $${p.amount} ARS
`;
                    msg += `Fecha: ${fecha}
`;
                    if (p.status === 'pending' && p.payment_url) {
                        msg += `🔗 ${p.payment_url.substring(0, 40)}...
`;
                    }
                    msg += `
`;
                });
                msg += `🔄 Verificación automática cada 2 minutos\n`;
                msg += `🤖 ¿Dudas? Escribe *7* para asistencia IA`;
                await client.sendMessage(phone, msg, { sendSeen: false });
            });
    }
    else if (text === '5') {
        await logUserBehavior(phone, 'app_download_request', {
            timestamp: moment().format()
        });
        
        // Buscar APK automáticamente
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
                
                await client.sendMessage(phone, `📱 *DESCARGANDO APP*

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

💡 Si no ves el archivo, revisa la sección "Archivos" de WhatsApp

🤖 ¿Problemas con la instalación?
Escribe *7* para asistencia IA`, 
                    sendSeen: false
                });
                
                console.log(chalk.green(`✅ APK enviado exitosamente`));
                
            } catch (error) {
                console.error(chalk.red('❌ Error enviando APK:'), error.message);
                await logUserBehavior(phone, 'app_download_error', { error: error.message });
                
                // Fallback: servidor web
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

⚠️ El enlace expira en 1 hora

🤖 ¿Problemas? Escribe *7* para IA`, { sendSeen: false });
                } else {
                    await client.sendMessage(phone, `❌ *ERROR AL ENVIAR APK*

No se pudo enviar el archivo.

🤖 Escribe *7* para asistencia IA
📞 O contacta soporte:
${config.links.support}`, { sendSeen: false });
                }
            }
        } else {
            await client.sendMessage(phone, `❌ *APK NO DISPONIBLE*

El archivo de instalación no está disponible en el servidor.

🤖 Escribe *7* para asistencia IA
📞 Contacta al administrador:
${config.links.support}

💡 Ubicación esperada: /root/app.apk`, { sendSeen: false });
        }
    }
    else if (text === '6') {
        await logUserBehavior(phone, 'support_request', {
            request_type: 'human_support',
            timestamp: moment().format()
        });
        
        await client.sendMessage(phone, `🆘 *SOPORTE TÉCNICO HUMANO*

📞 Canal de soporte:
${config.links.support}

⏰ Horario: 9AM - 10PM (GMT-3)

🤖 *¿Primero prueba con el asistente IA?*
Escribe *7* para preguntas rápidas

📋 *Para soporte humano:*
1. Ve al enlace de arriba
2. Describe tu problema en detalle
3. Incluye tu número de WhatsApp
4. Espera respuesta del técnico

💬 Escribe "menu" para volver al inicio`, { sendSeen: false });
    }
    // ================================================
    // ASISTENTE DE IA - OPCIÓN 7
    // ================================================
    else if (text === '7' || text.startsWith('ia ') || text.startsWith('ai ') || text.startsWith('pregunta ') || text.startsWith('ask ')) {
        let pregunta = '';
        
        if (text === '7') {
            await client.sendMessage(phone, `🤖 *ASISTENTE DE IA INTELIGENTE*\n\nPuedes preguntarme sobre:\n\n• 💰 Precios y planes\n• 🔧 Configuración técnica\n• 📶 Problemas de conexión\n• 📱 Uso de la aplicación\n• 🔄 Renovaciones\n• ⚡ Optimización de velocidad\n• 🆘 Solución de errores\n• 📝 Cualquier duda del servicio\n\n💬 *Ejemplos:*\n"ia ¿Cómo configuro la app en iPhone?"\n"ia ¿Los precios incluyen IVA?"\n"ia Mi conexión está lenta, ¿qué hago?"\n"ia ¿Cómo renuevo mi plan premium?"\n\n📝 Escribe tu pregunta directamente o responde a este mensaje.`, { sendSeen: false });
            return;
        } else {
            pregunta = text.replace(/^(ia|ai|pregunta|ask|7\s+)/i, '').trim();
        }
        
        if (!pregunta) {
            await client.sendMessage(phone, `🤖 *ASISTENTE DE IA*\n\nPor favor, escribe tu pregunta después de "ia".\n\nEjemplo:\nia ¿Cómo configuro la app en mi teléfono?\n\n💡 También puedes usar la opción *7* del menú`, { sendSeen: false });
            return;
        }
        
        // Registrar comportamiento
        await logUserBehavior(phone, 'ai_consultation', { 
            message: pregunta.substring(0, 200),
            length: pregunta.length 
        });
        
        await client.sendMessage(phone, '🤖 *Procesando tu pregunta con IA...*\n⏳ Por favor, espera unos segundos.', { sendSeen: false });
        
        try {
            const respuestaIA = await consultarIA(pregunta, phone, `Consulta desde WhatsApp - ${moment().format('DD/MM/YYYY HH:mm')}`);
            
            // Limitar longitud para WhatsApp
            const respuestaFinal = respuestaIA.length > 3500 
                ? respuestaIA.substring(0, 3500) + "...\n\n📝 *Respuesta recortada por límite de WhatsApp*\n💡 Para respuestas más largas, contacta soporte (opción 6)." 
                : respuestaIA;
            
            await client.sendMessage(phone, `🤖 *RESPUESTA DE IA*\n\n${respuestaFinal}\n\n---\n*¿Resolví tu duda?*\n✅ Sí - Escribe "menu" para volver\n❌ No - Escribe "6" para soporte humano\n🔄 Otra pregunta - Escribe "ia [tu pregunta]" o "7"`, { sendSeen: false });
            
        } catch (error) {
            console.error(chalk.red(`❌ Error IA para ${phone}:`), error.message);
            await logUserBehavior(phone, 'ai_error', { error: error.message });
            await client.sendMessage(phone, `❌ *ERROR DE IA*\n\nNo pude procesar tu pregunta en este momento.\n\n📞 Por favor, intenta:\n1. Reformular tu pregunta más simple\n2. Usar las opciones del menú principal\n3. Contactar soporte humano (opción 6)\n\n🤖 *Pregunta ejemplo que sí funciona:*\n"ia ¿Cuánto cuesta el plan de 30 días?"\n\nDisculpa las molestias.`, { sendSeen: false });
        }
    }
    else if (text === 'admin' || text === 'administrador') {
        // Comando secreto para ver estadísticas (solo para ciertos números)
        const adminNumbers = ['5491111111111', '5492222222222']; // Reemplaza con tus números
        
        if (adminNumbers.includes(phone.replace('@c.us', '').replace('@s.whatsapp.net', ''))) {
            db.get(`SELECT 
                COUNT(*) as total_users,
                SUM(CASE WHEN status = 1 THEN 1 ELSE 0 END) as active_users,
                SUM(CASE WHEN tipo = 'premium' AND status = 1 THEN 1 ELSE 0 END) as premium_active,
                (SELECT COUNT(*) FROM payments WHERE status = 'approved') as payments_approved,
                (SELECT SUM(amount) FROM payments WHERE status = 'approved') as total_revenue
            FROM users`, async (err, stats) => {
                if (!err && stats) {
                    await client.sendMessage(phone, `📊 *ESTADÍSTICAS DEL SISTEMA (ADMIN)*

👥 Usuarios totales: ${stats.total_users}
✅ Activos ahora: ${stats.active_users}
💎 Premium activos: ${stats.premium_active}
💰 Pagos aprobados: ${stats.payments_approved}
📈 Ingresos totales: $${stats.total_revenue || 0} ARS

🤖 Consultas IA hoy: ${await getAICountToday()}
🚨 Alertas activas: ${await getActiveAlerts()}

⏰ Última actualización: ${moment().format('DD/MM/YYYY HH:mm:ss')}`, { sendSeen: false });
                }
            });
        }
    }
});

// Función para contar consultas IA hoy
async function getAICountToday() {
    return new Promise((resolve) => {
        const today = moment().format('YYYY-MM-DD');
        db.get(`SELECT COUNT(*) as count FROM ai_conversations WHERE date(created_at) = ?`, [today], (err, row) => {
            resolve(row ? row.count : 0);
        });
    });
}

// Función para contar alertas activas
async function getActiveAlerts() {
    return new Promise((resolve) => {
        db.get(`SELECT COUNT(*) as count FROM risk_alerts WHERE resolved = 0`, (err, row) => {
            resolve(row ? row.count : 0);
        });
    });
}

// ✅ Verificar pagos cada 2 minutos
cron.schedule('*/2 * * * *', () => {
    console.log(chalk.yellow('🔄 Verificando pagos pendientes...'));
    checkPendingPayments();
});

// ✅ AJUSTE: Limpiar usuarios expirados cada 15 minutos
cron.schedule('*/15 * * * *', async () => {
    const now = moment().format('YYYY-MM-DD HH:mm:ss');
    console.log(chalk.yellow(`🧹 Limpiando usuarios expirados cada 15 minutos (${now})...`));
    
    db.all('SELECT username, phone FROM users WHERE expires_at < ? AND status = 1', [now], async (err, rows) => {
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
                
                // Registrar eliminación
                await logUserBehavior(r.phone, 'account_expired', {
                    username: r.username,
                    action: 'automatic_cleanup'
                });
                
                console.log(chalk.green(`🗑️ Eliminado: ${r.username}`));
            } catch (e) {
                console.error(chalk.red(`Error eliminando ${r.username}:`), e.message);
            }
        }
        console.log(chalk.green(`✅ Limpiados ${rows.length} usuarios expirados`));
    });
});

// ✅ Limpiar pagos antiguos cada 24 horas
cron.schedule('0 0 * * *', () => {
    console.log(chalk.yellow('🧹 Limpiando pagos antiguos...'));
    db.run(`DELETE FROM payments WHERE status = 'pending' AND created_at < datetime('now', '-7 days')`, (err) => {
        if (!err) console.log(chalk.green('✅ Pagos antiguos limpiados'));
    });
});

// ✅ MONITOR AUTOMÁTICO - VERIFICA CADA 30 SEGUNDOS SI HAY MÁS DE 1 CONEXIÓN
setInterval(() => {
    db.all('SELECT username, phone FROM users WHERE status = 1', (err, rows) => {
        if (!err && rows) {
            rows.forEach(user => {
                require('child_process').exec(`ps aux | grep "^${user.username}" | grep -v grep | wc -l`, (e, out) => {
                    const cnt = parseInt(out) || 0;
                    if (cnt > 1) {
                        console.log(chalk.red(`⚠️ ${user.username} tiene ${cnt} conexiones (>1)`));
                        
                        // Registrar posible abuso
                        logUserBehavior(user.phone, 'connection_abuse', {
                            username: user.username,
                            connections: cnt,
                            action: 'automatic_monitoring'
                        });
                        
                        require('child_process').exec(`pkill -u ${user.username} 2>/dev/null; sleep 1; pkill -u ${user.username} 2>/dev/null`);
                    }
                });
            });
        }
    });
}, 30000);

// ✅ REPORTE DIARIO DE COMPORTAMIENTO
cron.schedule('0 9 * * *', () => {
    console.log(chalk.cyan('📊 Generando reporte diario de comportamiento...'));
    
    const yesterday = moment().subtract(1, 'days').format('YYYY-MM-DD');
    
    db.get(`SELECT 
        COUNT(DISTINCT phone) as unique_users,
        COUNT(*) as total_actions,
        AVG(risk_score) as avg_risk,
        SUM(CASE WHEN risk_score >= 40 THEN 1 ELSE 0 END) as high_risk_actions
    FROM user_behavior WHERE date(created_at) = ?`, [yesterday], (err, report) => {
        if (!err && report) {
            console.log(chalk.yellow(`📈 Reporte ${yesterday}:`));
            console.log(chalk.yellow(`   👥 Usuarios únicos: ${report.unique_users}`));
            console.log(chalk.yellow(`   📝 Acciones totales: ${report.total_actions}`));
            console.log(chalk.yellow(`   ⚠️  Riesgo promedio: ${report.avg_risk ? report.avg_risk.toFixed(2) : 0}`));
            console.log(chalk.yellow(`   🚨 Acciones alto riesgo: ${report.high_risk_actions}`));
        }
    });
});

console.log(chalk.green('\n🚀 Inicializando bot con IA...\n'));
client.initialize();
BOTEOF

echo -e "${GREEN}✅ Bot con IA creado exitosamente${NC}"

# ================================================
# CREAR PANEL DE CONTROL CON OPCIONES DE IA
# ================================================
echo -e "\n${CYAN}${BOLD}🎛️  CREANDO PANEL DE CONTROL CON OPCIONES DE IA...${NC}"

cat > /usr/local/bin/sshbot << 'PANELEOF'
#!/bin/bash
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; BLUE='\033[0;34m'; NC='\033[0m'

DB="/opt/ssh-bot/data/users.db"
CONFIG="/opt/ssh-bot/config/config.json"

get_val() { jq -r "$1" "$CONFIG" 2>/dev/null; }
set_val() { local t=$(mktemp); jq "$1 = $2" "$CONFIG" > "$t" && mv "$t" "$CONFIG"; }

show_header() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║              🎛️  PANEL SSH BOT PRO v8.6 + IA               ║${NC}"
    echo -e "${CYAN}║               🤖 Google Gemini AI + Análisis               ║${NC}"
    echo -e "${CYAN}║               ⏰ Test: 2h | ⚡ Limpieza: 15min              ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}\n"
}

while true; do
    show_header
    
    TOTAL_USERS=$(sqlite3 "$DB" "SELECT COUNT(*) FROM users" 2>/dev/null || echo "0")
    ACTIVE_USERS=$(sqlite3 "$DB" "SELECT COUNT(*) FROM users WHERE status=1" 2>/dev/null || echo "0")
    
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
    
    AI_KEY=$(get_val '.bot.google_ai_key')
    if [[ -n "$AI_KEY" && "$AI_KEY" != "" && "$AI_KEY" != "null" && "$AI_KEY" != "AIzaSyBojMPaBM6NpRbXQP7sC9D9aXc2XZmI8_Q" ]]; then
        AI_STATUS="${GREEN}✅ GEMINI CONFIGURADO${NC}"
    else
        AI_STATUS="${YELLOW}⚠️  CONFIGURAR API KEY${NC}"
    fi
    
    APK_FOUND=""
    if [[ -f "/root/app.apk" ]]; then
        APK_SIZE=$(du -h "/root/app.apk" | cut -f1)
        APK_FOUND="${GREEN}✅ ${APK_SIZE}${NC}"
    else
        APK_FOUND="${RED}❌ NO ENCONTRADO${NC}"
    fi
    
    # Estadísticas de IA
    AI_TODAY=$(sqlite3 "$DB" "SELECT COUNT(*) FROM ai_conversations WHERE date(created_at) = date('now')" 2>/dev/null || echo "0")
    ALERTS_ACTIVE=$(sqlite3 "$DB" "SELECT COUNT(*) FROM risk_alerts WHERE resolved = 0" 2>/dev/null || echo "0")
    
    echo -e "${YELLOW}📊 ESTADO DEL SISTEMA${NC}"
    echo -e "  Bot: $BOT_STATUS"
    echo -e "  Usuarios: ${CYAN}$ACTIVE_USERS/$TOTAL_USERS${NC} activos/total"
    echo -e "  MercadoPago: $MP_STATUS"
    echo -e "  IA Gemini: $AI_STATUS"
    echo -e "  APK: $APK_FOUND"
    echo -e "  🤖 Consultas IA hoy: ${CYAN}$AI_TODAY${NC}"
    echo -e "  🚨 Alertas activas: ${CYAN}$ALERTS_ACTIVE${NC}"
    echo -e "  Test: ${GREEN}2 horas${NC} | Limpieza: ${GREEN}cada 15 min${NC}"
    echo -e "  Conexión por usuario: ${GREEN}1${NC}"
    echo -e ""
    
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}[1]${NC}  🚀  Iniciar/Reiniciar bot"
    echo -e "${CYAN}[2]${NC}  🛑  Detener bot"
    echo -e "${CYAN}[3]${NC}  📱  Ver QR WhatsApp"
    echo -e "${CYAN}[4]${NC}  👤  Crear usuario manual"
    echo -e "${CYAN}[5]${NC}  👥  Listar usuarios"
    echo -e "${CYAN}[6]${NC}  🗑️   Eliminar usuario"
    echo -e ""
    echo -e "${CYAN}[7]${NC}  💰  Cambiar precios"
    echo -e "${CYAN}[8]${NC}  🔑  Configurar MercadoPago"
    echo -e "${CYAN}[9]${NC}  📱  Gestionar APK"
    echo -e "${CYAN}[10]${NC} 📊  Ver estadísticas"
    echo -e "${CYAN}[11]${NC} ⚙️   Ver configuración"
    echo -e "${CYAN}[12]${NC} 📝  Ver logs"
    echo -e "${CYAN}[13]${NC} 🔧  Reparar bot"
    echo -e "${CYAN}[14]${NC} 🧪  Test MercadoPago"
    echo -e "${CYAN}[15]${NC} 🤖  Configurar IA Google Gemini"
    echo -e "${CYAN}[16]${NC} 📊  Ver análisis de comportamiento"
    echo -e "${CYAN}[17]${NC} 🚨  Ver alertas de seguridad"
    echo -e "${CYAN}[18]${NC} 🔍  Ver consultas IA recientes"
    echo -e "${CYAN}[0]${NC}  🚪  Salir"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    echo -e ""
    read -p "👉 Selecciona una opción: " OPTION
    
    case $OPTION in
        1)
            echo -e "\n${YELLOW}🔄 Reiniciando bot...${NC}"
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
                echo -e "${YELLOW}Opciones:${NC}"
                echo -e "  1. Ver logs en tiempo real"
                echo -e "  2. Información de descarga"
                echo -e "  3. Volver"
                echo -e ""
                read -p "Selecciona (1-3): " QR_OPT
                
                case $QR_OPT in
                    1) pm2 logs ssh-bot --lines 200 ;;
                    2)
                        echo -e "\n${GREEN}Ruta: /root/qr-whatsapp.png${NC}"
                        echo -e "\n${YELLOW}Descarga con SFTP o:${NC}"
                        echo -e "  scp root@$(get_val '.bot.server_ip'):/root/qr-whatsapp.png ."
                        read -p "Presiona Enter..." 
                        ;;
                esac
            else
                echo -e "${YELLOW}⚠️  QR no generado aún${NC}\n"
                echo -e "${CYAN}Ejecuta opción 1 o 13 para generar QR${NC}\n"
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
            read -p "Usuario (auto=generar): " USERNAME
            read -p "Contraseña (siempre será 12345): " PASSWORD_IGNORED
            PASSWORD="12345"
            read -p "Tipo (test/premium): " TIPO
            read -p "Días (0=test 2h, 7/15/30=premium): " DAYS
            read -p "Conexiones (1): " CONNECTIONS
            
            [[ -z "$DAYS" ]] && DAYS="30"
            [[ -z "$CONNECTIONS" ]] && CONNECTIONS="1"
            [[ "$USERNAME" == "auto" || -z "$USERNAME" ]] && USERNAME="user$(tr -dc 'a-z0-9' < /dev/urandom | head -c 6)"
            
            # Agregar sufijo "j" si es premium
            if [[ "$TIPO" == "premium" ]]; then
                USERNAME="${USERNAME}j"
                echo -e "${YELLOW}✅ Nombre con sufijo: ${USERNAME}${NC}"
            fi
            
            if [[ "$TIPO" == "test" ]]; then
                DAYS="0"
                EXPIRE_DATE=$(date -d "+2 hours" +"%Y-%m-%d %H:%M:%S")
                useradd -M -s /bin/false "$USERNAME" && echo "$USERNAME:$PASSWORD" | chpasswd && chage -E "$(date -d '+2 hours' +%Y-%m-%d)" "$USERNAME"
            else
                EXPIRE_DATE=$(date -d "+$DAYS days" +"%Y-%m-%d 23:59:59")
                useradd -M -s /bin/false -e "$(date -d "+$DAYS days" +%Y-%m-%d)" "$USERNAME" && echo "$USERNAME:$PASSWORD" | chpasswd
            fi
            
            if [[ $? -eq 0 ]]; then
                sqlite3 "$DB" "INSERT INTO users (phone, username, password, tipo, expires_at, max_connections, status) VALUES ('$PHONE', '$USERNAME', '$PASSWORD', '$TIPO', '$EXPIRE_DATE', 1, 1)"
                echo -e "\n${GREEN}✅ USUARIO CREADO${NC}"
                echo -e "👤 Usuario: ${USERNAME}"
                echo -e "🔑 Contraseña: ${PASSWORD}"
                echo -e "⏰ Expira: ${EXPIRE_DATE}"
                echo -e "🔌 Conexiones: 1"
                
                # Registrar en análisis de comportamiento
                sqlite3 "$DB" "INSERT INTO user_behavior (phone, username, action_type, details) VALUES ('$PHONE', '$USERNAME', 'manual_creation', '{\"admin\": true, \"days\": $DAYS}')"
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
            
            sqlite3 -column -header "$DB" "SELECT username, password, tipo, expires_at, max_connections as conex, substr(phone,1,12) as tel FROM users WHERE status = 1 ORDER BY expires_at DESC LIMIT 20"
            echo -e "\n${YELLOW}Total: ${ACTIVE_USERS}${NC}"
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
            echo -e "${CYAN}║                     💰 CAMBIAR PRECIOS                      ║${NC}"
            echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}\n"
            
            CURRENT_7D=$(get_val '.prices.price_7d')
            CURRENT_15D=$(get_val '.prices.price_15d')
            CURRENT_30D=$(get_val '.prices.price_30d')
            
            echo -e "${YELLOW}Precios actuales:${NC}"
            echo -e "  7 días: $${CURRENT_7D} (1 conexión)"
            echo -e "  15 días: $${CURRENT_15D} (1 conexión)"
            echo -e "  30 días: $${CURRENT_30D} (1 conexión)\n"
            
            read -p "Nuevo precio 7d [${CURRENT_7D}]: " NEW_7D
            read -p "Nuevo precio 15d [${CURRENT_15D}]: " NEW_15D
            read -p "Nuevo precio 30d [${CURRENT_30D}]: " NEW_30D
            
            [[ -n "$NEW_7D" ]] && set_val '.prices.price_7d' "$NEW_7D"
            [[ -n "$NEW_15D" ]] && set_val '.prices.price_15d' "$NEW_15D"
            [[ -n "$NEW_30D" ]] && set_val '.prices.price_30d' "$NEW_30D"
            
            echo -e "\n${GREEN}✅ Precios actualizados${NC}"
            echo -e "${YELLOW}⚠️  Nota: Todos los planes tienen 1 conexión${NC}"
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
            sqlite3 "$DB" "SELECT 'Total: ' || COUNT(*) || ' | Activos: ' || SUM(CASE WHEN status=1 THEN 1 ELSE 0 END) || ' | Premium: ' || SUM(CASE WHEN tipo='premium' THEN 1 ELSE 0 END) FROM users"
            
            echo -e "\n${YELLOW}💰 PAGOS:${NC}"
            sqlite3 "$DB" "SELECT 'Pendientes: ' || SUM(CASE WHEN status='pending' THEN 1 ELSE 0 END) || ' | Aprobados: ' || SUM(CASE WHEN status='approved' THEN 1 ELSE 0 END) || ' | Total: $' || printf('%.2f', SUM(CASE WHEN status='approved' THEN amount ELSE 0 END)) FROM payments"
            
            echo -e "\n${YELLOW}📅 HOY:${NC}"
            TODAY=$(date +%Y-%m-%d)
            sqlite3 "$DB" "SELECT 'Tests: ' || COUNT(*) FROM daily_tests WHERE date = '$TODAY'"
            
            echo -e "\n${YELLOW}🤖 IA HOY:${NC}"
            sqlite3 "$DB" "SELECT 'Consultas IA: ' || COUNT(*) FROM ai_conversations WHERE date(created_at) = '$TODAY'"
            
            echo -e "\n${YELLOW}🚨 ALERTAS:${NC}"
            sqlite3 "$DB" "SELECT 'Activas: ' || SUM(CASE WHEN resolved=0 THEN 1 ELSE 0 END) || ' | Totales: ' || COUNT(*) FROM risk_alerts"
            
            read -p "\nPresiona Enter..."
            ;;
        11)
            clear
            echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
            echo -e "${CYAN}║                     ⚙️  CONFIGURACIÓN                        ║${NC}"
            echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}\n"
            
            echo -e "${YELLOW}🤖 BOT:${NC}"
            echo -e "  IP: $(get_val '.bot.server_ip')"
            echo -e "  Versión: $(get_val '.bot.version')"
            
            echo -e "\n${YELLOW}💰 PRECIOS:${NC}"
            echo -e "  7d: $(get_val '.prices.price_7d') ARS (1 conexión)"
            echo -e "  15d: $(get_val '.prices.price_15d') ARS (1 conexión)"
            echo -e "  30d: $(get_val '.prices.price_30d') ARS (1 conexión)"
            echo -e "  Test: $(get_val '.prices.test_hours') horas (1 conexión)"
            
            echo -e "\n${YELLOW}💳 MERCADOPAGO:${NC}"
            MP_TOKEN=$(get_val '.mercadopago.access_token')
            if [[ -n "$MP_TOKEN" && "$MP_TOKEN" != "null" ]]; then
                echo -e "  Estado: ${GREEN}SDK v2.x ACTIVO${NC}"
                echo -e "  Token: ${MP_TOKEN:0:25}..."
            else
                echo -e "  Estado: ${RED}NO CONFIGURADO${NC}"
            fi
            
            echo -e "\n${YELLOW}🤖 INTELIGENCIA ARTIFICIAL:${NC}"
            AI_KEY=$(get_val '.bot.google_ai_key')
            if [[ -n "$AI_KEY" && "$AI_KEY" != "null" && "$AI_KEY" != "AIzaSyBojMPaBM6NpRbXQP7sC9D9aXc2XZmI8_Q" ]]; then
                echo -e "  Estado: ${GREEN}GEMINI CONFIGURADO${NC}"
                echo -e "  Token: ${AI_KEY:0:25}..."
            else
                echo -e "  Estado: ${YELLOW}NO CONFIGURADO (usando fallback)${NC}"
            fi
            
            echo -e "\n${YELLOW}⚡ AJUSTES:${NC}"
            echo -e "  Limpieza: cada 15 minutos"
            echo -e "  Test: 2 horas exactas"
            echo -e "  Conexión por usuario: 1"
            echo -e "  Análisis comportamiento: ACTIVADO"
            echo -e "  Sistema alertas: ACTIVADO"
            
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
            
            echo -e "${RED}⚠️  Borrará sesión de WhatsApp${NC}\n"
            read -p "¿Continuar? (s/N): " CONF
            
            if [[ "$CONF" == "s" ]]; then
                echo -e "\n${YELLOW}🧹 Limpiando...${NC}"
                rm -rf /root/.wwebjs_auth/* /root/.wwebjs_cache/* /root/qr-whatsapp.png
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
            echo -e "${CYAN}║              🤖 CONFIGURAR GOOGLE GEMINI AI                  ║${NC}"
            echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}\n"
            
            CURRENT_KEY=$(get_val '.bot.google_ai_key')
            
            if [[ -n "$CURRENT_KEY" && "$CURRENT_KEY" != "null" && "$CURRENT_KEY" != "" && "$CURRENT_KEY" != "AIzaSyBojMPaBM6NpRbXQP7sC9D9aXc2XZmI8_Q" ]]; then
                echo -e "${GREEN}✅ API Key configurada${NC}"
                echo -e "${YELLOW}Preview: ${CURRENT_KEY:0:30}...${NC}\n"
                echo -e "${CYAN}Consultas IA hoy:${NC}"
                TODAY=$(date +%Y-%m-%d)
                sqlite3 "$DB" "SELECT COUNT(*) FROM ai_conversations WHERE date(created_at) = '$TODAY'" 2>/dev/null || echo "0"
                echo -e ""
            else
                echo -e "${YELLOW}⚠️  Usando API Key por defecto${NC}"
                echo -e "${RED}⚠️  RECOMENDADO: Configurar tu propia API Key${NC}\n"
            fi
            
            echo -e "${CYAN}📋 Obtener API Key GRATIS:${NC}"
            echo -e "  1. Ve a: ${GREEN}https://makersuite.google.com/app/apikey${NC}"
            echo -e "  2. Inicia sesión con tu cuenta Google"
            echo -e "  3. Crea un nuevo proyecto o selecciona uno existente"
            echo -e "  4. Haz clic en 'Create API Key'"
            echo -e "  5. Selecciona 'Gemini API'"
            echo -e "  6. Copia la API Key generada"
            echo -e "  7. Formato: AIzaSyxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\n"
            echo -e "${YELLOW}💡 La API Key gratuita incluye:${NC}"
            echo -e "  • 60 solicitudes por minuto"
            echo -e "  • Suficiente para ~1000 consultas diarias"
            echo -e "  • Sin costo inicial\n"
            
            read -p "¿Configurar nueva API Key? (s/N): " CONF
            if [[ "$CONF" == "s" ]]; then
                echo ""
                read -p "Pega la API Key de Google AI: " NEW_KEY
                
                if [[ "$NEW_KEY" =~ ^AIzaSy[0-9A-Za-z_-]{35}$ ]]; then
                    set_val '.bot.google_ai_key' "\"$NEW_KEY\""
                    echo -e "\n${GREEN}✅ API Key configurada${NC}"
                    echo -e "${YELLOW}🔄 Reiniciando bot para cargar IA...${NC}"
                    cd /root/ssh-bot && pm2 restart ssh-bot
                    sleep 3
                    echo -e "${GREEN}✅ Google Gemini AI activado con tu API Key${NC}"
                else
                    echo -e "${RED}❌ Formato de API Key inválido${NC}"
                    echo -e "${YELLOW}Debe empezar con 'AIzaSy' y tener 39 caracteres${NC}"
                    echo -e "${YELLOW}Ejemplo correcto: AIzaSyBojMPaBM6NpRbXQP7sC9D9aXc2XZmI8_Q${NC}"
                fi
            fi
            read -p "Presiona Enter..."
            ;;
        16)
            clear
            echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
            echo -e "${CYAN}║              📊 ANÁLISIS DE COMPORTAMIENTO                   ║${NC}"
            echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}\n"
            
            echo -e "${YELLOW}📈 COMPORTAMIENTO GENERAL (últimos 7 días):${NC}"
            sqlite3 "$DB" "SELECT 
                'Usúarios únicos: ' || COUNT(DISTINCT phone) || ' | ' ||
                'Acciones totales: ' || COUNT(*) || ' | ' ||
                'Riesgo promedio: ' || printf('%.1f', AVG(risk_score))
            FROM user_behavior WHERE created_at > datetime('now', '-7 days')"
            
            echo -e "\n${YELLOW}🚨 ACCIONES DE ALTO RIESGO (últimas 24h):${NC}"
            sqlite3 -column -header "$DB" "SELECT 
                time(created_at) as hora,
                substr(phone,1,12) as tel,
                action_type,
                risk_score
            FROM user_behavior 
            WHERE risk_score >= 40 AND created_at > datetime('now', '-1 day')
            ORDER BY risk_score DESC
            LIMIT 15"
            
            echo -e "\n${YELLOW}📊 ACCIONES MÁS COMUNES:${NC}"
            sqlite3 -column -header "$DB" "SELECT 
                action_type,
                COUNT(*) as cantidad,
                AVG(risk_score) as riesgo_promedio
            FROM user_behavior 
            WHERE created_at > datetime('now', '-3 days')
            GROUP BY action_type
            ORDER BY cantidad DESC
            LIMIT 10"
            
            echo -e "\n${YELLOW}👤 USUARIOS CON MÁS ACTIVIDAD:${NC}"
            sqlite3 -column -header "$DB" "SELECT 
                substr(phone,1,12) as tel,
                COUNT(*) as acciones,
                MAX(risk_score) as max_riesgo
            FROM user_behavior 
            WHERE created_at > datetime('now', '-1 day')
            GROUP BY phone
            ORDER BY acciones DESC
            LIMIT 10"
            
            read -p "\nPresiona Enter..."
            ;;
        17)
            clear
            echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
            echo -e "${CYAN}║              🚨 ALERTAS DE SEGURIDAD                         ║${NC}"
            echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}\n"
            
            echo -e "${YELLOW}🔴 ALERTAS NO RESUELTAS:${NC}"
            sqlite3 -column -header "$DB" "SELECT 
                datetime(created_at) as fecha,
                substr(phone,1,12) as tel,
                alert_type,
                severity,
                substr(description,1,50) as descripcion
            FROM risk_alerts 
            WHERE resolved = 0
            ORDER BY 
                CASE severity 
                    WHEN 'critical' THEN 1
                    WHEN 'high' THEN 2
                    WHEN 'medium' THEN 3
                    WHEN 'low' THEN 4
                END,
                created_at DESC
            LIMIT 15"
            
            echo -e "\n${YELLOW}📊 ESTADÍSTICAS DE ALERTAS (últimos 30 días):${NC}"
            sqlite3 "$DB" "SELECT 
                'Totales: ' || COUNT(*) || ' | ' ||
                'Críticas: ' || SUM(CASE WHEN severity='critical' THEN 1 ELSE 0 END) || ' | ' ||
                'Altas: ' || SUM(CASE WHEN severity='high' THEN 1 ELSE 0 END) || ' | ' ||
                'Medias: ' || SUM(CASE WHEN severity='medium' THEN 1 ELSE 0 END) || ' | ' ||
                'Resueltas: ' || SUM(CASE WHEN resolved=1 THEN 1 ELSE 0 END)
            FROM risk_alerts WHERE created_at > datetime('now', '-30 days')"
            
            echo ""
            read -p "¿Marcar alertas como resueltas? (s/N): " RESOLVE
            if [[ "$RESOLVE" == "s" ]]; then
                sqlite3 "$DB" "UPDATE risk_alerts SET resolved = 1, resolved_at = CURRENT_TIMESTAMP WHERE resolved = 0"
                echo -e "${GREEN}✅ Todas las alertas marcadas como resueltas${NC}"
            fi
            
            read -p "\nPresiona Enter..."
            ;;
        18)
            clear
            echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
            echo -e "${CYAN}║              🤖 CONSULTAS IA RECIENTES                       ║${NC}"
            echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}\n"
            
            echo -e "${YELLOW}📝 ÚLTIMAS 10 CONSULTAS:${NC}"
            sqlite3 -column -header "$DB" "SELECT 
                datetime(created_at) as fecha,
                substr(phone,1,12) as tel,
                substr(user_query,1,40) as pregunta
            FROM ai_conversations 
            ORDER BY created_at DESC
            LIMIT 10"
            
            echo -e "\n${YELLOW}📊 ESTADÍSTICAS DE IA:${NC}"
            sqlite3 "$DB" "SELECT 
                'Hoy: ' || SUM(CASE WHEN date(created_at) = date('now') THEN 1 ELSE 0 END) || ' | ' ||
                'Ayer: ' || SUM(CASE WHEN date(created_at) = date('now', '-1 day') THEN 1 ELSE 0 END) || ' | ' ||
                'Total: ' || COUNT(*)
            FROM ai_conversations"
            
            echo -e "\n${YELLOW}🔍 BUSCAR CONSULTA:${NC}"
            read -p "Buscar por palabra clave: " SEARCH_TERM
            if [[ -n "$SEARCH_TERM" ]]; then
                echo ""
                sqlite3 -column -header "$DB" "SELECT 
                    datetime(created_at) as fecha,
                    substr(phone,1,12) as tel,
                    substr(user_query,1,50) as pregunta
                FROM ai_conversations 
                WHERE user_query LIKE '%$SEARCH_TERM%'
                ORDER BY created_at DESC
                LIMIT 10"
            fi
            
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
echo -e "${GREEN}✅ Panel de control con IA creado${NC}"

# ================================================
# INICIAR BOT CON IA
# ================================================
echo -e "\n${CYAN}${BOLD}🚀 INICIANDO BOT CON INTELIGENCIA ARTIFICIAL...${NC}"

cd "$USER_HOME"
pm2 start bot.js --name ssh-bot
pm2 save
pm2 startup systemd -u root --hp /root > /dev/null 2>&1

sleep 5

# ================================================
# MENSAJE FINAL CON IA
# ================================================
clear
echo -e "${GREEN}${BOLD}"
cat << "FINAL"
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║      🎉 INSTALACIÓN COMPLETADA - IA INTEGRADA 🎉           ║
║                                                              ║
║         SSH BOT PRO v8.6 - CON INTELIGENCIA ARTIFICIAL      ║
║           🤖 Google Gemini AI + Análisis de Comportamiento  ║
║           💳 MercadoPago SDK v2.x FULLY FIXED               ║
║           📅 Fechas ISO 8601 corregidas                     ║
║           🤖 WhatsApp markedUnread parcheado                ║
║           🔑 Validación token corregida                     ║
║           🚨 Sistema de alertas de seguridad                ║
║           📊 Análisis de comportamiento de usuarios         ║
║           ⏰ Test: 2 horas exactas                          ║
║           ⚡ Limpieza: cada 15 minutos                      ║
║           📱 APK Automático                                 ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
FINAL
echo -e "${NC}"

echo -e "${CYAN}══════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✅ Bot instalado con INTELIGENCIA ARTIFICIAL${NC}"
echo -e "${GREEN}✅ Google Gemini AI integrado con tu API Key${NC}"
echo -e "${GREEN}✅ Sistema de análisis de comportamiento activo${NC}"
echo -e "${GREEN}✅ Alertas automáticas de seguridad configuradas${NC}"
echo -e "${GREEN}✅ Panel de control con opciones de IA${NC}"
echo -e "${GREEN}✅ Fechas ISO 8601 corregidas para MP v2.x${NC}"
echo -e "${GREEN}✅ Error WhatsApp Web parcheado (markedUnread)${NC}"
echo -e "${GREEN}✅ Validación de token MP corregida${NC}"
echo -e "${GREEN}✅ Test ajustado a 2 horas exactas${NC}"
echo -e "${GREEN}✅ Limpieza ajustada a cada 15 minutos${NC}"
echo -e "${GREEN}✅ Usuarios con nombre personalizado + 'j'${NC}"
echo -e "${GREEN}✅ Contraseña siempre '12345'${NC}"
echo -e "${CYAN}══════════════════════════════════════════════════════════════${NC}\n"

echo -e "${YELLOW}📋 COMANDOS PRINCIPALES:${NC}\n"
echo -e "  ${GREEN}sshbot${NC}           - Panel de control con IA"
echo -e "  ${GREEN}pm2 logs ssh-bot${NC} - Ver logs del bot"
echo -e "  ${GREEN}pm2 restart ssh-bot${NC} - Reiniciar bot\n"

echo -e "${YELLOW}🤖 FUNCIONALIDADES DE IA:${NC}\n"
echo -e "  • Opción ${CYAN}7${NC} en el menú WhatsApp - Asistente IA"
echo -e "  • Comando: ${CYAN}ia [tu pregunta]${NC}"
echo -e "  • Ejemplo: ${CYAN}ia ¿Cómo configuro la app?${NC}"
echo -e "  • Respuestas inteligentes basadas en contexto\n"

echo -e "${YELLOW}🔧 CONFIGURACIÓN INICIAL:${NC}\n"
echo -e "  1. Ejecuta: ${GREEN}sshbot${NC}"
echo -e "  2. Opción ${CYAN}[8]${NC} - Configurar MercadoPago (obligatorio)"
echo -e "  3. Opción ${CYAN}[15]${NC} - Verificar/Configurar IA Gemini"
echo -e "  4. Opción ${CYAN}[3]${NC} - Escanear QR WhatsApp"
echo -e "  5. Sube APK a: ${CYAN}/root/app.apk${NC}\n"

echo -e "${YELLOW}📊 MONITOREO Y SEGURIDAD:${NC}\n"
echo -e "  • Opción ${CYAN}[16]${NC} - Análisis de comportamiento"
echo -e "  • Opción ${CYAN}[17]${NC} - Alertas de seguridad"
echo -e "  • Opción ${CYAN}[18]${NC} - Consultas IA recientes"
echo -e "  • Sistema automático de detección de fraudes\n"

echo -e "${YELLOW}⚡ DATOS TÉCNICOS:${NC}\n"
echo -e "  IP del servidor: ${CYAN}$SERVER_IP${NC}"
echo -e "  API Key Gemini: ${CYAN}Configurada${NC}"
echo -e "  Base de datos: ${CYAN}$DB_FILE${NC}"
echo -e "  Configuración: ${CYAN}$CONFIG_FILE${NC}"
echo -e "  Directorio bot: ${CYAN}$USER_HOME${NC}\n"

echo -e "${YELLOW}📱 USO PARA CLIENTES:${NC}\n"
echo -e "  1. Envían 'menu' a WhatsApp"
echo -e "  2. Opción 7: Asistente IA para preguntas"
echo -e "  3. Opción 1: Prueba gratis 2 horas"
echo -e "  4. Opción 2: Planes premium con MercadoPago"
echo -e "  5. Sistema solicita nombre para usuario personalizado\n"

echo -e "${CYAN}══════════════════════════════════════════════════════════════${NC}\n"

read -p "$(echo -e "${YELLOW}¿Abrir panel de control ahora? (s/N): ${NC}")" -n 1 -r
echo
if [[ $REPLY =~ ^[Ss]$ ]]; then
    echo -e "\n${CYAN}Abriendo panel de control...${NC}\n"
    sleep 2
    /usr/local/bin/sshbot
else
    echo -e "\n${YELLOW}💡 Recuerda ejecutar: ${GREEN}sshbot${NC}\n"
    echo -e "${RED}⚠️  IMPORTANTE: Configura MercadoPago (opción 8) para recibir pagos${NC}\n"
    echo -e "${GREEN}✅ La IA ya está configurada con tu API Key${NC}\n"
fi

echo -e "${GREEN}${BOLD}¡Instalación exitosa! Tu bot ahora tiene inteligencia artificial 🚀${NC}\n"

# ================================================
# AUTO-DESTRUCCIÓN DEL SCRIPT (SEGURIDAD)
# ================================================
echo -e "\n${RED}${BOLD}⚠️  AUTO-DESTRUCCIÓN ACTIVADA ⚠️${NC}"
echo -e "${YELLOW}El script se eliminará automáticamente en 15 segundos...${NC}"
echo -e "${CYAN}Guarda una copia local si necesitas reinstalar${NC}"

sleep 15

# Obtener la ruta completa del script
SCRIPT_PATH="$(realpath "$0")"

# Verificar que es un script de instalación
if [[ "$SCRIPT_PATH" =~ install.*\.sh$ ]] || [[ "$(basename "$SCRIPT_PATH")" =~ ^install_ ]]; then
    echo -e "${RED}🗑️  Eliminando script de instalación: $SCRIPT_PATH${NC}"
    
    # Crear comando de autodestrucción en background
    nohup bash -c "
        sleep 3
        echo 'Eliminando script de instalación...'
        rm -f '$SCRIPT_PATH'
        echo '✅ Script eliminado para seguridad'
        rm -f /tmp/sshbot-install-* 2>/dev/null
    " > /dev/null 2>&1 &
    
    echo -e "${GREEN}✅ El script se autoeliminará en background${NC}"
else
    echo -e "${YELLOW}⚠️  No se eliminó (nombre no seguro)${NC}"
fi

# Mensaje final
echo -e "\n${GREEN}═══════════════════════════════════════════════${NC}"
echo -e "${GREEN}           🎉 INSTALACIÓN TERMINADA           ${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════${NC}"
echo -e "${YELLOW}Inicia el panel con:${NC}"
echo -e "  ${CYAN}sshbot${NC}          - Panel de control completo"
echo -e "  ${CYAN}pm2 logs ssh-bot${NC} - Ver logs en tiempo real"
echo -e "\n${GREEN}🤖 ¡Disfruta de tu bot con inteligencia artificial!${NC}"
exit 0
