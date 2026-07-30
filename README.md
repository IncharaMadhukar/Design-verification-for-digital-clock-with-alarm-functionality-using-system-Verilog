# Design-verification-for-digital-clock-with-alarm-functionality-using-system-Verilog
SystemVerilog RTL Design and Verification
# Digital Clock with Alarm using SystemVerilog

## Project Overview

This project implements a synchronous digital clock with alarm functionality using SystemVerilog. The design includes hour, minute, and second counters, programmable alarm registers, and comparator logic to generate an alarm trigger when the current time matches the programmed alarm time.

A SystemVerilog verification environment is developed using Generator, Driver, Monitor, and Scoreboard components to verify the functionality of the design.

---

## Design Features

- 24-hour clock operation
- Mod-60 counters for seconds and minutes
- Mod-24 counter for hours
- Current time loading capability
- Alarm time programming
- Alarm enable control
- Alarm trigger generation
- Active-low reset functionality

---

## Verification Environment

The verification environment consists of:

- *Generator:* Creates test transactions containing clock values, alarm values, and control signals.
- *Driver:* Applies generated transactions to the DUT through the interface.
- *Monitor:* Observes DUT outputs and collects response transactions.
- *Scoreboard:* Compares expected outputs with actual DUT outputs using a reference model.

---

## Project Structure

RTL:
- digital_clock.sv

Verification:
- interface.sv
- transaction.sv
- generator.sv
- driver.sv
- monitor.sv
- scoreboard.sv
- environment.sv

## Tools Used

- SystemVerilog
- EDA Playground
- GitHub

---

## Conclusion

The digital clock with alarm was designed and verified successfully using SystemVerilog. The verification environment validated clock operation, alarm functionality, reset behavior, and synchronization between the DUT and verification components.
