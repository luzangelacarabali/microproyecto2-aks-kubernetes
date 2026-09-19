#!/bin/bash
# Comandos para desplegar el clasificador de imagenes en AKS usando ACR
# Ejecutar en Azure Cloud Shell, dentro de esta carpeta (clasificador-imagenes)

# 1. Crear el Azure Container Registry (ACR) - nombre unico global, cambia si ya existe
az acr create --resource-group mi-practica --name acrluzzamicroproyecto2 --sku Basic --admin-enabled true

# 2. Construir la imagen directamente en la nube (no necesita Docker local)
az acr build --registry acrluzzamicroproyecto2 --image kubermatic-dl:latest .

# 3. Conectar el ACR con el cluster AKS para que pueda descargar la imagen
az aks update --name aks-microproyecto2 --resource-group mi-practica --attach-acr acrluzzamicroproyecto2

# 4. IMPORTANTE: edita deployment.yaml y reemplaza TU_REGISTRO por acrluzzamicroproyecto2
#    la linea debe quedar: image: acrluzzamicroproyecto2.azurecr.io/kubermatic-dl:latest

# 5. Desplegar en el cluster
kubectl apply -f deployment.yaml

# 6. Exponer el servicio con IP publica
kubectl expose deployment kubermatic-dl-deployment --type=LoadBalancer --port 80 --target-port 5000

# 7. Ver la IP externa (puede tardar 1-2 minutos en asignarse)
kubectl get service kubermatic-dl-deployment --watch
# Presiona Ctrl+C cuando veas una IP real en EXTERNAL-IP

# 8. Descargar una imagen de prueba
curl -o test1.jpg https://raw.githubusercontent.com/dmlc/web-data/master/gluoncv/classification/plane-draw.jpeg

# 9. Probar la API (reemplaza <EXTERNAL-IP> por la IP obtenida en el paso 7)
curl -X POST -F img=@test1.jpg http://<EXTERNAL-IP>/predict
