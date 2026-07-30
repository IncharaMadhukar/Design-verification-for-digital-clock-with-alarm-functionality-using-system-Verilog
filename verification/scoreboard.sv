//=========================================================
// Scoreboard Class : Digital Clock with Alarm
//=========================================================

class scoreboard;


  mailbox mon2scb;

  int no_transactions;


  // Reference Clock Model

  bit [4:0] exp_hr;
  bit [5:0] exp_min;
  bit [5:0] exp_sec;


  // Reference Alarm Model

  bit [4:0] alarm_hr;
  bit [5:0] alarm_min;
  bit [5:0] alarm_sec;

  bit alarm_enable;



  // Constructor

  function new(mailbox mon2scb);

    this.mon2scb = mon2scb;


    exp_hr  = 0;
    exp_min = 0;
    exp_sec = 0;


    alarm_hr  = 0;
    alarm_min = 0;
    alarm_sec = 0;


    alarm_enable = 0;


  endfunction



  //=======================================================
  // Main Task
  //=======================================================

  task main();


    transaction trans;


    forever begin


      mon2scb.get(trans);  //Put the captured transaction (done in monitor class ) into the mailbox so that the Scoreboard can read it.



      //-----------------------------------------------
      // Update Reference Clock
      //-----------------------------------------------


      // Loading current time
      if(trans.load_time) begin


          exp_hr  = trans.in_hr;

          exp_min = trans.in_min;

          exp_sec = trans.in_sec;


      end



      // Normal clock operation
      // Do not increment for alarm loading

      else if(!trans.load_alarm) begin



          if(exp_sec == 59) begin


              exp_sec = 0;


              if(exp_min == 59) begin


                  exp_min = 0;


                  if(exp_hr == 23)

                      exp_hr = 0;

                  else

                      exp_hr = exp_hr + 1;


              end

              else begin

                  exp_min = exp_min + 1;

              end


          end


          else begin

              exp_sec = exp_sec + 1;

          end


      end



      //-----------------------------------------------
      // Update Reference Alarm
      //-----------------------------------------------


      if(trans.load_alarm) begin


          alarm_hr  = trans.in_hr;

          alarm_min = trans.in_min;

          alarm_sec = trans.in_sec;


      end


      alarm_enable = trans.alarm_en;



      //-----------------------------------------------
      // Compare Clock
      //-----------------------------------------------


      if((trans.hr  == exp_hr) &&
         (trans.min == exp_min) &&
         (trans.sec == exp_sec)) begin


          $display("[SCOREBOARD] Clock Time Matched");


      end

      else begin


          $error("[SCOREBOARD] Clock Mismatch \nExpected : %0d:%0d:%0d Actual : %0d:%0d:%0d",
                  exp_hr,
                  exp_min,
                  exp_sec,
                  trans.hr,
                  trans.min,
                  trans.sec);


      end



      //-----------------------------------------------
      // Alarm Checking
      //-----------------------------------------------


      if(alarm_enable &&
         (exp_hr  == alarm_hr) &&
         (exp_min == alarm_min) &&
         (exp_sec == alarm_sec)) begin



          if(trans.alarm_trigger)

              $display("[SCOREBOARD] Alarm Trigger Correct");


          else

              $error("[SCOREBOARD] Alarm Trigger Missing");



      end


      else begin



          if(!trans.alarm_trigger)

              $display("[SCOREBOARD] Alarm Status Correct");


          else

              $error("[SCOREBOARD] False Alarm Trigger");


      end



      no_transactions++;


      trans.display("[SCOREBOARD]");



    end


  endtask


endclass
