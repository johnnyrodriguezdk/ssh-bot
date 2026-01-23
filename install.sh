#!/bin/bash

# ============================================
# SSH BOT CON IA OMNIPRESENTE
# Versión mejorada con IA en todas las funcionalidades
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
USER=$(whoami)

# Funciones de utilidad
print_header() {
    clear
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║                                                          ║"
    echo "║                🤖 SSH BOT CON IA OMNIPRESENTE           ║"
    echo "║                    Instalador Completo                   ║"
    echo "║                                                          ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_step() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_success() {
    echo -e "${GREEN}✅${NC} $1"
}

check_root() {
    if [[ $EUID -eq 0 ]]; then
        print_warning "Ejecutando como root. Usando usuario: $USER"
    fi
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
    
    if [[ "$OS" != *"Ubuntu"* ]] && [[ "$OS" != *"Debian"* ]]; then
        print_warning "Este script está optimizado para Ubuntu/Debian"
    fi
}

install_dependencies() {
    print_step "Instalando dependencias del sistema..."
    
    sudo apt-get update > /dev/null 2>&1
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
        npm \
        build-essential \
        python3-dev \
        libssl-dev \
        libffi-dev \
        python3-setuptools > /dev/null 2>&1
    
    if ! command -v node &> /dev/null; then
        print_warning "Node.js no encontrado, instalando..."
        curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - > /dev/null 2>&1
        sudo apt-get install -y nodejs > /dev/null 2>&1
    fi
    
    if ! command -v npm &> /dev/null; then
        sudo apt-get install -y npm > /dev/null 2>&1
    fi
    
    print_success "Dependencias instaladas"
}

setup_python_environment() {
    print_step "Configurando entorno Python..."
    
    mkdir -p "$INSTALL_DIR"
    
    if [ ! -d "$VENV_DIR" ]; then
        python3 -m venv "$VENV_DIR"
        print_success "Entorno virtual creado"
    fi
    
    source "$VENV_DIR/bin/activate"
    
    # Requirements optimizados
    cat > "$REQUIREMENTS_FILE" << 'EOF'
# WhatsApp
whatsapp-web.js==1.24.0
qrcode-terminal==0.12.0
pywhatsapp==0.8.0

# IA Omnipresente
openai==0.28.0
google-generativeai==0.3.0
anthropic==0.7.0
transformers==4.34.0
torch==2.0.1
sentence-transformers==2.2.2

# Web y API
flask==2.3.0
flask-cors==4.0.0
fastapi==0.104.0
uvicorn[standard]==0.24.0
python-socketio==5.9.0

# Utilidades
requests==2.31.0
beautifulsoup4==4.12.0
pillow==10.0.0
pandas==2.1.1
numpy==1.24.0

# SSH y sistema
paramiko==3.3.0
fabric==3.0.0
psutil==5.9.0
speedtest-cli==2.1.3

# Base de datos
sqlalchemy==2.0.0
alembic==1.12.0

# Logging y monitoreo
loguru==0.7.2
prometheus-client==0.18.0

# Seguridad
cryptography==41.0.0
python-jose[cryptography]==3.3.0
passlib[bcrypt]==1.7.4
EOF
    
    pip install --upgrade pip > /dev/null 2>&1
    pip install -r "$REQUIREMENTS_FILE" > /dev/null 2>&1
    
    # Instalar adicionales para IA local
    pip install langchain==0.0.340 chromadb==0.4.15 > /dev/null 2>&1
    
    deactivate
    print_success "Entorno Python configurado"
}

setup_project_structure() {
    print_step "Creando estructura del proyecto..."
    
    # Directorios principales
    mkdir -p "$INSTALL_DIR"/{modules,data,logs,models,ai_cache,temp}
    mkdir -p "$INSTALL_DIR"/modules/{ssh,ai,whatsapp,utils,api}
    mkdir -p "$INSTALL_DIR"/data/{users,sessions,configs}
    mkdir -p "$LOG_DIR"
    
    # Permisos
    sudo chown -R $USER:$USER "$INSTALL_DIR" "$LOG_DIR"
    sudo chmod 755 "$INSTALL_DIR"
    sudo chmod 700 "$INSTALL_DIR/data"
    
    print_success "Estructura creada"
}

create_ssh_manager() {
    print_step "Creando módulo SSH avanzado..."
    
    cat > "$INSTALL_DIR/modules/ssh/manager.py" << 'EOF'
"""
Módulo SSH Avanzado con IA Integrada
"""
import os
import json
import logging
import subprocess
import paramiko
from pathlib import Path
from typing import Dict, List, Optional, Tuple
from datetime import datetime, timedelta
import asyncio

logger = logging.getLogger(__name__)

class SSHManagerAI:
    """Gestor SSH con IA integrada en todas las operaciones"""
    
    def __init__(self, ai_processor):
        self.config_file = "data/configs/ssh_config.json"
        self.ai = ai_processor
        self.ssh_config = self.load_config()
        
    def load_config(self) -> Dict:
        """Cargar configuración con IA"""
        config_path = Path(self.config_file)
        if config_path.exists():
            try:
                with open(config_path, 'r') as f:
                    return json.load(f)
            except Exception as e:
                logger.error(f"Error cargando configuración SSH: {e}")
        return self._get_default_config()
    
    def _get_default_config(self) -> Dict:
        """Configuración por defecto generada por IA"""
        return {
            "max_users": 100,
            "default_expire_days": 30,
            "password_policy": {
                "min_length": 8,
                "require_special": True,
                "require_numbers": True,
                "require_uppercase": True
            },
            "security": {
                "fail2ban": True,
                "max_attempts": 3,
                "lockout_time": 300
            }
        }
    
    async def add_user_with_ai(self, username: str, requirements: str = "") -> Dict:
        """Crear usuario SSH con IA generando contraseña segura"""
        try:
            # Generar contraseña segura con IA
            password_prompt = f"""
            Genera una contraseña segura para usuario SSH con estos requisitos:
            - Longitud: 12-16 caracteres
            - Incluir mayúsculas, minúsculas, números y símbolos
            - Fácil de recordar pero segura
            - No usar patrones secuenciales
            
            Requisitos adicionales: {requirements}
            """
            
            secure_password = await self.ai.generate_text(
                prompt=password_prompt,
                max_length=20,
                temperature=0.7
            )
            
            # Limpiar y formatear contraseña
            secure_password = self._clean_password(secure_password.strip())
            
            # Crear usuario
            result = await self._create_ssh_user(username, secure_password)
            
            # Generar documentación con IA
            docs = await self.ai.generate_text(
                prompt=f"Genera instrucciones claras para el usuario {username} sobre cómo conectarse por SSH",
                max_length=300
            )
            
            return {
                "success": True,
                "username": username,
                "password": secure_password,
                "instructions": docs,
                "expiry": (datetime.now() + timedelta(days=30)).strftime("%Y-%m-%d"),
                "ai_generated": True
            }
            
        except Exception as e:
            logger.error(f"Error creando usuario con IA: {e}")
            return {"success": False, "error": str(e)}
    
    async def _create_ssh_user(self, username: str, password: str) -> Dict:
        """Crear usuario en el sistema"""
        try:
            # Verificar si usuario existe
            if self._user_exists(username):
                return {"success": False, "error": "Usuario ya existe"}
            
            # Crear usuario
            commands = [
                f"sudo useradd -m -s /bin/bash {username}",
                f'echo "{username}:{password}" | sudo chpasswd',
                f"sudo chage -M 30 {username}",
                f"sudo usermod -aG ssh-users {username} 2>/dev/null || true"
            ]
            
            for cmd in commands:
                subprocess.run(cmd, shell=True, check=True)
            
            # Crear directorio .ssh
            ssh_dir = f"/home/{username}/.ssh"
            subprocess.run(f"sudo mkdir -p {ssh_dir}", shell=True)
            subprocess.run(f"sudo chown {username}:{username} {ssh_dir}", shell=True)
            subprocess.run(f"sudo chmod 700 {ssh_dir}", shell=True)
            
            return {"success": True}
            
        except subprocess.CalledProcessError as e:
            return {"success": False, "error": str(e)}
    
    async def analyze_server_with_ai(self) -> Dict:
        """Análisis completo del servidor con IA"""
        try:
            # Obtener datos del sistema
            system_data = await self._collect_system_data()
            
            # Analizar con IA
            analysis_prompt = f"""
            Analiza este servidor y proporciona:
            1. Estado de salud general
            2. Problemas detectados
            3. Recomendaciones de optimización
            4. Alertas de seguridad
            
            Datos del servidor:
            {json.dumps(system_data, indent=2)}
            
            Proporciona respuesta estructurada y práctica.
            """
            
            ai_analysis = await self.ai.generate_text(
                prompt=analysis_prompt,
                max_length=500
            )
            
            # Generar resumen ejecutivo
            summary = await self.ai.summarize_text(ai_analysis)
            
            return {
                "success": True,
                "data": system_data,
                "analysis": ai_analysis,
                "summary": summary,
                "timestamp": datetime.now().isoformat()
            }
            
        except Exception as e:
            logger.error(f"Error en análisis con IA: {e}")
            return {"success": False, "error": str(e)}
    
    async def _collect_system_data(self) -> Dict:
        """Recolectar datos del sistema"""
        data = {}
        
        try:
            # Información básica
            data["hostname"] = subprocess.getoutput("hostname")
            data["uptime"] = subprocess.getoutput("uptime -p")
            
            # CPU
            data["cpu_usage"] = subprocess.getoutput("top -bn1 | grep 'Cpu(s)' | awk '{print $2}'")
            data["cpu_cores"] = subprocess.getoutput("nproc")
            
            # Memoria
            data["memory"] = subprocess.getoutput("free -h | grep Mem | awk '{print $2,$3,$4}'")
            
            # Disco
            data["disk_usage"] = subprocess.getoutput("df -h / | tail -1")
            
            # Conexiones
            data["ssh_connections"] = subprocess.getoutput("netstat -an | grep :22 | grep ESTABLISHED | wc -l")
            data["total_connections"] = subprocess.getoutput("netstat -an | grep ESTABLISHED | wc -l")
            
            # Servicios
            data["running_services"] = subprocess.getoutput("systemctl list-units --type=service --state=running | wc -l")
            
            # Seguridad
            data["failed_logins"] = subprocess.getoutput("grep 'Failed password' /var/log/auth.log | wc -l")
            data["last_login"] = subprocess.getoutput("last -n 5")
            
        except Exception as e:
            logger.error(f"Error recolectando datos: {e}")
        
        return data
    
    async def optimize_with_ai(self, issue: str = "") -> Dict:
        """Optimización automática con IA"""
        try:
            # Diagnosticar
            diagnosis = await self._diagnose_issue(issue)
            
            # Generar solución con IA
            solution_prompt = f"""
            Problema detectado: {diagnosis}
            
            Genera solución paso a paso para servidor Linux Ubuntu/Debian.
            Incluye comandos exactos a ejecutar.
            Considera seguridad y estabilidad.
            """
            
            solution = await self.ai.generate_text(
                prompt=solution_prompt,
                max_length=400
            )
            
            # Ejecutar solución (modo seguro, solo muestra comandos)
            return {
                "success": True,
                "diagnosis": diagnosis,
                "solution": solution,
                "commands": self._extract_commands(solution),
                "warning": "Revisa los comandos antes de ejecutar manualmente"
            }
            
        except Exception as e:
            logger.error(f"Error en optimización con IA: {e}")
            return {"success": False, "error": str(e)}
    
    async def _diagnose_issue(self, issue: str) -> str:
        """Diagnosticar problema con IA"""
        if issue:
            return issue
        
        # Analizar automáticamente
        system_data = await self._collect_system_data()
        
        prompt = f"""
        Analiza estos datos de servidor y detecta problemas potenciales:
        {json.dumps(system_data, indent=2)}
        
        Identifica:
        1. Cuellos de botella de rendimiento
        2. Problemas de seguridad
        3. Configuraciones subóptimas
        4. Alertas críticas
        """
        
        return await self.ai.generate_text(prompt=prompt, max_length=300)
    
    def _extract_commands(self, text: str) -> List[str]:
        """Extraer comandos del texto generado por IA"""
        import re
        commands = re.findall(r'`(.*?)`', text)
        commands += re.findall(r'\$(.*?)\n', text)
        return [cmd.strip() for cmd in commands if cmd.strip()]
    
    def _clean_password(self, password: str) -> str:
        """Limpiar y validar contraseña generada por IA"""
        import re
        # Eliminar caracteres no imprimibles
        password = re.sub(r'[^\x20-\x7E]', '', password)
        # Asegurar longitud mínima
        if len(password) < 8:
            password += "Aa1!" + password
        # Asegurar complejidad
        if not re.search(r'[A-Z]', password):
            password += "A"
        if not re.search(r'[a-z]', password):
            password += "a"
        if not re.search(r'\d', password):
            password += "1"
        if not re.search(r'[!@#$%^&*()_+\-=\[\]{};:"\\|,.<>\/?]', password):
            password += "!"
        return password[:16]
    
    def _user_exists(self, username: str) -> bool:
        """Verificar si usuario existe"""
        try:
            subprocess.run(f"id {username}", shell=True, check=True, 
                          stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            return True
        except:
            return False
    
    async def get_ai_recommendations(self) -> List[str]:
        """Obtener recomendaciones de IA para el servidor"""
        try:
            system_data = await self._collect_system_data()
            
            prompt = f"""
            Basado en estos datos del servidor, proporciona 5 recomendaciones prácticas:
            {json.dumps(system_data, indent=2)}
            
            Formato:
            1. [Prioridad Alta/Media/Baja] [Recomendación específica]
            """
            
            recommendations = await self.ai.generate_text(
                prompt=prompt,
                max_length=400
            )
            
            return [rec.strip() for rec in recommendations.split('\n') if rec.strip()]
            
        except Exception as e:
            logger.error(f"Error obteniendo recomendaciones: {e}")
            return ["Error obteniendo recomendaciones"]
EOF
    
    print_success "Módulo SSH con IA creado"
}

create_ai_omnipresent() {
    print_step "Creando módulo de IA Omnipresente..."
    
    cat > "$INSTALL_DIR/modules/ai/core.py" << 'EOF'
"""
Núcleo de IA Omnipresente - Procesamiento avanzado en todas las funciones
"""
import os
import json
import logging
import asyncio
from pathlib import Path
from typing import Dict, List, Optional, Any, Union
from datetime import datetime
import hashlib
import pickle

logger = logging.getLogger(__name__)

class OmnipresentAI:
    """IA central que permea todas las funcionalidades del bot"""
    
    def __init__(self, config_path: str = "data/configs/ai_config.json"):
        self.config_path = Path(config_path)
        self.config = self.load_config()
        self.providers = {}
        self.local_models = {}
        self.conversation_history = {}
        self.cache_dir = Path("ai_cache")
        self.cache_dir.mkdir(exist_ok=True)
        
        # Inicializar todos los proveedores
        self._initialize_providers()
        self._load_local_models()
        
        # Sistema de aprendizaje continuo
        self.learning_data = self._load_learning_data()
        
        logger.info("IA Omnipresente inicializada")
    
    def load_config(self) -> Dict:
        """Cargar configuración de IA"""
        if self.config_path.exists():
            try:
                with open(self.config_path, 'r') as f:
                    return json.load(f)
            except Exception as e:
                logger.error(f"Error cargando configuración IA: {e}")
        
        # Configuración por defecto omnipresente
        return {
            "providers": {
                "openai": {"enabled": True, "priority": 1},
                "gemini": {"enabled": True, "priority": 2},
                "anthropic": {"enabled": True, "priority": 3},
                "local": {"enabled": True, "priority": 4}
            },
            "context_window": 20,
            "temperature": 0.7,
            "max_tokens": 1500,
            "learning_enabled": True,
            "cache_enabled": True,
            "auto_optimize": True
        }
    
    def _initialize_providers(self):
        """Inicializar todos los proveedores de IA disponibles"""
        
        # OpenAI
        openai_key = os.getenv("OPENAI_API_KEY") or self.config.get("openai_key")
        if openai_key and self.config["providers"]["openai"]["enabled"]:
            try:
                import openai
                openai.api_key = openai_key
                self.providers["openai"] = {
                    "client": openai,
                    "models": ["gpt-4", "gpt-3.5-turbo", "gpt-3.5-turbo-16k"],
                    "capabilities": ["chat", "completion", "embeddings"]
                }
                logger.info("OpenAI configurado")
            except Exception as e:
                logger.error(f"Error inicializando OpenAI: {e}")
        
        # Google Gemini
        gemini_key = os.getenv("GEMINI_API_KEY") or self.config.get("gemini_key")
        if gemini_key and self.config["providers"]["gemini"]["enabled"]:
            try:
                import google.generativeai as genai
                genai.configure(api_key=gemini_key)
                self.providers["gemini"] = {
                    "client": genai,
                    "models": ["gemini-pro", "gemini-pro-vision"],
                    "capabilities": ["generate_content", "chat", "multimodal"]
                }
                logger.info("Gemini configurado")
            except Exception as e:
                logger.error(f"Error inicializando Gemini: {e}")
        
        # Anthropic Claude
        anthropic_key = os.getenv("ANTHROPIC_API_KEY") or self.config.get("anthropic_key")
        if anthropic_key and self.config["providers"]["anthropic"]["enabled"]:
            try:
                import anthropic
                self.providers["anthropic"] = {
                    "client": anthropic.Anthropic(api_key=anthropic_key),
                    "models": ["claude-3-opus", "claude-3-sonnet", "claude-3-haiku"],
                    "capabilities": ["messages", "completions"]
                }
                logger.info("Anthropic configurado")
            except Exception as e:
                logger.error(f"Error inicializando Anthropic: {e}")
        
        # Modelos locales
        if self.config["providers"]["local"]["enabled"]:
            self._setup_local_models()
    
    def _setup_local_models(self):
        """Configurar modelos locales para operación offline"""
        try:
            from transformers import pipeline, AutoTokenizer, AutoModelForCausalLM
            
            # Modelo para conversación
            self.local_models["chat"] = pipeline(
                "text-generation",
                model="microsoft/DialoGPT-medium",
                tokenizer="microsoft/DialoGPT-medium"
            )
            
            # Modelo para clasificación
            self.local_models["classifier"] = pipeline(
                "zero-shot-classification",
                model="facebook/bart-large-mnli"
            )
            
            # Modelo para embeddings
            from sentence_transformers import SentenceTransformer
            self.local_models["embeddings"] = SentenceTransformer('all-MiniLM-L6-v2')
            
            logger.info("Modelos locales cargados")
            
        except Exception as e:
            logger.error(f"Error cargando modelos locales: {e}")
            self.local_models = {}
    
    def _load_local_models(self):
        """Cargar modelos locales desde caché"""
        model_files = list(self.cache_dir.glob("*.pkl"))
        for model_file in model_files:
            try:
                with open(model_file, 'rb') as f:
                    model_name = model_file.stem
                    self.local_models[model_name] = pickle.load(f)
            except Exception as e:
                logger.error(f"Error cargando modelo {model_file}: {e}")
    
    async def process_with_context(self, prompt: str, context_type: str = "general", 
                                  user_id: str = None, **kwargs) -> str:
        """Procesamiento inteligente con contexto omnipresente"""
        
        # Verificar caché primero
        cache_key = self._generate_cache_key(prompt, context_type, user_id)
        if self.config["cache_enabled"]:
            cached = self._get_from_cache(cache_key)
            if cached:
                logger.debug(f"Respuesta obtenida de caché: {cache_key}")
                return cached
        
        # Preparar contexto enriquecido
        enriched_prompt = await self._enrich_prompt(prompt, context_type, user_id)
        
        # Seleccionar proveedor óptimo
        provider = self._select_optimal_provider(context_type, enriched_prompt)
        
        try:
            # Procesar con proveedor seleccionado
            if provider == "openai":
                response = await self._call_openai(enriched_prompt, **kwargs)
            elif provider == "gemini":
                response = await self._call_gemini(enriched_prompt, **kwargs)
            elif provider == "anthropic":
                response = await self._call_anthropic(enriched_prompt, **kwargs)
            elif provider == "local":
                response = await self._call_local(enriched_prompt, **kwargs)
            else:
                response = "⚠️ No hay proveedores de IA disponibles"
            
            # Post-procesamiento inteligente
            processed_response = await self._post_process(response, context_type, user_id)
            
            # Guardar en caché
            if self.config["cache_enabled"]:
                self._save_to_cache(cache_key, processed_response)
            
            # Aprendizaje continuo
            if self.config["learning_enabled"] and user_id:
                await self._learn_from_interaction(prompt, processed_response, user_id, context_type)
            
            return processed_response
            
        except Exception as e:
            logger.error(f"Error procesando con IA: {e}")
            return f"❌ Error en procesamiento IA: {str(e)}"
    
    async def _enrich_prompt(self, prompt: str, context_type: str, user_id: str = None) -> str:
        """Enriquecer prompt con contexto relevante"""
        
        base_prompt = prompt
        
        # Añadir contexto histórico si existe
        if user_id and user_id in self.conversation_history:
            history = self.conversation_history[user_id][-5:]  # Últimas 5 interacciones
            if history:
                history_text = "\n".join([f"User: {h['query']}\nAI: {h['response']}" 
                                         for h in history])
                base_prompt = f"Historial de conversación:\n{history_text}\n\nNueva consulta: {prompt}"
        
        # Añadir contexto específico por tipo
        context_templates = {
            "ssh": "Eres un experto en administración de sistemas SSH. ",
            "server": "Eres un administrador de sistemas Linux experto. ",
            "security": "Eres un especialista en ciberseguridad. ",
            "technical": "Eres un ingeniero de sistemas técnico. ",
            "creative": "Eres creativo y detallado. ",
            "general": "Eres un asistente inteligente y útil. "
        }
        
        context_prefix = context_templates.get(context_type, "")
        
        # Añadir metadatos
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        metadata = f"\n\n[Contexto: {context_type}, Tiempo: {timestamp}]"
        
        return context_prefix + base_prompt + metadata
    
    def _select_optimal_provider(self, context_type: str, prompt: str) -> str:
        """Seleccionar el proveedor óptimo basado en contexto y disponibilidad"""
        
        # Priorizar proveedores configurados
        for provider_name in ["openai", "gemini", "anthropic", "local"]:
            if provider_name in self.providers:
                return provider_name
        
        # Si no hay proveedores en la nube, usar local
        if self.local_models:
            return "local"
        
        # Último recurso
        return "fallback"
    
    async def _call_openai(self, prompt: str, **kwargs) -> str:
        """Llamar a OpenAI"""
        try:
            response = await self.providers["openai"]["client"].ChatCompletion.acreate(
                model=kwargs.get("model", "gpt-3.5-turbo"),
                messages=[{"role": "user", "content": prompt}],
                temperature=kwargs.get("temperature", self.config["temperature"]),
                max_tokens=kwargs.get("max_tokens", self.config["max_tokens"])
            )
            return response.choices[0].message.content
        except Exception as e:
            logger.error(f"Error OpenAI: {e}")
            raise
    
    async def _call_gemini(self, prompt: str, **kwargs) -> str:
        """Llamar a Google Gemini"""
        try:
            model = self.providers["gemini"]["client"].GenerativeModel(
                kwargs.get("model", "gemini-pro")
            )
            response = await model.generate_content_async(prompt)
            return response.text
        except Exception as e:
            logger.error(f"Error Gemini: {e}")
            raise
    
    async def _call_anthropic(self, prompt: str, **kwargs) -> str:
        """Llamar a Anthropic Claude"""
        try:
            response = await self.providers["anthropic"]["client"].messages.acreate(
                model=kwargs.get("model", "claude-3-haiku-20240307"),
                max_tokens=kwargs.get("max_tokens", self.config["max_tokens"]),
                messages=[{"role": "user", "content": prompt}]
            )
            return response.content[0].text
        except Exception as e:
            logger.error(f"Error Anthropic: {e}")
            raise
    
    async def _call_local(self, prompt: str, **kwargs) -> str:
        """Usar modelos locales"""
        try:
            if "chat" in self.local_models:
                response = self.local_models["chat"](
                    prompt,
                    max_length=kwargs.get("max_tokens", 500),
                    temperature=kwargs.get("temperature", 0.7),
                    do_sample=True
                )[0]["generated_text"]
                return response
            else:
                return "🤖 Respuesta local: " + prompt[:200] + "..."
        except Exception as e:
            logger.error(f"Error modelo local: {e}")
            return "Modelo local no disponible"
    
    async def _post_process(self, response: str, context_type: str, user_id: str = None) -> str:
        """Post-procesamiento inteligente de respuestas"""
        
        # Limpiar respuesta
        response = response.strip()
        
        # Formatear según contexto
        if context_type in ["ssh", "server", "technical"]:
            # Añadir formato técnico
            response = self._format_technical_response(response)
        elif context_type == "creative":
            # Añadir emojis y formato amigable
            response = self._format_creative_response(response)
        
        # Validar contenido
        response = self._validate_content(response)
        
        # Añadir firma contextual
        signature = self._get_context_signature(context_type)
        if signature:
            response += f"\n\n{signature}"
        
        return response
    
    def _format_technical_response(self, text: str) -> str:
        """Formatear respuesta técnica"""
        lines = text.split('\n')
        formatted = []
        for line in lines:
            if line.strip().startswith(('•', '-', '*', '1.', '2.', '3.')):
                formatted.append(line)
            elif ':' in line and len(line.split(':')[0]) < 30:
                formatted.append(f"**{line}**")
            else:
                formatted.append(line)
        return '\n'.join(formatted)
    
    def _format_creative_response(self, text: str) -> str:
        """Formatear respuesta creativa"""
        emojis = ["✨", "🌟", "💡", "🚀", "🎯", "🔥", "💎", "🌈"]
        import random
        if random.random() > 0.7:  # 30% de probabilidad de añadir emoji
            text = random.choice(emojis) + " " + text
        return text
    
    def _validate_content(self, text: str) -> str:
        """Validar y filtrar contenido inapropiado"""
        # Lista de términos no deseados (simplificada)
        blacklist = ["contraseña es", "password is", "hack", "exploit"]
        for term in blacklist:
            if term in text.lower():
                text = text.replace(term, "[información filtrada]")
        return text
    
    def _get_context_signature(self, context_type: str) -> str:
        """Obtener firma contextual"""
        signatures = {
            "ssh": "_⚡ Generado por Asistente SSH IA_",
            "server": "_🖥️ Análisis de Sistema Automatizado_",
            "security": "_🛡️ Revisión de Seguridad_",
            "technical": "_🔧 Análisis Técnico_",
            "creative": "_🎨 Creatividad Asistida_"
        }
        return signatures.get(context_type, "_🤖 Asistente IA_")
    
    def _generate_cache_key(self, prompt: str, context_type: str, user_id: str = None) -> str:
        """Generar clave de caché única"""
        content = f"{prompt}:{context_type}:{user_id}"
        return hashlib.md5(content.encode()).hexdigest()
    
    def _get_from_cache(self, cache_key: str) -> Optional[str]:
        """Obtener respuesta de caché"""
        cache_file = self.cache_dir / f"{cache_key}.cache"
        if cache_file.exists():
            try:
                with open(cache_file, 'r', encoding='utf-8') as f:
                    data = json.load(f)
                    # Verificar expiración (24 horas)
                    if datetime.now().timestamp() - data['timestamp'] < 86400:
                        return data['response']
            except:
                pass
        return None
    
    def _save_to_cache(self, cache_key: str, response: str):
        """Guardar respuesta en caché"""
        cache_file = self.cache_dir / f"{cache_key}.cache"
        try:
            data = {
                'response': response,
                'timestamp': datetime.now().timestamp(),
                'key': cache_key
            }
            with open(cache_file, 'w', encoding='utf-8') as f:
                json.dump(data, f, ensure_ascii=False, indent=2)
        except Exception as e:
            logger.error(f"Error guardando en caché: {e}")
    
    async def _learn_from_interaction(self, query: str, response: str, user_id: str, context_type: str):
        """Aprender de la interacción para mejorar respuestas futuras"""
        if user_id not in self.learning_data:
            self.learning_data[user_id] = []
        
        learning_entry = {
            'query': query,
            'response': response,
            'context': context_type,
            'timestamp': datetime.now().isoformat(),
            'feedback': None
        }
        
        self.learning_data[user_id].append(learning_entry)
        
        # Limitar historial por usuario
        if len(self.learning_data[user_id]) > 100:
            self.learning_data[user_id] = self.learning_data[user_id][-100:]
        
        # Guardar periódicamente
        if len(self.learning_data[user_id]) % 10 == 0:
            self._save_learning_data()
    
    def _load_learning_data(self) -> Dict:
        """Cargar datos de aprendizaje"""
        learning_file = self.cache_dir / "learning_data.json"
        if learning_file.exists():
            try:
                with open(learning_file, 'r') as f:
                    return json.load(f)
            except:
                pass
        return {}
    
    def _save_learning_data(self):
        """Guardar datos de aprendizaje"""
        learning_file = self.cache_dir / "learning_data.json"
        try:
            with open(learning_file, 'w') as f:
                json.dump(self.learning_data, f, indent=2)
        except Exception as e:
            logger.error(f"Error guardando datos de aprendizaje: {e}")
    
    # Métodos de utilidad pública
    async def summarize_text(self, text: str, max_length: int = 200) -> str:
        """Resumir texto con IA"""
        prompt = f"Resume este texto en máximo {max_length} caracteres manteniendo la esencia:\n\n{text}"
        return await self.process_with_context(prompt, context_type="general")
    
    async def translate_text(self, text: str, target_lang: str = "es") -> str:
        """Traducir texto con IA"""
        prompt = f"Traduce este texto al {target_lang} manteniendo el significado original:\n\n{text}"
        return await self.process_with_context(prompt, context_type="general")
    
    async def generate_code(self, description: str, language: str = "python") -> str:
        """Generar código con IA"""
        prompt = f"Genera código {language} para: {description}\nIncluye comentarios explicativos."
        return await self.process_with_context(prompt, context_type="technical")
    
    async def analyze_sentiment(self, text: str) -> Dict:
        """Analizar sentimiento con IA"""
        prompt = f"Analiza el sentimiento de este texto y proporciona:\n1. Sentimiento (positivo/negativo/neutral)\n2. Confianza (0-100%)\n3. Razones\n\nTexto: {text}"
        response = await self.process_with_context(prompt, context_type="creative")
        
        # Parsear respuesta
        result = {
            "sentiment": "neutral",
            "confidence": 50,
            "reasons": [],
            "raw_response": response
        }
        
        # Análisis simple (en producción usar modelo especializado)
        if any(word in response.lower() for word in ["positivo", "positive", "bueno", "good"]):
            result["sentiment"] = "positive"
            result["confidence"] = 70
        elif any(word in response.lower() for word in ["negativo", "negative", "malo", "bad"]):
            result["sentiment"] = "negative"
            result["confidence"] = 70
        
        return result
    
    async def extract_entities(self, text: str) -> Dict:
        """Extraer entidades nombradas con IA"""
        prompt = f"Extrae entidades nombradas de este texto. Identifica:\n1. Personas\n2. Lugares\n3. Organizaciones\n4. Fechas\n5. Conceptos técnicos\n\nTexto: {text}"
        response = await self.process_with_context(prompt, context_type="technical")
        return self._parse_entities(response)
    
    def _parse_entities(self, text: str) -> Dict:
        """Parsear entidades de la respuesta de IA"""
        entities = {
            "persons": [],
            "places": [],
            "organizations": [],
            "dates": [],
            "concepts": []
        }
        
        lines = text.split('\n')
        current_category = None
        
        for line in lines:
            line_lower = line.lower()
            if "persona" in line_lower or "people" in line_lower:
                current_category = "persons"
            elif "lugar" in line_lower or "place" in line_lower:
                current_category = "places"
            elif "organización" in line_lower or "organization" in line_lower:
                current_category = "organizations"
            elif "fecha" in line_lower or "date" in line_lower:
                current_category = "dates"
            elif "concepto" in line_lower or "concept" in line_lower:
                current_category = "concepts"
            elif current_category and (line.startswith('- ') or line.startswith('• ') or line.startswith('* ')):
                entity = line[2:].strip()
                if entity and entity not in entities[current_category]:
                    entities[current_category].append(entity)
        
        return entities
    
    def get_provider_status(self) -> Dict:
        """Obtener estado de todos los proveedores"""
        status = {}
        for provider_name, provider_info in self.providers.items():
            status[provider_name] = {
                "enabled": True,
                "models": provider_info.get("models", []),
                "capabilities": provider_info.get("capabilities", [])
            }
        
        status["local"] = {
            "enabled": len(self.local_models) > 0,
            "models": list(self.local_models.keys()),
            "capabilities": ["chat", "classification", "embeddings"]
        }
        
        return status
    
    async def test_all_providers(self) -> Dict:
        """Probar todos los proveedores disponibles"""
        test_prompt = "Responde con 'OK' si estás funcionando correctamente."
        results = {}
        
        for provider_name in self.providers:
            try:
                start_time = datetime.now()
                if provider_name == "openai":
                    response = await self._call_openai(test_prompt, max_tokens=10)
                elif provider_name == "gemini":
                    response = await self._call_gemini(test_prompt)
                elif provider_name == "anthropic":
                    response = await self._call_anthropic(test_prompt, max_tokens=10)
                else:
                    response = "N/A"
                
                response_time = (datetime.now() - start_time).total_seconds()
                
                results[provider_name] = {
                    "status": "active" if "OK" in response else "error",
                    "response_time": response_time,
                    "response": response[:100]
                }
                
            except Exception as e:
                results[provider_name] = {
                    "status": "error",
                    "response_time": 0,
                    "error": str(e)
                }
        
        # Probar local
        if self.local_models:
            try:
                start_time = datetime.now()
                response = await self._call_local(test_prompt, max_tokens=10)
                response_time = (datetime.now() - start_time).total_seconds()
                
                results["local"] = {
                    "status": "active",
                    "response_time": response_time,
                    "response": response[:100]
                }
            except Exception as e:
                results["local"] = {
                    "status": "error",
                    "response_time": 0,
                    "error": str(e)
                }
        
        return results
EOF
    
    # Crear archivo de configuración IA
    cat > "$INSTALL_DIR/modules/ai/config.py" << 'EOF'
"""
Configuración del sistema de IA Omnipresente
"""
import json
from pathlib import Path
from typing import Dict, Any

class AIConfig:
    """Gestor de configuración de IA"""
    
    DEFAULT_CONFIG = {
        "system": {
            "name": "SSH Bot IA Omnipresente",
            "version": "2.0.0",
            "mode": "enhanced"
        },
        "providers": {
            "openai": {
                "enabled": True,
                "api_key": "",
                "default_model": "gpt-3.5-turbo",
                "fallback_model": "gpt-3.5-turbo",
                "max_tokens": 2000,
                "temperature": 0.7
            },
            "gemini": {
                "enabled": True,
                "api_key": "",
                "default_model": "gemini-pro",
                "max_tokens": 2048,
                "temperature": 0.7
            },
            "anthropic": {
                "enabled": True,
                "api_key": "",
                "default_model": "claude-3-haiku-20240307",
                "max_tokens": 4000,
                "temperature": 0.7
            },
            "local": {
                "enabled": True,
                "models_dir": "models/local",
                "default_model": "dialoGPT-medium"
            }
        },
        "features": {
            "context_aware": True,
            "learning_enabled": True,
            "cache_enabled": True,
            "auto_fallback": True,
            "multi_language": True,
            "sentiment_analysis": True,
            "code_generation": True,
            "security_scan": True
        },
        "optimization": {
            "response_timeout": 30,
            "cache_ttl": 3600,
            "max_context_length": 4000,
            "compression_enabled": True
        },
        "security": {
            "content_filter": True,
            "rate_limiting": True,
            "max_requests_per_minute": 60,
            "blacklist_enabled": True
        }
    }
    
    def __init__(self, config_path: str = "data/configs/ai_system.json"):
        self.config_path = Path(config_path)
        self.config = self.load_or_create_config()
    
    def load_or_create_config(self) -> Dict[str, Any]:
        """Cargar o crear configuración"""
        if self.config_path.exists():
            try:
                with open(self.config_path, 'r', encoding='utf-8') as f:
                    loaded_config = json.load(f)
                    return self.merge_configs(self.DEFAULT_CONFIG, loaded_config)
            except Exception as e:
                print(f"Error cargando configuración: {e}")
        
        # Crear directorio si no existe
        self.config_path.parent.mkdir(parents=True, exist_ok=True)
        
        # Guardar configuración por defecto
        self.save_config(self.DEFAULT_CONFIG)
        return self.DEFAULT_CONFIG
    
    def merge_configs(self, default: Dict, custom: Dict) -> Dict:
        """Fusionar configuraciones"""
        merged = default.copy()
        
        def recursive_merge(base, update):
            for key, value in update.items():
                if key in base and isinstance(base[key], dict) and isinstance(value, dict):
                    recursive_merge(base[key], value)
                else:
                    base[key] = value
        
        recursive_merge(merged, custom)
        return merged
    
    def save_config(self, config: Dict = None):
        """Guardar configuración"""
        if config is None:
            config = self.config
        
        try:
            with open(self.config_path, 'w', encoding='utf-8') as f:
                json.dump(config, f, indent=2, ensure_ascii=False)
        except Exception as e:
            print(f"Error guardando configuración: {e}")
    
    def update_provider_key(self, provider: str, api_key: str):
        """Actualizar API key de proveedor"""
        if provider in self.config["providers"]:
            self.config["providers"][provider]["api_key"] = api_key
            self.save_config()
            return True
        return False
    
    def enable_feature(self, feature: str, enabled: bool = True):
        """Habilitar/deshabilitar característica"""
        if feature in self.config["features"]:
            self.config["features"][feature] = enabled
            self.save_config()
            return True
        return False
    
    def get_enabled_providers(self) -> list:
        """Obtener proveedores habilitados"""
        return [name for name, config in self.config["providers"].items() 
                if config.get("enabled", False)]
    
    def get_provider_config(self, provider: str) -> Dict:
        """Obtener configuración de proveedor específico"""
        return self.config["providers"].get(provider, {})
    
    def get_feature_status(self, feature: str) -> bool:
        """Obtener estado de característica"""
        return self.config["features"].get(feature, False)
    
    def to_dict(self) -> Dict:
        """Convertir configuración a dict"""
        return self.config.copy()
EOF
    
    print_success "Módulo de IA Omnipresente creado"
}

create_whatsapp_ai_bot() {
    print_step "Creando bot WhatsApp con IA integrada..."
    
    cat > "$INSTALL_DIR/modules/whatsapp/bot.py" << 'EOF'
"""
Bot WhatsApp con IA Omnipresente Integrada
"""
import asyncio
import logging
import json
from datetime import datetime
from typing import Dict, List, Optional, Any
from pathlib import Path

from whatsapp_web.js import Client, LocalAuth, Message
from qrcode_terminal import qr_terminal

logger = logging.getLogger(__name__)

class WhatsAppAIBot:
    """Bot de WhatsApp con IA integrada en todas las interacciones"""
    
    def __init__(self, ssh_manager, ai_core):
        self.ssh = ssh_manager
        self.ai = ai_core
        self.client = None
        self.sessions = {}
        self.user_profiles = self._load_user_profiles()
        
        # Configuración
        self.config = {
            "session_timeout": 3600,
            "max_history": 50,
            "auto_learn": True,
            "personalized_responses": True
        }
    
    def _load_user_profiles(self) -> Dict:
        """Cargar perfiles de usuario"""
        profiles_file = Path("data/users/profiles.json")
        if profiles_file.exists():
            try:
                with open(profiles_file, 'r') as f:
                    return json.load(f)
            except:
                pass
        return {}
    
    def _save_user_profiles(self):
        """Guardar perfiles de usuario"""
        profiles_file = Path("data/users/profiles.json")
        profiles_file.parent.mkdir(parents=True, exist_ok=True)
        try:
            with open(profiles_file, 'w') as f:
                json.dump(self.user_profiles, f, indent=2)
        except Exception as e:
            logger.error(f"Error guardando perfiles: {e}")
    
    async def initialize(self):
        """Inicializar bot WhatsApp"""
        logger.info("🚀 Inicializando WhatsApp Bot con IA...")
        
        # Configurar cliente
        self.client = Client(
            auth_strategy=LocalAuth(persistence=True),
            puppeteer={
                'headless': True,
                'args': [
                    '--no-sandbox',
                    '--disable-setuid-sandbox',
                    '--disable-dev-shm-usage',
                    '--disable-accelerated-2d-canvas',
                    '--no-first-run',
                    '--no-zygote',
                    '--disable-gpu'
                ]
            },
            qr_timeout=300
        )
        
        # Configurar eventos
        self.client.on('qr', self._on_qr)
        self.client.on('ready', self._on_ready)
        self.client.on('message', self._on_message)
        self.client.on('authenticated', self._on_authenticated)
        self.client.on('disconnected', self._on_disconnected)
        
        # Iniciar
        await self.client.initialize()
        logger.info("✅ WhatsApp Bot inicializado. Esperando QR...")
    
    def _on_qr(self, qr):
        """Manejar código QR"""
        logger.info("📱 Escanea este código QR con WhatsApp:")
        qr_terminal.draw(qr)
        print("\n" + "="*50)
        print("📱 Abre WhatsApp > Ajustes > Dispositivos vinculados")
        print("📱 Escanea el código QR arriba")
        print("="*50 + "\n")
    
    def _on_ready(self):
        """Manejador de cliente listo"""
        logger.info("✅ WhatsApp conectado y listo!")
        print("\n" + "="*50)
        print("🤖 BOT ACTIVO - SSH con IA Omnipresente")
        print("="*50 + "\n")
    
    def _on_authenticated(self):
        """Manejador de autenticación"""
        logger.info("🔑 WhatsApp autenticado")
    
    def _on_disconnected(self, reason):
        """Manejador de desconexión"""
        logger.warning(f"⚠️ WhatsApp desconectado: {reason}")
    
    async def _on_message(self, message: Message):
        """Manejador de mensajes con IA"""
        try:
            # Ignorar mensajes propios
            if message.from_me:
                return
            
            # Obtener información del mensaje
            chat_id = message.from
            user_id = message.author or chat_id
            text = message.body or ""
            
            logger.info(f"📨 Mensaje de {user_id}: {text[:100]}...")
            
            # Procesar con IA
            response = await self._process_message_with_ai(user_id, text, message)
            
            # Enviar respuesta
            if response:
                await message.reply(response)
                logger.info(f"✅ Respondido a {user_id}")
            
        except Exception as e:
            logger.error(f"❌ Error procesando mensaje: {e}")
            try:
                await message.reply("⚠️ Ocurrió un error al procesar tu mensaje.")
            except:
                pass
    
    async def _process_message_with_ai(self, user_id: str, text: str, message: Message) -> str:
        """Procesar mensaje con IA omnipresente"""
        
        # Actualizar perfil de usuario
        await self._update_user_profile(user_id, text)
        
        # Detectar intención con IA
        intent = await self._detect_intent_with_ai(text, user_id)
        
        # Procesar según intención
        if intent == "ssh_management":
            return await self._handle_ssh_command(text, user_id)
        
        elif intent == "server_info":
            return await self._handle_server_command(text, user_id)
        
        elif intent == "ai_chat":
            return await self._handle_ai_chat(text, user_id)
        
        elif intent == "help":
            return await self._generate_help_response(user_id)
        
        elif intent == "system":
            return await self._handle_system_command(text, user_id)
        
        else:
            # Respuesta inteligente por defecto
            return await self._generate_intelligent_response(text, user_id)
    
    async def _detect_intent_with_ai(self, text: str, user_id: str) -> str:
        """Detectar intención usando IA"""
        
        prompt = f"""
        Analiza esta conversación y clasifica la intención:
        
        Mensaje: "{text}"
        
        Opciones:
        1. ssh_management - Comandos SSH (crear/eliminar usuarios, etc.)
        2. server_info - Información del servidor (estado, recursos, etc.)
        3. ai_chat - Conversación general con IA
        4. help - Solicitud de ayuda o menú
        5. system - Comandos del sistema o configuración
        
        Responde solo con la palabra clave de la intención.
        """
        
        try:
            response = await self.ai.process_with_context(
                prompt=prompt,
                context_type="technical",
                user_id=user_id,
                max_tokens=50
            )
            
            # Limpiar y validar respuesta
            intent = response.strip().lower()
            valid_intents = ["ssh_management", "server_info", "ai_chat", "help", "system"]
            
            if intent in valid_intents:
                return intent
            else:
                # Buscar palabras clave
                text_lower = text.lower()
                if any(word in text_lower for word in ["ssh", "usuario", "user", "crear", "eliminar"]):
                    return "ssh_management"
                elif any(word in text_lower for word in ["servidor", "server", "estado", "info", "memoria"]):
                    return "server_info"
                elif any(word in text_lower for word in ["hola", "ai", "pregunta", "qué", "cómo"]):
                    return "ai_chat"
                elif any(word in text_lower for word in ["ayuda", "help", "menú", "menu", "comandos"]):
                    return "help"
                else:
                    return "ai_chat"
                    
        except Exception as e:
            logger.error(f"Error detectando intención: {e}")
            return "ai_chat"
    
    async def _handle_ssh_command(self, text: str, user_id: str) -> str:
        """Manejar comandos SSH con IA"""
        
        text_lower = text.lower()
        
        # Comando específico: crear usuario
        if any(word in text_lower for word in ["crear usuario", "adduser", "nuevo usuario"]):
            # Extraer parámetros con IA
            params = await self._extract_ssh_params(text)
            
            if "username" in params:
                result = await self.ssh.add_user_with_ai(
                    username=params["username"],
                    requirements=params.get("requirements", "")
                )
                
                if result["success"]:
                    return f"""✅ *Usuario SSH Creado con IA*
                    
👤 *Usuario:* `{result["username"]}`
🔑 *Contraseña:* `{result["password"]}`
📅 *Expira:* {result["expiry"]}
💡 *Consejo IA:* {result["instructions"][:200]}...
                    
⚠️ Guarda esta información de forma segura."""
                else:
                    return f"❌ Error: {result.get('error', 'Desconocido')}"
            else:
                return "⚠️ Especifica un nombre de usuario. Ejemplo: 'crear usuario juan'"
        
        # Comando: listar usuarios
        elif any(word in text_lower for word in ["listar usuarios", "ver usuarios", "usuarios ssh"]):
            # Usar SSH manager tradicional para listar
            users = self.ssh.list_users()
            if users:
                user_list = "\n".join([f"• {user}" for user in users])
                return f"""👥 *Usuarios SSH Activos*
                
{user_list}
                
💡 *Recomendación IA:* Revisa periódicamente usuarios activos."""
            else:
                return "📭 No hay usuarios SSH creados."
        
        # Comando: eliminar usuario
        elif any(word in text_lower for word in ["eliminar usuario", "borrar usuario", "deluser"]):
            params = await self._extract_ssh_params(text)
            if "username" in params:
                result = self.ssh.delete_user(params["username"])
                if result["success"]:
                    return f"✅ Usuario `{params['username']}` eliminado"
                else:
                    return f"❌ Error: {result.get('error', 'Desconocido')}"
            else:
                return "⚠️ Especifica el usuario a eliminar. Ejemplo: 'eliminar usuario juan'"
        
        # Comando SSH genérico
        else:
            # Explicar SSH con IA
            explanation = await self.ai.process_with_context(
                prompt=f"Explica brevemente qué es SSH y sus comandos básicos",
                context_type="ssh",
                user_id=user_id
            )
            
            return f"""🔐 *Gestión SSH con IA*
            
{explanation}

*Comandos disponibles:*
• `crear usuario [nombre]` - Crear usuario SSH
• `listar usuarios` - Ver usuarios activos
• `eliminar usuario [nombre]` - Eliminar usuario
• `ayuda ssh` - Más información"""
    
    async def _extract_ssh_params(self, text: str) -> Dict:
        """Extraer parámetros SSH del texto usando IA"""
        prompt = f"""
        Extrae parámetros SSH de este mensaje:
        
        "{text}"
        
        Busca:
        1. username - nombre de usuario
        2. requirements - requisitos especiales mencionados
        3. days - días de expiración si se menciona
        
        Responde en formato JSON.
        """
        
        try:
            response = await self.ai.process_with_context(
                prompt=prompt,
                context_type="technical",
                max_tokens=200
            )
            
            # Intentar parsear JSON
            import re
            json_match = re.search(r'\{.*\}', response, re.DOTALL)
            if json_match:
                return json.loads(json_match.group())
            
        except Exception as e:
            logger.error(f"Error extrayendo parámetros: {e}")
        
        return {}
    
    async def _handle_server_command(self, text: str, user_id: str) -> str:
        """Manejar comandos del servidor con IA"""
        
        text_lower = text.lower()
        
        # Análisis completo del servidor
        if any(word in text_lower for word in ["análisis servidor", "server analysis", "estado completo"]):
            result = await self.ssh.analyze_server_with_ai()
            
            if result["success"]:
                return f"""🖥️ *Análisis de Servidor con IA*
                
📊 *Resumen:* {result["summary"]}
                
🔍 *Análisis Detallado:*
{result["analysis"][:500]}...
                
⏰ *Actualizado:* {result["timestamp"]}"""
            else:
                return f"❌ Error en análisis: {result.get('error', 'Desconocido')}"
        
        # Información básica
        elif any(word in text_lower for word in ["info servidor", "server info", "estado"]):
            info = await self.ssh._collect_system_data()
            
            if info:
                response = "🖥️ *Información del Servidor*\n\n"
                for key, value in info.items():
                    response += f"• *{key}:* {value}\n"
                
                # Añadir recomendación IA
                recs = await self.ssh.get_ai_recommendations()
                if recs:
                    response += "\n💡 *Recomendaciones IA:*\n"
                    for i, rec in enumerate(recs[:3], 1):
                        response += f"{i}. {rec}\n"
                
                return response
            else:
                return "⚠️ No se pudo obtener información del servidor"
        
        # Optimización
        elif any(word in text_lower for word in ["optimizar", "mejorar", "problema"]):
            issue = text_lower
            result = await self.ssh.optimize_with_ai(issue)
            
            if result["success"]:
                return f"""🔧 *Optimización con IA*
                
📋 *Diagnóstico:* {result["diagnosis"][:200]}...
                
🛠️ *Solución Propuesta:*
{result["solution"][:400]}...
                
⚠️ {result["warning"]}"""
            else:
                return f"❌ Error en optimización: {result.get('error', 'Desconocido')}"
        
        # Comando genérico
        else:
            explanation = await self.ai.process_with_context(
                prompt="Explica brevemente cómo monitorear y optimizar un servidor Linux",
                context_type="server",
                user_id=user_id
            )
            
            return f"""📊 *Monitoreo de Servidor*
            
{explanation}

*Comandos disponibles:*
• `info servidor` - Información básica
• `análisis servidor` - Análisis completo con IA
• `optimizar [problema]` - Solucionar problemas
• `ayuda servidor` - Más información"""
    
    async def _handle_ai_chat(self, text: str, user_id: str) -> str:
        """Manejar conversación con IA"""
        
        # Saludo inicial
        if any(word in text.lower() for word in ["hola", "hi", "hello", "buenos días"]):
            greeting = await self._generate_personalized_greeting(user_id)
            return greeting
        
        # Pregunta específica
        response = await self.ai.process_with_context(
            prompt=text,
            context_type="general",
            user_id=user_id,
            max_tokens=500
        )
        
        return f"""🤖 *Asistente IA*
        
{response}

_💡 Puedes preguntarme sobre SSH, servidores, o cualquier otro tema._"""
    
    async def _generate_personalized_greeting(self, user_id: str) -> str:
        """Generar saludo personalizado con IA"""
        
        profile = self.user_profiles.get(user_id, {})
        name = profile.get("name", "usuario")
        last_seen = profile.get("last_seen")
        
        prompt = f"""
        Genera un saludo amigable y personalizado para {name}.
        Incluye emojis relevantes y mantén un tono profesional pero cálido.
        """
        
        greeting = await self.ai.process_with_context(
            prompt=prompt,
            context_type="creative",
            user_id=user_id
        )
        
        return f"""👋 {greeting}

Soy tu *Asistente SSH con IA Omnipresente* 🤖

Puedo ayudarte con:
🔐 Gestión de usuarios SSH
🖥️ Monitoreo del servidor
🔧 Optimización del sistema
💬 Cualquier pregunta que tengas

Escribe *!menu* para ver todos los comandos."""
    
    async def _generate_help_response(self, user_id: str) -> str:
        """Generar respuesta de ayuda con IA"""
        
        prompt = """
        Genera un menú de ayuda para un bot de WhatsApp que maneja:
        1. Gestión SSH (crear/eliminar usuarios)
        2. Monitoreo de servidor
        3. Asistente IA general
        4. Optimización del sistema
        
        Formato: Emojis, títulos claros, comandos en `código`.
        """
        
        menu = await self.ai.process_with_context(
            prompt=prompt,
            context_type="creative",
            user_id=user_id
        )
        
        return f"""📱 *MENÚ PRINCIPAL - SSH Bot IA*
        
{menu}

*📚 Comandos rápidos:*
• `hola` - Saludar al bot
• `crear usuario [nombre]` - Crear usuario SSH
• `info servidor` - Ver estado del servidor
• `pregunta [tu pregunta]` - Consultar a la IA

💡 *Consejo:* Puedes hablar naturalmente, la IA entenderá tu intención."""
    
    async def _handle_system_command(self, text: str, user_id: str) -> str:
        """Manejar comandos del sistema"""
        
        text_lower = text.lower()
        
        # Estado del bot
        if any(word in text_lower for word in ["estado bot", "bot status", "status"]):
            bot_status = await self._get_bot_status()
            return bot_status
        
        # Configuración IA
        elif any(word in text_lower for word in ["configurar ia", "setup ai", "api keys"]):
            return await self._get_ai_config_info()
        
        # Reiniciar
        elif any(word in text_lower for word in ["reiniciar", "restart"]):
            return "⚠️ Comando de reinicio detectado. Usa `!reiniciar` para confirmar."
        
        # Comando desconocido
        else:
            return "⚠️ Comando del sistema no reconocido. Usa `!menu` para ver opciones."
    
    async def _get_bot_status(self) -> str:
        """Obtener estado del bot"""
        
        # Verificar conexión WhatsApp
        whatsapp_status = "✅ Conectado" if self.client else "❌ Desconectado"
        
        # Verificar IA
        ai_status = await self.ai.test_all_providers()
        active_providers = sum(1 for p in ai_status.values() if p.get("status") == "active")
        
        # Verificar SSH
        ssh_users = len(self.ssh.list_users())
        
        return f"""🤖 *ESTADO DEL BOT*
        
📱 *WhatsApp:* {whatsapp_status}
🤖 *IA Activa:* {active_providers} proveedores
👥 *Usuarios SSH:* {ssh_users}
⏰ *Tiempo activo:* {datetime.now().strftime('%H:%M:%S')}

💡 *Recomendación:* Todo funciona correctamente."""
    
    async def _get_ai_config_info(self) -> str:
        """Obtener información de configuración IA"""
        
        providers = self.ai.get_provider_status()
        enabled = [p for p, s in providers.items() if s.get("enabled")]
        
        return f"""🔧 *CONFIGURACIÓN IA*
        
*Proveedores activos:* {', '.join(enabled) if enabled else 'Ninguno'}

*Configurar API Keys:*
1. Obtén keys de:
   • OpenAI: https://platform.openai.com/api-keys
   • Gemini: https://makersuite.google.com/app/apikey
   • Anthropic: https://console.anthropic.com/settings/keys

2. Ejecuta:
   ```bash
   export OPENAI_API_KEY='tu_key'
   export GEMINI_API_KEY='tu_key'
   export ANTHROPIC_API_KEY='tu_key'
