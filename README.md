# MIPS processor
This is a simple implementation of a single cycle MIPS-like processor in Verilog, with a slightly different instruction set from the standard MIPS32.

### Project structure
`assembler/asm.cpp`: a simple assembler

`processor/*.v`: a Verilog implementation of the processor

`processor/tests`: a set of hardware tests, including one for each instruction and each module, which are combined in a single testbench

## Supported instructions
```
# R-format

instr   func    syntax          description

add     0x20    rd, rs, rt
and     0x24    rd, rs, rt
balrn   0x17    rs, rd          if [z]=0, branch to rs, store return in rd (31 by default)
balrz   0x16    rs, rd          if [z]=1, ---^---
brn     0x15    rs              if [z]=0, branch to rs
brz     0x14    rs              if [z]=1, branch to rs
jalr    0x09    rs, rd          unconditional jump to rs and link rd
jr      0x08    rs              unconditional jump to rs
nor     0x27    rd, rs, rt
or      0x25    rd, rs, rt
slt     0x2a    rd, rs, rt      set rd to (rs < rt)
sll     0x00    rd, rt, shamt   rd = rt << shamt
srl     0x02    rd, rt, shamt   rd = rt >> shamt
sub     0x22    rd, rs, rt      rd = rs - rt


# I-format

instr   opcode  syntax          description

addi    0x08    rt, rs, imm     rt = rs + imm
andi    0x0C    rt, rs, imm     rt = rs & zeroext(imm)
balmn   0x17    rt, imm(rs)     if [z]=0, branches to address in memory and links to rt(31)
balmz   0x16    rt, imm(rs)     if [z]=1, ---^---
beq     0x04    rs, rt, offset  if rs=rt, branch to offset
beqal   0x2C    rs, rt, offset  if rs=rt, branch to offset and link 31
bmn     0x15    imm(rs)         if [z]=0, branch to address in memory
bmz     0x14    imm(rs)         if [z]=1, branch to address in memory
bne     0x05    rs, rt, offset  if rs!=rt, branch to offset
bneal   0x2D    rs, rt, offset  if rs!=rt, branch to offset and link 31
jalm    0x13    rt, imm(rs)     jump to address in memory and link to rt(31)
jalpc   0x1F    rt, offset      jump to pc-relative address, and link to rt(31)
jm      0x12    imm(rs)         jump to address in memory
jpc     0x1E    offset          jump to pc-relative address
lw      0x23    rt, imm(rs)     load word at rs+imm into rt
ori     0x0D    rt, rs, imm     rt = rs | zeroext(imm)
sw      0x2B    rt, imm(rs)     store word in rt into memory at rs+imm


# J-format

instr   opcode  syntax          description

baln    0x1B    target26        if [z]=0, branch to target and link 31
balz    0x1A    target26        if [z]=1, branch to target and link 31
bn      0x19    target26        if [z]=0, branch to target
bz      0x18    target26        if [z]=1, branch to target
jal     0x03    target26        jump and link 31
j       0x02    target26        jump
```

### Control signals table
https://docs.google.com/a/ivanovs.info/spreadsheets/d/1ARzTCMWv4Y96ZnglDix2fxHa96c0Vds3O4Jouae4WkE/edit?usp=sharing

### Instruction Fetch Unit RTL diagram

![IFU](/IFU.png)


### Processor RTL diagram

![CPU](/CPU.png)

