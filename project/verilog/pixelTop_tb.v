`timescale 1 ns / 1 ps

module pixelTop_tb;

   // Clock
   logic                clk = 0;
   logic                reset = 0;
   parameter integer    clk_period = 500;
   parameter integer    sim_end = clk_period*2400;
   always #clk_period   clk=~clk;

   // Posibility to change the light in the different pixels.
   parameter dv_pixel1 = 0.2;
   parameter dv_pixel2 = 0.4;
   parameter dv_pixel3 = 0.8;
   parameter dv_pixel4 = 0.9;

   //Instanciate the pixel
   pixelTop  #(.dv_pixel1(dv_pixel1), .dv_pixel2(dv_pixel2), .dv_pixel3(dv_pixel3), .dv_pixel4(dv_pixel4)) top(.clk(clk), .reset(reset));

   // // Set reset to high once:
   // parameter integer reset_period_top = 10000;
   // parameter integer reset_period_bottom = 100000;
   // always begin
   //    #reset_period_top reset = 0;
   //    #(reset_period_bottom) reset = 1;
   //    #reset_period_top reset = 0;
   //    #(reset_period_bottom*3) reset = 1;
   //    #reset_period_top reset = 0;
   //    #(reset_period_bottom*5.3) reset = 1;
   //    #reset_period_top reset = 0;
   // end // always @ (posedge clk or reset)

   // Testbench stuff-
   initial
     begin
        reset = 1;

        #clk_period  reset = 0;

        $dumpfile("pixelTop_tb.vcd");
        $dumpvars(0,pixelTop_tb);

        #sim_end
        $stop;

     end

endmodule // test

