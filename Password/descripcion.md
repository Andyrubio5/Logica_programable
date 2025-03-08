# **Sistema de Verificación de Contraseña en FPGA con Quartus y Verilog**

## **Descripción**

Este proyecto implementa un **sistema de verificación de contraseña** en una **FPGA DE10-Lite** utilizando **Quartus Prime** y **Verilog**. Se incluyen los módulos principales para la entrada de una contraseña mediante switches, validación de la contraseña almacenada y salida de un estado de acceso permitido o denegado. También se proporciona un testbench para la simulación y validación del diseño.

## **Requisitos**

- **Quartus Prime** (Intel FPGA)
- **FPGA DE10-Lite** (Intel MAX 10)
- **Cable de programación JTAG**
- **Conjunto de switches o teclado matricial (opcional)**

## **Estructura del Proyecto**
```
/Password_System

│── password.v        # Módulo principal para la verificación de contraseña

│── clk_div.v         # Divisor de reloj para el control del sistema

│── oneshot.v         # Generador de un solo pulso para la entrada

│── password_tb.v     # Testbench para simulación

│── password.qpf      # Archivo del proyecto en Quartus

│── password.qsf      # Archivo de configuración del FPGA

│── README.md         # Este archivo

```

## **RTL View**
![image](https://github.com/user-attachments/assets/a8d0ba39-f562-4e54-8ae8-8c3f8761d8be)
![image](https://github.com/user-attachments/assets/04ae7dec-1799-405f-9aa2-d7025589ca0a)


## **Funcionalidad**

✔ Entrada de contraseña mediante switches o señales digitales.  
✔ Comparación con una contraseña almacenada en el sistema.  
✔ Indicación de acceso permitido o denegado a través de LEDs.  
✔ Simulación mediante testbench (`password_tb.v`).  

## **Implementación en FPGA**

El proyecto se implementa en la **FPGA DE10-Lite** y utiliza los siguientes pines:

| **Señal**      | **Pin FPGA** | **Descripción** |
|---------------|-------------|----------------|
| SWITCH_IN    | GPIO_0-7     | Entrada de la contraseña |
| LED_OUT      | GPIO_8-9     | Indicación de acceso |
| CLK          | CLK_FPGA     | Reloj del sistema |

## **Simulación**
Se proporciona un testbench (`password_tb.v`) para validar la funcionalidad del sistema. La simulación permite visualizar el ingreso de la contraseña y la comparación con la clave almacenada.

