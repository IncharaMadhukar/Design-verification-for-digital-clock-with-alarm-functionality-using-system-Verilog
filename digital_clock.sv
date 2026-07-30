
 //PROJECT NAME:Design verification of digital clock with alarm functionality using
//system verilog

module digital_clock (
    input  logic        clk,
    input  logic        rst_n,

    // 1-Hz enable pulse (one clock-wide pulse every second)
    input  logic        tick_1hz,

    // Control signals
    input  logic        load_time,
    input  logic        load_alarm,
    input  logic        alarm_en,

    // Time inputs
    input  logic [4:0]  in_hr,
    input  logic [5:0]  in_min,
    input  logic [5:0]  in_sec,

    // Current time
    output logic [4:0]  hr,
    output logic [5:0]  min,
    output logic [5:0]  sec,

    // Alarm output
    output logic        alarm_trigger
);

    // Alarm registers
    logic [4:0] a_hr;
    logic [5:0] a_min;
    logic [5:0] a_sec;

    //----------------------------------------------------
    // Time Counter
    //----------------------------------------------------
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            hr  <= 5'd0;
            min <= 6'd0;
            sec <= 6'd0;
        end

        else if (load_time) begin
            // Accept only valid time values
            if ((in_hr < 24) &&
                (in_min < 60) &&
                (in_sec < 60)) begin

                hr  <= in_hr;
                min <= in_min;
                sec <= in_sec;
            end
        end

        else if (tick_1hz) begin

            if (sec == 59) begin
                sec <= 0;

                if (min == 59) begin
                    min <= 0;

                    if (hr == 23)
                        hr <= 0;
                    else
                        hr <= hr + 1;
                end
                else
                    min <= min + 1;
            end
            else
                sec <= sec + 1;

        end
    end

    //----------------------------------------------------
    // Alarm Register
    //----------------------------------------------------
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_hr <= 0;
            a_min <= 0;
            a_sec <= 0;
        end

        else if (load_alarm) begin

            if ((in_hr < 24) &&
                (in_min < 60) &&
                (in_sec < 60)) begin

                a_hr <= in_hr;
                a_min <= in_min;
                a_sec <= in_sec;
            end
        end
    end

    //----------------------------------------------------
    // Alarm Logic
    //----------------------------------------------------
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            alarm_trigger <= 1'b0;

        else if (alarm_en &&
                 tick_1hz &&
                 hr  == a_hr &&
                 min == a_min &&
                 sec == a_sec)

            alarm_trigger <= 1'b1;

        else
            alarm_trigger <= 1'b0;
    end

endmodule
