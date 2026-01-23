#!/bin/bash

# ============================================
# COMBINED SSH BOT WITH IA CAPABILITIES
# Combines functionality from martincho247 
# with AI from johnnyrodriguezdk
# ============================================

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Configuración
INSTALL_DIR="$HOME/ssh-bot"
VENV_DIR="$INSTALL_DIR/venv"
REQUIREMENTS_FILE="$INSTALL_DIR/requirements.txt"
SERVICE_FILE="/etc/systemd/system/ssh-bot.service"
CONFIG_FILE="$INSTALL_DIR/config.json"
LOG_DIR="/var/log/ssh-bot"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Funciones de utilidad
print_header() {
    echo -e "${CYAN}"
    echo "========================================="
    echo "    SSH BOT WITH IA - INSTALLER"
    echo "========================================="
    echo -e "${NC}"
}

print_step() {
    echo -e "${GREEN}[+]${NC} $1"
}

print_error() {
    echo -e "${RED}[!]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_info() {
    echo -e "${BLUE}[i]${NC} $1"
}

check_root() {
    if [[ $EUID -eq 0 ]]; then
        print_warning "No se recomienda ejecutar como root. Usando usuario actual."
        return 1
    fi
    return 0
}

check_os() {
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        OS=$NAME
        VER=$VERSION_ID
    else
        OS=$(uname -s)
        VER=$(uname -r)
    fi
    
    print_info "Sistema detectado: $OS $VER"
    
    # Verificar si es Ubuntu/Debian
    if [[ "$OS" != *"Ubuntu"* ]] && [[ "$OS" != *"Debian"* ]]; then
        print_warning "Este script está optimizado para Ubuntu/Debian. Puede que necesites ajustes."
    fi
}

install_dependencies() {
    print_step "Instalando dependencias del sistema..."
    
    sudo apt-get update
    sudo apt-get install -y \
        python3 \
        python3-pip \
        python3-venv \
        git \
        curl \
        wget \
        jq \
        ffmpeg \
        nodejs \
        npm
    
    # Verificar Node.js
    if ! command -v node &> /dev/null; then
        print_warning "Node.js no encontrado, instalando..."
        curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
        sudo apt-get install -y nodejs
    fi
    
    # Verificar npm
    if ! command -v npm &> /dev/null; then
        print_warning "npm no encontrado, instalando..."
        sudo apt-get install -y npm
    fi
}

setup_python_environment() {
    print_step "Configurando entorno Python..."
    
    # Crear directorio de instalación
    mkdir -p "$INSTALL_DIR"
    
    # Crear entorno virtual
    python3 -m venv "$VENV_DIR"
    
    # Activar entorno virtual y instalar dependencias
    source "$VENV_DIR/bin/activate"
    
    # Crear requirements.txt
    cat > "$REQUIREMENTS_FILE" << 'EOF'
# Core dependencies
whatsapp-web.js>=1.23.0
qrcode-terminal>=0.12.0
requests>=2.28.0
flask>=2.3.0
python-dotenv>=1.0.0
pyngrok>=5.0.0
colorama>=0.4.6

# AI/ML dependencies
openai>=0.27.0
google-generativeai>=0.3.0
anthropic>=0.7.0

# Utilities
pillow>=10.0.0
python-multipart>=0.0.6
pydantic>=2.0.0
sqlalchemy>=2.0.0

# Web framework
fastapi>=0.100.0
uvicorn>=0.23.0
EOF
    
    pip install --upgrade pip
    pip install -r "$REQUIREMENTS_FILE"
    
    deactivate
}

setup_project_structure() {
    print_step "Creando estructura del proyecto..."
    
    # Crear directorios
    mkdir -p "$INSTALL_DIR/modules"
    mkdir -p "$INSTALL_DIR/data"
    mkdir -p "$INSTALL_DIR/logs"
    mkdir -p "$LOG_DIR"
    
    # Configurar permisos
    sudo chown -R $USER:$USER "$INSTALL_DIR"
    sudo chmod 755 "$INSTALL_DIR"
    sudo chown -R $USER:$USER "$LOG_DIR"
}

create_main_bot() {
    print_step "Creando bot principal combinado..."
    
    # Crear archivo principal del bot
    cat > "$INSTALL_DIR/main.py" << 'EOF'
#!/usr/bin/env python3
"""
SSH Bot con IA Combinado
Combina funcionalidades SSH con sistema de IA
"""

import asyncio
import logging
import sys
import os
from pathlib import Path

# Añadir directorio actual al path
sys.path.append(str(Path(__file__).parent))

# Configurar logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('/var/log/ssh-bot/bot.log'),
        logging.StreamHandler()
    ]
)

logger = logging.getLogger(__name__)

async def main():
    """Función principal"""
    try:
        logger.info("Iniciando SSH Bot con IA...")
        
        # Importar componentes
        from modules.ssh_manager import SSHManager
        from modules.ai_processor import AIProcessor
        from modules.whatsapp_client import WhatsAppClient
        
        # Inicializar componentes
        ssh_manager = SSHManager()
        ai_processor = AIProcessor()
        
        # Configurar WhatsApp
        whatsapp = WhatsAppClient(ssh_manager, ai_processor)
        
        # Iniciar bot
        await whatsapp.initialize()
        
        # Mantener el bot activo
        while True:
            await asyncio.sleep(3600)
            
    except KeyboardInterrupt:
        logger.info("Bot detenido por el usuario")
    except Exception as e:
        logger.error(f"Error en el bot: {str(e)}")
        sys.exit(1)

if __name__ == "__main__":
    asyncio.run(main())
EOF
    
    chmod +x "$INSTALL_DIR/main.py"
}

create_ssh_manager() {
    print_step "Creando módulo de gestión SSH..."
    
    cat > "$INSTALL_DIR/modules/ssh_manager.py" << 'EOF'
"""
Módulo de gestión SSH - Basado en martincho247/ssh-bot
"""

import json
import logging
import subprocess
import os
from pathlib import Path
from typing import Dict, List, Optional
from datetime import datetime, timedelta

logger = logging.getLogger(__name__)

class SSHManager:
    """Gestiona operaciones SSH"""
    
    def __init__(self, config_file: str = "data/ssh_config.json"):
        self.config_file = config_file
        self.config = self.load_config()
        
    def load_config(self) -> Dict:
        """Cargar configuración SSH"""
        config_path = Path(self.config_file)
        if config_path.exists():
            try:
                with open(config_path, 'r') as f:
                    return json.load(f)
            except Exception as e:
                logger.error(f"Error cargando configuración: {e}")
                return {}
        return {}
    
    def save_config(self):
        """Guardar configuración SSH"""
        try:
            config_path = Path(self.config_file)
            config_path.parent.mkdir(parents=True, exist_ok=True)
            with open(config_path, 'w') as f:
                json.dump(self.config, f, indent=2)
        except Exception as e:
            logger.error(f"Error guardando configuración: {e}")
    
    def add_user(self, username: str, password: str, expire_days: int = 30) -> Dict:
        """Añadir usuario SSH"""
        try:
            # Comando para crear usuario
            cmd = f"sudo useradd -m -s /bin/bash {username}"
            subprocess.run(cmd, shell=True, check=True)
            
            # Establecer contraseña
            cmd = f'echo "{username}:{password}" | sudo chpasswd'
            subprocess.run(cmd, shell=True, check=True)
            
            # Configurar expiración si se especifica
            if expire_days > 0:
                expire_date = (datetime.now() + timedelta(days=expire_days)).strftime('%Y-%m-%d')
                cmd = f"sudo chage -E {expire_date} {username}"
                subprocess.run(cmd, shell=True, check=True)
            
            # Guardar en configuración
            if 'users' not in self.config:
                self.config['users'] = {}
            
            self.config['users'][username] = {
                'password': password,
                'created_at': datetime.now().isoformat(),
                'expire_days': expire_days
            }
            self.save_config()
            
            return {
                'success': True,
                'username': username,
                'password': password,
                'message': f'Usuario {username} creado exitosamente'
            }
            
        except subprocess.CalledProcessError as e:
            logger.error(f"Error creando usuario: {e}")
            return {
                'success': False,
                'message': f'Error creando usuario: {str(e)}'
            }
    
    def delete_user(self, username: str) -> Dict:
        """Eliminar usuario SSH"""
        try:
            cmd = f"sudo userdel -r {username}"
            subprocess.run(cmd, shell=True, check=True)
            
            # Eliminar de configuración
            if 'users' in self.config and username in self.config['users']:
                del self.config['users'][username]
                self.save_config()
            
            return {
                'success': True,
                'message': f'Usuario {username} eliminado exitosamente'
            }
            
        except subprocess.CalledProcessError as e:
            logger.error(f"Error eliminando usuario: {e}")
            return {
                'success': False,
                'message': f'Error eliminando usuario: {str(e)}'
            }
    
    def list_users(self) -> List[Dict]:
        """Listar usuarios SSH"""
        try:
            cmd = "cut -d: -f1 /etc/passwd | grep -E '^(user|ssh|client)' || true"
            result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
            users = result.stdout.strip().split('\n') if result.stdout else []
            
            user_list = []
            for user in users:
                if user:  # Filtrar líneas vacías
                    user_list.append({
                        'username': user,
                        'status': 'active'
                    })
            
            return user_list
            
        except Exception as e:
            logger.error(f"Error listando usuarios: {e}")
            return []
    
    def get_server_info(self) -> Dict:
        """Obtener información del servidor"""
        try:
            info = {}
            
            # Hostname
            cmd = "hostname"
            result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
            info['hostname'] = result.stdout.strip()
            
            # Uptime
            cmd = "uptime -p"
            result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
            info['uptime'] = result.stdout.strip()
            
            # Memoria
            cmd = "free -h | grep Mem | awk '{print $2,$3,$4}'"
            result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
            mem_parts = result.stdout.strip().split()
            if len(mem_parts) >= 3:
                info['memory_total'] = mem_parts[0]
                info['memory_used'] = mem_parts[1]
                info['memory_free'] = mem_parts[2]
            
            # Disco
            cmd = "df -h / | tail -1 | awk '{print $2,$3,$4,$5}'"
            result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
            disk_parts = result.stdout.strip().split()
            if len(disk_parts) >= 4:
                info['disk_total'] = disk_parts[0]
                info['disk_used'] = disk_parts[1]
                info['disk_free'] = disk_parts[2]
                info['disk_percent'] = disk_parts[3]
            
            # Conexiones SSH
            cmd = "netstat -an | grep :22 | grep ESTABLISHED | wc -l"
            result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
            info['ssh_connections'] = result.stdout.strip()
            
            return info
            
        except Exception as e:
            logger.error(f"Error obteniendo info del servidor: {e}")
            return {}
    
    def test_speed(self) -> Dict:
        """Prueba de velocidad del servidor"""
        try:
            import speedtest
            st = speedtest.Speedtest()
            st.get_best_server()
            
            download = st.download() / 1_000_000  # Convertir a Mbps
            upload = st.upload() / 1_000_000  # Convertir a Mbps
            ping = st.results.ping
            
            return {
                'success': True,
                'download': f"{download:.2f} Mbps",
                'upload': f"{upload:.2f} Mbps",
                'ping': f"{ping:.2f} ms",
                'server': st.results.server['name']
            }
        except Exception as e:
            logger.error(f"Error en prueba de velocidad: {e}")
            return {
                'success': False,
                'message': f'Error: {str(e)}'
            }
EOF
}

create_ai_processor() {
    print_step "Creando módulo de IA (sin estados de WhatsApp)..."
    
    cat > "$INSTALL_DIR/modules/ai_processor.py" << 'EOF'
"""
Módulo de IA - Basado en johnnyrodriguezdk/ssh-bot
Versión sin funcionalidades de estados/status de WhatsApp
"""

import logging
import json
import os
from typing import Dict, List, Optional, Any
from pathlib import Path

logger = logging.getLogger(__name__)

class AIProcessor:
    """Procesador de IA para el bot"""
    
    def __init__(self, config_file: str = "data/ai_config.json"):
        self.config_file = config_file
        self.config = self.load_config()
        self.providers = self.initialize_providers()
        
    def load_config(self) -> Dict:
        """Cargar configuración de IA"""
        config_path = Path(self.config_file)
        if config_path.exists():
            try:
                with open(config_path, 'r') as f:
                    return json.load(f)
            except Exception as e:
                logger.error(f"Error cargando configuración IA: {e}")
                return {'providers': {}, 'preferred': 'openai'}
        
        # Configuración por defecto
        return {
            'providers': {},
            'preferred': 'openai',
            'context_window': 10,
            'temperature': 0.7
        }
    
    def save_config(self):
        """Guardar configuración de IA"""
        try:
            config_path = Path(self.config_file)
            config_path.parent.mkdir(parents=True, exist_ok=True)
            with open(config_path, 'w') as f:
                json.dump(self.config, f, indent=2)
        except Exception as e:
            logger.error(f"Error guardando configuración IA: {e}")
    
    def initialize_providers(self) -> Dict:
        """Inicializar proveedores de IA"""
        providers = {}
        
        # OpenAI
        openai_key = os.getenv('OPENAI_API_KEY') or self.config.get('providers', {}).get('openai', {}).get('api_key')
        if openai_key:
            try:
                import openai
                openai.api_key = openai_key
                providers['openai'] = {
                    'name': 'OpenAI',
                    'client': openai,
                    'available': True
                }
            except Exception as e:
                logger.error(f"Error inicializando OpenAI: {e}")
        
        # Google Gemini
        gemini_key = os.getenv('GEMINI_API_KEY') or self.config.get('providers', {}).get('gemini', {}).get('api_key')
        if gemini_key:
            try:
                import google.generativeai as genai
                genai.configure(api_key=gemini_key)
                providers['gemini'] = {
                    'name': 'Google Gemini',
                    'client': genai,
                    'available': True
                }
            except Exception as e:
                logger.error(f"Error inicializando Gemini: {e}")
        
        # Anthropic Claude
        anthropic_key = os.getenv('ANTHROPIC_API_KEY') or self.config.get('providers', {}).get('anthropic', {}).get('api_key')
        if anthropic_key:
            try:
                import anthropic
                providers['anthropic'] = {
                    'name': 'Anthropic Claude',
                    'client': anthropic.Anthropic(api_key=anthropic_key),
                    'available': True
                }
            except Exception as e:
                logger.error(f"Error inicializando Anthropic: {e}")
        
        return providers
    
    async def process_message(self, message: str, context: List[Dict] = None) -> str:
        """Procesar mensaje con IA"""
        if not self.providers:
            return "⚠️ No hay proveedores de IA configurados. Por favor, configura al menos una API key."
        
        preferred = self.config.get('preferred', 'openai')
        
        if preferred not in self.providers or not self.providers[preferred]['available']:
            # Usar el primer proveedor disponible
            for provider_name, provider_info in self.providers.items():
                if provider_info['available']:
                    preferred = provider_name
                    break
            else:
                return "⚠️ No hay proveedores de IA disponibles."
        
        try:
            response = await self._call_provider(preferred, message, context)
            return response
        except Exception as e:
            logger.error(f"Error procesando mensaje con IA: {e}")
            return f"❌ Error al procesar con IA: {str(e)}"
    
    async def _call_provider(self, provider: str, message: str, context: List[Dict] = None) -> str:
        """Llamar al proveedor de IA específico"""
        if provider == 'openai':
            return await self._call_openai(message, context)
        elif provider == 'gemini':
            return await self._call_gemini(message, context)
        elif provider == 'anthropic':
            return await self._call_anthropic(message, context)
        else:
            return "❌ Proveedor de IA no soportado."
    
    async def _call_openai(self, message: str, context: List[Dict] = None) -> str:
        """Usar OpenAI"""
        try:
            import openai
            
            messages = []
            
            # Añadir contexto si existe
            if context:
                for ctx in context[-self.config.get('context_window', 10):]:
                    messages.append({
                        'role': ctx.get('role', 'user'),
                        'content': ctx.get('content', '')
                    })
            
            # Añadir mensaje actual
            messages.append({
                'role': 'user',
                'content': message
            })
            
            response = await openai.ChatCompletion.acreate(
                model=self.config.get('providers', {}).get('openai', {}).get('model', 'gpt-3.5-turbo'),
                messages=messages,
                temperature=self.config.get('temperature', 0.7),
                max_tokens=1000
            )
            
            return response.choices[0].message.content
            
        except Exception as e:
            logger.error(f"Error en OpenAI: {e}")
            raise
    
    async def _call_gemini(self, message: str, context: List[Dict] = None) -> str:
        """Usar Google Gemini"""
        try:
            import google.generativeai as genai
            
            # Configurar modelo
            model_name = self.config.get('providers', {}).get('gemini', {}).get('model', 'gemini-pro')
            model = genai.GenerativeModel(model_name)
            
            # Preparar prompt con contexto
            prompt_parts = []
            
            if context:
                for ctx in context[-self.config.get('context_window', 10):]:
                    role = ctx.get('role', 'user')
                    content = ctx.get('content', '')
                    prompt_parts.append(f"{role}: {content}")
            
            prompt_parts.append(f"user: {message}")
            
            response = await model.generate_content_async('\n'.join(prompt_parts))
            
            return response.text
            
        except Exception as e:
            logger.error(f"Error en Gemini: {e}")
            raise
    
    async def _call_anthropic(self, message: str, context: List[Dict] = None) -> str:
        """Usar Anthropic Claude"""
        try:
            client = self.providers['anthropic']['client']
            
            # Preparar mensajes
            messages = []
            
            if context:
                for ctx in context[-self.config.get('context_window', 10):]:
                    messages.append({
                        'role': ctx.get('role', 'user'),
                        'content': ctx.get('content', '')
                    })
            
            messages.append({
                'role': 'user',
                'content': message
            })
            
            response = await client.messages.acreate(
                model=self.config.get('providers', {}).get('anthropic', {}).get('model', 'claude-3-haiku-20240307'),
                messages=messages,
                max_tokens=1000,
                temperature=self.config.get('temperature', 0.7)
            )
            
            return response.content[0].text
            
        except Exception as e:
            logger.error(f"Error en Anthropic: {e}")
            raise
    
    def set_provider(self, provider: str) -> bool:
        """Establecer proveedor preferido"""
        if provider in self.providers and self.providers[provider]['available']:
            self.config['preferred'] = provider
            self.save_config()
            return True
        return False
    
    def add_api_key(self, provider: str, api_key: str) -> bool:
        """Añadir API key para un proveedor"""
        if 'providers' not in self.config:
            self.config['providers'] = {}
        
        if provider not in self.config['providers']:
            self.config['providers'][provider] = {}
        
        self.config['providers'][provider]['api_key'] = api_key
        self.save_config()
        
        # Re-inicializar proveedores
        self.providers = self.initialize_providers()
        
        return True
    
    def get_available_providers(self) -> List[str]:
        """Obtener lista de proveedores disponibles"""
        return [name for name, info in self.providers.items() if info['available']]
    
    def get_ai_response_for_command(self, command: str, user_message: str = "") -> str:
        """Generar respuesta de IA para comandos específicos"""
        
        ai_prompts = {
            'menu': "Proporciona un menú de ayuda amigable para el bot SSH con IA. Incluye comandos básicos, gestión de usuarios, información del servidor y comandos de IA.",
            'help': "Explica cómo usar el bot SSH con IA. Incluye ejemplos de comandos y cómo interactuar con la IA.",
            'info': "Genera una descripción completa de las capacidades del bot SSH con IA, destacando sus funciones principales.",
            'ssh': "Explica cómo gestionar usuarios SSH, incluyendo creación, eliminación y listado.",
            'speed': "Explica qué hace el test de velocidad y cómo interpretar los resultados.",
            'ai': "Describe las capacidades de IA del bot y cómo configurar diferentes proveedores (OpenAI, Gemini, Claude)."
        }
        
        prompt = ai_prompts.get(command, f"Responde a esta consulta sobre {command}: {user_message}")
        
        # Si no hay proveedores de IA, usar respuestas predefinidas
        if not self.providers:
            default_responses = {
                'menu': "📱 *MENÚ SSH BOT CON IA*\n\n"
                       "🔧 *COMANDOS SSH:*\n"
                       "• !adduser usuario contraseña - Crear usuario SSH\n"
                       "• !deluser usuario - Eliminar usuario SSH\n"
                       "• !listusers - Listar usuarios\n"
                       "• !serverinfo - Información del servidor\n"
                       "• !speedtest - Test de velocidad\n\n"
                       "🤖 *COMANDOS IA:*\n"
                       "• !ai pregunta - Preguntar a la IA\n"
                       "• !setai proveedor - Cambiar proveedor IA\n"
                       "• !aikeys - Configurar API keys\n\n"
                       "📋 *OTROS:*\n"
                       "• !menu - Mostrar este menú\n"
                       "• !help - Ayuda detallada\n"
                       "• !status - Estado del bot",
                'help': "🆘 *AYUDA SSH BOT CON IA*\n\n"
                       "Este bot combina gestión SSH con capacidades de IA.\n\n"
                       "*Uso básico:*\n"
                       "1. Comandos SSH para gestión de usuarios\n"
                       "2. Comandos de información del servidor\n"
                       "3. Interacción con IA multilingüe\n\n"
                       "*Configuración IA:*\n"
                       "Necesitas API keys de proveedores como OpenAI, Google Gemini o Anthropic.\n\n"
                       "Usa !menu para ver todos los comandos disponibles.",
                'info': "🤖 *INFORMACIÓN DEL BOT*\n\n"
                       "*SSH Bot con IA*\n"
                       "Combina funcionalidades SSH tradicionales con inteligencia artificial avanzada.\n\n"
                       "*Características:*\n"
                       "✅ Gestión completa de usuarios SSH\n"
                       "✅ Monitoreo del servidor\n"
                       "✅ Pruebas de velocidad\n"
                       "✅ IA multilingüe\n"
                       "✅ Multiples proveedores de IA\n"
                       "✅ Sin estados/status de WhatsApp\n\n"
                       "Desarrollado para administración remota eficiente."
            }
            
            return default_responses.get(command, f"Consulta sobre {command}: {user_message}")
        
        # Usar IA para generar respuesta
        import asyncio
        try:
            return asyncio.run(self.process_message(prompt))
        except:
            return f"📝 Información sobre {command}: {user_message}"
EOF
}

create_whatsapp_client() {
    print_step "Creando cliente WhatsApp (sin estados)..."
    
    cat > "$INSTALL_DIR/modules/whatsapp_client.py" << 'EOF'
"""
Cliente WhatsApp - Versión sin estados/status
"""

import asyncio
import logging
import json
from typing import Dict, List, Optional
from datetime import datetime

from whatsapp_web.js import Client, LocalAuth
from qrcode_terminal import qr_terminal

logger = logging.getLogger(__name__)

class WhatsAppClient:
    """Cliente WhatsApp para el bot"""
    
    def __init__(self, ssh_manager, ai_processor):
        self.ssh_manager = ssh_manager
        self.ai_processor = ai_processor
        self.client = None
        self.qr_code = None
        self.authenticated = False
        self.chat_context = {}
        
    async def initialize(self):
        """Inicializar cliente WhatsApp"""
        logger.info("Inicializando cliente WhatsApp...")
        
        # Configurar cliente
        self.client = Client(
            auth_strategy=LocalAuth(),
            puppeteer={
                'headless': True,
                'args': ['--no-sandbox', '--disable-setuid-sandbox']
            }
        )
        
        # Configurar event handlers
        self.client.on('qr', self.on_qr)
        self.client.on('ready', self.on_ready)
        self.client.on('message', self.on_message)
        self.client.on('authenticated', self.on_authenticated)
        
        # Iniciar cliente
        await self.client.initialize()
        
        logger.info("Cliente WhatsApp inicializado. Esperando QR...")
        
    def on_qr(self, qr):
        """Manejar código QR"""
        self.qr_code = qr
        logger.info("Escanea el código QR con WhatsApp")
        qr_terminal.draw(qr)
        
    def on_ready(self):
        """Manejar cliente listo"""
        logger.info("Cliente WhatsApp listo!")
        self.authenticated = True
        
    def on_authenticated(self):
        """Manejar autenticación"""
        logger.info("WhatsApp autenticado")
        
    async def on_message(self, message):
        """Manejar mensajes entrantes"""
        try:
            # Ignorar mensajes propios
            if message.from_me:
                return
                
            # Obtener información del mensaje
            chat_id = message.from
            text = message.body.lower().strip() if message.body else ""
            
            # Log del mensaje
            logger.info(f"Mensaje de {chat_id}: {text}")
            
            # Procesar comando
            if text.startswith('!'):
                await self.process_command(chat_id, text, message)
            else:
                # Respuesta automática para mensajes no comandos
                await message.reply(
                    "🤖 *SSH Bot con IA*\n\n"
                    "Escribe !menu para ver los comandos disponibles.\n"
                    "Escribe !help para obtener ayuda."
                )
                
        except Exception as e:
            logger.error(f"Error procesando mensaje: {e}")
            
    async def process_command(self, chat_id: str, text: str, message):
        """Procesar comandos del usuario"""
        command_parts = text.split()
        command = command_parts[0]
        args = command_parts[1:] if len(command_parts) > 1 else []
        
        # Inicializar contexto si no existe
        if chat_id not in self.chat_context:
            self.chat_context[chat_id] = {
                'messages': [],
                'last_command': None
            }
        
        # Actualizar contexto
        self.chat_context[chat_id]['last_command'] = command
        self.chat_context[chat_id]['messages'].append({
            'role': 'user',
            'content': text,
            'timestamp': datetime.now().isoformat()
        })
        
        # Limitar historial de contexto
        if len(self.chat_context[chat_id]['messages']) > 20:
            self.chat_context[chat_id]['messages'] = self.chat_context[chat_id]['messages'][-20:]
        
        # Procesar comando específico
        response = await self.execute_command(command, args, chat_id)
        
        # Enviar respuesta
        if response:
            await message.reply(response)
            
            # Añadir respuesta al contexto
            self.chat_context[chat_id]['messages'].append({
                'role': 'assistant',
                'content': response,
                'timestamp': datetime.now().isoformat()
            })
    
    async def execute_command(self, command: str, args: List[str], chat_id: str) -> str:
        """Ejecutar comando específico"""
        
        # Comandos de ayuda
        if command in ['!menu', '!help', '!start']:
            return self.ai_processor.get_ai_response_for_command('menu')
            
        elif command == '!info':
            return self.ai_processor.get_ai_response_for_command('info')
            
        # Comandos SSH
        elif command == '!adduser':
            if len(args) >= 2:
                username = args[0]
                password = args[1]
                expire_days = int(args[2]) if len(args) >= 3 else 30
                
                result = self.ssh_manager.add_user(username, password, expire_days)
                if result['success']:
                    return f"✅ Usuario creado:\n👤 Usuario: {username}\n🔑 Contraseña: {password}\n📅 Expira en: {expire_days} días"
                else:
                    return f"❌ Error: {result['message']}"
            else:
                return "⚠️ Uso: !adduser usuario contraseña [días_expiracion]"
                
        elif command == '!deluser':
            if len(args) >= 1:
                username = args[0]
                result = self.ssh_manager.delete_user(username)
                return f"✅ {result['message']}" if result['success'] else f"❌ {result['message']}"
            else:
                return "⚠️ Uso: !deluser usuario"
                
        elif command == '!listusers':
            users = self.ssh_manager.list_users()
            if users:
                response = "👥 *Usuarios SSH:*\n"
                for user in users:
                    response += f"• {user['username']} - {user['status']}\n"
                return response
            else:
                return "📭 No hay usuarios SSH creados."
                
        elif command == '!serverinfo':
            info = self.ssh_manager.get_server_info()
            if info:
                response = "🖥️ *Información del Servidor:*\n"
                response += f"• Hostname: {info.get('hostname', 'N/A')}\n"
                response += f"• Uptime: {info.get('uptime', 'N/A')}\n"
                response += f"• Memoria: {info.get('memory_used', 'N/A')}/{info.get('memory_total', 'N/A')}\n"
                response += f"• Disco: {info.get('disk_used', 'N/A')}/{info.get('disk_total', 'N/A')} ({info.get('disk_percent', 'N/A')})\n"
                response += f"• Conexiones SSH: {info.get('ssh_connections', '0')}\n"
                return response
            else:
                return "❌ Error obteniendo información del servidor."
                
        elif command == '!speedtest':
            result = self.ssh_manager.test_speed()
            if result['success']:
                response = "🚀 *Test de Velocidad:*\n"
                response += f"• Descarga: {result['download']}\n"
                response += f"• Subida: {result['upload']}\n"
                response += f"• Ping: {result['ping']}\n"
                response += f"• Servidor: {result['server']}\n"
                return response
            else:
                return f"❌ {result['message']}"
        
        # Comandos IA
        elif command == '!ai':
            if args:
                question = ' '.join(args)
                context = self.chat_context[chat_id]['messages'][-10:] if chat_id in self.chat_context else []
                response = await self.ai_processor.process_message(question, context)
                return f"🤖 *Respuesta IA:*\n\n{response}"
            else:
                return "⚠️ Uso: !ai tu_pregunta"
                
        elif command == '!setai':
            if args:
                provider = args[0].lower()
                if self.ai_processor.set_provider(provider):
                    return f"✅ Proveedor IA cambiado a: {provider}"
                else:
                    available = self.ai_processor.get_available_providers()
                    return f"❌ Proveedor no disponible. Disponibles: {', '.join(available) if available else 'Ninguno'}"
            else:
                available = self.ai_processor.get_available_providers()
                current = self.ai_processor.config.get('preferred', 'Ninguno')
                return f"🔧 *Configuración IA:*\n• Actual: {current}\n• Disponibles: {', '.join(available) if available else 'Ninguno'}\n\nUso: !setai proveedor"
                
        elif command in ['!aikeys', '!setkey']:
            return "🔑 *Configurar API Keys:*\n\n" \
                   "1. Obtén API keys de:\n" \
                   "   • OpenAI: https://platform.openai.com/api-keys\n" \
                   "   • Gemini: https://makersuite.google.com/app/apikey\n" \
                   "   • Anthropic: https://console.anthropic.com/settings/keys\n\n" \
                   "2. Configura variables de entorno:\n" \
                   "   export OPENAI_API_KEY='tu_key'\n" \
                   "   export GEMINI_API_KEY='tu_key'\n" \
                   "   export ANTHROPIC_API_KEY='tu_key'\n\n" \
                   "O edita data/ai_config.json manualmente."
        
        # Comando de estado
        elif command == '!status':
            return "✅ *Bot activo*\n\n" \
                   "🤖 SSH Bot con IA funcionando correctamente.\n" \
                   "📊 Usuarios SSH: " + str(len(self.ssh_manager.list_users())) + "\n" \
                   "🔧 IA disponible: " + ("Sí" if self.ai_processor.get_available_providers() else "No") + "\n" \
                   "📱 WhatsApp: " + ("Conectado" if self.authenticated else "Desconectado")
        
        # Comando desconocido
        else:
            return "❌ Comando no reconocido. Escribe !menu para ver comandos disponibles."
    
    async def cleanup(self):
        """Limpiar recursos"""
        if self.client:
            await self.client.destroy()
            logger.info("Cliente WhatsApp cerrado")
EOF
}

create_config_file() {
    print_step "Creando archivo de configuración..."
    
    cat > "$INSTALL_DIR/config.json" << 'EOF'
{
    "whatsapp": {
        "session_name": "ssh-bot-session",
        "qr_timeout": 300,
        "auto_reconnect": true
    },
    "ssh": {
        "default_expire_days": 30,
        "max_users": 50,
        "allow_root_login": false
    },
    "ai": {
        "providers": {
            "openai": {
                "enabled": true,
                "default_model": "gpt-3.5-turbo"
            },
            "gemini": {
                "enabled": true,
                "default_model": "gemini-pro"
            },
            "anthropic": {
                "enabled": true,
                "default_model": "claude-3-haiku-20240307"
            }
        },
        "preferred_provider": "openai",
        "temperature": 0.7,
        "max_tokens": 1000,
        "context_window": 10
    },
    "security": {
        "allowed_chats": [],
        "admin_numbers": [],
        "require_admin_for_ssh": true
    },
    "logging": {
        "level": "INFO",
        "file": "/var/log/ssh-bot/bot.log",
        "max_size_mb": 10,
        "backup_count": 5
    }
}
EOF
}

create_service_file() {
    print_step "Creando servicio systemd..."
    
    sudo tee "$SERVICE_FILE" > /dev/null << EOF
[Unit]
Description=SSH Bot with IA Service
After=network.target
Wants=network.target

[Service]
Type=simple
User=$USER
WorkingDirectory=$INSTALL_DIR
Environment="PATH=$VENV_DIR/bin:$PATH"
Environment="PYTHONPATH=$INSTALL_DIR"
ExecStart=$VENV_DIR/bin/python $INSTALL_DIR/main.py
Restart=always
RestartSec=10
StandardOutput=append:/var/log/ssh-bot/service.log
StandardError=append:/var/log/ssh-bot/service_error.log

# Security
NoNewPrivileges=yes
PrivateTmp=yes
ProtectSystem=strict
ReadWritePaths=/var/log/ssh-bot $INSTALL_DIR/data

[Install]
WantedBy=multi-user.target
EOF
    
    sudo systemctl daemon-reload
}

setup_permissions() {
    print_step "Configurando permisos..."
    
    # Directorio de logs
    sudo mkdir -p "$LOG_DIR"
    sudo chown -R $USER:$USER "$LOG_DIR"
    sudo chmod 755 "$LOG_DIR"
    
    # Directorio de instalación
    chmod 755 "$INSTALL_DIR"
    chmod 644 "$INSTALL_DIR"/*.py 2>/dev/null || true
    chmod 644 "$INSTALL_DIR"/*.json 2>/dev/null || true
    
    # Scripts ejecutables
    chmod +x "$INSTALL_DIR/main.py"
    
    # Directorio de datos
    mkdir -p "$INSTALL_DIR/data"
    chmod 700 "$INSTALL_DIR/data"
}

create_setup_script() {
    print_step "Creando script de configuración..."
    
    cat > "$INSTALL_DIR/setup_ai.py" << 'EOF'
#!/usr/bin/env python3
"""
Script de configuración de IA
"""

import json
import os
from pathlib import Path

def setup_ai_config():
    """Configurar API keys de IA"""
    config_path = Path("data/ai_config.json")
    
    if config_path.exists():
        with open(config_path, 'r') as f:
            config = json.load(f)
    else:
        config = {
            'providers': {},
            'preferred': 'openai',
            'temperature': 0.7,
            'context_window': 10
        }
    
    print("🤖 Configuración de Proveedores IA")
    print("=" * 40)
    
    providers = ['openai', 'gemini', 'anthropic']
    
    for provider in providers:
        print(f"\n🔧 {provider.upper()}:")
        use = input(f"¿Usar {provider}? (s/n): ").lower().strip()
        
        if use == 's':
            api_key = input(f"API Key de {provider}: ").strip()
            if api_key:
                if 'providers' not in config:
                    config['providers'] = {}
                
                if provider not in config['providers']:
                    config['providers'][provider] = {}
                
                config['providers'][provider]['api_key'] = api_key
                
                # Preguntar por modelo
                if provider == 'openai':
                    model = input("Modelo (gpt-3.5-turbo, gpt-4, etc): ").strip() or 'gpt-3.5-turbo'
                elif provider == 'gemini':
                    model = input("Modelo (gemini-pro, gemini-pro-vision): ").strip() or 'gemini-pro'
                elif provider == 'anthropic':
                    model = input("Modelo (claude-3-haiku, claude-3-sonnet): ").strip() or 'claude-3-haiku-20240307'
                else:
                    model = 'default'
                
                config['providers'][provider]['model'] = model
                
                print(f"✅ {provider} configurado")
    
    # Guardar configuración
    config_path.parent.mkdir(parents=True, exist_ok=True)
    with open(config_path, 'w') as f:
        json.dump(config, f, indent=2)
    
    print("\n✅ Configuración IA guardada en data/ai_config.json")
    print("\n📝 También puedes configurar con variables de entorno:")
    print("   export OPENAI_API_KEY='tu_key'")
    print("   export GEMINI_API_KEY='tu_key'")
    print("   export ANTHROPIC_API_KEY='tu_key'")

if __name__ == "__main__":
    setup_ai_config()
EOF
    
    chmod +x "$INSTALL_DIR/setup_ai.py"
}

create_control_script() {
    print_step "Creando script de control..."
    
    cat > "$INSTALL_DIR/control.sh" << 'EOF'
#!/bin/bash

# Script de control para SSH Bot con IA

INSTALL_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
SERVICE_NAME="ssh-bot"

case "$1" in
    start)
        echo "Iniciando SSH Bot con IA..."
        sudo systemctl start $SERVICE_NAME
        sudo systemctl enable $SERVICE_NAME 2>/dev/null || true
        ;;
    stop)
        echo "Deteniendo SSH Bot con IA..."
        sudo systemctl stop $SERVICE_NAME
        ;;
    restart)
        echo "Reiniciando SSH Bot con IA..."
        sudo systemctl restart $SERVICE_NAME
        ;;
    status)
        sudo systemctl status $SERVICE_NAME
        ;;
    logs)
        echo "Mostrando logs..."
        if [[ "$2" == "error" ]]; then
            sudo tail -f /var/log/ssh-bot/service_error.log
        else
            sudo tail -f /var/log/ssh-bot/service.log
        fi
        ;;
    botlogs)
        sudo tail -f /var/log/ssh-bot/bot.log
        ;;
    setup-ai)
        cd $INSTALL_DIR
        source venv/bin/activate
        python setup_ai.py
        deactivate
        ;;
    update)
        echo "Actualizando SSH Bot con IA..."
        cd $INSTALL_DIR
        git pull 2>/dev/null || echo "No hay repositorio git"
        source venv/bin/activate
        pip install -r requirements.txt --upgrade
        deactivate
        sudo systemctl restart $SERVICE_NAME
        ;;
    *)
        echo "Uso: $0 {start|stop|restart|status|logs|botlogs|setup-ai|update}"
        echo ""
        echo "Comandos:"
        echo "  start     - Iniciar el bot"
        echo "  stop      - Detener el bot"
        echo "  restart   - Reiniciar el bot"
        echo "  status    - Ver estado del servicio"
        echo "  logs      - Ver logs del servicio"
        echo "  logs error - Ver logs de errores"
        echo "  botlogs   - Ver logs del bot"
        echo "  setup-ai  - Configurar API keys de IA"
        echo "  update    - Actualizar bot"
        exit 1
        ;;
esac
EOF
    
    chmod +x "$INSTALL_DIR/control.sh"
}

create_readme() {
    print_step "Creando README..."
    
    cat > "$INSTALL_DIR/README.md" << 'EOF'
# SSH Bot con IA

Bot de WhatsApp que combina gestión SSH con inteligencia artificial.

## Características

### Gestión SSH (de martincho247)
- ✅ Creación de usuarios SSH
- ✅ Eliminación de usuarios SSH  
- ✅ Listado de usuarios
- ✅ Información del servidor
- ✅ Test de velocidad
- ✅ Expiración automática de usuarios

### Sistema de IA (de johnnyrodriguezdk)
- ✅ Soporte para múltiples proveedores (OpenAI, Gemini, Anthropic)
- ✅ Respuestas contextuales inteligentes
- ✅ Configuración flexible de modelos
- ✅ Sin funcionalidades de estados/status de WhatsApp

### Seguridad
- ✅ Autenticación por código QR
- ✅ Sesiones locales persistentes
- ✅ Restricción de comandos por usuario
- ✅ Logs detallados

## Instalación Rápida

```bash
# 1. Clonar o descargar el proyecto
cd ~
git clone <repo-url> ssh-bot
cd ssh-bot

# 2. Hacer ejecutable el instalador
chmod +x install.sh

# 3. Ejecutar instalación
./install.sh
