# Microproyecto 2 - Computacion en la Nube (AKS)

Universidad Autonoma de Occidente 

Implementacion de un cluster de Kubernetes en Azure (AKS), despliegue de una
aplicacion de clasificacion de imagenes, una aplicacion de interes, monitoreo,
y demostracion de Horizontal Pod Autoscaling.

## Estructura del repositorio

```
microproyecto2-aks-kubernetes/
├── README.md                          <- este archivo
├── 01-cluster-aks-comandos.sh         <- Punto 1: verificacion del cluster
├── 04-monitoreo-comandos.sh           <- Punto 4: supervision y monitoreo
├── clasificador-imagenes/             <- Punto 2: clasificador de imagenes
│   ├── app.py
│   ├── requirements.txt
│   ├── Dockerfile
│   ├── deployment.yaml
│   └── comandos-despliegue.sh
├── app-interes/                       <- Punto 3: app de interes (AKS demo)
│   └── comandos-despliegue.sh
└── hpa-autoscaling/                   <- Punto extra: Horizontal Autoscaling
    └── comandos-hpa.sh
```

## Resumen por punto

### 1. Cluster de Kubernetes en Azure (AKS)

Cluster creado desde el Portal de Azure (Kubernetes services > Create), con:
- Region: **Chile Central**
- Node size: **Standard_DS2_v2**
- Node count minimo: **2** (cumple el requisito de al menos 2 nodos)

Verificado desde Cloud Shell y la CLI de Azure con los comandos de
`01-cluster-aks-comandos.sh` (`az aks get-credentials` + `kubectl get nodes`).

> Nota sobre regiones y tamanos de VM: varias regiones y suscripciones de
> Azure for Students no permiten los tamanos de VM clasicos (DSv2, etc.) o
> tienen la cuota en 0 para las familias nuevas (v6/v7). Se recomienda
> verificar primero con `az vm list-skus --location <region>` y
> `az vm list-usage --location <region>` antes de crear el cluster, para
> evitar errores de "VM size not allowed" o "insufficient quota".

### 2. Clasificador de imagenes

Basado en la guia sugerida por el profesor:
https://opensource.com/article/20/9/deep-learning-model-kubernetes

Modelo `cifar_resnet20_v1` (MXNet/Gluon) servido con Flask. Reconoce 10
categorias: avion, auto, pajaro, gato, venado, perro, rana, caballo, barco,
camion.

**Cambios aplicados al codigo original (segun el enunciado):**

```python
# Antes:
net = get_model('cifar_resnet20_v1', classes=10)
net.load_parameters('net.params')

# Despues:
net = get_model('cifar_resnet20_v1', classes=10, pretrained=True)
```

```python
# Antes:
prediction = 'The input picture is classified as [%s], with probability %.3f.'%
             (class_names[ind.asscalar()], nd.softmax(pred)[0][ind].asscalar())

# Despues:
prediction = ('The input picture is classified as [%s], with probability %.3f.'%
             (class_names[ind.asscalar()], nd.softmax(pred)[0][ind].asscalar()))
```

Se usa **Azure Container Registry (ACR)** para construir y alojar la imagen
del contenedor (con `az acr build`, sin necesidad de Docker instalado
localmente). Ver `clasificador-imagenes/comandos-despliegue.sh` para el
paso a paso completo (crear ACR, construir imagen, conectar con AKS,
desplegar, exponer y probar).

Prueba de la aplicacion (una vez tenga IP publica):
```bash
curl -X POST -F img=@test1.jpg http://<EXTERNAL-IP>/predict
```

### 3. Aplicacion de interes

Se desplego la aplicacion oficial de demostracion de Microsoft para AKS
(`mcr.microsoft.com/azuredocs/aks-helloworld:v1`), que no requiere construir
ninguna imagen propia y permite verificar rapidamente que el cluster puede
desplegar y exponer aplicaciones adicionales. Ver
`app-interes/comandos-despliegue.sh`.

### 4. Supervision y monitoreo

Dos niveles de evidencia:
- **Rapida:** `kubectl top nodes` y `kubectl top pods` (usa el metrics-server
  integrado de AKS).
- **Completa:** Azure Monitor / Container Insights, activado con
  `az aks enable-addons -a monitoring`, visible en el portal en
  *Kubernetes services > [cluster] > Monitoring > Insights*.

Ver `04-monitoreo-comandos.sh`.

### Punto extra: Horizontal Autoscaling (0.5 puntos)

Se demuestra el HPA con la app oficial de ejemplo `php-apache` de
Kubernetes, generando carga artificial con un pod `busybox` y observando
como el numero de replicas escala automaticamente segun el uso de CPU.
Ver `hpa-autoscaling/comandos-hpa.sh` para el paso a paso (usa dos pestanas
del Cloud Shell: una para observar el HPA, otra para generar la carga).

## Nota importante sobre costos

Segun recomendacion del enunciado, el cluster AKS consume credito de forma
significativa. Se recomienda destruirlo despues de la sustentacion:

```bash
az aks delete --name aks-microproyecto2 --resource-group mi-practica --yes --no-wait
```
