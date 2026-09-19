#!/bin/bash
# Punto extra: Horizontal Autoscaling (0.5 puntos)
# Ejecutar en Azure Cloud Shell (usar el mismo cluster AKS ya que estamos cortas de tiempo)

# --- PESTANA 1 del Cloud Shell ---

# 1. Crear un deployment de ejemplo (app php-apache oficial de Kubernetes, hecha para demostrar HPA)
kubectl create deployment php-apache --image=registry.k8s.io/hpa-example --requests=cpu=200m

# 2. Exponerlo dentro del cluster (no necesita IP publica para esta prueba)
kubectl expose deployment php-apache --port=80

# 3. Crear el Horizontal Pod Autoscaler: minimo 1 replica, maximo 5, escala si CPU pasa de 50%
kubectl autoscale deployment php-apache --cpu-percent=50 --min=1 --max=5

# 4. Verificar que el HPA se creo correctamente
kubectl get hpa php-apache

# 5. Dejar esto corriendo para observar el autoescalado en tiempo real
kubectl get hpa php-apache --watch
# (dejar corriendo mientras generas carga desde la Pestana 2)


# --- PESTANA 2 del Cloud Shell (abrir con el boton "Nueva sesion") ---

# 6. Generar carga artificial constante contra la app para forzar el autoescalado
kubectl run -i --tty load-generator --rm --image=busybox:1.28 --restart=Never -- /bin/sh -c "while sleep 0.01; do wget -q -O- http://php-apache; done"

# Deja esto corriendo 1-2 minutos. En la Pestana 1 deberias ver la columna REPLICAS
# subir de 1 a mas, a medida que sube el % de CPU (TARGETS).
# Cuando ya tengas la evidencia (captura de pantalla), presiona Ctrl+C para detener la carga.

# 7. Limpieza opcional al terminar (no es obligatorio si vas a destruir el cluster despues)
# kubectl delete deployment php-apache
# kubectl delete service php-apache
# kubectl delete hpa php-apache
