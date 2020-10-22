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
	wire [10:0]h_pos;
	wire [10:0]v_pos;
	
	reg [2:0]glyph_x;
	reg [3:0]glyph_y;
	reg [7:0]char = 8'h43;
	
	wire pixel_val;
	wire [13:0]addr;
	
	assign led = 8'b0;
	
	assign addr = (char << 7) + glyph_x + (glyph_y << 3);
	//Generating 25MHz pixel clock for vga timing control unit
	clk_generator clk_40MHz(
    .CLK_IN1(clk),      
    .CLK_OUT1(pixel_clk),     
    .RESET(rst));

	video_timing_controller vga_driver (
    .pixel_clk(pixel_clk), 
    .reset(rst),
    .h_sync(h_sync), 
    .v_sync(v_sync), 
    .h_pos(h_pos), 
    .v_pos(v_pos)
    );
	 
	 glyph_rom text_rom (
		.clka(pixel_clk),
		.addra(addr),
		.douta(pixel_val)
		);
		
		
	 always @(posedge pixel_clk) begin
		glyph_x <= h_pos[2:0];
		glyph_y <= v_pos[3:0];
	 end
	 
	 always @(posedge pixel_clk) begin 
		if(pixel_val && h_pos <= 800 && v_pos <= 600) begin
			r <= 0;
			g <= 1;
			b <= 0;
		end
		
		else begin
			r <= 0;
			g <= 0;
			b <= 0;
		end
			
	 end
endmodule