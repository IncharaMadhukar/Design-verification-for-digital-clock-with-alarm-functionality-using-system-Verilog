//=========================================================
// Monitor Class : Digital Clock with Alarm
//=========================================================
//Monito observes DUT inputs and outputs through the interface.
class monitor;

  // Virtual Interface
  virtual intf vif;

  // Mailbox
  mailbox mon2scb;

  // Constructor
  function new(virtual intf vif, mailbox mon2scb);
    this.vif = vif;
    this.mon2scb = mon2scb;
  endfunction

  //=======================================================
  // Main Task
  //=======================================================

  task main;

    forever begin

      transaction trans;
      trans = new();

      // Wait for a clock edge
      @(posedge vif.clk);

      // Capture transaction when either load signal is asserted
      wait(vif.load_time || vif.load_alarm);

      // Capture input signals
      trans.load_time  = vif.load_time;
      trans.load_alarm = vif.load_alarm;
      trans.alarm_en   = vif.alarm_en;

      trans.in_hr  = vif.in_hr;
      trans.in_min = vif.in_min;
      trans.in_sec = vif.in_sec;

      // Wait for DUT to update
      @(posedge vif.clk);

      // Capture DUT outputs
      trans.hr = vif.hr;
      trans.min = vif.min;
      trans.sec = vif.sec;
      trans.alarm_trigger = vif.alarm_trigger;

      // Send transaction to scoreboard
      mon2scb.put(trans);

      // Display transaction
      trans.display("[MONITOR]");

    end

  endtask

endclass
