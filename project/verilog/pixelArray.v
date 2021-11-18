`timescale 1 ns / 1 ps

// PIXEL ARRAY MODULE THAT USES PIXEL SENSOR MODULE
module pixelArray(
                    input logic      vbn1,
                    input logic      ramp,
                    input logic      reset,
                    input logic      erase,
                    input logic      expose,
                    input logic      read1,
                    input logic      read2,
                    inout [7:0]      data1,
                    inout [7:0]      data2,
                    inout [7:0]      data3,
                    inout [7:0]      data4
                );

    parameter dv_pixel1 = 0.5;
    parameter dv_pixel2 = 0.5;
    parameter dv_pixel3 = 0.5;
    parameter dv_pixel4 = 0.5;

    PIXEL_SENSOR #(.dv_pixel(dv_pixel1)) pixel1(vbn1, ramp, reset, erase, expose, read1, data1); 
    PIXEL_SENSOR #(.dv_pixel(dv_pixel2)) pixel2(vbn1, ramp, reset, erase, expose, read1, data2); 
    PIXEL_SENSOR #(.dv_pixel(dv_pixel3)) pixel3(vbn1, ramp, reset, erase, expose, read2, data3); 
    PIXEL_SENSOR #(.dv_pixel(dv_pixel4)) pixel4(vbn1, ramp, reset, erase, expose, read2, data4); 
endmodule