module gen_clk_reset (
output reg reset,
output reg clk
);

initial begin

clk <= 0;
forever #10 begin
clk <= ~clk;
end

end

initial begin

reset <= 'b1;
#5 reset <= 'b0;
@(posedge clk);
@(posedge clk);
reset <= 'b1;

end
endmodule