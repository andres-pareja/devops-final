# Proyecto Final DevOps - estudiante20

API de tareas en Python (Flask) desplegada con Docker Compose en un servidor compartido.

## Tecnologías
- Python + Flask
- PostgreSQL 18
- Docker + Docker Compose

## Poner en marcha

### 1. Conexión al servidor
```bash
ssh afpareja@178.128.14.98
```

### 2. Clonar el repositorio
```bash
git clone https://github.com/TU_USUARIO/devops-final.git ~/devops-final
cd ~/devops-final
```

### 3. Configurar variables de entorno
```bash
cp .env.example .env
nano .env
```

### 4. Levantar los contenedores
```bash
docker compose up -d --build
```

### 5. Verificar que la API responde
```bash
curl http://178.128.14.98:8020/health
```

## Endpoints
| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/health` | Estado de la API |
| GET | `/tareas` | Lista las tareas |
| POST | `/tareas` | Crea una tarea |
| PUT | `/tareas/<id>` | Actualiza una tarea |
| DELETE | `/tareas/<id>` | Elimina una tarea |

## DevSecOps
```bash
./seguridad.sh
```
Ejecuta Gitleaks, Semgrep, Syft, Trivy y Hadolint. Los reportes quedan en `reportes/`.

## Monitoreo
El mismo script incluye una función que verifica el estado de la API y los contenedores, y registra el resultado en `monitoreo.log`.


## Comandos Linux utilizados

```bash
# Conexión al servidor
ssh estudiante20@178.128.14.98

# Navegación y creación de carpetas
cd ~/devops-final

# Copiar archivo de variables de entorno
cp .env.example .env

# Editar archivos
nano .env
nano docker-compose.yml
nano seguridad.sh
nano README.md

# Dar permisos de ejecución al script
chmod +x seguridad.sh

# Despliegue con Docker
docker compose up -d --build
docker compose ps
docker compose logs db

# Verificar la API
curl http://localhost:8020/health

# Ejecutar pipeline de seguridad
./seguridad.sh

# Ver reportes generados
ls -lh reportes/
cat monitoreo.log

# Git
git config user.name "Andres Pareja"
git config user.email "andres.pareja@aacesoft.com"
git add docker-compose.yml seguridad.sh README.md
git commit -m "Agrega docker-compose, script de seguridad y README"
git add -f reportes/
git commit -m "Agrega reportes de seguridad DevSecOps"
git push origin main
git log --oneline --graph
```

