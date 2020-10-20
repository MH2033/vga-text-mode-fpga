module mojo_top(
    // 50MHz clock input
    input clk,
    // Input from reset button (active low)
    input rst_n,
    // Outputs to the 8 onboard LEDs
    output[7:0]led,
    );

wire rst = ~rst_n; // make reset active high

assign led = 8'b0;

endmodule