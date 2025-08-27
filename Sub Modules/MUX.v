module MUX(in0,in1,sel,out);
  input [15:0]in0,in1;
  input sel;
  output reg [15:0]out;
  
  assign out = sel ? in1 : in0;
    
endmodule
