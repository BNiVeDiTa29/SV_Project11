interface Intel8088Pins(input bit CLK, RESET);
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

logic [19:0] Address;
wire [7:0] Data;



modport Processor(input CLK, RESET, HOLD, READY, NMI, INTR, MNMX, TEST, inout AD, output A, output HLDA, output IOM, output WR, output RD, output SSO, output INTA, output ALE, output DTR, output DEN);

modport Pheripheral(input CLK, RESET, ALE, IOM, RD, WR, Address, inout Data);

endinterface
