
# Implementación de Contadores y Decodificadores BCD en FPGA con Quartus y Verilog

**Descripción**  

Este proyecto implementa **contadores y decodificadores BCD** en una **FPGA** utilizando **Quartus Prime** y **Verilog**. Se incluyen los módulos principales para la generación de señales de reloj, conteo en binario y conversión a BCD, así como la visualización de los valores en un **display de 7 segmentos**. Además, se proporciona un **testbench** para la simulación y validación del diseño.

## Requisitos  

- **Quartus Prime** (Intel FPGA)  
- **FPGA compatible** (Ejemplo: DE10-Lite con MAX10 FPGA)  
- **Cable de programación JTAG**  

## Estructura del Proyecto  
/Counter_BCD

│── clk_div.v # Módulo para la división de frecuencia del reloj

│── counter.v # Módulo de contador en binario

│── counter_bcd.v # Módulo para conversión de binario a BCD

│── bcd_decoder.v # Decodificador BCD para display de 7 segmentos

│── bin_a_dec.v # Conversión de binario a decimal

│── segment7.v # Controlador para display de 7 segmentos

│── counter_tb.v # Testbench para simulación del contador

│── counter.qpf # Archivo del proyecto en Quartus

│── counter.qsf # Archivo de configuración del FPGA

│── README.md # Este archivo

## Funcionalidad  

✔ Contador en binario con conversión a BCD  
✔ Visualización en display de 7 segmentos  
✔ Simulación y validación con testbench (`counter_tb.v`)  

Este diseño permite el conteo y visualización de números en formato BCD, con una arquitectura modular que facilita su modificación y extensión.
