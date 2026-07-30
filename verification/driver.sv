//=========================================================
// Driver Class : Digital Clock with Alarm
//=========================================================

class driver;


  int no_transactions;


  // Virtual Interface

  virtual intf vif;


  // Mailbox

  mailbox gen2driv;



  // Constructor

  function new(virtual intf vif, mailbox gen2driv);

    this.vif = vif;

    this.gen2driv = gen2driv;

  endfunction



  //=======================================================
  // Reset Task
  //=======================================================

  task reset;


    wait(!vif.rst_n);   //Pause the execution until the reset signal rst_n becomes 0.


    $display("[DRIVER] -------- RESET STARTED --------");



    vif.tick_1hz   <= 0;

    vif.load_time  <= 0;

    vif.load_alarm <= 0;

    vif.alarm_en   <= 0;


    vif.in_hr  <= 0;

    vif.in_min <= 0;

    vif.in_sec <= 0;



    wait(vif.rst_n);



    $display("[DRIVER] -------- RESET ENDED ----------");



  endtask




  //=======================================================
  // Main Task
  //=======================================================

  task main;


    transaction trans;



    forever begin



      // Get transaction from generator

      gen2driv.get(trans);   //gets data from mailbox and gives it to transaction class handle trans



      //--------------------------------------------
      // Alarm Enable
      //--------------------------------------------

      vif.alarm_en <= trans.alarm_en;  //Drives alarm enable signal to DUT via the virtual interface vif
 


      //--------------------------------------------
      // Load Current Time
      //--------------------------------------------

      if(trans.load_time) begin



        @(posedge vif.clk);  //Waits for clock edge to make the operation synchronous.



        vif.load_time <= 1;



        vif.in_hr  <= trans.in_hr;

        vif.in_min <= trans.in_min;

        vif.in_sec <= trans.in_sec;



        @(posedge vif.clk);



        vif.load_time <= 0;  //Disables load signal after one cycle.



      end



      //--------------------------------------------
      // Load Alarm Time
      //--------------------------------------------

      else if(trans.load_alarm) begin



        @(posedge vif.clk);



        vif.load_alarm <= 1;



        vif.in_hr  <= trans.in_hr;

        vif.in_min <= trans.in_min;

        vif.in_sec <= trans.in_sec;



        @(posedge vif.clk);



        vif.load_alarm <= 0;



      end



      //--------------------------------------------
      // Normal Clock Operation					//If neither time nor alarm is loaded
      //--------------------------------------------

      else begin



        @(posedge vif.clk);



        vif.tick_1hz <= 1;



        @(posedge vif.clk);



        vif.tick_1hz <= 0;



      end

trans.display("[DRIVER]");

 no_transactions++;

end

endtask

endclass


