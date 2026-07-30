//=========================================================
// Interface : Digital Clock with Alarm
//=========================================================

interface intf (input logic clk, rst_n);

    // Control Signals
    logic        tick_1hz;
    logic        load_time;
    logic        load_alarm;
    logic        alarm_en;

    // Time Inputs
    logic [4:0]  in_hr;
    logic [5:0]  in_min;
    logic [5:0]  in_sec;

    // Current Time Outputs
    logic [4:0]  hr;
    logic [5:0]  min;
    logic [5:0]  sec;

    // Alarm Output
    logic        alarm_trigger;

endinterface
