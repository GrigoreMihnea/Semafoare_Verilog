module modulPietoni #(
parameter SEC=24'd10000000
)(
input clk,
input reset,
input intretinere,
input Pietoni_start,
output reg Pietoni_stop,
output reg Verde_pietoni_o,
output reg Rosu_pietoni_o
);

localparam N = 24;
localparam Init = 0;
localparam Verde = 1;
localparam Verde_int = 2;
localparam Done = 3;
reg en = 0;

reg [2:0] prezent;
reg [2:0] viitor;
reg [4:0] counter;
reg [6:0] cnt0;
reg [6:0] cnt1;
reg [6:0] cnt2;
reg [6:0] cnt3;
reg [7:0] sec;
reg [N-1:0] slow_clk = 0;
reg [25:0] SECHALF;

always @(posedge clk) begin
    SECHALF = SEC >> 1;
end

always @ (posedge clk) begin
    if (slow_clk == SEC) begin
        sec <= sec + 8'b1;
	if (prezent == Init&&en==1) cnt0 <= cnt0 + 8'b1;
	if (prezent == Verde) cnt1 <= cnt1 + 8'b1;
	if (prezent == Verde_int) cnt2 <= cnt2 + 8'b1;
        slow_clk <= 0;
    end
    else begin
        slow_clk <= slow_clk + 1'b1;
    end
    if (slow_clk == SECHALF) begin
	if (prezent == Verde_int) cnt3 <= cnt3 + 8'b1;
    end
end

always @(posedge clk or negedge reset) begin
	if (~reset) prezent <= Init;
	else prezent <= viitor;
end

always @(negedge reset) begin
	if (~reset) begin en <= 0;cnt0 <= 1'b0;cnt1 <= 1'b0;cnt2 <= 1'b0;cnt3 <= 1'b0;end
end

always @(posedge Pietoni_start) begin
	en <= 1;
end

always @(*) begin
	case (prezent)
		Init:if(en == 1 && cnt0==1) viitor <= Verde;
		     else viitor <= Init;
		Verde:if(cnt1==12) viitor <= Verde_int;
		       else if(cnt1<12) viitor <= Verde;
			    else viitor <= Init;
		Verde_int:if(cnt2==6) viitor <= Done;
		       else if(cnt2<6) viitor <= Verde_int;
			    else viitor <= Init;
		Done:begin viitor <= Init;en <=0; end
		default:viitor <= Init;
	endcase
end

always @(posedge clk or negedge reset) begin
	if (~reset) begin Pietoni_stop<=0;
		    Verde_pietoni_o <=0;
		    Rosu_pietoni_o <=1;end
	else if(prezent == Init) begin Pietoni_stop<=0;
		    Verde_pietoni_o <=0;
		    Rosu_pietoni_o <=1;
		    cnt1 <= 1'b0;cnt2 <= 1'b0;cnt3 <= 1'b0;end
	else if(prezent == Verde) begin Pietoni_stop<=0;
		    Verde_pietoni_o <=1;
		    Rosu_pietoni_o <=0;
		    cnt0 <= 1'b0;end
	else if(prezent == Verde_int) begin Pietoni_stop<=0;
		    Rosu_pietoni_o <=0;
		    if(cnt3%2==1) Verde_pietoni_o <=1;
		    else Verde_pietoni_o <=0;
		    end
	else if(prezent == Done) begin Pietoni_stop<=1;
		    Verde_pietoni_o <=0;
		    Rosu_pietoni_o <=1;end
end
endmodule