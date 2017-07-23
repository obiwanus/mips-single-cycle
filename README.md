# MIPS processor
This is a simple implementation of a single cycle MIPS-like processor in Verilog, with a slightly different instruction set than the standard MIPS32.

### Project structure
`assembler/asm.cpp`: a simple assembler

`instructions`: the list of all instructions supported by this processor

`processor/*.v`: the Verilog implementation of the processor

`processor/tests`: the set of hardware tests, including one for each instruction and each module, which are combined in a single testbench

### Control signals table
https://docs.google.com/a/ivanovs.info/spreadsheets/d/1ARzTCMWv4Y96ZnglDix2fxHa96c0Vds3O4Jouae4WkE/edit?usp=sharing

### Instruction Fetch Unit RTL diagram

![IFU](/IFU.png)
