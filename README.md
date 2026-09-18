# 2RM ERP

Sistema ERP multiplataforma desarrollado para **2RM S.A.C.**, empresa del rubro metalmecánico.

El objetivo principal del sistema es permitir el seguimiento de las **Órdenes de Trabajo (OT)**, controlar el avance de producción, materiales, tareas asignadas y fechas de entrega, brindando trazabilidad durante todo el proceso de fabricación.

---

## Objetivo del proyecto

2RM ERP busca centralizar el seguimiento de las órdenes de trabajo de la empresa.

Cada OT puede visualizar:

* Porcentaje total de avance.
* Porcentaje de avance de Maestranza / Soldadura.
* Porcentaje de material recibido.
* Fecha original de entrega.
* Nueva fecha de entrega en caso de reprogramación.
* Tareas asignadas a cada usuario.
* Estado de avance de cada tarea.
* Alertas visuales para órdenes atrasadas.

El porcentaje general de una OT se calcula automáticamente en función del progreso registrado.

---

## Flujo general de una OT

El proceso inicialmente considerado es:

1. Creación y aprobación de la Orden de Trabajo.
2. Cotización y generación del pedido.
3. Preparación o carga de archivos necesarios para fabricación.
4. Gestión logística.
5. Recepción de materiales.
6. Inicio de producción.
7. Trabajo de Maestranza / Soldadura.
8. Validaciones internas.
9. Revisión por Jefatura.
10. Finalización de la OT.

Cada etapa puede estar asociada a una o varias tareas.

---

## Usuarios y roles

Actualmente el sistema contempla los siguientes usuarios:

| Usuario        | Rol           |
| -------------- | ------------- |
| Almacén        | Almacén       |
| Logística      | Logística     |
| Contabilidad   | Contabilidad  |
| Jefatura 1     | Jefatura      |
| Jefatura 2     | Jefatura      |
| Supervisor 1   | Supervisor    |
| Supervisor 2   | Supervisor    |
| Cotizaciones 1 | Cotizaciones  |
| Cotizaciones 2 | Cotizaciones  |
| Administrador  | Administrador |

Cada usuario puede visualizar y actualizar únicamente las funciones relacionadas con su rol.

---

## Permisos principales

### Administrador

Puede:

* Administrar usuarios.
* Crear usuarios.
* Activar o desactivar usuarios.
* Visualizar todas las OTs.
* Crear órdenes de trabajo.
* Crear y asignar tareas.
* Consultar el avance general del sistema.

### Jefatura 1 y Jefatura 2

Pueden:

* Visualizar todas las OTs.
* Crear órdenes de trabajo.
* Crear y asignar tareas.
* Modificar la fecha de entrega.

La fecha original no se reemplaza.

El sistema muestra:

```text
Fecha de entrega: 20/09/2026
Nueva fecha de entrega: 25/09/2026
```

### Supervisor 1 y Supervisor 2

Pueden modificar el porcentaje de:

```text
Maestranza / Soldadura
```

Los valores permitidos son:

```text
0%
25%
50%
75%
100%
```

### Almacén

Puede modificar el porcentaje de:

```text
Material recibido
```

Los valores permitidos son:

```text
0%
25%
50%
75%
100%
```

### Otros usuarios

Cada usuario puede modificar el avance de las tareas que tenga asignadas.

---

## Indicadores de cada Orden de Trabajo

Dentro del detalle de cada OT se muestran tres indicadores circulares.

### 1. Avance total

Representa el porcentaje general de la OT.

Este valor no se modifica manualmente.

Actualmente se calcula utilizando:

```text
Tareas                  40%
Maestranza / Soldadura  40%
Material recibido       20%
```

Ejemplo:

```text
Tareas:                  65%
Producción:              75%
Material recibido:       50%

65 × 0.40 = 26
75 × 0.40 = 30
50 × 0.20 = 10

Avance total = 66%
```

---

### 2. Maestranza / Soldadura

Indica el avance general del trabajo de producción.

Solo los usuarios con rol **Supervisor** pueden actualizarlo.

---

### 3. Material recibido

Indica el porcentaje de material disponible o recibido para la OT.

Solo el usuario de **Almacén** puede actualizarlo.

---

## Indicadores de color

Los porcentajes cambian progresivamente de color:

```text
0%      → Rojo
25%     → Rojo / Morado
50%     → Morado
75%     → Morado / Azul
100%    → Azul
```

El mismo comportamiento se utiliza tanto en los indicadores generales como en las tareas.

---

## Control de fechas

Cada OT contiene una fecha original de entrega.

Ejemplo:

```text
Entrega: 20/09/2026
```

Si existe una reprogramación realizada por Jefatura:

```text
Entrega: 20/09/2026
Nueva fecha de entrega: 25/09/2026
```

La fecha original permanece almacenada para conservar trazabilidad.

Para determinar si una OT se encuentra atrasada, el sistema utiliza:

```text
Nueva fecha de entrega
```

si existe.

De lo contrario utiliza:

```text
Fecha original de entrega
```

---

## Órdenes atrasadas

Cuando una OT supera su fecha de entrega y todavía no se encuentra completada, la tarjeta cambia automáticamente a un tono rojo y muestra:

```text
ATRASADA
```

Esto permite identificar rápidamente las órdenes que requieren atención.

---

## Sistema de tareas

Cada OT puede contener múltiples tareas.

Ejemplo:

```text
OT-000158

Preparar cotización
Asignado a: Cotizaciones 1
100%

Gestionar pedido
Asignado a: Cotizaciones 2
100%

Coordinar transporte
Asignado a: Logística
75%

Registrar material
Asignado a: Almacén
50%

Fabricación y soldadura
Asignado a: Supervisor 1
75%

Control de maestranza
Asignado a: Supervisor 2
50%

Validación contable
Asignado a: Contabilidad
25%

Revisión final
Asignado a: Jefatura 1
0%
```

Cada tarea posee su propio porcentaje.

Los valores disponibles son:

```text
0%
25%
50%
75%
100%
```

Cada usuario puede modificar únicamente las tareas que tenga asignadas.

---

# Tecnología utilizada

La aplicación actualmente se encuentra desarrollada con:

* Flutter
* Dart
* Material Design 3
* Shared Preferences
* File Picker

---

## Plataformas

El proyecto está diseñado para funcionar en:

* Windows
* Android
* Web
* iOS

Durante la etapa actual de desarrollo se está trabajando principalmente sobre:

```text
Windows
Android
```

---

# Persistencia actual

Actualmente la aplicación utiliza almacenamiento local mediante:

```text
shared_preferences
```

Esta implementación corresponde a la etapa de prototipo funcional.

Los datos pueden mantenerse localmente entre ejecuciones de la aplicación.

---

# Arquitectura futura

La versión productiva utilizará una arquitectura cliente-servidor.

```text
Flutter
   │
   │ HTTPS
   ▼
NestJS API
   │
   ▼
PostgreSQL
```

La base de datos estará ubicada inicialmente en un servidor local dentro de 2RM.

Arquitectura prevista:

```text
                    INTERNET
                       │
                       ▼
                Cloudflare
                       │
                       ▼
              Servidor 2RM
                       │
              ┌────────┴────────┐
              │                 │
              ▼                 ▼
          NestJS API        Archivos
              │             PDF / DXF
              ▼
          PostgreSQL
```

Esto permitirá acceder al ERP tanto dentro como fuera de la red de la empresa.

---

# Base de datos futura

Se utilizará:

```text
PostgreSQL
```

Algunas de las principales entidades previstas son:

```text
usuarios
roles
ordenes_trabajo
tareas
historial_ot
archivos_ot
clientes
materiales
recepciones
notificaciones
```

La aplicación Flutter no se conectará directamente a PostgreSQL.

Toda la comunicación se realizará mediante la API.

---

# Servidor

La arquitectura está pensada inicialmente para aproximadamente:

```text
30 usuarios concurrentes
```

El servidor local ejecutará:

```text
NestJS
PostgreSQL
Almacenamiento de archivos
```

Los dispositivos accederán al servidor mediante la API.

---

# Acceso remoto

La implementación futura contempla el uso de:

```text
Cloudflare Tunnel
```

para permitir el acceso desde:

* Red WiFi de 2RM.
* Datos móviles.
* Red doméstica.
* Laptop fuera de la empresa.
* Otros puntos con acceso a Internet.

PostgreSQL no será expuesto directamente a Internet.

---

# Estructura actual del proyecto

```text
erp_2rm/
│
├── android/
├── ios/
├── linux/
├── macos/
├── web/
├── windows/
│
├── lib/
│   └── main.dart
│
├── pubspec.yaml
├── pubspec.lock
└── README.md
```

Durante el desarrollo el proyecto podrá dividirse posteriormente en:

```text
lib/
│
├── main.dart
│
├── models/
├── screens/
├── widgets/
├── services/
├── repositories/
├── providers/
└── utils/
```

---

# Requisitos

Se necesita tener instalado:

* Flutter SDK
* Dart SDK
* Android Studio para Android
* Visual Studio con Desktop Development with C++ para Windows
* Git

Para comprobar el entorno:

```bash
flutter doctor
```

---

# Instalación

Clonar el repositorio:

```bash
git clone https://github.com/xlexandr0/2RM_ERP.git
```

Entrar al proyecto:

```bash
cd 2RM_ERP
```

Instalar dependencias:

```bash
flutter pub get
```

---

# Ejecutar en Windows

```bash
flutter run -d windows
```

---

# Ejecutar en Android

Primero comprobar dispositivos disponibles:

```bash
flutter devices
```

Para ejecutar en un emulador:

```bash
flutter run -d emulator-5554
```

El identificador puede variar dependiendo del dispositivo.

También puede ejecutarse directamente con:

```bash
flutter run
```

---

# Ejecutar en Chrome

```bash
flutter run -d chrome
```

---

# Credenciales de prueba

Todos los usuarios iniciales utilizan:

```text
Contraseña: 1234
```

Usuarios disponibles:

```text
admin
almacen
logistica
contabilidad
jefatura1
jefatura2
supervisor1
supervisor2
cotizaciones1
cotizaciones2
```

Ejemplo:

```text
Usuario: admin
Contraseña: 1234
```

---

# Estado actual

Actualmente se encuentra implementado:

* [x] Login.
* [x] Usuarios y roles.
* [x] Vista Administrador.
* [x] Dashboard.
* [x] Creación de OTs.
* [x] Listado de OTs.
* [x] Detalle de OT.
* [x] Fecha de entrega.
* [x] Nueva fecha de entrega.
* [x] Control de retrasos.
* [x] Tarjetas rojas para OTs atrasadas.
* [x] Sistema de tareas.
* [x] Asignación de tareas.
* [x] Porcentaje por tarea.
* [x] Indicador de avance total.
* [x] Indicador de Maestranza / Soldadura.
* [x] Indicador de material recibido.
* [x] Control de permisos por rol.
* [x] Persistencia local.
* [x] Soporte Windows.
* [x] Soporte Android.

---

# Próximas implementaciones

* [ ] Backend con NestJS.
* [ ] PostgreSQL.
* [ ] Autenticación JWT.
* [ ] Servidor local 2RM.
* [ ] Cloudflare Tunnel.
* [ ] Gestión de clientes.
* [ ] Historial completo de modificaciones.
* [ ] Adjuntar archivos PDF.
* [ ] Adjuntar archivos DXF.
* [ ] Notificaciones.
* [ ] Reportes de producción.
* [ ] Filtros por fecha.
* [ ] Filtros por usuario.
* [ ] Indicadores de productividad.
* [ ] Backups automáticos.
* [ ] Registro de auditoría.
* [ ] Modo offline.
* [ ] Sincronización con servidor.

---

# Proyecto académico / empresarial

Este sistema se encuentra actualmente en proceso de diseño y desarrollo para adaptarse al flujo real de trabajo de **2RM S.A.C.**

Las funcionalidades pueden modificarse conforme se definan nuevos requerimientos de las áreas involucradas.

---

## Autor

**Alexandro Alarcón Aguilar**

Proyecto:

```text
2RM ERP
Sistema multiplataforma para gestión y seguimiento de órdenes de trabajo.
```
