// single-cycle MIPS processor
// instantiates a controller and a datapath module

module mips(input          clk, reset,
            output  [31:0] pc,
            input   [31:0] instr,
            output         memwrite,
            output  [31:0] aluout, writedata,
            input   [31:0] readdata);

  wire        memtoreg, branch,
               pcsrc, zero,
               alusrc, regdst, regwrite, jump, BNE, sigzer;
  wire [2:0]  alucontrol;

  controller c(instr[31:26], instr[5:0], zero,
               memtoreg, memwrite, pcsrc,
               alusrc, regdst, regwrite, jump, sigzer, 
               alucontrol);
  datapath dp(clk, reset, memtoreg, pcsrc,
              alusrc, regdst, regwrite, jump, sigzer, 
              alucontrol,
              zero, pc, instr,
              aluout, writedata, readdata);
endmodule


// Todo: Implement controller module
module controller(input   [5:0] op, funct,
                  input         zero,
                  output        memtoreg, memwrite,
                  output        pcsrc, alusrc,
                  output        regdst, regwrite,
                  output        jump, sigzer,
                  output  [2:0] alucontrol);

// **PUT YOUR CODE HERE**
  wire [1:0] aluop;
  wire branch, BNE;

  maindec md(op, memtoreg, memwrite, branch, alusrc, regdst, regwrite, jump, BNE, sigzer, aluop);
  aludec ad(funct, aluop, alucontrol);
  ////////// CHANGE: For BNE functionality, added or (|) and "(~zero & BNE)" enabling PCSrc 
  ////////// 	to equal 1 when ALU outputs that two elements are not equal
  assign pcsrc = (branch & zero)|(~zero & BNE);

endmodule




// Todo: Implement datapath
module datapath(input          clk, reset,
                input          memtoreg, pcsrc,
                input          alusrc, regdst,
                input          regwrite, jump,
		input 	       sigzer,
                input   [2:0]  alucontrol,
                output         zero,
                output  [31:0] pc,
                input   [31:0] instr,
                output  [31:0] aluout, writedata,
                input   [31:0] readdata);

// **PUT YOUR CODE HERE** 
  wire [4:0] writereg;
  wire [31:0] pcnext, pcnextbr, pcplus4, pcbranch;
  ////////// CHANGE: Added wire extimm to connect to output of mux that connects 
  ////////// 	two bit extenders
  wire [31:0] signimm, extimm, signimmsh;
  ////////// CHANGE: Added wire zeroimm to connect to output of zero bit extender
  wire [31:0] zeroimm;
  wire [31:0] srca, srcb;
  wire [31:0] result;
  
  // next PC	logic
  flopr#(32)	pcreg(clk,reset,pcnext,pc);
  adder		pcaddl(pc, 32'b100, pcplus4);
  sl2		imash(extimm, signimmsh);
  adder		pcadd2(pcplus4, signimmsh, pcbranch);
  mux2 #(32)	pcbrmux(pcplus4, pcbranch, pcsrc, pcnextbr);
  mux2 #(32)	pcmux(pcnextbr, {pcplus4[31:28],
		      instr[25:0], 2'b00}, jump, pcnext);

  // register file logic
  regfile	rf(clk, regwrite, instr[25:21], instr[20:16],
		   writereg, result, srca, writedata);
  mux2 #(5)	wrmux(instr[20:16], instr[15:11],
		      regdst, writereg);
  mux2 #(32)	resmux(aluout, readdata, memtoreg, result);
  signext	se(instr[15:0], signimm);
  ////////// CHANGE: Added instantiation of zero extension module and mux which connects 
  ////////// 	both bit extension modules, and determines which one outputs to the ALU based
  //////////	on the output of the control unit
  zeroext       ze(instr[15:0], zeroimm);
  mux2 #(32)    sigzemux(signimm, zeroimm, sigzer, extimm);

 // ALU logic
  ////////// CHANGE: modified input of mux to now contain wire extimm, which connects to the 
  //////////	bit extenders
  mux2 #(32)	srcbmux(writedata, extimm, alusrc, srcb);
  alu		alu(srca, srcb, alucontrol, aluout, zero);                
endmodule


