# **Medidor de Frecuencia en FPGA con Quartus y Verilog**

## **Descripción**

Este proyecto implementa un **medidor de frecuencia** en una **FPGA DE10-Lite** utilizando **Quartus Prime** y **Verilog**. Se incluyen los módulos principales para la medición de frecuencia de señales de entrada y su visualización en un display de 7 segmentos. También se proporciona un testbench para la simulación y validación del diseño.

## **Requisitos**

- **Quartus Prime** (Intel FPGA)
- **FPGA DE10-Lite** (Intel MAX 10)
- **Cable de programación JTAG**

## **Estructura del Proyecto**
```
/Frequency_Meter

│── bcd_decoder.v               # Módulo de decodificación BCD

│── bin_a_dec.v                 # Conversión de binario a decimal

│── counter_debouncer.v         # Contador con debounce

│── debouncer.v                 # Módulo de debounce

│── debouncer_one_shot.v        # Debounce con un solo pulso

│── decoder_7_seg.v             # Controlador para display de 7 segmentos

│── frequency_measurement.v     # Módulo principal para medición de frecuencia

│── frequency_meter.v           # Medidor de frecuencia

│── frequency_meter_tb.v        # Testbench para simulación

│── one_shot.v                  # Generador de un solo pulso

│── signal_processor.v          # Procesador de señales

│── frec.qpf                    # Archivo del proyecto en Quartus

│── frec.qsf                    # Archivo de configuración del FPGA

│── README.md                   # Este archivo

```

## **RTL View**
![image](https://github.com/user-attachments/assets/67c0c8f8-2e6b-4571-869d-d232ebcf8548)


## **Funcionalidad**

✔ Medición de la frecuencia de una señal de entrada.  
✔ Conversión de datos binarios a BCD para visualización.  
✔ Filtrado y procesamiento de la señal de entrada.  
✔ Visualización en un display de 7 segmentos.  
✔ Simulación mediante testbench (`frequency_meter_tb.v`).  

## **Implementación en FPGA**

El proyecto se implementa en la **FPGA DE10-Lite** y utiliza los siguientes pines:

| **Señal**         | **Pin FPGA** | **Descripción** |
|-------------------|-------------|----------------|
| SIGNAL_IN        | GPIO_0       | Entrada de la señal a medir |
| DISPLAY_7SEG    | GPIO_1-7     | Salida a display de 7 segmentos |
| CLK             | CLK_FPGA     | Reloj de la FPGA |

## **Simulación**
Se proporciona un testbench (`frequency_meter_tb.v`) para validar la funcionalidad del módulo. La simulación permite visualizar el conteo y la conversión de frecuencia en el display de 7 segmentos.
