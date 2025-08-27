`include "MUX.v"
`include "PIPO.v"
`include "sub.v"
`include "comp.v"

module HCF_finder(lt,gt,eq,ldA,ldB,sel1,sel2,sel_in,data_in,clk);
  output lt,gt,eq;
  input reg ldA,ldB,sel1,sel2,sel_in,clk;
  
  wire [15:0] aOut,bOut,x,y,subOut,bus;
  
  input [15:0] data_in;
  
  PIPO A(.data_in(bus),.load(ldA),.clk(clk),.data_out(aOut));
  PIPO B(.data_in(bus),.load(ldB),.clk(clk),.data_out(bOut));
  
  sub s1 (.in0(x),.in1(y),.sOut(subOut));
  
  compare c1 (.data0(aOut),.data1(bOut),.lt(lt),.gt(gt),.eq(eq));
  
  MUX mux_in1  (.in0(aOut),.in1(bOut),.sel(sel1),.out(x));
  MUX mux_in2 (.in0(aOut),.in1(bOut),.sel(sel2),.out(y));
  MUX mux_load  (.in0(subOut),.in1(data_in),.sel(sel_in),.out(bus));
  
endmodule
