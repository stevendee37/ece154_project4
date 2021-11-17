module maindec(input [5:0] op,
	       output	memtoreg, memtowrite,
	       output	branch, alusrc, 
	       output	regdst, regwrite,
	       output	jump, BNE, sigzer,
	       output [1:0] aluop);
  
  reg [10:0] controls;
  assign {regwrite, regdst, alusrc, branch, memwrite,
 	  memtoreg, jump, BNE, sigzer, aluop} = controls;

  always@(*) begin
    case(op)
      6'b000000: controls <= 11'b11000000010; // RTYPE
      6'b100011: controls <= 11'b10100100000; // LW
      6'b101011: controls <= 11'b00101000000; // SW
      6'b000100: controls <= 11'b00010000001; // BEQ
      6'b001000: controls <= 11'b10100000000; // ADDI
      6'b000010: controls <= 11'b00000010000; // J
      ////////// CHANGE: Added Opcode -> instruction directions
      6'b001101: controls <= 11'b10100000111; // ORI
      6'b000101: controls <= 11'b00000001001; // BNE
      default:   controls <= 11'bxxxxxxxxxxx; // illegal op
    endcase
  end
endmodule

module aludec(input     [5:0] funct,
	      input     [1:0] aluop,
	      output    reg [2:0] alucontrol);
  always@(*) begin
    case(aluop)
      2'b00: alucontrol <= 3'b010; // add (for lw/sw/addi)
      2'b01: alucontrol <= 3'b110; // sub (for beq)
      ////////// CHANGE: Added extended functionality for ALU decoder in alucontrol
      2'b11: alucontrol <= 3'b001; // or (for ori)
      default: case(funct)	   // R-type instructions
        6'b100000: alucontrol <= 3'b010; // add
        6'b100010: alucontrol <= 3'b110; // sub
        6'b100100: alucontrol <= 3'b000; // and
        6'b100101: alucontrol <= 3'b001; // or
        6'b101010: alucontrol <= 3'b111; // slt
        default:   alucontrol <= 3'bxxx; // n/a
      endcase
    endcase
  end
endmodule