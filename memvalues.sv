/*file for generating the MEM_CONTENTS.txt files for all IO/M  modules 
Generated 4 MEM_CONTENTS
MEM_CONTENTS1 size 512KiB
MEM_CONTENTS2 size 512KiB
MEM_CONTENTS3 size 4B
MEM_CONTENTS4 size 512B */

module memvalues();

string filename = "MEM_CONTENTS.txt";
int myfile;


initial
begin
myfile = $fopen(filename ,"w");
	if (!myfile)
	begin
		$display("Error opening file");
		$fclose(myfile);
		
		$finish;
end 
	else 
		begin
		for(int i=0;i<2**20;i++)
		begin
			automatic byte j=$urandom_range(8'h00,8'hFF);
			$fwrite(myfile,"%h \n",j);
		end
		$display("File created successfully");
		end
		$finish;
end
	endmodule
	endmodule
