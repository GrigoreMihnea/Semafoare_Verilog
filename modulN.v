module modulN #(
parameter SEC=24'd10000000
)(
input clk,
input reset,
input intretinere,
input Continuare_e_n,
output reg Continuare_n_s,
output reg Verde_auto_N,
output reg Galben_auto_N,
output reg Rosu_auto_N
);

localparam N = 24;
localparam Init = 0;
localparam Galben = 1;
localparam Verde = 2;
localparam Done = 3;
reg en = 0;

reg [2:0] prezent;
reg [2:0] viitor;
reg [4:0] counter;
reg [6:0] cnt0;
reg [6:0] cnt1;
reg [6:0] cnt2;
reg [7:0] sec;
reg [N-1:0] slow_clk = 0;

always @ (posedge clk)
    if (slow_clk == SEC) begin
        sec <= sec + 8'b1;
	if (prezent == Init&&en==1) cnt0 <= cnt0 + 8'b1;
	if (prezent == Galben) cnt1 <= cnt1 + 8'b1;
	if (prezent == Verde) cnt2 <= cnt2 + 8'b1;
        slow_clk <= 0;
    end
    else begin
        slow_clk <= slow_clk + 1'b1;
    end

always @(posedge clk or negedge reset) begin
	if (~reset) prezent <= Init;
	else prezent <= viitor;
end

always @(negedge reset) begin
	if (~reset) begin en <= 0;cnt0 <= 1'b0;cnt1 <= 1'b0;cnt2 <= 1'b0;end
end

always @(posedge Continuare_e_n) begin
	en <= 1;
end

always @(*) begin
	case (prezent)
		Init:if(en == 1 && cnt0==1) viitor <= Galben;
		     else viitor <= Init;
		Galben:if(cnt1==2) viitor <= Verde;
		       else if(cnt1<2) viitor <= Galben;
			    else viitor <= Init;
		Verde:if(cnt2==26) viitor <= Done;
		       else if(cnt2<26) viitor <= Verde;
			    else viitor <= Init;
		Done:if(en == 1) begin viitor <= Init; en <=0; end
		     else viitor <= Done;
		default:viitor <= Init;
	endcase
end

always @(posedge clk or negedge reset) begin
	if (~reset) begin Continuare_n_s <=0;
		    Verde_auto_N <=0;
		    Galben_auto_N <=0;
		    Rosu_auto_N <=1;end
	else if(prezent == Init) begin Continuare_n_s <=0;
		    Verde_auto_N <=0;
		    Galben_auto_N <=0;
		    Rosu_auto_N <=1;end
	else if(prezent == Galben) begin Continuare_n_s <=0;
		    Verde_auto_N <=0;
		    Galben_auto_N <=1;
		    Rosu_auto_N <=0;end
	else if(prezent == Verde) begin Continuare_n_s <=0;
		    Verde_auto_N <=1;
		    Galben_auto_N <=0;
		    Rosu_auto_N <=0;end
	else if(prezent == Done) begin Continuare_n_s <=1;
		    Verde_auto_N <=0;
		    Galben_auto_N <=0;
		    Rosu_auto_N <=1;end
end
endmodule