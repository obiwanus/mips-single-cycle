`ifndef _const_h
`define _const_h

// ALU operations
`define OP_AND 3'b000
`define OP_OR  3'b001
`define OP_ADD 3'b010
`define OP_SLL 3'b011
`define OP_NOR 3'b100
`define OP_SRL 3'b101
`define OP_SUB 3'b110
`define OP_SLT 3'b111

// Opcodes
`define OPCODE_RTYPE    'h00
`define OPCODE_ADDI     'h08
`define OPCODE_ANDI     'h0C
`define OPCODE_BALMN    'h17
`define OPCODE_BALMZ    'h16
`define OPCODE_BEQ      'h04
`define OPCODE_BEQAL    'h2C
`define OPCODE_BMN      'h15
`define OPCODE_BMZ      'h14
`define OPCODE_BNE      'h05
`define OPCODE_BNEAL    'h2D
`define OPCODE_JALM     'h13
`define OPCODE_JALPC    'h1F
`define OPCODE_JM       'h12
`define OPCODE_JPC      'h1E
`define OPCODE_LW       'h23
`define OPCODE_ORI      'h0D
`define OPCODE_SW       'h2B
`define OPCODE_BALN     'h1B
`define OPCODE_BALZ     'h1A
`define OPCODE_BN       'h19
`define OPCODE_BZ       'h18
`define OPCODE_JAL      'h03
`define OPCODE_J        'h02

// Functions
`define FUNC_ADD     'h20
`define FUNC_AND     'h24
`define FUNC_BALRN   'h17
`define FUNC_BALRZ   'h16
`define FUNC_BRN     'h15
`define FUNC_BRZ     'h14
`define FUNC_JALR    'h09
`define FUNC_JR      'h08
`define FUNC_NOR     'h27
`define FUNC_OR      'h25
`define FUNC_SLT     'h2a
`define FUNC_SLL     'h00
`define FUNC_SRL     'h02
`define FUNC_SUB     'h22

// $0  $zero   Hard-wired to 0
// $1  $at Reserved for pseudo-instructions
// $2 - $3 $v0, $v1    Return values from functions
// $4 - $7 $a0 - $a3   Arguments to functions - not preserved by subprograms
// $8 - $15    $t0 - $t7   Temporary data, not preserved by subprograms
// $16 - $23   $s0 - $s7   Saved registers, preserved by subprograms
// $24 - $25   $t8 - $t9   More temporary registers, not preserved by subprograms
// $26 - $27   $k0 - $k1   Reserved for kernel. Do not use.
// $28 $gp Global Area Pointer (base of global data segment)
// $29 $sp Stack Pointer
// $30 $fp Frame Pointer
// $31 $ra Return Address
`define REG_ZERO    0
`define REG_AT      1
`define REG_V0      2
`define REG_V1      3
`define REG_A0      4
`define REG_A1      5
`define REG_A2      6
`define REG_A3      7
`define REG_T0      8
`define REG_T1      9
`define REG_T2      10
`define REG_T3      11
`define REG_T4      12
`define REG_T5      13
`define REG_T6      14
`define REG_T7      15
`define REG_S0      16
`define REG_S1      17
`define REG_S2      18
`define REG_S3      19
`define REG_S4      20
`define REG_S5      21
`define REG_S6      22
`define REG_S7      23
`define REG_T8      24
`define REG_T9      25
`define REG_K0      26
`define REG_K1      27
`define REG_GP      28
`define REG_SP      29
`define REG_FP      30
`define REG_RA      31

`define ALU_SRC_DATA_B          2'b00
`define ALU_SRC_SEXT_IMM16      2'b01
`define ALU_SRC_ZEXT_IMM16      2'b10

`endif
