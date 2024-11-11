module top(
input clk_i    ,
input reset_n_i  , 
input service_i ,

output Verde_auto_E_o ,
output Galben_auto_E_o ,
output Rosu_auto_E_o ,

output Verde_auto_N_o ,
output Galben_auto_N_o ,
output Rosu_auto_N_o  ,

output Verde_auto_S_o ,
output Galben_auto_S_o ,
output Rosu_auto_S_o ,

output Verde_auto_V_o ,
output Galben_auto_V_o ,
output Rosu_auto_V_o  ,

output Verde_pietoni_o ,
output Rosu_pietoni_o 

);

localparam DIV_FACTOR = 10000000;
reg k='b1;

wire clk;
wire reset;
wire intretinere;
reg intre;

always @(posedge intretinere) begin
	intre<=~intre;
end


wire continuare11;
wire continuare12;
wire continuare21;
wire continuare22;
wire continuare31;
wire continuare32;
wire continuare41;
wire pstart;
wire pstop;

reg c11;
reg c12;
reg c21;
reg c22;
reg c31;
reg c32;
reg c41;
reg pstartt;
reg pstopp;

wire Verde_auto_E;
wire Galben_auto_E;
wire Rosu_auto_E;

wire Verde_auto_N;
wire Galben_auto_N;
wire Rosu_auto_N;

wire Verde_auto_S;
wire Galben_auto_S;
wire Rosu_auto_S;

wire Verde_auto_V;
wire Galben_auto_V;
wire Rosu_auto_V;

wire Verde_pietoni;
wire Rosu_pietoni;

assign reset=reset_n_i,
assign clk=clk_i,
assign intretinere=service_i,

modulE #(.SEC(DIV_FACTOR)) DUTE(
.clk(clk),
.reset(reset),
.intretinere(intretinere),
.Continuare_e_n(continuare11),
.Verde_auto_E(Verde_auto_E),
.Galben_auto_E(Galben_auto_E),
.Rosu_auto_E(Rosu_auto_E)
);

modulN #(.SEC(DIV_FACTOR)) DUTN(
.clk(clk),
.reset(reset),
.intretinere(intretinere),
.Continuare_e_n(continuare12),
.Continuare_n_s(continuare21),
.Verde_auto_N(Verde_auto_N),
.Galben_auto_N(Galben_auto_N),
.Rosu_auto_N(Rosu_auto_N)
);

modulS #(.SEC(DIV_FACTOR)) DUTS(
.clk(clk),
.reset(reset),
.intretinere(intretinere),
.Continuare_n_s(continuare22),
.Continuare_s_v(continuare31),
.Verde_auto_S(Verde_auto_S),
.Galben_auto_S(Galben_auto_S),
.Rosu_auto_S(Rosu_auto_S)
);

modulV #(.SEC(DIV_FACTOR)) DUTV(
.clk(clk),
.reset(reset),
.intretinere(intretinere),
.Continuare_s_v(continuare32),
.Continuare_v(continuare41),
.Verde_auto_V(Verde_auto_V),
.Galben_auto_V(Galben_auto_V),
.Rosu_auto_V(Rosu_auto_V)
); 

modulPietoni #(.SEC(DIV_FACTOR)) DUTPIETONI(
.clk(clk),
.reset(reset),
.intretinere(intretinere),
.Pietoni_start(pstart),
.Pietoni_stop(pstop),
.Verde_pietoni_o(Verde_pietoni),
.Rosu_pietoni_o(Rosu_pietoni)
);

reg [2:0] prezent;
reg [2:0] viitor;

localparam EST = 0;
localparam NORD = 1;
localparam SUD = 2;
localparam VEST = 3;
localparam PIETONI = 4;
reg [2:0]OLD;

always @(posedge clk or negedge reset) begin
	if (~reset) prezent <= EST;
	else prezent <= viitor;
end

always @(*) begin
	case (prezent)
		EST:if(c11=='b1) viitor <= PIETONI;
		     else viitor <= EST;
		NORD:if(c21=='b1)begin viitor <= PIETONI;end
		     else viitor <= NORD;
		SUD:if(c31=='b1)begin viitor <= PIETONI;end
		     else viitor <= SUD;
		VEST:if(c41=='b1)begin viitor <= PIETONI;end
		     else viitor <= VEST;
		PIETONI:if(pstopp=='b1) begin
			if(intre=='b0)begin
		     if(OLD==EST) viitor <= NORD;
			else if(OLD==NORD) viitor <= SUD;
			else if(OLD==SUD) viitor <= VEST;
		     end
		     else viitor <= PIETONI;
		     end
		     else viitor <= PIETONI;
		default:viitor <= EST;
	endcase
end

always @(posedge clk or negedge reset) begin
	if (~reset) begin 
		  intre <='b0;
		  c11  <='b0;
		  c12  <='b0;
		  c21  <='b0;
		  c22  <='b0;
		  c31  <='b0;
		  c32  <='b0;
		  c41  <='b0;
		  pstartt  <='b0;
		  pstopp  <='b0;
		  OLD<='b0;end
	else if(prezent == NORD)begin c12<='b1; OLD<=NORD;pstartt<='b0;end
	else if(prezent == SUD)begin c22<='b1;  OLD<=SUD;pstartt<='b0;end
	else if(prezent == VEST)begin c32<='b1;  OLD<=VEST;pstartt<='b0;end
	else if(prezent == PIETONI)pstartt<='b1; 
	
end

assign c11=continuare11;
assign continuare12=c12;
assign c21=continuare21;
assign continuare22=c22;
assign c31=continuare31;
assign continuare32=c32;
assign c41=continuare41;
assign pstart = pstartt;
assign pstopp = pstop;

assign Verde_auto_E_o =Verde_auto_E;
assign Galben_auto_E_o =Galben_auto_E;
assign Rosu_auto_E_o =Rosu_auto_E;

assign Verde_auto_N_o =Verde_auto_N;
assign Galben_auto_N_o =Galben_auto_N;
assign Rosu_auto_N_o  =Rosu_auto_N;

assign Verde_auto_S_o =Verde_auto_S;
assign Galben_auto_S_o =Galben_auto_S;
assign Rosu_auto_S_o =Rosu_auto_S;

assign Verde_auto_V_o =Verde_auto_V;
assign Galben_auto_V_o =Galben_auto_V;
assign Rosu_auto_V_o  =Rosu_auto_V;

assign Verde_pietoni_o =Verde_pietoni;
assign Rosu_pietoni_o =Rosu_pietoni;

endmodule