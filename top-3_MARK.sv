module top;

bit CLK = '0;
bit MNMX = '1;
bit TEST = '1;
bit RESET = '0;
bit READY = '1;
bit NMI = '0;
bit INTR = '0;
bit HOLD = '0;

wire logic [7:0] AD;
logic [19:8] A;
logic HLDA;
logic IOM;
logic WR;
logic RD;
logic SSO;
logic INTA;
logic ALE;
logic DTR;
logic DEN;
logic CS,CS1,CS2,CS3,CS4;


logic [19:0] Address;
wire [7:0]  Data;

Intel8088 P(CLK, MNMX, TEST, RESET, READY, NMI, INTR, HOLD, AD, A, HLDA, IOM, WR, RD, SSO, INTA, ALE, DTR, DEN);
IOM_Module M1(CLK, RESET, ALE, IOM, CS1, RD, WR, Address, Data);
IOM_Module M2(CLK, RESET, ALE, IOM, CS2, RD, WR, Address, Data);
IOM_Module M3(CLK, RESET, ALE, IOM, CS3, RD, WR, Address, Data);
IOM_Module M4(CLK, RESET, ALE, IOM, CS4, RD, WR, Address, Data);


// 8282 Latch to latch bus address
always_latch
begin
if (ALE)
	Address <= {A, AD};
end

// 8286 transceiver
assign Data =  (DTR & ~DEN) ? AD   : 'z;
assign AD   = (~DTR & ~DEN) ? Data : 'z;


always #50 CLK = ~CLK;

initial
begin
$dumpfile("dump.vcd"); $dumpvars;

repeat (2) @(posedge CLK);
RESET = '1;
repeat (5) @(posedge CLK);
RESET = '0;

repeat(10000) @(posedge CLK);
$finish();
end

//Chip Select logic
always_comb
	begin
	{CS1,CS2,CS3,CS4} = 4'b0000;

	if (!Address[19] && !IOM)
		CS1 = 1;
	else if (Address[19] && !IOM)
		CS2 = 1;
	else if (IOM && Address[15:4] == 12'hFF0)
		CS3 = 1;
	else if (IOM && Address[15:9] == 7'h0E)
		CS4 = 1;
	end
endmodule
