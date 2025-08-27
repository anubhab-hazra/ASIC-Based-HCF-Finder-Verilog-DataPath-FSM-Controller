module compare(data0,data1,lt,gt,eq);
  input [15:0] data0,data1;
  output reg lt,gt,eq;
  
  assign lt = data0 < data1;
  assign gt = data0 > data1;
  assign eq = data0 == data1;
  
endmodule
