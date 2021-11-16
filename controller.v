module maindec(input [5:0] op,
	       output	memtoreg, memtowrite,
	       output	branch, alusrc, 
	       output	regdst, regwrite,
	       output	jump,
	       output [1:0] aluop);
  
  reg [8:0] controls;
  assign {regwrite, regdst, alusrc, branch, memwrite,
 	  memtoreg, jump, aluop} = controls;

  always
    case(op)
      6'b000000: controls <= 9'b110000010; // RTYPE
      6'b100011: controls <= 9'b101001000; // LW
      6'b101011: controls <= 9'b001010000; // SW
      6'b000100: controls <= 9'b000100001; // BEQ
      6'b001000: controls <= 9'b101000000; // ADDI
      6'b000010: controls <= 9'b000000100; // J
      // 6'b // ORI
      // 6'b // BNE
      default:   controls <= 9'bxxxxxxxxx; // illegal op
    endcase
endmodule

module aludec(input    reg [5:0] funct,
	      input    reg [1:0] aluop,
	      output   reg[2:0] alucontrol);
  always
    case(aluop)
      2'b00: alucontrol <= 3'b010; // add (for lw/sw/addi)
      2'b01: alucontrol <= 3'b110; // sub (for beq)
      default: case(funct)	   // R-type instructions
        6'b100000: alucontrol <= 3'b010; // add
        6'b100010: alucontrol <= 3'b110; // sub
        6'b100100: alucontrol <= 3'b000; // and
        6'b100101: alucontrol <= 3'b001; // or
        6'b101010: alucontrol <= 3'b111; // slt
        default:   alucontrol <= 3'bxxx; // n/a
      endcase
    endcase
endmodule