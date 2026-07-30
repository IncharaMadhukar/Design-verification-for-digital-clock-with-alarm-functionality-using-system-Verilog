//=========================================================
// Transaction Class : Digital Clock with Alarm
//=========================================================

class transaction;


  //--------------- Random Inputs ----------------//

  rand bit        load_time;
  rand bit        load_alarm;
  rand bit        alarm_en;

  rand bit [4:0]  in_hr;
  rand bit [5:0]  in_min;
  rand bit [5:0]  in_sec;



  //--------------- DUT Outputs ------------------//

  bit [4:0] hr;
  bit [5:0] min;
  bit [5:0] sec;

  bit alarm_trigger;



  //--------------- Time Constraint --------------//

  constraint valid_time {

      in_hr  inside {[0:23]};
      in_min inside {[0:59]};
      in_sec inside {[0:59]};

  }



  //--------------- Control Constraint ------------//

  // Both operations cannot happen at same time

  constraint control_constraint {

    load_time != load_alarm;

}


  //--------------- Display Function --------------//

  function void display(string name);


    $display("==============================================");
    $display(" %s ", name);
    $display("==============================================");

    $display("load_time    = %0b", load_time);

    $display("load_alarm   = %0b", load_alarm);

    $display("alarm_en     = %0b", alarm_en);


    $display("Input Time   = %0d:%0d:%0d",
              in_hr,
              in_min,
              in_sec);


    $display("Clock Time   = %0d:%0d:%0d",
              hr,
              min,
              sec);


    $display("Alarm Trigger= %0b",
              alarm_trigger);


    $display("==============================================");


  endfunction


endclass
