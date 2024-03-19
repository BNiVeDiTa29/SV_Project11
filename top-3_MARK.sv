module top;

bit CLK = '0;
bit RESET = '0;

//Intel8088 P(CLK, MNMX, TEST, RESET, READY, NMI, INTR, HOLD, AD, A, HLDA, IOM, WR, RD, SSO, INTA, ALE, DTR, DEN);
Intel8088Pins i (.*);
Intel8088 P (.i(i.Processor));
IOM_Module0 M0 (i.Pheripheral0);
IOM_Module1 M1 (i.Pheripheral1);
IOM_Module2 I0 (i.Pheripheral2);
IOM_Module3 I1 (i.Pheripheral3);
/*
IOM_Module M1(CLK, RESET, ALE, IOM, CS1, RD, WR, Address, Data);
IOM_Module M2(CLK, RESET, ALE, IOM, CS2, RD, WR, Address, Data);
IOM_Module M3(CLK, RESET, ALE, IOM, CS3, RD, WR, Address, Data);
IOM_Module M4(CLK, RESET, ALE, IOM, CS4, RD, WR, Address, Data);
*/




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

endmodule
