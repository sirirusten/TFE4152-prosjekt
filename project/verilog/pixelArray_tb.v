`timescale 1 ns / 1 ps

module pixelArray_tb();
   // Declearing variables
   logic       vbn1; 
   logic       ramp;
   logic       reset = 0;
   logic       erase = 0;
   logic       expose = 1;
   logic       read1 = 0;
   logic       read2 = 1;
   wire [7:0]  data1;
   wire [7:0]  data2; 
   wire [7:0]  data3;
   wire [7:0]  data4; 

   // Use pixel_array
   pixelArray dut(.vbn(vbn1), .ramp(ramp), .reset(reset), .erase(erase), .expose(expose), .read(read1), .read2(read2), .data1(data1), .data2(data2), .data3(data3), .data4(data4));
   
   // Rudementary tests to check that we have hooked things up correctly
   logic clk = 0;
   parameter integer clk_period = 500;
   parameter integer sim_end = clk_period*2400;
   always #clk_period clk=~clk;

   // Generate convert signal
   logic convert = 0;
   parameter integer conv_period = sim_end/4;
   always #conv_period convert=~convert;

   // Generate ramp signal: If we are to convert, then provide a clock via ramp -->No resemblence to real world. 
   assign ramp = convert ? clk : 0;

   // Generate expose signal opposite of convert 
   parameter integer expose_period = sim_end/4;
   always #expose_period expose=~expose;
   
   // Generate vnn1 signal: During expoure, provide a clock via bias -->No resemblence to real world. 
   assign vbn1 = expose ? clk : 0;

   // genearate erase signal: 
   parameter integer erase_period_top = 200;
   parameter integer erase_period_bottom = 5000;
   always begin
      if(erase) begin
         #erase_period_top erase = 0;
      end
      else begin
         #erase_period_bottom erase = 1;
      end
   end // always @ (posedge clk or reset)


   // Generate read signals that are opposite of each other: 
   parameter integer read1_period = sim_end/5;
   always #read1_period read1=~read1;

   parameter integer read2_period = sim_end/5;
   always #read2_period read2=~read2;

   // Set reset to high once:
   parameter integer reset_period_top = 200;
   parameter integer reset_period_bottom = 700000;
   always begin
      if(erase) begin
         #reset_period_top reset = 0;
      end
      else begin
         #reset_period_bottom reset = 1;
      end
   end // always @ (posedge clk or reset)

   initial
     begin
        reset = 1;

        #clk_period  reset=0;

        $dumpfile("pixelArray_tb.vcd");
        $dumpvars(0,pixelArray_tb);

        #sim_end
        $stop;
     end
endmodule // test
