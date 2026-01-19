# Capstone Project

## Energy-Efficient Near-Memory Systolic Accelerator with On-Chip Weight Compression for Edge AI Applications


----------------------------------------------------------------------------------------------------------------

<details>
 <summary><b>
Week 1:</b> The functional simulation of the systolic core integrated with the weight matrix and SRAM was successfully completed.</summary>

## 1.Updates
## Current Progress

During this week, the functional simulation of the systolic core integrated with the weight matrix and SRAM was successfully completed. The proper multiply-accumulate operation of the 4x4 weight-stationary systolic Processing Element (PE) array was confirmed. The SRAM's compressed weights were successfully retrieved, decompressed, and streamed into the PEs. Simulation was used to validate the movement of activation data and partial sum propagation across the systolic array. The simulation results confirmed that the systolic core and memory subsystem interacted correctly by matching the predicted matrix multiplication outputs.

### Challenges Faced

Ensuring correct synchronization between SRAM read operations and systolic data flow was a key challenge. Handling timing alignment between weight decompression and PE loading required careful control logic. Debugging partial sum mismatches in early simulations also required detailed waveform analysis to verify data propagation across clock cycles.

### Next Steps

In the next phase, the focus will be on integrating the activation routing logic and output SRAM for complete end-to-end data flow. Additional test cases with larger matrices and different weight patterns will be simulated. Clock-gating techniques will also be explored to reduce power consumption in idle PEs.

## 2.Project Idea

The project focuses on designing a near-memory systolic accelerator optimized for energy-efficient edge-AI inference. By combining weight-stationary dataflow with on-chip INT8 weight compression and localized SRAM banks, the design significantly reduces memory bandwidth and power consumption. The accelerator is fully synthesizable and scalable, making it suitable for ASIC feasibility studies and FPGA prototyping.

## 3.Simulation/Schematic
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


-----------------------------------------------------------------------------------------------------------------------------------------------------

<details>
 <summary><b>
Week 2:</b> The successful completion of the memory subsystems' integration with the compute logic.</summary>

## 1.Updates
## Current Progress

This week witnessed the successful completion of the memory subsystems' integration with the compute logic. To create exact control over the distribution and routing of input data, the Activation Buffer and Activation Router were combined. In order to verify accurate weight parameter retrieval and real-time decoding, the Compressed Weight SRAM and Decompressor were simultaneously connected to the system. To confirm matrix multiplication, functional simulations were run and the entire 4x4 systolic array was instantiated. The smooth data flow from the buffers and decompressors into the array was verified by these simulations, leading to successful multiply-accumulate operations and precise output generation that matched theoretical expectations.

### Challenges Faced

It was challenging to achieve exact synchronization between the Decompressor output and the Activation Router because pipeline stalls were occasionally caused by variable latency in the decompression logic. It took several iterations to control the handshake signals between the systolic array and the Activation Buffer so that no data was lost during backpressure events. Furthermore, it was difficult to identify the source of data mismatches during full 4x4 array simulation, requiring careful waveform analysis to differentiate between computation errors and routing errors within individual PEs.

### Next Steps

A top-level FSM will be implemented to coordinate the entire execution pipeline, from memory access to result writeback, in the subsequent phase, which focuses on full system bring-up. In order to improve power efficiency during idle cycles, design optimizations like clock-gating will be incorporated concurrently. After that, comprehensive functional testing will be used to confirm the system's robustness and make sure the hardware outputs precisely match the golden reference model.

## 2.Project Idea

The project focuses on designing a near-memory systolic accelerator optimized for energy-efficient edge-AI inference. By combining weight-stationary dataflow with on-chip INT8 weight compression and localized SRAM banks, the design significantly reduces memory bandwidth and power consumption. The accelerator is fully synthesizable and scalable, making it suitable for ASIC feasibility studies and FPGA prototyping.

## 3.Simulation/Schematic

<img width="932" height="495" alt="image" src="https://github.com/user-attachments/assets/f18a990d-8a8b-4a08-8e86-fc891bf6c09f" />

<img width="932" height="495" alt="image" src="https://github.com/user-attachments/assets/708ab595-1c14-4a75-a013-c12a45ce8c9c" />

<img width="930" height="387" alt="image" src="https://github.com/user-attachments/assets/97c6ef89-3294-4e3b-83b1-ac4bccb9d679" />

## 5.Analysis
Provide analysis or interpretation of results:

### Key Findings
•	Bandwidth Efficiency: The Compressed Weight SRAM reduced bandwidth usage while maintaining full throughput.


•	Data Integrity: Simulation confirmed bit-exact accuracy for partial sums propagating across all 16 PEs.


•	Synchronization: The memory subsystem successfully meets the strict timing "heartbeat" of the systolic array.


### Insights / Learnings
•	Pipeline Sensitivity: Even single-cycle mismatches in memory readout can severely disrupt weight-stationary flow.


•	Dynamic Routing: Dynamic flow control is essential; static scheduling cannot handle variable data delays effectively.


•	Modular Debugging: Isolating the memory and compute blocks for initial testing significantly accelerated the full integration.


### Improvements / Modifications Needed
•	Latency Masking: Implement pre-fetch buffers between the Decompressor and PEs to prevent array stalls.


•	Flow Control: Add robust "ready/valid" backpressure signals to the Activation Router to prevent data loss.


•	Control Logic: Refine the FSM state transitions to better handle corner cases in partial sum output.

--------------------------------------------------------------------------------------------------------------------------------------------------------------------



