`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: M.Hossein Allahakbari
// 
// Create Date:    17:47:52 08/16/2020 
// Design Name:
// Module Name:    video_timing_controller
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module video_timing_controller #(
		parameter h_pixels = 800,
		parameter v_pixels = 600,
		
		parameter hf_porch = 40,
		parameter h_spulse = 128,
		parameter hb_porch = 88,
		
		parameter vf_porch = 1,
		parameter v_spluse = 4,
		parameter vb_porch = 23,
		
		parameter h_pol = 1'b1,
		parameter v_pol = 1'b1 )
	(
	input pixel_clk,
	input reset,
	input en,
	
	output reg h_sync,
	output reg v_sync,
	
	output reg [31:0] h_pos,
	output reg [31:0] v_pos
	
    );
	
	
	wire [31:0]h_period = h_pixels + hf_porch + h_spulse + hb_porch;
	wire [31:0]v_period = v_pixels + vf_porch + v_spluse + vb_porch;

	initial begin
		h_pos = 0;
		v_pos = 0;
		h_sync = ~h_pol;
		v_sync = ~v_pol;
	end
	
	//setting horizontal and vertical position based on pixel clock
	always @(posedge pixel_clk) begin
		
		if(reset) begin
			h_pos <= 0;
			v_pos <= 0;
			h_sync <= ~h_pol;
			v_sync <= ~v_pol;
		end
		
		else begin
			if(en) begin
				if(h_pos < h_period - 1) begin 
					h_pos <= h_pos + 1;
					
				end
				
				else begin
				
					h_pos <= 0;
					
					if (v_pos < v_period - 1)begin
						v_pos <= v_pos + 1;
						
					end
					
					else begin
						v_pos <= 0;
						
					end
					
				end
				
				//setting sync signals
				
				if(h_pos < h_pixels + hf_porch || h_pos >= h_pixels + hf_porch + h_spulse) begin
					h_sync <= ~h_pol;
					
				end
				
				else begin
					h_sync <= h_pol;
					
				end
				
				if(v_pos < v_pixels + vf_porch || v_pos >= v_pixels + vf_porch + v_spluse) begin
					v_sync <= ~v_pol;
					
				end
				
				else begin
					v_sync <= v_pol;
					
				end
			end
			
			else begin
				h_sync <= 1'bz;
				v_sync <= 1'bz;
				h_pos <= 1'bz;
				v_pos <= 1'bz;
			end
		end
		
	end
		
endmodule
