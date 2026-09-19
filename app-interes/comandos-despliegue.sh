#!/bin/bash
# Punto 3: Aplicacion de interes (app oficial de ejemplo de AKS, rapida de desplegar)
# Ejecutar en Azure Cloud Shell

# 1. Crear el deployment con la imagen oficial de demo de Microsoft para AKS
kubectl create deployment aks-helloworld --image=mcr.microsoft.com/azuredocs/aks-helloworld:v1

# 2. Exponerlo con IP publica
kubectl expose deployment aks-helloworld --type=LoadBalancer --port=80 --target-port=80

# 3. Ver la IP externa (puede tardar 1-2 minutos)
kubectl get service aks-helloworld --watch
# Presiona Ctrl+C cuando veas la IP en EXTERNAL-IP

# 4. Abrir esa IP en el navegador para ver la pagina de bienvenida de AKS
