`timescale 1 ns / 1 ps

module pixelState_tb;

   // Testbench clock
   logic                clk = 0;
   logic                reset = 0;
   parameter integer    clk_period = 500;
   parameter integer    sim_end = clk_period*2400;
   always               #clk_period clk=~clk;

   //Analog signals
   logic              anaBias1;
   logic              anaRamp;
   logic              anaReset;

   //Tie off the unused lines
   assign            anaReset = 1;

   //Digital
   wire             erase;
   wire             expose;
   wire             read1;
   wire             read2;
   wire             convert;

   tri[7:0]         pixData1; //  We need this to be a wire, because we're tristating it
   tri[7:0]         pixData2;
   tri[7:0]         pixData3;
   tri[7:0]         pixData4;

   // Posibility to change the light in the different pixels.
   parameter dv_pixel1 = 0.2;
   parameter dv_pixel2 = 0.4;
   parameter dv_pixel3 = 0.8;
   parameter dv_pixel4 = 0.9;

   //Instanciate the array
   pixelArray #(.dv_pixel1(dv_pixel1), .dv_pixel2(dv_pixel2), .dv_pixel3(dv_pixel3), .dv_pixel4(dv_pixel4)) array(.vbn1(anaBias1), .ramp(anaRamp), .reset(anaReset), .erase(erase), .expose(expose), .read1(read1), .read2(read2), .data1(pixData1), .data2(pixData2), .data3(pixData3), .data4(pixData4));
   
   pixelState #(.c_erase(5), .c_expose(255), .c_convert(255), .c_read(5))
   fsm1(.clk(clk), .reset(reset), .erase(erase), .expose(expose), .read1(read1), .read2(read2), .convert(convert));

   // DAC and ADC model
   logic[7:0] data;

   // If we are to convert, then provide a clock via anaRamp
   // This does not model the real world behavior, as anaRamp would be a voltage from the ADC
   // however, we cheat
   assign anaRamp = convert ? clk : 0;

   // During expoure, provide a clock via anaBias1.
   // Again, no resemblence to real world, but we cheat.
   assign anaBias1 = expose ? clk : 0;

   // If we're not reading the pixData, then we should drive the bus
   assign pixData1 = read1 ? 8'bZ: data; // if read1 high --> pixData1 = data, else pixdata is not connected. 
   assign pixData2 = read1 ? 8'bZ: data;
   assign pixData3 = read2 ? 8'bZ: data;
   assign pixData4 = read2 ? 8'bZ: data;

   // When convert, then run a analog ramp (via anaRamp clock) and digtal ramp via
   // data bus.
   always_ff @(posedge clk or posedge reset) begin
      if(reset) begin
         data = 0;
      end
      if(convert) begin
         data +=  1;
      end
      else begin
         data = 0;
      end
   end // always @ (posedge clk or reset)

   // Readout from databus
   logic [7:0] pixelDataOut1;
   logic [7:0] pixelDataOut2;
   always_ff @(posedge clk or posedge reset) begin
      if(reset) begin
         pixelDataOut1 = 0;
         pixelDataOut2 = 0;
      end
      else begin
         if(read1) begin
           pixelDataOut1 <= pixData1;
           pixelDataOut2 <= pixData2;
         end
         else if(read2) begin
           pixelDataOut1 <= pixData3;
           pixelDataOut2 <= pixData4;
         end
         else begin 
            // Needed to set pixelDataOut to 0 after the values are read out. 
           pixelDataOut1 = 0;  
           pixelDataOut2 = 0;
         end
           
      end
   end

   // Testbench stuff
   initial
     begin
        reset = 1;

        #clk_period  reset = 0;

        $dumpfile("pixelState_tb.vcd");
        $dumpvars(0,pixelState_tb);

        #sim_end
        $stop;

     end

endmodule // test
