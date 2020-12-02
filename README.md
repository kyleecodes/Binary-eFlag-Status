# eFlagStatus.asm
An Assembly program that displays the status of eflags when given certain operations.

"Eflags" are the fundamental registers in Intel x86 microprocessors that contain the current state of the processor.

Each "flag" represents a state:
- Sign Flag (SF): Indicates negative (0) or positive (1) state
- Zero Flag (ZF): Indicates a zero (1) or nonzero (0) state
- Adjust Flag (AF): Indicates an auxillary carry (1) or no auxillary carry
- Parity Flag (PF): Indicates an even (1) or odd (0) state
- Carry Flag (CF): Indicates an arithmetic borrow/carry (1) or no carry (0)
While the Reserved (RES) remains the same for every operation.

This program was written in 1259 lines of Assembly code using the MASM (Microsoft's Macro Assembler) in Visual Studio Code. The [Irvine library]( http://asmirvine.com/gettingStartedVS2019/index.htm) must be installed in the same directory in order for this to run properly on x86 processors.

Demos:

![Demo photo](/demo.png)
