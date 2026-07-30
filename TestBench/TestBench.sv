  //=========================================================
  // Top Testbench : Digital Clock with Alarm
  //=========================================================

  `include "interface.sv"
  `include "test.sv"


  module top;


    //=========================================================
    // Clock and Reset
    //=========================================================

    bit clk;
    bit rst_n;



    //=========================================================
    // Clock Generation
    // Clock Period = 10ns
    //=========================================================

    always #5 clk = ~clk;



    //=========================================================
    // Reset Generation
    //=========================================================

    initial begin

      clk = 0;

      rst_n = 0;

      #20;

      rst_n = 1;

    end



    //=========================================================
    // Interface Instance
    //=========================================================

    intf i_intf(clk, rst_n);



    //=========================================================
    // Test Program Instance
    //=========================================================

    test t1(i_intf);



    //=========================================================
    // DUT Instance
    //=========================================================

    digital_clock dut (

        .clk            (i_intf.clk),

        .rst_n          (i_intf.rst_n),


       .tick_1hz       (i_intf.tick_1hz),


        .load_time      (i_intf.load_time),

        .load_alarm     (i_intf.load_alarm),

        .alarm_en       (i_intf.alarm_en),


        .in_hr          (i_intf.in_hr),

        .in_min         (i_intf.in_min),

        .in_sec         (i_intf.in_sec),


        .hr             (i_intf.hr),

        .min            (i_intf.min),

        .sec            (i_intf.sec),


        .alarm_trigger  (i_intf.alarm_trigger)

    );



    //=========================================================
    // VCD Waveform Dump
    //=========================================================

    initial begin

        $dumpfile("digital_clock.vcd");

        $dumpvars(0, top);

    end



  endmodule

