# Decodificador BCD en FPGA con Quartus y Verilog

 **Descripción**

Este proyecto implementa un **decodificador BCD** en una **FPGA** utilizando **Quartus Prime** y **Verilog**. Se incluyen los módulos principales para la conversión de binario a BCD y su visualización en un display de 7 segmentos. Además, se proporciona un testbench para la simulación y validación del diseño.

## Requisitos

- **Quartus Prime** (Intel FPGA)
- **FPGA compatible** (Ejemplo: Cyclone IV, MAX10)
- **Cable de programación JTAG**

## Estructura del Proyecto
/Decodificador_BCD

│── bcd_decoder.v # Módulo principal para decodificación BCD 

│── bin_a_dec.v # Conversión de binario a decimal 

│── segment7.v # Controlador para display de 7 segmentos

│── bcd_decoder_tb.v # Testbench para simulación 

│── Decodificador_BCD.qpf # Archivo del proyecto en Quartus 

│── Decodificador_BCD.qsf # Archivo de configuración del FPGA 

│── Decodificador_BCD_nativelink_simulation.rpt # Reporte de simulación 

│── README.md # Este archivo

## RTL View
![Captura de pantalla 2025-02-25 103647](https://github.com/user-attachments/assets/c0ea4f1d-29c8-48a1-83d4-ee5f4101706d)
![Captura de pantalla 2025-02-25 103754](https://github.com/user-attachments/assets/f1365628-0920-4f03-a5e1-408c197c2b56)

## Wave
![image](https://github.com/user-attachments/assets/3c60b328-ce3f-455c-adc4-2aa733eb1497)

## Funcionalidad

✔ Convierte valores binarios a BCD.  
✔ Simulación mediante testbench (`bcd_decoder_tb.v`).  
✔ Mapeo de salidas en un display de 7 segmentos.
