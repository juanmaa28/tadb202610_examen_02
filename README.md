 # 📊 Examen 2 TABD

**Juan Manuel Arias**
**Juan Andres Ciro**

---

## 📌 Descripción del Proyecto

Este proyecto tiene como objetivo analizar la participación de diferentes continentes en rankings musicales semanales, utilizando técnicas avanzadas de consultas SQL en MySQL y PostgreSQL.

Se realiza el procesamiento de datos a partir de múltiples tablas relacionadas (artistas, canciones, rankings, nacionalidades y continentes), aplicando operaciones de agregación, joins y funciones de ventana.

---

## 🎯 Objetivos

* Calcular los puntos aportados por cada continente por semana.
* Determinar el total global de puntos semanales.
* Analizar la participación porcentual de cada continente.
* Establecer un ranking semanal basado en los puntos obtenidos.
* Evaluar el rendimiento de las consultas mediante planes de ejecución.

---

## 🛠️ Tecnologías Utilizadas

* Conector: DataGrip
* Lenguaje: SQL (MySQL y PostgreSQL)
* Herramientas: Aiven, Neon, consola

---

## 📂 Estructura del Proyecto
├── MySql/
│   ├── Scripts/
│   │   ├── Script_creacion_BD.sql
│   │   ├── Script_creacion_modelo.sql
│   │   ├── Script_migracion_datos.sql
│   │   ├── Script_consulta1.sql
│   │   └── Script_consulta2.sql
│   ├── Análisis_Consultas.pdf
│   ├── Documentacion_examen2.pdf
│   ├── resultado_consulta1.csv
│   └── resultado_consulta2.csv
│
├── PostgreSQL/
│   ├── Scripts/
│   │   ├── Script_Creacion_Base_de_Datos.sql
│   │   ├── Script_Creacion_modelo.sql
│   │   ├── Script_migracion_datos.sql
│   │   ├── Script_consulta_1.sql
│   │   └── Script_consulta_2.sql
│   ├── Análisis_Consultas.pdf
│   ├── Documentacion_examen02.pdf
│   ├── Resultado_Consulta1.csv
│   └── Resultado_Consulta2.csv
│
├── Chat con IA.pdf
└── Esquema_relacional.png
```

 🧩 Estructura de la Solución

El análisis se divide en tres etapas principales:

### 1. Cálculo de puntos por continente

Se agrupan los datos por continente y fecha, sumando los puntos obtenidos.

### 2. Cálculo de puntos globales

Se calcula el total de puntos por semana a partir de los resultados anteriores.

### 3. Análisis final

Se determina:

* Participación porcentual por continente
* Ranking semanal utilizando funciones de ventana (`RANK()`)

 ⚙️ Implementación

Se utilizaron tablas temporales para optimizar el procesamiento:

* `temp_continent_points`
* `temp_global`

Esto permite:

* Reducir el costo de recomputación
* Mejorar la claridad del análisis
* Facilitar la interpretación de resultados intermedios

---

## 📊 Resultados

El resultado final incluye:

* Nombre del continente
* Fecha del ranking
* Puntos por continente
* Puntos globales
* Porcentaje de participación
* Ranking semanal

Los resultados se exportaron en archivos `.csv` para cada motor de base de datos.

---

## 🔍 Análisis de Rendimiento

Se utilizaron comandos como:

```sql
EXPLAIN ANALYZE
```

Para identificar:

* Operaciones más costosas
* Uso de índices
* Tipos de joins
* Procesos de ordenamiento

Los análisis completos se encuentran en los archivos `Análisis_Consultas.pdf`.
---

## 👨‍💻 Autor

Juan Manuel Arias
Juan Andres Ciro

Estudiantes de Ingeniería de Sistemas
Proyecto académico – Topicos Avanzados en Bases de Datos 
