# Capstone Project

----------------------------------------------------------------------------------------------------------------

<details>
 <summary><b>
Week 1:</b> The functional simulation of the systolic core integrated with the weight matrix and SRAM was successfully completed</summary>

## 1.Updates
## Current Progress

During this week, the functional simulation of the systolic core integrated with the weight matrix and SRAM was successfully completed. The proper multiply-accumulate operation of the 4x4 weight-stationary systolic Processing Element (PE) array was confirmed. The SRAM's compressed weights were successfully retrieved, decompressed, and streamed into the PEs. Simulation was used to validate the movement of activation data and partial sum propagation across the systolic array. The simulation results confirmed that the systolic core and memory subsystem interacted correctly by matching the predicted matrix multiplication outputs.

### Challenges Faced

Ensuring correct synchronization between SRAM read operations and systolic data flow was a key challenge. Handling timing alignment between weight decompression and PE loading required careful control logic. Debugging partial sum mismatches in early simulations also required detailed waveform analysis to verify data propagation across clock cycles.

### Next Steps

In the next phase, the focus will be on integrating the activation routing logic and output SRAM for complete end-to-end data flow. Additional test cases with larger matrices and different weight patterns will be simulated. Clock-gating techniques will also be explored to reduce power consumption in idle PEs.

## 2.Project Idea

The project focuses on designing a near-memory systolic accelerator optimized for energy-efficient edge-AI inference. By combining weight-stationary dataflow with on-chip INT8 weight compression and localized SRAM banks, the design significantly reduces memory bandwidth and power consumption. The accelerator is fully synthesizable and scalable, making it suitable for ASIC feasibility studies and FPGA prototyping.

## 3.Simulation
<img width="932" height="281" alt="image" src="https://github.com/user-attachments/assets/244d9cfb-751c-4b5a-a628-aa23828eb0e5" />


<img width="982" height="520" alt="image" src="https://github.com/user-attachments/assets/d5f2143c-0b78-42e2-92ba-48f9afc0a62f" />


<img width="966" height="350" alt="image" src="https://github.com/user-attachments/assets/45a03b82-d3a8-46d4-93bf-2cea733a2df4" />

## 5.Analysis
Provide analysis or interpretation of results:

### Key Findings:
•	SRAM-integrated weight loading works correctly with systolic timing.


•	Weight-stationary dataflow minimizes repeated SRAM accesses.

### Insights / Learnings
•	Precise control of read-enable and load signals is critical for systolic correctness.


•	Early SRAM modelling simplifies later synthesis and integration.


•	Waveform-level debugging is essential for validating systolic architectures.

### Improvements / Modifications Needed
•	Add clock-gating for inactive PEs to reduce dynamic power.


•	Extend simulations to cover corner cases and stress conditions.





