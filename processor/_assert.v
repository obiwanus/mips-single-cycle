`ifndef _assert_h
`define _assert_h

`define assertEq(signal, value) \
    if ((signal) !== (value)) begin \
        $display("Error in %m:%3d: %h != %h", `__LINE__, (signal), (value)); \
        error = 1; \
    end

`define printResults \
    if (error === 0) \
        $display("===== %m OK ====="); \
    else \
        $display("===== %m FAIL =====");

`endif  // assert_h
