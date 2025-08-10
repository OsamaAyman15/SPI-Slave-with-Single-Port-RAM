📌 Overview
This project implements an SPI Slave module in Verilog with an integrated RAM block on the Basys3 FPGA board.
It supports read and write operations controlled via an FSM (Finite State Machine) and communicates with a master device using the SPI protocol.

The design has been verified through simulation in Vivado and can be tested on hardware with an SPI master (e.g., microcontroller or another FPGA).

🛠 Features
SPI Slave implementation in Verilog.

10-bit serial-to-parallel conversion for data reception.

FSM-based control with states:

IDLE

CHK_CMD (Check Command)

WRITE (Write to RAM)

READ_ADDR (Set Read Address)

READ_DATA (Read from RAM)

Integrated 8-bit RAM for data storage.

MISO output for sending data back to SPI Master.

Parameterizable RAM size and data width.

Basys3 XDC constraints file included.
