module mojo_top(
    // 50MHz clock input
    input clk,
    // Input from reset button (active low)
    input rst_n,
    // Outputs to the 8 onboard LEDs
    output[7:0]led,
	 
	 output h_sync,
	 output v_sync,
	 
	 output reg r,
	 output reg g,
	 output reg b
    );

	wire rst = ~rst_n; // make reset active high
	wire pixel_clk;
	wire [31:0]h_pos;
	wire [31:0]v_pos;
	
	assign led = 8'b0;
	
	//Generating 25MHz pixel clock for vga timing control unit
	clk_25MHz instance_name(
    .CLK_IN1(clk),      
    .CLK_OUT1(pixel_clk),     
    .RESET(rst));

	video_timing_controller #(
		.h_pixels(640),
		.v_pixels(480),
		
		.hf_porch(16),
		.h_spulse(96),
		.hb_porch(48),
		
		.vf_porch(10),
		.v_spluse(2),
		.vb_porch(33),
		
		.h_pol(0),
		.v_pol(0))
	 vga_driver (
    .pixel_clk(pixel_clk), 
    .reset(rst), 
    .en(1), 
    .h_sync(h_sync), 
    .v_sync(v_sync), 
    .h_pos(h_pos), 
    .v_pos(v_pos)
    );
	 
	 always @(clk) begin 
		if(h_pos <= 320 && v_pos <= 240) begin
			r = 1;
			g = 1;
			b = 0;
		end
		
		else begin
			r = 0;
			g = 0;
			b = 0;
		end
			
	 end
endmodule