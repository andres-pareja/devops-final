#!/bin/bash

REPORTE_DIR="reportes"
mkdir -p "$REPORTE_DIR"

echo "=========================================="
echo " PIPELINE DEVSECOPS - estudiante20"
echo "=========================================="

echo "[1/5] Gitleaks - buscando secretos..."
gitleaks detect --source=. -v --report-path="$REPORTE_DIR/gitleaks.json" || echo "■■ Secretos detectados"

echo "[2/5] Semgrep - análisis estático..."
PYTHONWARNINGS="ignore" semgrep scan --config=p/owasp-top-ten --json -o "$REPORTE_DIR/semgrep.json" || echo "■■ Hallazgos SAST"

echo "[3/5] Syft - inventario SBOM de la imagen..."
syft estudiante20-api:latest --output cyclonedx-json > "$REPORTE_DIR/sbom.json" || echo "■■ Error Syft"

echo "[4/5] Trivy - vulnerabilidades de la imagen..."
trivy image estudiante20-api:latest
 --severity HIGH,CRITICAL -o "$REPORTE_DIR/trivy.txt" || echo "■■ Vulnerabilidades encontradas"

echo "[5/5] Hadolint - revisión del Dockerfile..."
hadolint Dockerfile | tee "$REPORTE_DIR/hadolint.txt" || echo "■■ Advertencias en Dockerfile"

echo "=========================================="
echo " MONITOREO"
echo "=========================================="

monitorear() {
    local FECHA=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$FECHA] Iniciando monitoreo..." | tee -a monitoreo.log

    echo "--- Estado de contenedores ---" | tee -a monitoreo.log
    docker compose ps | tee -a monitoreo.log

    echo "--- Verificando /health ---" | tee -a monitoreo.log
    RESPUESTA=$(curl -s http://localhost:8020/health)
    if echo "$RESPUESTA" | grep -q "ok"; then
        echo "[$FECHA] API responde correctamente: $RESPUESTA" | tee -a monitoreo.log
    else
        echo "[$FECHA] ■■ API NO responde" | tee -a monitoreo.log
    fi

    echo "--- Últimos logs de la API ---" | tee -a monitoreo.log
    docker logs est20_api --tail 10 2>&1 | tee -a monitoreo.log

    echo "[$FECHA] Monitoreo finalizado." | tee -a monitoreo.log
}

monitorear

echo "=========================================="
echo " PIPELINE FINALIZADO"
echo "=========================================="


