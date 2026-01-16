# Capstone Project

----------------------------------------------------------------------------------------------------------------

<details>
 <summary><b>
Week 1:</b> The functional simulation of the systolic core integrated with the weight matrix and SRAM was successfully completed</summary>

## Current Progress

During this week, the functional simulation of the systolic core integrated with the weight matrix and SRAM was successfully completed. The proper multiply-accumulate operation of the 4x4 weight-stationary systolic Processing Element (PE) array was confirmed. The SRAM's compressed weights were successfully retrieved, decompressed, and streamed into the PEs. Simulation was used to validate the movement of activation data and partial sum propagation across the systolic array. The simulation results confirmed that the systolic core and memory subsystem interacted correctly by matching the predicted matrix multiplication outputs.

### Challenges Faced

Ensuring correct synchronization between SRAM read operations and systolic data flow was a key challenge. Handling timing alignment between weight decompression and PE loading required careful control logic. Debugging partial sum mismatches in early simulations also required detailed waveform analysis to verify data propagation across clock cycles.

### Next Steps

In the next phase, the focus will be on integrating the activation routing logic and output SRAM for complete end-to-end data flow. Additional test cases with larger matrices and different weight patterns will be simulated. Clock-gating techniques will also be explored to reduce power consumption in idle PEs.


