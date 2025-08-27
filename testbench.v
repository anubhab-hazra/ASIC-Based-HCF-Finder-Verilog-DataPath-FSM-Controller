`include "dataPath.v"
`include "controller.v"

module testbench;
  reg [15:0]data_in;
  reg clk,start;
  wire ldA,ldB,sel1,sel2,sel_in,done,gt,lt,eq;
  
  HCF_finder DP(lt,gt,eq,ldA,ldB,sel1,sel2,sel_in,data_in,clk);
  controller CTR(lt,gt,eq,ldA,ldB,sel1,sel2,sel_in,clk,done,start);

  
  initial
    begin
       clk = 1'b0;
    #3 start = 1'b1;
    #300 $finish;
  end
    
  always #5 clk = ~clk;
  
  initial begin
    #22 data_in = 8'd143;
    #10 data_in = 8'd78;
  end
  
  initial begin
    $monitor($time, " aOut = %d, bOut = %d, done = %b",DP.aOut,DP.bOut,done);
    $dumpfile("dump.vcd");
    $dumpvars(0,testbench);
  end

endmodule
    
    
  
