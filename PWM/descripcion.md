# **Generador PWM en FPGA con Quartus y Verilog**

## **Descripción**

Este proyecto implementa un **generador de PWM (Pulse Width Modulation)** en una **FPGA DE10-Lite** utilizando **Quartus Prime** y **Verilog**. Se incluyen los módulos principales para la generación de señales PWM con ciclo de trabajo variable y su control mediante botones. También se proporciona un testbench para simulación y validación del diseño.

## **Requisitos**

- **Quartus Prime** (Intel FPGA)
- **FPGA DE10-Lite** (Intel MAX 10)
- **Cable de programación JTAG**
- **Servomotor compatible con PWM (opcional)**

## **Estructura del Proyecto**
```
/PWM_FPGA

│── pwm_2.v          # Módulo principal para generación de PWM

│── pwm_2_tb.v       # Testbench para simulación

│── pwm.qpf          # Archivo del proyecto en Quartus

│── pwm.qsf          # Archivo de configuración del FPGA

│── README.md        # Este archivo

```

## **RTL View**

![Captura de pantalla 2025-03-07 183332](https://github.com/user-attachments/assets/38ffe75f-7339-4294-8e47-866fb35bff79)


## **Funcionalidad**

✔ Generación de señales PWM con ciclo de trabajo variable.  
✔ Control del ciclo de trabajo mediante botones en la FPGA.  
✔ Simulación mediante testbench (`pwm_2_tb.v`).  

## **Implementación en FPGA**

El proyecto se implementa en la **FPGA DE10-Lite** y utiliza los siguientes pines:

| **Señal**  | **Pin FPGA** | **Descripción** |
|-----------|------------|----------------|
| PWM_OUT  | GPIO_0     | Salida de señal PWM |
| BTN_UP   | KEY0       | Aumenta el ciclo de trabajo |
| BTN_DOWN | KEY1       | Disminuye el ciclo de trabajo |

## **Simulación**
Se proporciona un testbench (`pwm_2_tb.v`) para validar la funcionalidad del módulo PWM. La simulación permite visualizar los cambios en el ciclo de trabajo de la señal PWM al presionar los botones.

## **Instrucciones para la Simulación y Síntesis**
1. Abrir Quartus Prime y cargar el archivo de proyecto `pwm.qpf`.
2. Compilar el diseño.
3. Asignar los pines correspondientes en `pwm.qsf`.
4. Ejecutar la simulación en ModelSim para validar la funcionalidad.
5. Cargar el diseño en la FPGA y verificar la señal PWM en un osciloscopio o con un servomotor.

