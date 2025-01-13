# Synch2AsyncFIFO
### Introduction 

This project highlights the differences between synchronous and asynchronous FIFO designs , providing implementations that focus on their logic and functionality.  

Key aspects covered in this project:  
- **Synchronous FIFO:** Operates under a single clock domain, making it simple and efficient for systems where data transfer occurs at the same clock rate.  
- **Asynchronous FIFO:** Supports communication between different clock domains, solving the challenge of transferring data reliably in heterogeneous systems.  

Additional insights include:  
- Proper handling of metastability issues in asynchronous designs.  
- Explanation of control signals like "write enable," "read enable," and pointers for both designs.  
- Use cases and advantages of each design in hardware systems.  

This project is a great resource for anyone looking to understand and implement FIFO structures in Verilog or similar hardware description languages.

<div style="text-align: center; margin: 30px 0;">
    <img src="images/Fifo_queue.png" alt="FIFO Queue Operations" width="500">
    <p><i>Figure_1 : Illustration of Enqueue and Dequeue operations in a FIFO.</i></p>
</div>

### Applications of Async FIFOs

Asynchronous FIFOs are commonly used in scenarios where data must be transferred between two parts of a system operating at different clock frequencies. They play a critical role in ensuring reliable data transfer across asynchronous clock domains. Some typical use cases include:

- **Interfacing between different clock domains**: For instance, transferring data from a high-speed processor to a slower peripheral device, or vice versa.
- **Communication between system modules**: In a system-on-chip (SoC), where different modules may operate at independent clock rates, Async FIFOs facilitate seamless data exchange.
- **Data buffering**: They help manage variations in data flow rates, ensuring smooth interaction between producers and consumers in digital systems.
- **Clock domain bridging**: Widely used in FPGA designs and digital circuits, Async FIFOs allow subsystems with differing clock speeds to communicate reliably.

### Architecture and Design Analysis

The block diagram of async. FIFO that is implemented in this repo is given below

![Architecture Diagram](images/FIFO_MOUDLE.jpeg)
 <p><i>Figure_2 : Overview of the functional components in an asynchronous FIFO
.</i></p>
Overview of the functional components in an asynchronous FIFO

Read and Write Operations
Operations
In an asynchronous FIFO, the read and write operations are managed by separate clock domains. The write pointer always points to the next word to be written. On a FIFO-write operation, the memory location pointed to by the write pointer is written, and then the write pointer is incremented to point to the next location to be written. Similarly, the read pointer always points to the current FIFO word to be read. On reset, both pointers are set to zero. When the first data word is written to the FIFO, the write pointer increments, the empty flag is cleared, and the read pointer, which is still addressing the contents of the first FIFO memory word, immediately drives that first valid word onto the FIFO data output port to be read by the receiver logic. The FIFO is empty when the read and write pointers are both equal, and it is full when the write pointer has wrapped around and caught up to the read pointer.

Full, empty and wrapping condition
The conditions for the FIFO to be full or empty are as follows:

Empty Condition: The FIFO is empty when the read and write pointers are both equal. This condition happens when both pointers are reset to zero during a reset operation, or when the read pointer catches up to the write pointer, having read the last word from the FIFO.

Full Condition: The FIFO is full when the write pointer has wrapped around and caught up to the read pointer. This means that the write pointer has incremented past the final FIFO address and has wrapped around to the beginning of the FIFO memory buffer.

To distinguish between the full and empty conditions when the pointers are equal, an extra bit is added to each pointer. This extra bit helps in identifying whether the pointers have wrapped around:

Wrapping Around Condition: When the write pointer increments past the final FIFO address, it will increment the unused Most Significant Bit (MSB) while setting the rest of the bits back to zero. The same is done with the read pointer. If the MSBs of the two pointers are different, it means that the write pointer has wrapped one more time than the read pointer. If the MSBs of the two pointers are the same, it means that both pointers have wrapped the same number of times.
This design technique helps in accurately determining the full and empty conditions of the FIFO.

Gray code counter
Gray code counters are used in FIFO design because they only allow one bit to change for each clock transition. This characteristic eliminates the problem associated with trying to synchronize multiple changing signals on the same clock edge, which is crucial for reliable operation in asynchronous systems.


