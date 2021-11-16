// External memories used by MIPS single-cycle processor

// Todo: Implement data memory
module dmem(input   clk, we,
            input   [31:0] a, wd,
            output  wire [31:0] rd);
  
// **PUT YOUR CODE HERE**
  reg [31:0] RAM[63:0];
  assign rd = RAM[a[31:2]];
  
  always@(posedge clk)
    if(we) RAM[a[31:2]] <= wd;
endmodule


// Instruction memory (already implemented)
module imem(input   [5:0]  a,
            output  wire [31:0] rd);

  reg [31:0] RAM[63:0];

  initial
    begin
      $readmemh("memfile.dat",RAM); // initialize memory with test program. Change this with memfile2.dat for the modified code
    end

  assign rd = RAM[a]; // word aligned
endmodule
