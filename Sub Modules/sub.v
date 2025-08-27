module sub(in0,in1,sOut);
  input [15:0]in0,in1;
  output reg [15:0] sOut;
  
  always@(*) begin
    sOut <= in0 - in1;
  end
endmodule
