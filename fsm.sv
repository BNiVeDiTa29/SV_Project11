module IOM_Module(CLK, RESET, ALE, IOM, CS, RD, WR, Address, Data);
input CLK, RESET, ALE, IOM, CS, RD, WR;
inout [7:0] Data;
input logic [19:0] Address;
logic OE, WREN, ADDR_LOAD;

typedef enum logic[0:4]{

	IDLE = 5'b00001,
	LOAD = 5'b00010,
	READ = 5'b00100,
	WRITE= 5'b01000,
	WAIT = 5'b10000
	} State;
	
	State CurrentState, NextState;
logic [19:0] Address_reg;
reg [7:0] mem[(2**20)-1 : 0];

initial
	begin
		$readmemh("MEM_CONTENTS.txt",mem);
	end
		
//sequential logic
always_ff@(posedge CLK)
begin
	if (RESET)
		CurrentState <= IDLE;
	else
		CurrentState <= NextState;
end

//next state logic
always_comb
begin
	NextState = CurrentState;
	case(CurrentState)
	IDLE	:	if(CS && ALE)
					begin
						NextState = LOAD;
					end
				else
					begin
						NextState = IDLE;
					end
				
	LOAD	:	if(!RD)
					begin
						NextState = READ;
					end
				else if(!WR)
					begin
						NextState = WRITE;
					end
				else
					begin
						NextState = LOAD;
					end
		
	READ	:	begin
						NextState = WAIT;
				end
	
	WRITE	:	begin
						NextState = WAIT;
				end
	
	WAIT	:	begin
						NextState = IDLE;
				end
	endcase
end

//output logic
always_comb
begin
	{OE,WREN,ADDR_LOAD} = 3'b000;
	case(CurrentState)
	IDLE	:	begin
				end
	
	LOAD	:	begin
					ADDR_LOAD = 1;
				end
	
	READ	:	begin
					OE = 1;
				end

	WRITE	:	begin
					WREN = 1;
				end
				
	WAIT	:	begin
				end
	endcase
end

//latching Address into Address Register
always_latch
begin
	if (ADDR_LOAD)
		Address_reg <= Address;
end

//Memory or IO registers


assign Data = (OE) ? mem[Address_reg] : 8'bzzzzzzzz;

always @(posedge CLK)
	begin
		if(WREN)
			mem[Address_reg] <= Data;
	end


	
endmodule
	