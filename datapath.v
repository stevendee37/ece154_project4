module regfile(input reg clk,
	       input reg we3,
	       input reg [4:0] ra1, ra2, wa3,
	       input reg [31:0] wd3,
	       output wire[31:0] rd1, rd2);
  reg [31:0] rf[31:0];
  always@(posedge clk)
    if(we3) rf[wa3] <= wd3;
  assign rd1 = (ra1 != 0) ? rf[ra1] : 0;
  assign rd2 = (ra2 != 0) ? rf[ra2] : 0;
endmodule


module adder(input reg[31:0] a, b,
	     output [31:0] y);
  assign y = a + b;
endmodule

module sl2(input wire [31:0] a,
	   output  [31:0] y);
  assign y = {a[29:0], 2'b00};
endmodule

module signext(input reg[15:0] a,
	       output [31:0] y);
  assign y = {{16{a[15]}}, a};
endmodule

module flopr #(parameter WIDTH=8)
	   (input reg		clk, reset,
	    input reg[WIDTH-1:0]d,
	    output reg[WIDTH-1:0]q);
  always@(posedge clk, posedge reset)
    if(reset) q <= 0;
    else      q <= d;
endmodule

module mux2 #(parameter WIDTH = 8)
	     (input reg[WIDTH-1:0] d0, d1,
	      input reg s,
	      output wire[WIDTH-1:0] y);
  assign y = s ? d1 : d0;
endmodule;