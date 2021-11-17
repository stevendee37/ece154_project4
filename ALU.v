module alu(
    input[31:0] a, b,
    input [2:0] f,
    output [31:0] y,
    output reg zero
    );
    reg[31:0] result;
    assign y = result;
    always@(*)
    begin
   	 case(f)
   		 3'b000:
   		   result = a & b;
   		 3'b001:
   		   result = a | b;
   		 3'b010:
   		   result = a + b;
   		 3'b100:
   		   result = a & ~b;
   		 3'b101:
   		   result = a | ~b;
   		 3'b110:
   		   result = a - b;
   		 3'b111:
   		   if(a == 32'b11111111111111111111111111111111) begin
   		 	if(b == 32'b11111111111111111111111111111111) begin
   			   result = 32'd0;
   		 	end
   		 	else
   		   	result = 32'd1;
   		   end
   		   else if(b == 32'b11111111111111111111111111111111) begin
   		 	result = 32'd0;
   		 	end
   		   else
   		   result = (a < b)?32'd1:32'd0;
   		 default:
   		   result = 0;
   	 endcase
    begin
   	 //zero = (y == 32'd0) ? 1 : 0;
   	 case(result)
   		 32'b00000000000000000000000000000000:
   		 zero = 1;
   	 default:
   		 zero = 0;
   	 endcase
    end
    end
    
   		 
endmodule


