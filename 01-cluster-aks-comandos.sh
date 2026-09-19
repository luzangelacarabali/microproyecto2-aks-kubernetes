#!/bin/bash
# Punto 1: Verificacion del cluster AKS (Cloud Shell + CLI de Azure)
# El cluster se crea desde el Portal de Azure (Kubernetes services > Create),
# usando: Region = Chile Central, Node size = Standard_DS2_v2, Node count minimo = 2
# (combinacion confirmada como viable para la suscripcion usada en este proyecto).

# 1. Ver que suscripciones tienes disponibles
az account list --query "[].{name:name, id:id}" -o table

# 2. Seleccionar la suscripcion donde esta el cluster
az account set --subscription "<ID-DE-LA-SUSCRIPCION>"

# 3. Confirmar que el cluster existe
az aks list --resource-group mi-practica -o table

# 4. Obtener las credenciales para que kubectl pueda hablar con el cluster
az aks get-credentials --resource-group mi-practica --name aks-microproyecto2 --overwrite-existing

# 5. Verificar el cluster: deben aparecer al menos 2 nodos en estado "Ready"
kubectl get nodes

# 6. (Opcional) Ver informacion general del cluster
kubectl cluster-info
