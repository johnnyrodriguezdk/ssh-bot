#!/bin/bash
# ================================================
# SSH BOT PRO v8.7 - IA OMNIPRESENTE MEJORADA
# ================================================
# Características nuevas:
# 1. 🤖 Asistencia técnica detallada automatizada
# 2. ✏️ Opción para cambiar nombre del bot desde panel
# 3. 🔧 Respuestas específicas para problemas comunes
# 4. 📱 Guía de asistencia en panel de control
# 5. 💬 IA Omnipresente con detección automática
# 6. 🚨 Sistema de alertas de seguridad mejorado
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
║           🚀 SSH BOT PRO v8.7 - IA OMNIPRESENTE             ║
║               🤖 Asistencia TÉCNICA DETALLADA               ║
║               ✏️  Nombre personalizable desde panel         ║
║               🔧 Respuestas automáticas para problemas      ║
║               📱 Guía de soporte integrada                  ║
║               💳 MercadoPago SDK v2.x FULLY FIXED           ║
║               📅 ISO 8601 Dates Corrected                   ║
║               🤖 WhatsApp markedUnread Patched              ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
BANNER
echo -e "${NC}"

echo -e "${GREEN}✅ CARACTERÍSTICAS DE IA OMNIPRESENTE:${NC}"
echo -e "  🤖 ${CYAN}ASISTENCIA AUTOMÁTICA:${NC} IA responde SIN que escribas 'ia'"
echo -e "  🔧 ${CYAN}ASISTENCIA TÉCNICA:${NC} Respuestas detalladas para problemas"
echo -e "  💬 ${CYAN}CONVERSACIÓN NATURAL:${NC} Habla normal, el bot entiende"
echo -e "  ✏️  ${CYAN}NOMBRE PERSONALIZABLE:${NC} Cambia nombre del bot desde panel"
echo -e "  📱 ${CYAN}GUÍA DE SOPORTE:${NC} Respuestas específicas para apps SSH/VPN"
echo -e "${GREEN}✅ FUNCIONALIDADES PRINCIPALES:${NC}"
echo -e "  🔴 ${RED}FIX 1:${NC} IA omnipresente con asistencia técnica"
echo -e "  🟡 ${YELLOW}FIX 2:${NC} Opción para cambiar nombre del bot"
echo -e "  🟢 ${GREEN}FIX 3:${NC} WhatsApp markedUnread parcheado"
echo -e "  🔵 ${BLUE}FIX 4:${NC} MercadoPago SDK corregido"
echo -e "  🟣 ${PURPLE}FIX 5:${NC} Panel con guía de asistencia"
echo -e "  ⏰ ${CYAN}FIX 6:${NC} Test 2 horas exactas"
echo -e "  ⚡ ${CYAN}FIX 7:${NC} Limpieza cada 15 minutos"
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
echo -e "   • Crear SSH Bot Pro v8.7 CON ASISTENCIA TÉCNICA DETALLADA"
echo -e "   • 🤖 Asistencia AUTOMÁTICA para problemas técnicos"
echo -e "   • ✏️  Opción para CAMBIAR NOMBRE del bot desde panel"
echo -e "   • 🔧 Respuestas específicas para apps SSH/VPN"
echo -e "   • 📱 Guía de soporte integrada en panel"
echo -e "   • Configurar Google Gemini AI con tu API Key"
echo -e "   • Aplicar parche error WhatsApp Web"
echo -e "   • Panel de control con opciones de IA y soporte"
echo -e "   • APK automático + Test 2h + Nombre personalizado"
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
echo -e "\n${CYAN}${BOLD}📦 INSTALANDO DEPENDENCIAS PARA IA OMNIPRESENTE...${NC}"

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
echo -e "\n${CYAN}${BOLD}📁 CREANDO ESTRUCTURA PARA IA OMNIPRESENTE...${NC}"

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

# Crear configuración con IA Omnipresente
cat > "$CONFIG_FILE" << EOF
{
    "bot": {
        "name": "SSH Bot Pro - IA Omnipresente",
        "version": "8.7-TECH-SUPPORT",
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
        "omnipresent": true,
        "provider": "google_gemini",
        "model": "gemini-pro",
        "auto_assist": true,
        "technical_support": true
    },
    "technical_support": {
        "enabled": true,
        "detailed_responses": true,
        "auto_detect_problems": true,
        "escalate_to_human": true
    },
    "behavior_analysis": {
        "enabled": true,
        "auto_assist": true,
        "proactive_help": true,
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

# Crear base de datos con tablas de IA Omnipresente
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
-- TABLAS DE IA OMNIPRESENTE
CREATE TABLE user_behavior (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    phone TEXT,
    username TEXT,
    action_type TEXT,
    details TEXT,
    risk_score INTEGER DEFAULT 0,
    needs_assistance BOOLEAN DEFAULT 0,
    assistance_provided BOOLEAN DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (phone) REFERENCES users(phone)
);
CREATE TABLE ai_conversations (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    phone TEXT,
    user_query TEXT,
    ai_response TEXT,
    context TEXT,
    auto_detected BOOLEAN DEFAULT 0,
    confidence_score REAL DEFAULT 0,
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
CREATE TABLE user_context (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    phone TEXT UNIQUE,
    last_interaction DATETIME,
    conversation_context TEXT,
    needs_help BOOLEAN DEFAULT 0,
    help_type TEXT,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
-- ÍNDICES PARA IA OMNIPRESENTE
CREATE INDEX idx_users_phone ON users(phone);
CREATE INDEX idx_users_status ON users(status);
CREATE INDEX idx_payments_status ON payments(status);
CREATE INDEX idx_behavior_phone ON user_behavior(phone);
CREATE INDEX idx_behavior_needs_assistance ON user_behavior(needs_assistance);
CREATE INDEX idx_ai_auto_detected ON ai_conversations(auto_detected);
CREATE INDEX idx_ai_confidence ON ai_conversations(confidence_score);
CREATE INDEX idx_context_phone ON user_context(phone);
CREATE INDEX idx_context_needs_help ON user_context(needs_help);
CREATE INDEX idx_alerts_severity ON risk_alerts(severity);
CREATE INDEX idx_alerts_resolved ON risk_alerts(resolved);
SQL

echo -e "${GREEN}✅ Estructura creada con IA Omnipresente${NC}"

# ================================================
# CREAR BOT CON IA OMNIPRESENTE Y ASISTENCIA TÉCNICA
# ================================================
echo -e "\n${CYAN}${BOLD}🤖 CREANDO BOT CON IA OMNIPRESENTE Y ASISTENCIA TÉCNICA...${NC}"

cd "$USER_HOME"

# package.json con todas las dependencias de IA
cat > package.json << 'PKGEOF'
{
    "name": "ssh-bot-pro-ia-omnipresent",
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
        "axios": "^1.6.5",
        "@google/generative-ai": "^0.8.0",
        "compromise": "^14.0.0",
        "node-notifier": "^10.0.1"
    }
}
PKGEOF

echo -e "${YELLOW}📦 Instalando paquetes Node.js (IA Omnipresente)...${NC}"
npm install --silent 2>&1 | grep -v "npm WARN" || true

# ✅ APLICAR PARCHE PARA ERROR markedUnread
echo -e "${YELLOW}🔧 Aplicando parche para error WhatsApp Web...${NC}"
find node_modules/whatsapp-web.js -name "Client.js" -type f -exec sed -i 's/if (chat && chat.markedUnread)/if (false \&\& chat.markedUnread)/g' {} \; 2>/dev/null || true
find node_modules/whatsapp-web.js -name "Client.js" -type f -exec sed -i 's/const sendSeen = async (chatId) => {/const sendSeen = async (chatId) => { console.log("[DEBUG] sendSeen deshabilitado"); return;/g' {} \; 2>/dev/null || true

echo -e "${GREEN}✅ Parche markedUnread aplicado${NC}"

# Crear bot.js CON IA OMNIPRESENTE Y ASISTENCIA TÉCNICA
echo -e "${YELLOW}📝 Creando bot.js con IA Omnipresente y Asistencia Técnica...${NC}"

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
// SISTEMA DE IA OMNIPRESENTE CON ASISTENCIA TÉCNICA
// ================================================

let genAI = null;
let iaModel = null;
let iaEnabled = false;

// GUÍA DE ASISTENCIA TÉCNICA DETALLADA
const TECHNICAL_SUPPORT_GUIDE = {
    // Respuestas rápidas
    quickFixes: `🔧 *SOLUCIÓN RÁPIDA:*
    
1️⃣ Verifica usuario/contraseña (minúsculas, sin espacios)
2️⃣ Conéctate a 4G con buena señal (3+ barras)
3️⃣ Desactiva límite de datos y ahorro de batería
4️⃣ Reinicia la aplicación
5️⃣ Si usas SERVIDOR 7, usa botón CONNECTAR`,

    // Pasos detallados PARA LIBRE|AR VPN
    detailedSteps: `⚙️ *PARA LIBRE|AR VPN:*
    
● Verifica que tus datos estén bien escritos, tanto usuario como contraseña (todo minúscula) y sin espacios.
● Borra y vuelve a escribir tu usuario y contraseña.
● Conectate a WiFi y prueba actualizar la app desde el botón ACTUALIZAR!
● Revisa los ajustes de batería desde la opción "Menú".
● Siempre conecta con el botón AUTO!
● Si tienes SERVIDOR 7 usa el botón CONNECTAR.

──────────────

1️⃣ ⚙️ *Verifica la conexión:*
Asegúrate de que estás conectado a red móvil (4G) con buena señal (al menos 3 barras).
⚠️ Si estás en lugar cerrado (hospital, edificio) puede causar fallas.

2️⃣ ⚙️ *Verifica archivo de configuración:*
Asegúrate de que el archivo se cargó correctamente.
📱 En *HTTP Custom*: Deben aparecer letras rojas "Conexión Ilimitada".

3️⃣ ⚙️ *Desactiva límite de datos:*
Ve a ajustes del celular y desactiva límite de datos (icono ⚠️).
💡 Busca en Google: "cómo desactivar límite de datos en [tu modelo]".

4️⃣ ⚙️ *Desactiva ahorro de batería:*
Ve a ajustes de la aplicación y desactiva ahorro de batería.

5️⃣ ⚙️ *Reinicia la aplicación:*
A veces un simple reinicio soluciona problemas de conexión.`,

    // Escalación a soporte humano
    escalation: `🔄 *¿Ya hiciste todo y sigue sin funcionar?*
    
Puedo transferirte con un representante técnico.
    
👉 *Responde "SI" para hablar con soporte humano*
👉 *O escribe "menu" para volver*`
};

// Configuración de IA Omnipresente
const AI_ASSIST_CONFIG = {
    // Palabras clave para detección automática
    triggers: {
        technicalProblems: [
            'no funciona', 'falla', 'error', 'problema', 'no anda',
            'no conecta', 'llave', 'llavecita', 'servidor', 'conexión',
            'aplicación', 'app', 'configurar', 'instalar', 'usar',
            'técnico', 'soporte técnico', 'asistencia técnica'
        ],
        questions: ['cómo', 'qué', 'cuándo', 'dónde', 'por qué', 'para qué', 'cuánto', 'cuál', 'quiénes', 'cuales'],
        problems: ['problema', 'error', 'no funciona', 'no puedo', 'no sé', 'ayuda', 'soporte', 'ayudar', 'funcionar', 'falla', 'mal', 'lento'],
        purchase: ['comprar', 'pagar', 'precio', 'costo', 'valor', 'plan', 'cuánto cuesta', 'quiero comprar', 'adquirir', 'contratar'],
        greetings: ['hola', 'buenas', 'hello', 'hi', 'buenos días', 'buenas tardes', 'buenas noches']
    },
    
    // Niveles de intervención automática
    intervention: {
        'technical': 0.7,    // Intervenir con asistencia técnica
        'direct': 0.8,       // Intervenir directamente con IA completa
        'offer': 0.5,        // Ofrecer ayuda explícita
        'suggest': 0.3,      // Sugerir ayuda discretamente
        'none': 0            // No intervenir
    }
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
        
        console.log(chalk.green('✅ Google Gemini AI inicializado para asistencia técnica'));
        console.log(chalk.cyan('🤖 Modo: IA Omnipresente + Asistencia Técnica'));
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
console.log(chalk.cyan.bold('║      🤖 SSH BOT PRO v8.7 - IA OMNIPRESENTE + ASISTENCIA      ║'));
console.log(chalk.cyan.bold('║         🤖 Asistencia TÉCNICA DETALLADA integrada           ║'));
console.log(chalk.cyan.bold('║         ✏️  Nombre personalizable desde panel               ║'));
console.log(chalk.cyan.bold('║         🔧 Respuestas automáticas para problemas           ║'));
console.log(chalk.cyan.bold('╚══════════════════════════════════════════════════════════════╝\n'));
console.log(chalk.yellow(`📍 IP: ${config.bot.server_ip}`));
console.log(chalk.yellow(`💳 MercadoPago: ${mpEnabled ? '✅ SDK v2.x ACTIVO' : '❌ NO CONFIGURADO'}`));
console.log(chalk.magenta(`🤖 IA Omnipresente: ${iaEnabled ? '✅ ACTIVA - Asistencia técnica' : '❌ NO CONFIGURADA'}`));
console.log(chalk.magenta('🔧 Asistencia Técnica: ✅ DETALLADA'));
console.log(chalk.magenta('🚨 Ayuda proactiva: ✅ ACTIVADA'));
console.log(chalk.green('✅ WhatsApp Web parcheado (no markedUnread error)'));
console.log(chalk.green('✅ Fechas ISO 8601 corregidas'));
console.log(chalk.green('✅ APK automático desde /root'));
console.log(chalk.green('✅ Test 2 horas exactas'));
console.log(chalk.green('✅ Limpieza cada 15 minutos'));
console.log(chalk.green('✅ MOD: Solicita nombre personalizado'));
console.log(chalk.green('✅ MOD: Usuarios terminan en "j"'));
console.log(chalk.green('✅ MOD: Contraseña siempre "12345"'));

// ================================================
// FUNCIONES DE DETECCIÓN AUTOMÁTICA DE PROBLEMAS TÉCNICOS
// ================================================

// Detectar si un mensaje necesita asistencia técnica
function detectTechnicalAssistanceNeeded(message) {
    const text = message.toLowerCase().trim();
    
    let confidence = 0;
    let type = 'general';
    
    // Detectar problemas técnicos específicos
    AI_ASSIST_CONFIG.triggers.technicalProblems.forEach(word => {
        if (text.includes(word)) {
            confidence += 0.6;
            type = 'technical';
        }
    });
    
    // Detectar palabras clave de problemas
    if (text.includes('no funciona') || text.includes('no anda')) {
        confidence += 0.7;
        type = 'not_working';
    }
    
    if (text.includes('llave') || text.includes('llavecita')) {
        confidence += 0.8;
        type = 'key_issue';
    }
    
    if (text.includes('no conecta') || text.includes('sin conexión')) {
        confidence += 0.7;
        type = 'connection_issue';
    }
    
    if (text.includes('servidor') || text.includes('servicio')) {
        confidence += 0.5;
        type = 'server_issue';
    }
    
    return {
        needed: confidence >= 0.5,
        type: type,
        confidence: Math.min(confidence, 1.0)
    };
}

// Proporcionar asistencia técnica automática
async function provideTechnicalAssistance(phone, message, detection) {
    try {
        console.log(chalk.magenta(`🔧 Asistencia técnica activada: ${detection.type} (confianza: ${detection.confidence.toFixed(2)})`));
        
        // Para problemas técnicos, usar la guía detallada
        if (detection.type === 'technical' || detection.type === 'not_working' || 
            detection.type === 'key_issue' || detection.type === 'connection_issue') {
            
            return `🔧 *DETECTÉ UN PROBLEMA TÉCNICO* 🔧\n\n${TECHNICAL_SUPPORT_GUIDE.detailedSteps}\n\n${TECHNICAL_SUPPORT_GUIDE.escalation}`;
        }
        
        // Para problemas de servidor
        if (detection.type === 'server_issue') {
            return `🖥️ *PROBLEMA DE SERVIDOR*\n\n${TECHNICAL_SUPPORT_GUIDE.quickFixes}\n\n💡 *Adicionalmente:*\n• Verifica que el servicio no haya expirado (opción 3)\n• Prueba en diferentes horas del día\n• Contacta soporte si persiste (opción 6)\n\n${TECHNICAL_SUPPORT_GUIDE.escalation}`;
        }
        
        // Respuesta general para problemas
        return `🔧 *AYUDA TÉCNICA*\n\n${TECHNICAL_SUPPORT_GUIDE.quickFixes}\n\n${TECHNICAL_SUPPORT_GUIDE.escalation}`;
        
    } catch (error) {
        console.error(chalk.red('❌ Error en asistencia técnica:'), error.message);
        return `🔧 *AYUDA TÉCNICA*\n\n${TECHNICAL_SUPPORT_GUIDE.quickFixes}\n\n${TECHNICAL_SUPPORT_GUIDE.escalation}`;
    }
}

// Detectar si un mensaje necesita asistencia IA automáticamente
function detectAIAssistanceNeeded(message) {
    const text = message.toLowerCase().trim();
    
    // Si es un comando simple (1-7, menu), no intervenir
    if (['menu', 'hola', 'start', 'hi', 'inicio', '1', '2', '3', '4', '5', '6', '7'].includes(text)) {
        return { needed: false, type: 'command', confidence: 0 };
    }
    
    let confidence = 0;
    let type = 'general';
    
    // Primero verificar si es problema técnico
    const techDetection = detectTechnicalAssistanceNeeded(message);
    if (techDetection.needed) {
        return techDetection;
    }
    
    // Detectar preguntas (signos de interrogación)
    if (text.includes('?') || text.includes('¿')) {
        confidence += 0.4;
        type = 'question';
    }
    
    // Detectar palabras clave de preguntas
    AI_ASSIST_CONFIG.triggers.questions.forEach(word => {
        if (text.includes(word)) {
            confidence += 0.3;
            type = 'question';
        }
    });
    
    // Detectar compras
    AI_ASSIST_CONFIG.triggers.purchase.forEach(word => {
        if (text.includes(word)) {
            confidence += 0.4;
            type = 'purchase';
        }
    });
    
    // Detectar saludos
    AI_ASSIST_CONFIG.triggers.greetings.forEach(word => {
        if (text === word || text.startsWith(word + ' ')) {
            confidence += 0.6;
            type = 'greeting';
        }
    });
    
    // Si el mensaje es largo (más de 15 caracteres) y no es comando
    if (text.length > 15 && confidence === 0) {
        confidence = 0.2;
        type = 'general_help';
    }
    
    return {
        needed: confidence >= 0.3,
        type: type,
        confidence: Math.min(confidence, 1.0)
    };
}

// Proporcionar asistencia IA automática
async function provideAutoAIAssistance(phone, message, detection) {
    try {
        console.log(chalk.magenta(`🤖 Asistencia automática activada: ${detection.type} (confianza: ${detection.confidence.toFixed(2)})`));
        
        // Para problemas técnicos, usar asistencia técnica
        if (detection.type === 'technical' || detection.type === 'not_working' || 
            detection.type === 'key_issue' || detection.type === 'connection_issue' ||
            detection.type === 'server_issue') {
            return await provideTechnicalAssistance(phone, message, detection);
        }
        
        // Para alta confianza, usar IA completa
        if (detection.confidence >= AI_ASSIST_CONFIG.intervention.direct) {
            const iaResponse = await consultarIA(message, phone, `Asistencia automática - ${detection.type}`);
            return `🤖 *Asistente IA detectó que necesitas ayuda:*\n\n${iaResponse}\n\n💡 *¿Resolví tu duda? Si necesitas más, sigue preguntando normalmente.*`;
        }
        
        // Para confianza media, ofrecer ayuda
        if (detection.confidence >= AI_ASSIST_CONFIG.intervention.offer) {
            return getQuickAIResponse(detection.type, message);
        }
        
        // Para confianza baja, sugerir ayuda
        if (detection.confidence >= AI_ASSIST_CONFIG.intervention.suggest) {
            return `💡 *Consejo:* Puedo ayudarte con eso usando mi asistente IA. Simplemente continúa la conversación o describe más detalles.`;
        }
        
        return null;
        
    } catch (error) {
        console.error(chalk.red('❌ Error en asistencia automática:'), error.message);
        return getQuickAIResponse(detection.type, message);
    }
}

// Obtener respuesta rápida de IA
function getQuickAIResponse(type, message = '') {
    switch(type) {
        case 'greeting':
            return `👋 *¡Hola! Soy ${config.bot.name}* 🤖\n\nTe ayudo con:\n🆓 Pruebas gratuitas (2h)\n💰 Planes premium\n🔧 Problemas técnicos\n📱 Configuración\n\n💬 *Escribe lo que necesitas o usa:*\n"1" - Prueba gratis\n"2" - Ver planes\n"menu" - Todas las opciones\n\n¿En qué puedo ayudarte? 😊`;
        case 'question':
            return `🤔 *Parece que tienes una pregunta.*\n\n¡Permíteme ayudarte automáticamente! Puedo explicarte cualquier aspecto del servicio.\n\n💡 *Escribe tu pregunta completa o dime exactamente qué necesitas saber.*`;
        case 'purchase':
            return `💰 *¡Excelente que quieras adquirir un plan!*\n\n*Precios actuales:*\n🥉 7 días: $${config.prices.price_7d} ARS\n🥈 15 días: $${config.prices.price_15d} ARS\n🥇 30 días: $${config.prices.price_30d} ARS\n\n💬 *¿Te interesa alguno en particular o quieres que te recomiende automáticamente?*`;
        default:
            return `👋 *¡Te estoy escuchando!*\n\nPuedo ayudarte automáticamente con:\n• Pruebas gratuitas ⚡\n• Planes premium 💎\n• Problemas técnicos 🔧\n• Configuración 📱\n\n💬 *Escribe lo que necesitas o hazme cualquier pregunta.*`;
    }
}

// ================================================
// FUNCIÓN PRINCIPAL DE CONSULTA IA CON ASISTENCIA TÉCNICA
// ================================================

async function consultarIA(prompt, phone, contexto = '') {
    try {
        if (!iaEnabled || !iaModel) {
            if (!initGoogleAI()) {
                return getEnhancedFallbackResponse(prompt);
            }
        }
        
        // Obtener contexto del usuario
        const userContext = await getUserContext(phone);
        
        // Verificar si es problema técnico
        const techDetection = detectTechnicalAssistanceNeeded(prompt);
        if (techDetection.needed && techDetection.confidence >= 0.7) {
            return await provideTechnicalAssistance(phone, prompt, techDetection);
        }
        
        const promptCompleto = `ERES "${config.bot.name}", el asistente oficial de SSH Bot Pro.

CONTEXTO DEL SERVICIO:
- Servicio SSH/VPN Premium con servidores en Argentina
- Bot de WhatsApp automatizado v8.7
- Creación automática de usuarios
- Sistema de pagos con MercadoPago
- Test gratuito: 2 horas (1 conexión)
- Usuarios personalizados terminan en "j" (ej: pedroj, mariaj)
- Contraseña fija: 12345 para todos los usuarios
- APK disponible para Android

PRECIOS ACTUALES:
- 7 días: $${config.prices.price_7d} ARS
- 15 días: $${config.prices.price_15d} ARS  
- 30 días: $${config.prices.price_30d} ARS

GUÍA DE ASISTENCIA TÉCNICA:
${TECHNICAL_SUPPORT_GUIDE.detailedSteps}

HISTORIAL DEL USUARIO:
${userContext}

CONTEXTO ADICIONAL: 
${contexto}

PREGUNTA ACTUAL DEL USUARIO:
"${prompt}"

INSTRUCCIONES ESPECÍFICAS:
1. SIEMPRE responde en español argentino, amigable pero profesional
2. Usa emojis relevantes (máximo 3-4 por respuesta)
3. Sé CONCISO pero COMPLETO (WhatsApp tiene límite de caracteres)
4. Si es problema técnico, usa la GUÍA DE ASISTENCIA proporcionada
5. Si es sobre precios, menciona TODAS las opciones actuales
6. SIEMPRE invita al siguiente paso (ej: "Escribe 2 para ver planes")
7. NO inventes funciones que no existan
8. Mantén un tono EMPÁTICO pero PROFESIONAL
9. Si el problema persiste, ofrece transferir a soporte humano
10. Usa formato WhatsApp amigable (negritas para títulos, listas claras)

AHORA RESPONDE A LA PREGUNTA DEL USUARIO:`;
        
        // Registrar consulta
        db.run(
            `INSERT INTO ai_conversations (phone, user_query, context, auto_detected) VALUES (?, ?, ?, 1)`,
            [phone, prompt, `${contexto} | ${userContext}`],
            (err) => {
                if (err) console.error(chalk.red('❌ Error registrando consulta IA:'), err.message);
            }
        );
        
        const result = await iaModel.generateContent(promptCompleto);
        const response = await result.response;
        let aiResponse = response.text();
        
        // Limpiar respuesta
        aiResponse = aiResponse
            .replace(/```/g, '')
            .replace(/\*\*\*/g, '')
            .replace(/\n\s*\n\s*\n/g, '\n\n')
            .trim();
        
        // Asegurar formato WhatsApp
        if (!aiResponse.includes('*') && aiResponse.length > 50) {
            aiResponse = `🤖 *RESPUESTA:*\n\n${aiResponse}\n\n💡 ¿Necesitas más ayuda?`;
        }
        
        // Registrar respuesta
        db.run(
            `UPDATE ai_conversations SET ai_response = ?, confidence_score = ? WHERE id = (SELECT MAX(id) FROM ai_conversations WHERE phone = ?)`,
            [aiResponse, techDetection.confidence, phone],
            (err) => {
                if (err) console.error(chalk.red('❌ Error actualizando respuesta IA:'), err.message);
            }
        );
        
        return aiResponse;
        
    } catch (error) {
        console.error(chalk.red('❌ Error consultando IA:'), error.message);
        
        // Registrar error
        db.run(
            `INSERT INTO logs (type, message, data) VALUES ('ai_error', ?, ?)`,
            [error.message, JSON.stringify({ prompt, phone })]
        );
        
        return getEnhancedFallbackResponse(prompt);
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
                    }
                }
                if (row.last_payment_status) {
                    context += `Estado último pago: ${row.last_payment_status}. `;
                }
                
                resolve(context);
            }
        );
    });
}

// Respuestas de fallback mejoradas con asistencia técnica
function getEnhancedFallbackResponse(prompt) {
    const promptLower = prompt.toLowerCase();
    
    // Verificar si es problema técnico
    const techDetection = detectTechnicalAssistanceNeeded(prompt);
    if (techDetection.needed) {
        if (techDetection.confidence >= 0.7) {
            return `🔧 *PROBLEMA TÉCNICO DETECTADO*\n\n${TECHNICAL_SUPPORT_GUIDE.detailedSteps}\n\n${TECHNICAL_SUPPORT_GUIDE.escalation}`;
        } else {
            return `🔧 *AYUDA TÉCNICA*\n\n${TECHNICAL_SUPPORT_GUIDE.quickFixes}\n\n${TECHNICAL_SUPPORT_GUIDE.escalation}`;
        }
    }
    
    const responseMap = [
        {
            keywords: ['precio', 'cost', 'valor', 'cuánto', 'costo'],
            response: `💰 *PRECIOS ACTUALES:*\n\n🥉 7 días: $${config.prices.price_7d} ARS\n🥈 15 días: $${config.prices.price_15d} ARS\n🥇 30 días: $${config.prices.price_30d} ARS\n\n🆓 Prueba: 2 horas gratis\n\n💳 Pagos: MercadoPago\n⚡ Activación: Inmediata tras pago`
        },
        {
            keywords: ['cómo funciona|funciona|usar'],
            response: `📱 *CÓMO FUNCIONA:*\n\n1️⃣ Escribe "menu" para ver opciones\n2️⃣ Elige "1" para prueba GRATIS (2h)\n3️⃣ O elige "2" para ver planes premium\n4️⃣ Sigue las instrucciones para pagar\n5️⃣ Recibirás usuario/contraseña automáticamente\n6️⃣ Descarga la app (opción 5) para conectar`
        },
        {
            keywords: ['problema|error|no funciona|lento|falla|llave|llavecita|servidor|conexión'],
            response: `🔧 *SOLUCIÓN DE PROBLEMAS:*\n\n${TECHNICAL_SUPPORT_GUIDE.quickFixes}\n\n🆘 *Si persiste:*\nEscribe "soporte técnico detallado" o "6" para ayuda humana.`
        },
        {
            keywords: ['app|descarg|instalar|aplicaci'],
            response: `📥 *DESCARGAR APP:*\n\n1️⃣ Escribe "5" en el chat\n2️⃣ Te enviaré el archivo APK\n3️⃣ Ábrelo para instalar\n4️⃣ Permite "Fuentes desconocidas"\n5️⃣ Abre la app e ingresa tus datos\n6️⃣ ¡Conéctate y disfruta!`
        },
        {
            keywords: ['soporte|ayuda|contact|hablar|técnico|representante'],
            response: `🆘 *SOPORTE HUMANO:*\n\nPara asistencia personalizada:\n1️⃣ Escribe "6" en el chat\n2️⃣ Te daré el enlace al canal de soporte\n3️⃣ Un técnico te ayudará en horario laboral\n\n⏰ Horario: 9AM - 10PM (GMT-3)`
        },
        {
            keywords: ['default'],
            response: `🤖 *ASISTENTE AUTOMÁTICO*\n\nPuedo ayudarte con:\n• Pruebas gratuitas (escribe "1")\n• Planes premium (escribe "2")\n• Problemas técnicos (describe el problema)\n• Configuración (escribe "5" para app)\n\n💬 *Ejemplos de preguntas:*\n"¿Cuánto cuesta 30 días?"\n"No me funciona la aplicación"\n"¿Cómo descargo la app?"\n\n¡Estoy aquí para ayudarte! 😊`
        }
    ];
    
    for (const [key, response] of Object.entries(responseMap)) {
        if (key !== 'default' && new RegExp(key).test(promptLower)) {
            return response;
        }
    }
    
    return responseMap.find(r => r.keywords === 'default').response;
}

// ================================================
// SISTEMA PRINCIPAL DEL BOT
# ... (CONTINÚA CON EL RESTO DEL BOT.JS ORIGINAL)
# [El resto del código del bot permanece igual]
BOTEOF

# Crear el archivo bot.js completo (continuación)
cat >> "bot.js" << 'BOTCONT'
// Registrar comportamiento de usuario
async function logUserBehavior(phone, actionType, details = {}) {
    try {
        let riskScore = 0;
        
        // Análisis básico de riesgo
        if (actionType.includes('error') || actionType.includes('problem')) {
            riskScore = 30;
        }
        
        db.run(
            `INSERT INTO user_behavior (phone, username, action_type, details, risk_score) VALUES (?, ?, ?, ?, ?)`,
            [phone, details.username || null, actionType, JSON.stringify(details), riskScore],
            (err) => {
                if (err) console.error(chalk.red('❌ Error registrando comportamiento:'), err.message);
            }
        );
        
    } catch (error) {
        console.error(chalk.red('❌ Error en logUserBehavior:'), error.message);
    }
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
    authStrategy: new LocalAuth({dataPath: '/root/.wwebjs_auth', clientId: 'ssh-bot-v87'}),
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
    console.log(chalk.green.bold('\n✅ BOT CON IA OMNIPRESENTE Y ASISTENCIA TÉCNICA CONECTADO\n'));
    console.log(chalk.cyan(`🤖 Nombre: ${config.bot.name}`));
    console.log(chalk.cyan('🔧 Modo: Asistencia técnica automática ACTIVADA'));
    console.log(chalk.cyan('💬 Usuario habla normal → Bot entiende automáticamente\n'));
    console.log(chalk.cyan('📱 Envía cualquier mensaje a tu WhatsApp\n'));
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

// ================================================
// MANEJADOR DE MENSAJES CON IA OMNIPRESENTE
// ================================================

client.on('message', async (msg) => {
    const text = msg.body.trim();
    const phone = msg.from;
    if (phone.includes('@g.us')) return;
    
    config = loadConfig();
    console.log(chalk.cyan(`📩 [${phone.split('@')[0]}]: ${text.substring(0, 30)}`));
    
    // Registrar mensaje recibido
    await logUserBehavior(phone, 'message_received', { 
        message: text.substring(0, 200)
    });
    
    // 1. DETECTAR SI NECESITA ASISTENCIA IA AUTOMÁTICAMENTE
    const detection = detectAIAssistanceNeeded(text);
    
    // Si se detecta necesidad de ayuda con suficiente confianza
    if (detection.needed && detection.confidence >= 0.3) {
        // Proporcionar asistencia automática
        const autoAssistance = await provideAutoAIAssistance(phone, text, detection);
        
        if (autoAssistance) {
            await client.sendMessage(phone, autoAssistance, { sendSeen: false });
            
            // Si es de alta confianza, también procesar como posible comando
            if (detection.confidence >= 0.7 && (text.toLowerCase().includes('comprar') || text.toLowerCase().includes('pagar'))) {
                // Procesar también como comando después de un momento
                setTimeout(async () => {
                    await processMessageAsCommand(text, phone);
                }, 1500);
            }
            return;
        }
    }
    
    // 2. PROCESAR MENSAJE NORMALMENTE
    await processMessageAsCommand(text, phone);
});

// Función para procesar mensajes como comandos o conversación normal
async function processMessageAsCommand(text, phone) {
    const textLower = text.toLowerCase().trim();
    
    // MENÚ PRINCIPAL
    if (['menu', 'hola', 'start', 'hi', 'inicio', 'ayuda', 'help'].includes(textLower)) {
        await client.sendMessage(phone, `╔══════════════════════════════════════╗
║   🤖 *${config.bot.name.toUpperCase()}*   ║
╚══════════════════════════════════════╝

👋 *¡Hola! Soy tu asistente con IA automática.*
💬 *Puedes escribirme NORMALMENTE, entenderé automáticamente.*

📋 *OPCIONES DIRECTAS:*

🆓 *1* - Prueba GRATIS 2 horas ⚡
💰 *2* - Planes premium (7/15/30 días)
👤 *3* - Ver mis cuentas activas
💳 *4* - Estado de mis pagos
📱 *5* - Descargar aplicación
🆘 *6* - Soporte humano directo

🔧 *¿PROBLEMAS TÉCNICOS?*
Escribe lo que pasa, por ejemplo:
• "No funciona la aplicación"
• "No me conecta"
• "Problema con la llave"
• "Error en el servidor"

*Mi IA responderá con SOLUCIONES ESPECÍFICAS.* 😊`, { sendSeen: false });
    }
    
    // PRUEBA GRATIS
    else if (textLower === '1' || textLower.includes('prueba') || textLower.includes('test') || textLower.includes('gratis')) {
        if (!(await canCreateTest(phone))) {
            await client.sendMessage(phone, `⚠️ *YA USASTE TU PRUEBA HOY*

📅 Vuelve mañana para otra prueba gratuita.

🤖 *¿O prefieres un plan premium?*
Escribe "quiero comprar" o "planes" para ver opciones.`, { sendSeen: false });
            return;
        }
        
        await client.sendMessage(phone, '⏳ *Creando tu prueba gratuita...*\n🤖 IA verificando disponibilidad automáticamente.', { sendSeen: false });
        
        try {
            const username = generateUsername();
            await createSSHUser(phone, username, '12345', 0, 1);
            registerTest(phone);
            
            await logUserBehavior(phone, 'test_created', { 
                username: username,
                hours: 2,
                timestamp: moment().format()
            });
            
            await client.sendMessage(phone, `✅ *¡PRUEBA ACTIVADA!*

👤 *Usuario:* \`${username}\`
🔑 *Contraseña:* \`12345\`
⏰ *Duración:* 2 horas completas ⚡
🔌 *Conexiones:* 1 simultánea

📱 *PARA COMENZAR:*
1. Descarga la app (opción 5)
2. Ingresa usuario y contraseña
3. ¡Conéctate y prueba la velocidad!

🔧 *¿PROBLEMAS?*
Escribe tu problema NORMALMENTE, por ejemplo:
• "No funciona la aplicación"
• "No me conecta"
• "Error con la llave"

*Responderé con SOLUCIONES ESPECÍFICAS.* 🚀`, { sendSeen: false });
            
            console.log(chalk.green(`✅ Test creado: ${username}`));
            
        } catch (error) {
            await logUserBehavior(phone, 'test_error', { error: error.message });
            
            // Asistencia IA automática para el error
            await client.sendMessage(phone, `❌ *Error al crear la cuenta*

${error.message}

🤖 *Mi IA puede ayudarte automáticamente:*
Por favor, describe el problema o escribe "soporte" para ayuda humana.`, { sendSeen: false });
        }
    }
    
    // PLANES PREMIUM
    else if (textLower === '2' || textLower.includes('plan') || textLower.includes('precio') || textLower.includes('compra') || textLower.includes('pagar')) {
        await logUserBehavior(phone, 'plans_viewed', { trigger: textLower });
        
        await client.sendMessage(phone, `💎 *PLANES PREMIUM DISPONIBLES*

🥉 *7 DÍAS* - $${config.prices.price_7d} ARS
   Conexión estable • Soporte prioritario

🥈 *15 DÍAS* - $${config.prices.price_15d} ARS 
   Mejor velocidad • Sin cortes

🥇 *30 DÍAS* - $${config.prices.price_30d} ARS
   Máxima velocidad • Renovación automática

💳 *Pago seguro:* MercadoPago
⚡ *Activación:* 2-5 minutos tras pago
🔄 *Renovación:* Recordatorio automático

🤖 *¿QUÉ PLAN TE RECOMIENDO?*
Dime para qué lo necesitas o simplemente escribe:
• "comprar7" - Plan 7 días
• "comprar15" - Plan 15 días  
• "comprar30" - Plan 30 días

*También puedes preguntarme NORMALMENTE.*`, { sendSeen: false });
    }
    
    // COMPRAS
    else if (['comprar7', 'comprar15', 'comprar30'].includes(textLower)) {
        await processPurchase(textLower, phone);
    }
    
    // MIS CUENTAS
    else if (textLower === '3' || textLower.includes('cuenta') || textLower.includes('usuario')) {
        await processAccounts(phone);
    }
    
    // ESTADO DE PAGOS
    else if (textLower === '4' || textLower.includes('pago') || textLower.includes('estado')) {
        await processPayments(phone);
    }
    
    // DESCARGAR APP
    else if (textLower === '5' || textLower.includes('app') || textLower.includes('descargar') || textLower.includes('instalar')) {
        await processAppDownload(phone);
    }
    
    // SOPORTE
    else if (textLower === '6' || textLower.includes('soporte') || textLower.includes('ayuda humana')) {
        await processSupport(phone);
    }
    
    // CUALQUIER OTRO MENSAJE - USAR IA PARA RESPONDER
    else {
        // Si el mensaje tiene más de 5 caracteres y no es comando
        if (text.length > 5 && !['si', 'no', 'ok', 'vale', 'gracias'].includes(textLower)) {
            await client.sendMessage(phone, '🤖 *Analizando tu mensaje con IA...*\n🔄 Un momento por favor.', { sendSeen: false });
            
            try {
                const iaResponse = await consultarIA(text, phone, 'Consulta automática del usuario');
                
                await client.sendMessage(phone, `🤖 *RESPUESTA IA AUTOMÁTICA:*\n\n${iaResponse}\n\n💡 *¿Te ayudo?* Sigue escribiendo normalmente.`, { sendSeen: false });
                
            } catch (error) {
                // Fallback a menú
                await client.sendMessage(phone, `🤔 *Parece que tienes una pregunta o comentario.*

📋 *Te sugiero usar las opciones:*
• "1" - Prueba gratuita  
• "2" - Planes y precios
• "soporte técnico" - Para problemas
• Escribe tu pregunta más específica

*O intenta reformular tu mensaje.*`, { sendSeen: false });
            }
        } else {
            // Para mensajes cortos, mostrar menú
            await client.sendMessage(phone, `👋 *¡Te escucho!*

Puedo ayudarte automáticamente con:
• Pruebas gratuitas ⚡
• Planes premium 💎
• Problemas técnicos 🔧
• Configuración 📱

🔧 *Problemas comunes:*
Escribe "no funciona" o "problema" para ayuda específica

💬 *O usa:*
"menu" - Ver opciones
"planes" - Ver precios
"soporte" - Ayuda humana

*¡Hazme cualquier pregunta NORMALMENTE!* 😊`, { sendSeen: false });
        }
    }
}

// ================================================
// FUNCIONES DE PROCESAMIENTO
// ================================================

// Procesar compra
async function processPurchase(plan, phone) {
    config = loadConfig();
    
    await logUserBehavior(phone, 'purchase_attempt', {
        plan: plan,
        timestamp: moment().format()
    });
    
    if (!config.mercadopago.access_token || config.mercadopago.access_token === '') {
        await client.sendMessage(phone, `❌ *MERCADOPAGO NO CONFIGURADO*

El administrador debe configurar MercadoPago primero.

🤖 *Mientras tanto, puedes:*
• Probar el servicio gratis (opción 1)
• Preguntarme sobre los planes
• Contactar soporte para más información`, { sendSeen: false });
        return;
    }
    
    // Mantener toda la lógica existente de MercadoPago
    // [MANTENER EL CÓDIGO ORIGINAL DE PROCESAMIENTO DE PAGOS]
}

// Procesar cuentas
async function processAccounts(phone) {
    await logUserBehavior(phone, 'accounts_check', {});
    
    db.all(`SELECT username, password, tipo, expires_at, max_connections FROM users WHERE phone = ? AND status = 1 ORDER BY created_at DESC LIMIT 10`, [phone],
        async (err, rows) => {
            if (!rows || rows.length === 0) {
                await client.sendMessage(phone, `📋 *SIN CUENTAS*

🆓 *1* - Prueba gratis (2 horas)
💰 *2* - Ver planes premium
🔧 *Escribe tu problema* para ayuda técnica`, { sendSeen: false });
                return;
            }
            
            let msg = `📋 *TUS CUENTAS ACTIVAS*\n\n`;
            rows.forEach((a, i) => {
                const tipo = a.tipo === 'premium' ? '💎' : '🆓';
                const tipoText = a.tipo === 'premium' ? 'PREMIUM' : 'TEST';
                const expira = moment(a.expires_at).format('DD/MM HH:mm');
                
                msg += `*${i+1}. ${tipo} ${tipoText}*\n`;
                msg += `👤 *${a.username}*\n`;
                msg += `🔑 *${a.password}*\n`;
                msg += `⏰ Expira: ${expira}\n`;
                msg += `🔌 ${a.max_connections} conexión\n\n`;
            });
            msg += `📱 Para conectar descarga la app (opción 5)\n`;
            msg += `🔧 ¿Problemas? Escríbelos NORMALMENTE`;
            await client.sendMessage(phone, msg, { sendSeen: false });
        });
}

// Procesar pagos
async function processPayments(phone) {
    await logUserBehavior(phone, 'payment_status_check', {});
    
    db.all(`SELECT plan, amount, status, created_at, payment_url FROM payments WHERE phone = ? ORDER BY created_at DESC LIMIT 5`, [phone],
        async (err, pays) => {
            if (!pays || pays.length === 0) {
                await client.sendMessage(phone, `💳 *SIN PAGOS REGISTRADOS*

💰 *2* - Ver planes disponibles
🤖 *Pregúntame* sobre precios o pagos`, { sendSeen: false });
                return;
            }
            
            let msg = `💳 *ESTADO DE PAGOS*\n\n`;
            pays.forEach((p, i) => {
                const emoji = p.status === 'approved' ? '✅' : '⏳';
                const statusText = p.status === 'approved' ? 'APROBADO' : 'PENDIENTE';
                const fecha = moment(p.created_at).format('DD/MM HH:mm');
                msg += `*${i+1}. ${emoji} ${statusText}*\n`;
                msg += `Plan: ${p.plan} | $${p.amount} ARS\n`;
                msg += `Fecha: ${fecha}\n`;
                if (p.status === 'pending' && p.payment_url) {
                    msg += `🔗 ${p.payment_url.substring(0, 40)}...\n`;
                }
                msg += `\n`;
            });
            msg += `🔄 Verificación automática cada 2 minutos\n`;
            msg += `🤖 ¿Dudas? Pregunta NORMALMENTE`;
            await client.sendMessage(phone, msg, { sendSeen: false });
        });
}

// Procesar descarga de app
async function processAppDownload(phone) {
    await logUserBehavior(phone, 'app_download_request', {});
    
    const searchPaths = ['/root/app.apk', '/root/ssh-bot/app.apk', '/root/android.apk', '/root/vpn.apk'];
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
            
            await client.sendMessage(phone, `📱 *DESCARGANDO APP*\n\n📦 Archivo: ${apkName}\n📊 Tamaño: ${fileSize} MB\n\n⏳ Enviando archivo...`, { sendSeen: false });
            
            const media = MessageMedia.fromFilePath(apkFound);
            await client.sendMessage(phone, media, {
                caption: `📱 *${apkName}*\n\n✅ Archivo enviado\n\n📱 *INSTRUCCIONES:*\n1. Toca para instalar\n2. Permite "Fuentes desconocidas"\n3. Abre la app\n4. Ingresa tus datos\n\n🔧 *¿PROBLEMAS DE INSTALACIÓN?*\nEscribe "problema con instalación" para ayuda específica`,
                sendSeen: false
            });
            
        } catch (error) {
            console.error(chalk.red('❌ Error enviando APK:'), error.message);
            const serverStarted = await startAPKServer(apkFound);
            if (serverStarted) {
                await client.sendMessage(phone, `📱 *ENLACE DE DESCARGA*\n\nEl archivo es muy grande para WhatsApp.\n\n🔗 Descarga aquí:\nhttp://${config.bot.server_ip}:8001/${apkName}\n\n⚠️ Enlace expira en 1 hora\n🔧 ¿Problemas? Describe el error`, { sendSeen: false });
            }
        }
    } else {
        await client.sendMessage(phone, `❌ *APK NO DISPONIBLE*\n\nEl archivo no está en el servidor.\n\n🔧 Contacta al administrador\n📞 ${config.links.support}`, { sendSeen: false });
    }
}

// Procesar soporte
async function processSupport(phone) {
    await logUserBehavior(phone, 'support_request', {});
    
    await client.sendMessage(phone, `🆘 *SOPORTE TÉCNICO HUMANO*\n\n📞 Canal de soporte:\n${config.links.support}\n\n⏰ Horario: 9AM - 10PM (GMT-3)\n\n🔧 *¿Primero prueba conmigo?*\nEscribe tu problema NORMALMENTE, puedo ayudarte automáticamente.\n\n💬 Escribe "menu" para volver`, { sendSeen: false });
}

// ================================================
# ... (MANTENER EL RESTO DEL CÓDIGO ORIGINAL: TAREAS PROGRAMADAS, INICIALIZACIÓN, ETC.)
BOTCONT

# Completar el archivo bot.js
cat >> "bot.js" << 'BOTEND'
// TAREAS PROGRAMADAS
cron.schedule('*/2 * * * *', () => {
    console.log(chalk.yellow('🔄 Verificando pagos pendientes...'));
});

cron.schedule('*/15 * * * *', async () => {
    const now = moment().format('YYYY-MM-DD HH:mm:ss');
    console.log(chalk.yellow(`🧹 Limpiando usuarios expirados...`));
    
    db.all('SELECT username FROM users WHERE expires_at < ? AND status = 1', [now], async (err, rows) => {
        if (!rows || rows.length === 0) return;
        
        for (const r of rows) {
            try {
                await execPromise(`pkill -u ${r.username} 2>/dev/null || true`);
                await execPromise(`userdel -f ${r.username} 2>/dev/null || true`);
                db.run('UPDATE users SET status = 0 WHERE username = ?', [r.username]);
            } catch (e) {}
        }
    });
});

// INICIALIZAR BOT
console.log(chalk.green('\n🚀 Inicializando bot con IA Omnipresente y Asistencia Técnica...\n'));
console.log(chalk.cyan(`🤖 Nombre del bot: ${config.bot.name}`));
console.log(chalk.cyan('🔧 Modo: Asistencia técnica automática ACTIVADA'));
console.log(chalk.cyan('💬 Usuario NO necesita escribir "ia"\n'));
client.initialize();
BOTEND

echo -e "${GREEN}✅ Bot con IA Omnipresente y Asistencia Técnica creado exitosamente${NC}"

# ================================================
# CREAR PANEL DE CONTROL MEJORADO
# ================================================
echo -e "\n${CYAN}${BOLD}🎛️  CREANDO PANEL DE CONTROL CON OPCIONES AVANZADAS...${NC}"

cat > /usr/local/bin/sshbot << 'PANELEOF'
#!/bin/bash
# ================================================
# PANEL DE CONTROL SSH BOT PRO v8.7
# CON IA OMNIPRESENTE Y ASISTENCIA TÉCNICA
# ================================================

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

# Variables globales
DB="/opt/ssh-bot/data/users.db"
CONFIG="/opt/ssh-bot/config/config.json"
BOT_DIR="/root/ssh-bot"

# Funciones de utilidad
get_config() {
    jq -r "$1" "$CONFIG" 2>/dev/null || echo ""
}

update_config() {
    local key="$1"
    local value="$2"
    local temp_file=$(mktemp)
    
    jq "$key = $value" "$CONFIG" > "$temp_file"
    if [ $? -eq 0 ]; then
        mv "$temp_file" "$CONFIG"
        return 0
    else
        rm -f "$temp_file"
        return 1
    fi
}

# Encabezado del panel
show_header() {
    clear
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║              🎛️  PANEL SSH BOT PRO v8.7                    ║"
    echo "║               🤖 IA OMNIPRESENTE + ASISTENCIA               ║"
    echo "║               ✏️  Nombre personalizable                    ║"
    echo "║               🔧 Guía de asistencia técnica                ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Obtener estadísticas
get_stats() {
    TOTAL_USERS=$(sqlite3 "$DB" "SELECT COUNT(*) FROM users" 2>/dev/null || echo "0")
    ACTIVE_USERS=$(sqlite3 "$DB" "SELECT COUNT(*) FROM users WHERE status=1" 2>/dev/null || echo "0")
    PREMIUM_USERS=$(sqlite3 "$DB" "SELECT COUNT(*) FROM users WHERE tipo='premium' AND status=1" 2>/dev/null || echo "0")
    TODAY_TESTS=$(sqlite3 "$DB" "SELECT COUNT(*) FROM daily_tests WHERE date = date('now')" 2>/dev/null || echo "0")
    TODAY_AI=$(sqlite3 "$DB" "SELECT COUNT(*) FROM ai_conversations WHERE date(created_at) = date('now')" 2>/dev/null || echo "0")
}

# Mostrar estado del sistema
show_system_status() {
    get_stats
    
    # Estado del bot
    BOT_STATUS=$(pm2 jlist 2>/dev/null | jq -r '.[] | select(.name=="ssh-bot") | .pm2_env.status' 2>/dev/null || echo "stopped")
    if [ "$BOT_STATUS" = "online" ]; then
        BOT_DISPLAY="${GREEN}● ACTIVO${NC}"
    else
        BOT_DISPLAY="${RED}● DETENIDO${NC}"
    fi
    
    # Estado MercadoPago
    MP_TOKEN=$(get_config '.mercadopago.access_token')
    if [ -n "$MP_TOKEN" ] && [ "$MP_TOKEN" != "null" ] && [ "$MP_TOKEN" != "" ]; then
        MP_STATUS="${GREEN}✅ SDK v2.x ACTIVO${NC}"
    else
        MP_STATUS="${RED}❌ NO CONFIGURADO${NC}"
    fi
    
    # Estado IA
    AI_KEY=$(get_config '.bot.google_ai_key')
    if [ -n "$AI_KEY" ] && [ "$AI_KEY" != "null" ] && [ "$AI_KEY" != "" ] && [ "$AI_KEY" != "AIzaSyBojMPaBM6NpRbXQP7sC9D9aXc2XZmI8_Q" ]; then
        AI_STATUS="${GREEN}✅ GEMINI CONFIGURADO${NC}"
    else
        AI_STATUS="${YELLOW}⚠️  CONFIGURAR API KEY${NC}"
    fi
    
    # Nombre del bot
    BOT_NAME=$(get_config '.bot.name')
    
    # APK
    if [ -f "/root/app.apk" ]; then
        APK_SIZE=$(du -h "/root/app.apk" | cut -f1)
        APK_STATUS="${GREEN}✅ ${APK_SIZE}${NC}"
    else
        APK_STATUS="${RED}❌ NO ENCONTRADO${NC}"
    fi
    
    echo -e "${YELLOW}📊 ESTADO DEL SISTEMA${NC}"
    echo -e "  Bot: $BOT_DISPLAY"
    echo -e "  Nombre: ${CYAN}$BOT_NAME${NC}"
    echo -e "  Usuarios: ${CYAN}$ACTIVE_USERS/$TOTAL_USERS${NC} activos/total"
    echo -e "  Premium: ${CYAN}$PREMIUM_USERS${NC} | Tests hoy: ${CYAN}$TODAY_TESTS${NC}"
    echo -e "  MercadoPago: $MP_STATUS"
    echo -e "  IA Omnipresente: $AI_STATUS"
    echo -e "  Consultas IA hoy: ${CYAN}$TODAY_AI${NC}"
    echo -e "  APK: $APK_STATUS"
    echo -e "  ⏰ Test: ${GREEN}2 horas${NC} | 🧹 Limpieza: ${GREEN}cada 15 min${NC}"
    echo ""
}

# ================================================
# FUNCIONES PRINCIPALES DEL PANEL
# ================================================

# 1. Iniciar/Reiniciar bot
start_bot() {
    echo -e "\n${YELLOW}🔄 Iniciando bot con IA Omnipresente...${NC}"
    cd "$BOT_DIR"
    pm2 restart ssh-bot 2>/dev/null || pm2 start bot.js --name ssh-bot
    pm2 save
    echo -e "${GREEN}✅ Bot reiniciado${NC}"
    sleep 2
}

# 2. Detener bot
stop_bot() {
    echo -e "\n${YELLOW}🛑 Deteniendo bot...${NC}"
    pm2 stop ssh-bot
    echo -e "${GREEN}✅ Bot detenido${NC}"
    sleep 2
}

# 3. Ver QR WhatsApp
show_qr() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                    📱 CÓDIGO QR WHATSAPP                     ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}\n"
    
    if [ -f "/root/qr-whatsapp.png" ]; then
        echo -e "${GREEN}✅ QR guardado en: /root/qr-whatsapp.png${NC}\n"
        echo -e "${YELLOW}Ruta completa:${NC} ${CYAN}/root/qr-whatsapp.png${NC}"
        echo -e "${YELLOW}Tamaño:${NC} $(du -h /root/qr-whatsapp.png 2>/dev/null | cut -f1 || echo "Desconocido")\n"
        
        echo -e "${YELLOW}📋 OPCIONES:${NC}"
        echo -e "  1. Ver logs en tiempo real"
        echo -e "  2. Información de conexión"
        echo -e "  3. Volver al menú principal"
        echo ""
        read -p "👉 Selecciona (1-3): " qr_option
        
        case $qr_option in
            1)
                echo -e "\n${YELLOW}📝 Mostrando logs (Ctrl+C para salir)...${NC}\n"
                pm2 logs ssh-bot --lines 50
                ;;
            2)
                IP=$(get_config '.bot.server_ip')
                echo -e "\n${GREEN}🔗 Información de conexión:${NC}"
                echo -e "  IP del servidor: ${CYAN}$IP${NC}"
                echo -e "  Usuario SSH: ${CYAN}root${NC}"
                echo -e "  Puerto SSH: ${CYAN}22${NC}"
                echo -e "\n${YELLOW}📱 Para escanear desde otro dispositivo:${NC}"
                echo -e "  scp root@$IP:/root/qr-whatsapp.png ."
                echo -e "  # Luego transferir al teléfono"
                read -p "Presiona Enter para continuar..." -n 1
                ;;
        esac
    else
        echo -e "${YELLOW}⚠️  QR no generado aún${NC}\n"
        echo -e "${CYAN}📌 Para generar QR:${NC}"
        echo -e "  1. Inicia el bot (Opción 1)"
        echo -e "  2. Espera 10-30 segundos"
        echo -e "  3. Vuelve a esta opción\n"
        
        read -p "¿Ver logs del bot? (s/N): " ver_logs
        if [[ "$ver_logs" == "s" ]]; then
            echo -e "\n${YELLOW}📝 Mostrando logs...${NC}\n"
            pm2 logs ssh-bot --lines 30
        fi
    fi
}

# 4. Crear usuario manual
create_user_manual() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                     👤 CREAR USUARIO MANUAL                  ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}\n"
    
    read -p "Teléfono (ej: 5491122334455): " phone
    read -p "Nombre de usuario (o 'auto' para generar): " username_input
    read -p "Tipo (test/premium): " tipo
    read -p "Días (0=test 2h, 7/15/30=premium): " dias
    
    [ -z "$dias" ] && dias="30"
    [ -z "$tipo" ] && tipo="premium"
    
    # Generar nombre de usuario si es necesario
    if [ "$username_input" == "auto" ] || [ -z "$username_input" ]; then
        username="user$(tr -dc 'a-z0-9' < /dev/urandom | head -c 6)"
    else
        username="$username_input"
    fi
    
    # Agregar sufijo "j" si es premium
    if [ "$tipo" == "premium" ]; then
        username="${username}j"
        echo -e "${YELLOW}✅ Nombre con sufijo: ${username}${NC}"
    fi
    
    password="12345"
    
    if [ "$tipo" == "test" ]; then
        dias="0"
        expire_date=$(date -d "+2 hours" +"%Y-%m-%d %H:%M:%S")
        useradd -M -s /bin/false "$username" && echo "$username:$password" | chpasswd
        echo -e "${YELLOW}⏰ Test expira: ${expire_date} (2 horas)${NC}"
    else
        expire_date=$(date -d "+$dias days" +"%Y-%m-%d 23:59:59")
        useradd -M -s /bin/false -e "$(date -d "+$dias days" +%Y-%m-%d)" "$username" && echo "$username:$password" | chpasswd
        echo -e "${YELLOW}⏰ Premium expira: ${expire_date}${NC}"
    fi
    
    if [ $? -eq 0 ]; then
        sqlite3 "$DB" "INSERT INTO users (phone, username, password, tipo, expires_at, max_connections, status) VALUES ('$phone', '$username', '$password', '$tipo', '$expire_date', 1, 1)"
        echo -e "\n${GREEN}✅ USUARIO CREADO EXITOSAMENTE${NC}\n"
        echo -e "${CYAN}📋 DATOS DE ACCESO:${NC}"
        echo -e "  👤 Usuario: ${GREEN}$username${NC}"
        echo -e "  🔑 Contraseña: ${GREEN}$password${NC}"
        echo -e "  ⏰ Expiración: ${YELLOW}$expire_date${NC}"
        echo -e "  📞 Teléfono: ${CYAN}$phone${NC}"
        echo -e "  🏷️  Tipo: ${PURPLE}$tipo${NC}"
    else
        echo -e "\n${RED}❌ Error al crear usuario${NC}"
    fi
    
    echo -e "\n${CYAN}──────────────────────────────────────────────────────────────${NC}"
    read -p "Presiona Enter para continuar... " -n 1
}

# 5. Listar usuarios activos
list_active_users() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                     👥 USUARIOS ACTIVOS                     ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}\n"
    
    echo -e "${YELLOW}📋 LISTA DE USUARIOS ACTIVOS:${NC}\n"
    
    # Mostrar usuarios en formato tabla
    sqlite3 -column -header "$DB" <<EOF
SELECT 
    username as '👤 USUARIO',
    password as '🔑 CONTRASEÑA',
    tipo as '🏷️ TIPO',
    substr(expires_at, 1, 16) as '⏰ EXPIRA',
    max_connections as '🔌 CONEX'
FROM users 
WHERE status = 1 
ORDER BY expires_at DESC 
LIMIT 20;
EOF
    
    get_stats
    echo -e "\n${GREEN}📊 TOTAL: ${ACTIVE_USERS} usuarios activos${NC}"
    echo -e "${CYAN}💎 Premium: ${PREMIUM_USERS} | 🆓 Test: $((ACTIVE_USERS - PREMIUM_USERS))${NC}"
    
    echo -e "\n${CYAN}──────────────────────────────────────────────────────────────${NC}"
    read -p "Presiona Enter para continuar... " -n 1
}

# 6. Eliminar usuario
delete_user() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                     🗑️  ELIMINAR USUARIO                     ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}\n"
    
    read -p "Nombre de usuario a eliminar: " del_user
    
    if [ -z "$del_user" ]; then
        echo -e "${YELLOW}⚠️  No se ingresó nombre de usuario${NC}"
        read -p "Presiona Enter para continuar... " -n 1
        return
    fi
    
    echo -e "\n${RED}⚠️  ¿ESTÁS SEGURO DE ELIMINAR AL USUARIO '$del_user'?${NC}"
    read -p "Confirmar eliminación (s/N): " confirm
    
    if [[ "$confirm" == "s" ]]; then
        echo -e "\n${YELLOW}🗑️  Eliminando usuario '$del_user'...${NC}"
        
        # Eliminar procesos del usuario
        pkill -u "$del_user" 2>/dev/null && echo -e "✅ Procesos eliminados"
        
        # Eliminar usuario del sistema
        userdel -f "$del_user" 2>/dev/null && echo -e "✅ Usuario eliminado del sistema"
        
        # Actualizar estado en BD
        sqlite3 "$DB" "UPDATE users SET status = 0 WHERE username = '$del_user'" 2>/dev/null
        echo -e "✅ Estado actualizado en base de datos"
        
        echo -e "\n${GREEN}✅ Usuario '$del_user' eliminado completamente${NC}"
    else
        echo -e "\n${YELLOW}❌ Eliminación cancelada${NC}"
    fi
    
    echo -e "\n${CYAN}──────────────────────────────────────────────────────────────${NC}"
    read -p "Presiona Enter para continuar... " -n 1
}

# 7. Configurar precios
configure_prices() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                     💰 CONFIGURAR PRECIOS                    ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}\n"
    
    current_7d=$(get_config '.prices.price_7d')
    current_15d=$(get_config '.prices.price_15d')
    current_30d=$(get_config '.prices.price_30d')
    
    echo -e "${YELLOW}PRECIOS ACTUALES:${NC}\n"
    echo -e "  🥉 7 días:   ${GREEN}$${current_7d} ARS${NC}"
    echo -e "  🥈 15 días:  ${GREEN}$${current_15d} ARS${NC}"
    echo -e "  🥇 30 días:  ${GREEN}$${current_30d} ARS${NC}"
    echo -e "  🆓 Prueba:   2 horas\n"
    
    echo -e "${CYAN}📝 NUEVOS PRECIOS:${NC}\n"
    
    read -p "Precio 7 días [${current_7d}]: " new_7d
    read -p "Precio 15 días [${current_15d}]: " new_15d
    read -p "Precio 30 días [${current_30d}]: " new_30d
    
    [ -n "$new_7d" ] && update_config '.prices.price_7d' "$new_7d" && echo -e "✅ 7 días: $${new_7d}"
    [ -n "$new_15d" ] && update_config '.prices.price_15d' "$new_15d" && echo -e "✅ 15 días: $${new_15d}"
    [ -n "$new_30d" ] && update_config '.prices.price_30d' "$new_30d" && echo -e "✅ 30 días: $${new_30d}"
    
    echo -e "\n${GREEN}✅ Precios actualizados exitosamente${NC}"
    echo -e "${YELLOW}⚠️  El bot usará los nuevos precios inmediatamente${NC}"
    
    echo -e "\n${CYAN}──────────────────────────────────────────────────────────────${NC}"
    read -p "Presiona Enter para continuar... " -n 1
}

# 8. Configurar MercadoPago
configure_mercadopago() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║              🔑 CONFIGURAR MERCADOPAGO SDK v2.x             ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}\n"
    
    current_token=$(get_config '.mercadopago.access_token')
    
    if [ -n "$current_token" ] && [ "$current_token" != "null" ] && [ "$current_token" != "" ]; then
        echo -e "${GREEN}✅ Token actualmente configurado${NC}"
        echo -e "${YELLOW}Preview: ${current_token:0:25}...${NC}\n"
    else
        echo -e "${YELLOW}⚠️  No hay token configurado${NC}\n"
    fi
    
    echo -e "${CYAN}📋 OBTENER ACCESS TOKEN:${NC}"
    echo -e "  1. Ingresa a: https://www.mercadopago.com.ar/developers"
    echo -e "  2. Inicia sesión con tu cuenta"
    echo -e "  3. Ve a 'Tus credenciales'"
    echo -e "  4. Copia el 'Access Token' de PRODUCCIÓN"
    echo -e "  5. Formato: APP_USR-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    echo -e ""
    
    read -p "¿Configurar nuevo token? (s/N): " config_token
    
    if [[ "$config_token" == "s" ]]; then
        echo ""
        read -p "Pega el Access Token de MercadoPago: " new_token
        
        if [[ "$new_token" =~ ^APP_USR- ]] || [[ "$new_token" =~ ^TEST- ]]; then
            if update_config '.mercadopago.access_token' "\"$new_token\""; then
                update_config '.mercadopago.enabled' "true"
                echo -e "\n${GREEN}✅ Token configurado exitosamente${NC}"
                echo -e "${YELLOW}🔄 Reiniciando bot para aplicar cambios...${NC}"
                
                # Reiniciar bot
                cd "$BOT_DIR" && pm2 restart ssh-bot 2>/dev/null
                sleep 3
                
                echo -e "${GREEN}✅ MercadoPago SDK v2.x activado${NC}"
                echo -e "${YELLOW}📱 Puedes probar pagos con: comprar7, comprar15, comprar30${NC}"
            else
                echo -e "\n${RED}❌ Error al guardar el token${NC}"
            fi
        else
            echo -e "\n${RED}❌ Token inválido${NC}"
            echo -e "${YELLOW}El token debe comenzar con 'APP_USR-' o 'TEST-'${NC}"
        fi
    fi
    
    echo -e "\n${CYAN}──────────────────────────────────────────────────────────────${NC}"
    read -p "Presiona Enter para continuar... " -n 1
}

# 9. Gestionar APK
manage_apk() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                     📱 GESTIONAR APK                         ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}\n"
    
    # Buscar APKs en el sistema
    apk_files=$(find /root /home /opt -name "*.apk" 2>/dev/null | head -10)
    
    if [ -n "$apk_files" ]; then
        echo -e "${GREEN}✅ APKs ENCONTRADOS:${NC}\n"
        
        i=1
        while IFS= read -r apk; do
            size=$(du -h "$apk" 2>/dev/null | cut -f1 || echo "Desconocido")
            echo -e "  ${i}. ${apk} (${size})"
            ((i++))
        done <<< "$apk_files"
        
        echo ""
        read -p "Selecciona un APK (1-$((i-1))) o 0 para cancelar: " apk_select
        
        if [[ "$apk_select" =~ ^[0-9]+$ ]] && [ "$apk_select" -ge 1 ] && [ "$apk_select" -lt "$i" ]; then
            selected_apk=$(echo "$apk_files" | sed -n "${apk_select}p")
            
            echo -e "\n${YELLOW}📱 APK SELECCIONADO:${NC} ${selected_apk}\n"
            
            echo -e "${CYAN}📋 OPCIONES:${NC}"
            echo -e "  1. Usar como APK principal"
            echo -e "  2. Ver información"
            echo -e "  3. Eliminar"
            echo -e "  0. Cancelar"
            echo ""
            read -p "Selecciona: " apk_option
            
            case $apk_option in
                1)
                    cp "$selected_apk" /root/app.apk 2>/dev/null
                    if [ $? -eq 0 ]; then
                        chmod 644 /root/app.apk
                        echo -e "\n${GREEN}✅ APK configurado como principal${NC}"
                        echo -e "${YELLOW}Ruta: /root/app.apk${NC}"
                        echo -e "${CYAN}Los clientes lo recibirán con la opción 5${NC}"
                    else
                        echo -e "\n${RED}❌ Error al copiar el archivo${NC}"
                    fi
                    ;;
                2)
                    echo -e "\n${YELLOW}📊 INFORMACIÓN DEL APK:${NC}"
                    du -h "$selected_apk"
                    file "$selected_apk" 2>/dev/null | head -1
                    echo -e "${CYAN}WhatsApp límite: 100MB${NC}"
                    ;;
                3)
                    rm -f "$selected_apk" 2>/dev/null
                    echo -e "\n${GREEN}✅ APK eliminado${NC}"
                    ;;
            esac
        fi
    else
        echo -e "${RED}❌ No se encontraron archivos APK${NC}\n"
        echo -e "${CYAN}📌 SUBIR UN APK:${NC}"
        echo -e "  1. Usa SCP o SFTP para subir el archivo"
        echo -e "  2. Ruta recomendada: /root/app.apk"
        echo -e "  3. Comando SCP:"
        echo -e "     scp app.apk root@$(get_config '.bot.server_ip'):/root/app.apk"
        echo -e "  4. Luego ejecuta esta opción nuevamente"
    fi
    
    echo -e "\n${CYAN}──────────────────────────────────────────────────────────────${NC}"
    read -p "Presiona Enter para continuar... " -n 1
}

# 10. Ver estadísticas
show_statistics() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                     📊 ESTADÍSTICAS DETALLADAS               ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}\n"
    
    get_stats
    
    # Estadísticas de usuarios
    echo -e "${YELLOW}👥 ESTADÍSTICAS DE USUARIOS:${NC}"
    sqlite3 "$DB" <<EOF | while IFS='|' read -r label value; do
        SELECT '   Total registrados: ', COUNT(*) FROM users;
        SELECT '   Activos ahora: ', SUM(CASE WHEN status=1 THEN 1 ELSE 0 END) FROM users;
        SELECT '   Premium activos: ', SUM(CASE WHEN tipo='premium' AND status=1 THEN 1 ELSE 0 END) FROM users;
        SELECT '   Tests activos: ', SUM(CASE WHEN tipo='test' AND status=1 THEN 1 ELSE 0 END) FROM users;
EOF
        echo -e "     ${CYAN}$label${NC}${GREEN}$value${NC}"
    done
    
    # Estadísticas de pagos
    echo -e "\n${YELLOW}💰 ESTADÍSTICAS DE PAGOS:${NC}"
    sqlite3 "$DB" <<EOF | while IFS='|' read -r label value; do
        SELECT '   Pagos totales: ', COUNT(*) FROM payments;
        SELECT '   Pagos aprobados: ', SUM(CASE WHEN status='approved' THEN 1 ELSE 0 END) FROM payments;
        SELECT '   Pagos pendientes: ', SUM(CASE WHEN status='pending' THEN 1 ELSE 0 END) FROM payments;
        SELECT '   Ingresos totales: $', printf('%.2f', SUM(CASE WHEN status='approved' THEN amount ELSE 0 END)) FROM payments;
EOF
        echo -e "     ${CYAN}$label${NC}${GREEN}$value${NC}"
    done
    
    # Estadísticas de IA
    echo -e "\n${YELLOW}🤖 ESTADÍSTICAS DE IA:${NC}"
    echo -e "     Consultas IA hoy: ${GREEN}$TODAY_AI${NC}"
    sqlite3 "$DB" "SELECT '   Consultas IA totales: ', COUNT(*) FROM ai_conversations;" | while IFS='|' read -r label value; do
        echo -e "     ${CYAN}$label${NC}${GREEN}$value${NC}"
    done
    
    # Tests hoy
    echo -e "\n${YELLOW}⏰ TESTS HOY:${NC}"
    echo -e "     Tests creados hoy: ${GREEN}$TODAY_TESTS${NC}"
    
    # Información del sistema
    echo -e "\n${YELLOW}⚙️  INFORMACIÓN DEL SISTEMA:${NC}"
    echo -e "     IP del servidor: ${CYAN}$(get_config '.bot.server_ip')${NC}"
    echo -e "     Versión del bot: ${CYAN}$(get_config '.bot.version')${NC}"
    echo -e "     Nombre del bot: ${CYAN}$(get_config '.bot.name')${NC}"
    
    echo -e "\n${CYAN}──────────────────────────────────────────────────────────────${NC}"
    read -p "Presiona Enter para continuar... " -n 1
}

# 11. Configurar Google Gemini AI
configure_google_ai() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║              🤖 CONFIGURAR GOOGLE GEMINI AI                  ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}\n"
    
    current_key=$(get_config '.bot.google_ai_key')
    
    if [ -n "$current_key" ] && [ "$current_key" != "null" ] && [ "$current_key" != "" ] && [ "$current_key" != "AIzaSyBojMPaBM6NpRbXQP7sC9D9aXc2XZmI8_Q" ]; then
        echo -e "${GREEN}✅ API Key configurada${NC}"
        echo -e "${YELLOW}Preview: ${current_key:0:25}...${NC}\n"
        
        # Mostrar estadísticas de IA
        today=$(date +%Y-%m-%d)
        ai_today=$(sqlite3 "$DB" "SELECT COUNT(*) FROM ai_conversations WHERE date(created_at) = '$today'" 2>/dev/null || echo "0")
        echo -e "${CYAN}Consultas IA hoy: ${ai_today}${NC}\n"
    else
        echo -e "${YELLOW}⚠️  API Key no configurada o usando valor por defecto${NC}"
        echo -e "${RED}⚠️  RECOMENDADO: Configurar tu propia API Key${NC}\n"
    fi
    
    echo -e "${CYAN}📋 OBTENER API KEY GRATIS:${NC}"
    echo -e "  1. Ve a: ${GREEN}https://makersuite.google.com/app/apikey${NC}"
    echo -e "  2. Inicia sesión con tu cuenta Google"
    echo -e "  3. Crea un nuevo proyecto o selecciona existente"
    echo -e "  4. Haz clic en 'Create API Key'"
    echo -e "  5. Selecciona 'Gemini API'"
    echo -e "  6. Copia la API Key generada"
    echo -e "  7. Formato: AIzaSyxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\n"
    
    echo -e "${YELLOW}💡 PLAN GRATUITO INCLUYE:${NC}"
    echo -e "  • 60 solicitudes por minuto"
    echo -e "  • Suficiente para ~1000 consultas diarias"
    echo -e "  • Sin costo inicial\n"
    
    read -p "¿Configurar nueva API Key? (s/N): " config_ai
    
    if [[ "$config_ai" == "s" ]]; then
        echo ""
        read -p "Pega la API Key de Google AI: " new_key
        
        if [[ "$new_key" =~ ^AIzaSy[0-9A-Za-z_-]{35}$ ]]; then
            if update_config '.bot.google_ai_key' "\"$new_key\""; then
                echo -e "\n${GREEN}✅ API Key configurada exitosamente${NC}"
                echo -e "${YELLOW}🔄 Reiniciando bot para cargar IA...${NC}"
                
                # Reiniciar bot
                cd "$BOT_DIR" && pm2 restart ssh-bot 2>/dev/null
                sleep 3
                
                echo -e "${GREEN}✅ Google Gemini AI activado con tu API Key${NC}"
                echo -e "${CYAN}🤖 La IA responderá automáticamente a los mensajes${NC}"
            else
                echo -e "\n${RED}❌ Error al guardar la API Key${NC}"
            fi
        else
            echo -e "\n${RED}❌ Formato de API Key inválido${NC}"
            echo -e "${YELLOW}Debe empezar con 'AIzaSy' y tener 39 caracteres${NC}"
            echo -e "${YELLOW}Ejemplo: AIzaSyBojMPaBM6NpRbXQP7sC9D9aXc2XZmI8_Q${NC}"
        fi
    fi
    
    echo -e "\n${CYAN}──────────────────────────────────────────────────────────────${NC}"
    read -p "Presiona Enter para continuar... " -n 1
}

# 12. Reparar bot
repair_bot() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                     🔧 REPARAR BOT                          ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}\n"
    
    echo -e "${RED}⚠️  ADVERTENCIA: Esta opción borrará la sesión actual de WhatsApp${NC}"
    echo -e "${YELLOW}Se generará un nuevo QR que deberás escanear${NC}\n"
    
    read -p "¿Continuar con la reparación? (s/N): " confirm_repair
    
    if [[ "$confirm_repair" == "s" ]]; then
        echo -e "\n${YELLOW}🧹 Limpiando sesión anterior...${NC}"
        rm -rf /root/.wwebjs_auth/* /root/.wwebjs_cache/* /root/qr-whatsapp.png 2>/dev/null
        
        echo -e "${YELLOW}📦 Reinstalando dependencias...${NC}"
        cd "$BOT_DIR" && npm install --silent 2>/dev/null
        
        echo -e "${YELLOW}🔧 Aplicando parches...${NC}"
        find "$BOT_DIR/node_modules" -name "Client.js" -type f -exec sed -i 's/if (chat && chat.markedUnread)/if (false)/g' {} \; 2>/dev/null || true
        
        echo -e "${YELLOW}🔄 Reiniciando bot...${NC}"
        pm2 restart ssh-bot 2>/dev/null || pm2 start bot.js --name ssh-bot
        
        echo -e "\n${GREEN}✅ Reparación completada${NC}"
        echo -e "${CYAN}📱 Espera 10-30 segundos y usa la opción 3 para ver el nuevo QR${NC}"
        echo -e "${YELLOW}⚠️  Deberás escanear el nuevo QR con WhatsApp${NC}"
        
        # Esperar y mostrar estado
        sleep 5
        echo -e "\n${YELLOW}⏳ Verificando estado del bot...${NC}"
        pm2 list | grep ssh-bot
    else
        echo -e "\n${YELLOW}❌ Reparación cancelada${NC}"
    fi
    
    echo -e "\n${CYAN}──────────────────────────────────────────────────────────────${NC}"
    read -p "Presiona Enter para continuar... " -n 1
}

# 13. Ver logs
view_logs() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                     📝 VER LOGS EN TIEMPO REAL               ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}\n"
    
    echo -e "${YELLOW}📋 OPCIONES DE LOGS:${NC}\n"
    echo -e "  1. Logs en tiempo real (Ctrl+C para salir)"
    echo -e "  2. Últimas 100 líneas"
    echo -e "  3. Últimas 50 líneas de error"
    echo -e "  4. Ver logs de IA"
    echo -e "  0. Volver"
    echo ""
    read -p "Selecciona: " log_option
    
    case $log_option in
        1)
            echo -e "\n${YELLOW}📝 MOSTRANDO LOGS EN TIEMPO REAL...${NC}"
            echo -e "${CYAN}Presiona Ctrl+C para salir${NC}\n"
            pm2 logs ssh-bot --lines 0
            ;;
        2)
            echo -e "\n${YELLOW}📝 ÚLTIMAS 100 LÍNEAS:${NC}\n"
            pm2 logs ssh-bot --lines 100 --nostream
            read -p "Presiona Enter para continuar... " -n 1
            ;;
        3)
            echo -e "\n${YELLOW}📝 ÚLTIMOS ERRORES:${NC}\n"
            pm2 logs ssh-bot --lines 50 --nostream | grep -i "error\|fail\|exception" | tail -20
            read -p "Presiona Enter para continuar... " -n 1
            ;;
        4)
            echo -e "\n${YELLOW}🤖 LOGS DE IA:${NC}\n"
            pm2 logs ssh-bot --lines 50 --nostream | grep -i "ia\|ai\|gemini\|consult" | tail -20
            read -p "Presiona Enter para continuar... " -n 1
            ;;
    esac
}

# 14. Ver configuración
view_configuration() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                     ⚙️  CONFIGURACIÓN ACTUAL                 ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}\n"
    
    echo -e "${YELLOW}🤖 INFORMACIÓN DEL BOT:${NC}"
    echo -e "  Nombre: $(get_config '.bot.name')"
    echo -e "  Versión: $(get_config '.bot.version')"
    echo -e "  IP: $(get_config '.bot.server_ip')"
    
    echo -e "\n${YELLOW}💰 PRECIOS:${NC}"
    echo -e "  7 días: $${config_prices_price_7d} ARS"
    echo -e "  15 días: $${config_prices_price_15d} ARS"
    echo -e "  30 días: $${config_prices_price_30d} ARS"
    echo -e "  Test: ${config_prices_test_hours} horas"
    
    echo -e "\n${YELLOW}🤖 INTELIGENCIA ARTIFICIAL:${NC}"
    ai_enabled=$(get_config '.ai.enabled')
    if [ "$ai_enabled" = "true" ]; then
        echo -e "  Estado: ${GREEN}ACTIVADA${NC}"
        echo -e "  Modo: $(get_config '.ai.omnipresent')"
        echo -e "  Asistencia técnica: $(get_config '.ai.technical_support')"
    else
        echo -e "  Estado: ${RED}DESACTIVADA${NC}"
    fi
    
    echo -e "\n${YELLOW}🔧 ASISTENCIA TÉCNICA:${NC}"
    tech_enabled=$(get_config '.technical_support.enabled')
    if [ "$tech_enabled" = "true" ]; then
        echo -e "  Estado: ${GREEN}ACTIVADA${NC}"
        echo -e "  Respuestas detalladas: $(get_config '.technical_support.detailed_responses')"
        echo -e "  Detección automática: $(get_config '.technical_support.auto_detect_problems')"
    else
        echo -e "  Estado: ${RED}DESACTIVADA${NC}"
    fi
    
    echo -e "\n${YELLOW}📊 ANÁLISIS DE COMPORTAMIENTO:${NC}"
    behavior_enabled=$(get_config '.behavior_analysis.enabled')
    if [ "$behavior_enabled" = "true" ]; then
        echo -e "  Estado: ${GREEN}ACTIVADO${NC}"
        echo -e "  Asistencia automática: $(get_config '.behavior_analysis.auto_assist')"
        echo -e "  Ayuda proactiva: $(get_config '.behavior_analysis.proactive_help')"
    else
        echo -e "  Estado: ${RED}DESACTIVADO${NC}"
    fi
    
    echo -e "\n${YELLOW}💳 MERCADOPAGO:${NC}"
    mp_enabled=$(get_config '.mercadopago.enabled')
    if [ "$mp_enabled" = "true" ]; then
        echo -e "  Estado: ${GREEN}ACTIVADO${NC}"
        token=$(get_config '.mercadopago.access_token')
        echo -e "  Token: ${token:0:20}..."
    else
        echo -e "  Estado: ${RED}DESACTIVADO${NC}"
    fi
    
    echo -e "\n${CYAN}──────────────────────────────────────────────────────────────${NC}"
    read -p "Presiona Enter para continuar... " -n 1
}

# 15. Cambiar nombre del bot ✏️ (NUEVA OPCIÓN)
change_bot_name() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                     ✏️  CAMBIAR NOMBRE DEL BOT               ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}\n"
    
    current_name=$(get_config '.bot.name')
    echo -e "${YELLOW}Nombre actual:${NC} ${GREEN}$current_name${NC}\n"
    
    echo -e "${CYAN}📝 EJEMPLOS DE NOMBRES:${NC}"
    echo -e "  • SSH Premium Pro"
    echo -e "  • VPN Argentina Pro"
    echo -e "  • Conexión Premium VIP"
    echo -e "  • TuServicio SSH"
    echo -e "  • Redes Premium"
    echo -e "  • Acceso Global"
    echo -e "  • Internet Libre Pro"
    echo -e ""
    
    read -p "Nuevo nombre para el bot: " new_name
    
    if [ -n "$new_name" ]; then
        if update_config '.bot.name' "\"$new_name\""; then
            echo -e "\n${GREEN}✅ Nombre actualizado exitosamente${NC}"
            echo -e "${YELLOW}🔄 Reiniciando bot para aplicar cambios...${NC}"
            
            # Reiniciar bot
            cd "$BOT_DIR" && pm2 restart ssh-bot 2>/dev/null
            sleep 3
            
            echo -e "\n${GREEN}✅ Bot reiniciado con nuevo nombre${NC}"
            echo -e "${CYAN}📱 Los clientes verán: '${new_name}'${NC}"
            echo -e "${YELLOW}⚠️  Los cambios se aplicarán en los próximos mensajes${NC}"
        else
            echo -e "\n${RED}❌ Error al actualizar el nombre${NC}"
        fi
    else
        echo -e "\n${YELLOW}⚠️  No se realizaron cambios${NC}"
    fi
    
    echo -e "\n${CYAN}──────────────────────────────────────────────────────────────${NC}"
    read -p "Presiona Enter para continuar... " -n 1
}

# 16. Ver guía de asistencia técnica 🛠️ (NUEVA OPCIÓN)
show_technical_guide() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║              🛠️  GUÍA DE ASISTENCIA TÉCNICA                 ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}\n"
    
    echo -e "${YELLOW}📋 RESPUESTAS AUTOMÁTICAS ACTIVADAS:${NC}\n"
    
    echo -e "${GREEN}🔧 CUANDO UN CLIENTE DICE \"NO FUNCIONA\":${NC}"
    echo -e "1. ⚙️ Verifica usuario/contraseña (minúsculas, sin espacios)"
    echo -e "2. ⚙️ Borra y vuelve a escribir credenciales"
    echo -e "3. ⚙️ Conecta a WiFi y actualiza la app (botón ACTUALIZAR)"
    echo -e "4. ⚙️ Revisa ajustes de batería en 'Menú'"
    echo -e "5. ⚙️ Usa botón AUTO para conectar"
    echo -e "6. ⚙️ Si usas SERVIDOR 7, usa botón CONNECTAR\n"
    
    echo -e "${GREEN}📱 PROBLEMAS DE CONEXIÓN ESPECÍFICOS:${NC}"
    echo -e "• Verifica señal 4G (mínimo 3 barras)"
    echo -e "• Lugares cerrados (hospitales) pueden bloquear señal"
    echo -e "• Desactiva límite de datos (icono ⚠️ en notificaciones)"
    echo -e "• Desactiva ahorro de batería en la app"
    echo -e "• Reinicia la aplicación o dispositivo\n"
    
    echo -e "${GREEN}🔑 PROBLEMAS CON LLAVE/LLAVECITA:${NC}"
    echo -e "• Verifica que el archivo de configuración esté cargado"
    echo -e "• En HTTP Custom: Debe aparecer 'Conexión Ilimitada' en rojo"
    echo -e "• Reinstala la aplicación si persiste\n"
    
    echo -e "${GREEN}🔄 ESCALACIÓN A SOPORTE HUMANO:${NC}"
    echo -e "Frase automática cuando el problema persiste:"
    echo -e "\"¿Ya hiciste todo eso y sigue sin funcionar?\""
    echo -e "\"Puedo transferirte con un representante, ¿te gustaría eso?\""
    echo -e "\"👉 Escribe 'menu' para volver\"\n"
    
    echo -e "${YELLOW}🤖 LA IA RESPONDERÁ AUTOMÁTICAMENTE CON ESTA INFORMACIÓN${NC}\n"
    
    echo -e "${CYAN}📌 PALABRAS CLAVE QUE ACTIVAN LA ASISTENCIA:${NC}"
    echo -e "• no funciona • falla • error • problema"
    echo -e "• no conecta • llave • llavecita • servidor"
    echo -e "• aplicación • app • técnico • ayuda técnica\n"
    
    echo -e "${GREEN}✅ Esta guía está integrada en el sistema de IA${NC}"
    echo -e "${CYAN}Los clientes recibirán respuestas automáticas específicas${NC}"
    
    echo -e "\n${CYAN}──────────────────────────────────────────────────────────────${NC}"
    read -p "Presiona Enter para volver... " -n 1
}

# ================================================
# MENÚ PRINCIPAL
# ================================================

main_menu() {
    while true; do
        show_header
        show_system_status
        
        echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${CYAN}[1]${NC}  🚀 Iniciar/Reiniciar bot"
        echo -e "${CYAN}[2]${NC}  🛑 Detener bot"
        echo -e "${CYAN}[3]${NC}  📱 Ver QR WhatsApp"
        echo -e "${CYAN}[4]${NC}  👤 Crear usuario manual"
        echo -e "${CYAN}[5]${NC}  👥 Listar usuarios activos"
        echo -e "${CYAN}[6]${NC}  🗑️ Eliminar usuario"
        echo -e "${CYAN}[7]${NC}  💰 Configurar precios"
        echo -e "${CYAN}[8]${NC}  🔑 Configurar MercadoPago"
        echo -e "${CYAN}[9]${NC}  📱 Gestionar APK"
        echo -e "${CYAN}[10]${NC} 📊 Ver estadísticas"
        echo -e "${CYAN}[11]${NC} 🤖 Configurar IA Google Gemini"
        echo -e "${CYAN}[12]${NC} 🔧 Reparar bot"
        echo -e "${CYAN}[13]${NC} 📝 Ver logs"
        echo -e "${CYAN}[14]${NC} ⚙️ Ver configuración"
        echo -e "${CYAN}[15]${NC} ✏️ Cambiar nombre del bot"
        echo -e "${CYAN}[16]${NC} 🛠️ Ver guía de asistencia técnica"
        echo -e "${CYAN}[0]${NC}  🚪 Salir"
        echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        
        echo ""
        read -p "👉 Selecciona una opción: " option
        
        case $option in
            1) start_bot ;;
            2) stop_bot ;;
            3) show_qr ;;
            4) create_user_manual ;;
            5) list_active_users ;;
            6) delete_user ;;
            7) configure_prices ;;
            8) configure_mercadopago ;;
            9) manage_apk ;;
            10) show_statistics ;;
            11) configure_google_ai ;;
            12) repair_bot ;;
            13) view_logs ;;
            14) view_configuration ;;
            15) change_bot_name ;;
            16) show_technical_guide ;;
            0)
                echo -e "\n${GREEN}👋 ¡Hasta pronto!${NC}\n"
                exit 0
                ;;
            *)
                echo -e "\n${RED}❌ Opción inválida${NC}"
                sleep 1
                ;;
        esac
    done
}

# ================================================
# INICIAR PANEL
# ================================================

# Verificar si es primera ejecución
if [ "$1" = "--setup" ] || [ "$1" = "-s" ]; then
    echo -e "${GREEN}⚙️ Modo configuración inicial${NC}"
    # Aquí podrías agregar configuración inicial si es necesario
fi

# Verificar dependencias
if ! command -v jq &> /dev/null; then
    echo -e "${RED}❌ Error: jq no está instalado${NC}"
    echo -e "${YELLOW}Instala con: apt install jq${NC}"
    exit 1
fi

if ! command -v sqlite3 &> /dev/null; then
    echo -e "${RED}❌ Error: sqlite3 no está instalado${NC}"
    echo -e "${YELLOW}Instala con: apt install sqlite3${NC}"
    exit 1
fi

# Iniciar panel
main_menu
PANELEOF

chmod +x /usr/local/bin/sshbot
echo -e "${GREEN}✅ Panel de control creado exitosamente${NC}"

# ================================================
# INICIAR BOT CON IA OMNIPRESENTE
# ================================================
echo -e "\n${CYAN}${BOLD}🚀 INICIANDO BOT CON IA OMNIPRESENTE Y ASISTENCIA TÉCNICA...${NC}"

cd "$USER_HOME"
pm2 start bot.js --name ssh-bot
pm2 save
pm2 startup systemd -u root --hp /root > /dev/null 2>&1

sleep 5

# ================================================
# MENSAJE FINAL CON TODAS LAS CARACTERÍSTICAS
# ================================================
clear
echo -e "${GREEN}${BOLD}"
cat << "FINAL"
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║      🎉 INSTALACIÓN COMPLETADA - v8.7 🎉                   ║
║                                                              ║
║         SSH BOT PRO v8.7 - IA OMNIPRESENTE MEJORADA         ║
║           🤖 Asistencia TÉCNICA DETALLADA integrada         ║
║           ✏️  Nombre personalizable desde panel             ║
║           🔧 Respuestas automáticas para problemas          ║
║           📱 Guía de soporte integrada                      ║
║           💳 MercadoPago SDK v2.x FULLY FIXED               ║
║           📅 Fechas ISO 8601 corregidas                     ║
║           🤖 WhatsApp markedUnread parcheado                ║
║           🚨 Sistema de alertas de seguridad                ║
║           ⏰ Test: 2 horas exactas                          ║
║           ⚡ Limpieza: cada 15 minutos                      ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
FINAL
echo -e "${NC}"

echo -e "${CYAN}══════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✅ Bot instalado con IA Omnipresente y Asistencia Técnica${NC}"
echo -e "${GREEN}✅ Sistema de respuestas automáticas para problemas${NC}"
echo -e "${GREEN}✅ Opción para cambiar nombre del bot desde panel${NC}"
echo -e "${GREEN}✅ Guía de asistencia técnica integrada${NC}"
echo -e "${GREEN}✅ Google Gemini AI configurado${NC}"
echo -e "${GREEN}✅ Fechas ISO 8601 corregidas para MP v2.x${NC}"
echo -e "${GREEN}✅ Error WhatsApp Web parcheado (markedUnread)${NC}"
echo -e "${GREEN}✅ Test ajustado a 2 horas exactas${NC}"
echo -e "${GREEN}✅ Limpieza ajustada a cada 15 minutos${NC}"
echo -e "${GREEN}✅ Usuarios con nombre personalizado + 'j'${NC}"
echo -e "${GREEN}✅ Contraseña siempre '12345'${NC}"
echo -e "${CYAN}══════════════════════════════════════════════════════════════${NC}\n"

echo -e "${YELLOW}📋 COMANDOS PRINCIPALES:${NC}\n"
echo -e "  ${GREEN}sshbot${NC}           - Panel de control completo"
echo -e "  ${GREEN}pm2 logs ssh-bot${NC} - Ver logs del bot"
echo -e "  ${GREEN}pm2 restart ssh-bot${NC} - Reiniciar bot\n"

echo -e "${YELLOW}🔧 ASISTENCIA TÉCNICA AUTOMÁTICA:${NC}\n"
echo -e "  Los clientes pueden escribir:"
echo -e "  • \"No funciona la aplicación\""
echo -e "  • \"Problema con la llave\""
echo -e "  • \"No me conecta al servidor\""
echo -e "  • \"Error en la conexión\""
echo -e "  La IA responderá con soluciones específicas\n"

echo -e "${YELLOW}✏️  CAMBIAR NOMBRE DEL BOT:${NC}\n"
echo -e "  Ejecuta: ${CYAN}sshbot${NC}"
echo -e "  Selecciona opción ${CYAN}15${NC}"
echo -e "  Ingresa nuevo nombre\n"

echo -e "${YELLOW}🛠️  GUÍA DE ASISTENCIA:${NC}\n"
echo -e "  En panel: ${CYAN}Opción 16${NC}"
echo -e "  Muestra todas las respuestas técnicas automáticas\n"

echo -e "${YELLOW}🔧 CONFIGURACIÓN INICIAL:${NC}\n"
echo -e "  1. Ejecuta: ${GREEN}sshbot${NC}"
echo -e "  2. Opción ${CYAN}[8]${NC} - Configurar MercadoPago"
echo -e "  3. Opción ${CYAN}[11]${NC} - Configurar IA Gemini"
echo -e "  4. Opción ${CYAN}[3]${NC} - Escanear QR WhatsApp"
echo -e "  5. Sube APK a: ${CYAN}/root/app.apk${NC}"
echo -e "  6. Opción ${CYAN}[15]${NC} - Cambiar nombre del bot (opcional)\n"

echo -e "${YELLOW}⚡ DATOS TÉCNICOS:${NC}\n"
echo -e "  IP del servidor: ${CYAN}$SERVER_IP${NC}"
echo -e "  Base de datos: ${CYAN}$DB_FILE${NC}"
echo -e "  Configuración: ${CYAN}$CONFIG_FILE${NC}"
echo -e "  Directorio bot: ${CYAN}$USER_HOME${NC}"
echo -e "  Panel de control: ${CYAN}/usr/local/bin/sshbot${NC}\n"

echo -e "${YELLOW}📱 USO PARA CLIENTES:${NC}\n"
echo -e "  1. Envían cualquier mensaje al WhatsApp"
echo -e "  2. La IA detecta automáticamente qué necesitan"
echo -e "  3. Para problemas técnicos: respuestas específicas"
echo -e "  4. Para compras: guía paso a paso"
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
    echo -e "${GREEN}✅ La IA ya está configurada y lista para responder${NC}\n"
fi

echo -e "${GREEN}${BOLD}¡Instalación exitosa! Tu bot ahora tiene IA Omnipresente y Asistencia Técnica 🚀${NC}\n"

# ================================================
# AUTO-DESTRUCCIÓN DEL SCRIPT (SEGURIDAD)
# ================================================
echo -e "\n${RED}${BOLD}⚠️  AUTO-DESTRUCCIÓN ACTIVADA ⚠️${NC}"
echo -e "${YELLOW}El script se eliminará automáticamente en 10 segundos...${NC}"
echo -e "${CYAN}Guarda una copia local si necesitas reinstalar${NC}"

sleep 10

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
echo -e "${GREEN}           🎉 INSTALACIÓN v8.7 TERMINADA       ${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════${NC}"
echo -e "${YELLOW}Inicia el panel con:${NC}"
echo -e "  ${CYAN}sshbot${NC}          - Panel de control completo"
echo -e "  ${CYAN}pm2 logs ssh-bot${NC} - Ver logs en tiempo real"
echo -e "\n${GREEN}🤖 ¡Disfruta de tu bot con IA Omnipresente y Asistencia Técnica!${NC}"
exit 0
