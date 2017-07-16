/*
* Main testbench, which includes all individual module testbenches
*/

module testbench;

    clock_generator clkgen(clk);

    // Component tests
    test_ifu IFU(clk);
    test_registers register_file(clk);
    test_memory memory(clk);
    test_alu alu();
    test_signext signext();
    test_zeroext zeroext();
    test_mux mux();
    test_control control();

    // Processor tests
    // test_fefe fefe();
    // test_memset memset();

    // ALU instruction tests
    // test_addi addi();
    // test_add add();
    // test_sub sub();
    // test_and and_t();
    // test_or or_t();
    // test_nor nor_t();
    // test_andi andi();
    // test_ori ori();
    // test_sll sll();
    // test_srl srl();
    // test_slt slt();

    // Jump tests
    // test_j j();
    // test_jr jr();

    // Branch tests
    // test_bne bne();
    // test_balmn balmn();
    test_balmz balmz();

endmodule
