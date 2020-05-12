# FPGA Implementation of a Stopwatch

The design is prototyped on the DE1-SoC board and is driven by the 50 MHz clock signal. 

The stopwatch displays  minutes, seconds and deciseconds on the seven-segment displays.

The specifications of the design are
*  Minutes are displayed on HEX5 and HEX4.
*  Seconds are displayed on HEX3 and HEX2.
*  Desiseconds are displayed on HEX1 and HEX0.
*  The stopwatch displays times from 00:00:00 to 59:59:99, and will roll the digits over properly.
*  KEY(0) will asynchronously reset the clock to 00:00:00.
*  KEY(1) will asynchronously pause and resume the stopwatch.

A Structure of the design is

    .
    ├── ...
    ├── Stopwatch.vhdl       # Top Level Entity
    │   ├── Minute1.vhdl          # MIN1 - Counts from 0-5 
    │   ├── Minute0.vhdl          # MIN0 - Counts from 0-9 
    │   ├── Second1.vhdl          # SEC1 - Counts from 0-5 
    │   ├── Second0.vhdl          # MIN0 - Counts from 0-9 
    │   ├── Cent_Sec1.vhdl        # SEC1 - Counts from 0-9 
    │   ├── Cent_Sec0.vhdl        # SEC0 - Counts from 0-9 
    │   ├── Cent_Sec_Gen.vhdl     # Generates a control signla every 1 decisecond 
    │   └── 7Segment.vhdl         # Controls digits on the seven segment displays
    └── ...


