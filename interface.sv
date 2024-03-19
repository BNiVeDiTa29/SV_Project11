interface Intel8088Pins(input bit CLK, RESET);


logic [19:0] Address;
wire [7:0]  Data, Dbus;

logic MNMX = '1;
logic TEST = '1;

logic READY = '1;
logic NMI = '0;
logic INTR = '0;
logic HOLD = '0;

logic HLDA;
tri [7:0] AD;
tri [19:8] A;

logic IOM;
logic WR;
logic RD;
logic SSO;
logic INTA;
logic ALE;
logic DTR;
logic DEN;

logic CS,CS1,CS2,CS3,CS4;


//fsm

// 8282 Latch to latch bus address
always_latch
begin
if (ALE)
	Address <= {A, AD};
end

// 8286 transceiver
assign Data =  (DTR & ~DEN) ? AD   : 'z;
assign AD   = (~DTR & ~DEN) ? Data : 'z;


//selction logic
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

modport Processor(input CLK, RESET, HOLD, READY, NMI, INTR, MNMX, TEST, inout AD, output A, output HLDA, output IOM, output WR, output RD, output SSO, output INTA, output ALE, output DTR, output DEN);

modport Pheripheral0(input CLK, RESET, ALE, IOM, CS1, RD, WR, Address, inout Data);
modport Pheripheral1(input CLK, RESET, ALE, IOM, CS2, RD, WR, Address, inout Data);
modport Pheripheral2(input CLK, RESET, ALE, IOM, CS3, RD, WR, Address, inout Data);
modport Pheripheral3(input CLK, RESET, ALE, IOM, CS4, RD, WR, Address, inout Data);
endinterface