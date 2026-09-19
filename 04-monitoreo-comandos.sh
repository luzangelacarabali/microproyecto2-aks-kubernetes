#!/bin/bash
# Punto 4: Supervision y monitoreo en AKS

# --- Verificacion rapida (inmediata, sin esperar) ---
# Usa el metrics-server que ya viene integrado en AKS
kubectl top nodes
kubectl top pods

# --- Monitoreo completo con Azure Monitor / Container Insights ---
# (tarda unos 5-10 minutos en empezar a mostrar datos despues de activarlo)
az aks enable-addons -a monitoring --name aks-microproyecto2 --resource-group mi-practica

# Despues de activarlo, ir al portal de Azure:
# Kubernetes services > aks-microproyecto2 > Monitoring > Insights
# Ahi se ven graficas de uso de CPU, memoria y estado de nodos/pods.
# Tomar captura de esa pantalla como evidencia para la entrega.
