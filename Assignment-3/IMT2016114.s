	THUMB
	PRESERVE8	
	AREA  assign3, CODE,READONLY
	EXPORT __main
	IMPORT printMsg
	IMPORT printMsg4p	
	IMPORT printMsg2p	
	IMPORT printp
	IMPORT printh
		ENTRY

__main FUNCTION
	 BL printh;
	 MOV R0,#0;					Case input
	 BL printp;	
	 BL __andfunc;
	 
	 MOV R0,#1;					Case input
	 BL printp;
	 BL __orfunc;	
	 
	 MOV R0,#2;					Case input
	 BL printp;	
	 BL __nandfunc;
	 
	 MOV R0,#3;					Case input
	 BL printp;	
	 BL __norfunc;
	 
	 MOV R0,#4;					Case input
	 BL printp;	
	 BL __xorfunc;
	 
	 MOV R0,#5;					Case input
	 BL printp;	
	 BL __xnorfunc;
	 
	 MOV R0,#6;					Case input	 
	 BL printp;	
	 BL __notfunc;
	 
	 B stop;
	 ENDFUNC	
		
;-------------------------------------------------------------------------------------	 
__loadval FUNCTION
	 PUSH {LR};
	 VMOV.F32 S0,R4;			Move A1 to S0 (floating point register)
     VCVT.F32.S32 S0,S0; 		Convert into signed 32bit number
	 VMOV.F32 S1,R5;			Move A2 to S1 (floating point register)
     VCVT.F32.S32 S1,S1; 		Convert into signed 32bit number
	 VMOV.F32 S2,R6;			Move A3 to S2 (floating point register)
     VCVT.F32.S32 S2,S2; 		Convert into signed 32bit number
	 POP {LR};
	 BX lr;
	 ENDFUNC

;---------------------------------------------------------------------------------------

__val FUNCTION
	 PUSH {LR};
	 BL __exp;					Compute e^-x
	 BL __sigmoid;				Sigmoid function output in S9
	 
	 VLDR.F32 S14,= 0.5;		Store 0.5 in S14
	 VCMP.F32 S9,S14;			Compare current Y and 0.5		
	 VMRS    APSR_nzcv, FPSCR;	 
	 MOV R0, R4;
	 MOV R1, R5;
	 MOV R2, R6;				Move inputs to R0, R1 and R2 to print
	 MOVGT	R3, #1;				If Y > 0.5, output is 1
	 MOVLT	R3, #0;				If Y < 0.5, output is 0
	 POP {LR};
	 BX lr;
	 ENDFUNC	 
;--------------------------------------------------------------------------------------------------	
__sigmoid FUNCTION
	 ;Compute sigmoid function e^-x in S11 and Sigmoid function output in S9
	 PUSH {LR};
	 VLDR.F32 S8,= 1;			Store #1 for calculations
	 VADD.F32 S9,S11,S8;		S9 has (e^-x)+1
	 VDIV.F32 S9,S8,S9;			S9 has 1 / (e^-x)+1		-> 	Value of Y - sigmoid function
	 POP {LR};	
	 BX lr;
	ENDFUNC
	
;--------------------------------------------------------------------------------------------------

__exp FUNCTION
	 PUSH {LR};
	 ;Compute e^-x for value in S10 and store in S11	

	 ; S10 has value of x
	 VNEG.F32 S10,S10;			S10 has -x
	 
	 MOV R11,#200;				No of terms in the series
     MOV R12,#1;	    			Count
	 
     VLDR.F32 S11,=1;			Store value of e^x
     VLDR.F32 S12,=1;			Temp variable to hold the previous term     
	 
LOOP1 
	 CMP R12,R11;					Compare count and no of term
     BLE LOOP2;				If count is < no og terms enter LOOP1
	 POP {LR};	
     BX lr;						else STOP
	 
LOOP2  
	 VMUL.F32 S12,S12,S10; 		Temp_var = temp_var * x
     VMOV.F32 S13,R12;			Move the count in R9 to S13 (floating point register)
     VCVT.F32.S32 S13,S13; 		Convert into signed 32bit number
     VDIV.F32 S12,S12,S13;		Divide temp_var by count (Now the term is finished)
     VADD.F32 S11,S11,S12;		Add temp_var to the sum
     ADD R12,R12,#1;				Increment the count
     B LOOP1;
	 
	ENDFUNC		 
;---------------------------------------------------------------------------------------
__val2 FUNCTION
	 PUSH {LR};
	 BL __exp;					Compute e^-x
	 BL __sigmoid;				Sigmoid function output in S9
	 
	 VLDR.F32 S14,= 0.5;		Store 0.5 in S14
	 VCMP.F32 S9,S14;			Compare current Y and 0.5		
	 VMRS    APSR_nzcv, FPSCR;	 
	 MOV R0, R4;
	 MOV R1, R5;
	 MOV R2, R6;				Move inouts to R0, R1 and R2 to print
	 MOVGT	R1, #1;				If Y > 0.5, output is 1
	 MOVLT	R1, #0;				If Y < 0.5, output is 0
	 POP {LR};
	 BX lr;
	 ENDFUNC	

;----------------------------------------------------------------------------------------
;		logic AND

__and FUNCTION
	 PUSH {LR};	 
	 VLDR.F32 S4,= 2;			Weight 1
	 VLDR.F32 S5,= 2;			Weight 2
	 VLDR.F32 S6,= 2;			Weight 3
	 VLDR.F32 S7,= -5;		Bias
	 
	 VMUL.F32 S0,S0,S4;			A1*W1
	 VMUL.F32 S1,S1,S5;			A2*W2
	 VMUL.F32 S2,S2,S6;			A3*W3
	 VADD.F32 S3,S0,S1;			A1*W1 + A2*W2 
	 VADD.F32 S3,S3,S2;			A1*W1 + A2*W2 + A3*W3 
	 VADD.F32 S3,S3,S7;			A1*W1 + A2*W2 + A3*W3 + B
	 
	 VMOV.F32 S10,S3;			S10 has the value of x
	 BL __val;
	 
	 POP {LR};	
	 BX lr;
	 ENDFUNC

;----------------------------------------------------------------------------------------
;		logic OR

__or FUNCTION
	 PUSH {LR};	 
	 VLDR.F32 S4,= 2;			Weight 1
	 VLDR.F32 S5,= 2;			Weight 2
	 VLDR.F32 S6,= 2;			Weight 3
	 VLDR.F32 S7,= -1;			Bias
	 
	 VMUL.F32 S0,S0,S4;			A1*W1
	 VMUL.F32 S1,S1,S5;			A2*W2
	 VMUL.F32 S2,S2,S6;			A3*W3
	 VADD.F32 S3,S0,S1;			A1*W1 + A2*W2 
	 VADD.F32 S3,S3,S2;			A1*W1 + A2*W2 + A3*W3 
	 VADD.F32 S3,S3,S7;			A1*W1 + A2*W2 + A3*W3 + B
	 
	 VMOV.F32 S10,S3;			S10 has the value of x
	 BL __val;
	 POP {LR};	
	 BX lr;
	 ENDFUNC

;----------------------------------------------------------------------------------------
;		logic NOT	We only consider 1st input (in R4) for NOT 

__not FUNCTION
	 PUSH {LR};	 
	 VLDR.F32 S4,= -2;			Weight 1
	 VLDR.F32 S7,= 1;			Bias
	 
	 VMUL.F32 S0,S0,S4;			A1*W1
	 VADD.F32 S3,S0,S7;			A1*W1 + B
	 
	 VMOV.F32 S10,S3;			S10 has the value of x
	 BL __val;
	 POP {LR};	
	 BX lr;
	 ENDFUNC
;------------------------------------------------------------------------------------------	 
;		logic NOT	We only consider 1st input (in R4) for NOT 

__not2 FUNCTION
	 PUSH {LR};	 
	 VLDR.F32 S4,= -2;			Weight 1
	 VLDR.F32 S7,= 1;			Bias
	 
	 VMUL.F32 S0,S0,S4;			A1*W1
	 VADD.F32 S3,S0,S7;			A1*W1 + B
	 
	 VMOV.F32 S10,S3;			S10 has the value of x
	 BL __val2;
	 POP {LR};	
	 BX lr;
	 ENDFUNC

;----------------------------------------------------------------------------------------
;		logic XOR

__xor FUNCTION
	
	PUSH {LR};
	 ; Store the inputs 
	 VMOV.F32 S19,S0;			S19 has A1
	 VMOV.F32 S20,S1;			S20 has A2
	 VMOV.F32 S21,S2;			S21 has A3
	 
	 BL __not;					Computes not for A
				;				A' stored in R3
	 VMOV.F32 S22,R3;			Move the A' in R3 to S22 (floating point register)
     VCVT.F32.S32 S22,S22; 		Convert into signed 32bit number	 
	 
	 VMOV.F32 S0,S20;			Move value of A2 to S0			
	 BL __not;					Computes not for B
				;				B' stored in R3
	 VMOV.F32 S23,R3;			Move the B' in R3 to S23 (floating point register)
     VCVT.F32.S32 S23,S23; 		Convert into signed 32bit number
	 
	 VMOV.F32 S0,S21;			Move value of A3 to S0	
	 BL __not;					Computes not for C
				;				C' stored in R3
	 VMOV.F32 S24,R3;			Move the C' in R3 to S24 (floating point register)
     VCVT.F32.S32 S24,S24; 		Convert into signed 32bit number
	 
;1)	 A1'*A2*A3'	
	 VMOV.F32 S0,S22;	
	 VMOV.F32 S1,S20;
	 VMOV.F32 S2,S24;
	 BL __and;					compute A1'*A2*A3' 
	 MOV R7,R3;					Store value in R7
	 
;2)	 A1*A2'*A3'	
	 VMOV.F32 S0,S19;	
	 VMOV.F32 S1,S23;
	 VMOV.F32 S2,S24;
	 BL __and;					compute A1*A2'*A3' 
	 MOV R8,R3;					Store value in R8

;3)	 A1'*A2'*A3	
	 VMOV.F32 S0,S22;	
	 VMOV.F32 S1,S23;
	 VMOV.F32 S2,S21;
	 BL __and;					compute A1'*A2'*A3 
	 MOV R9,R3;					Store value in R9
	 
;4)	 A1*A2*A3	
	 VMOV.F32 S0,S19;	
	 VMOV.F32 S1,S20;
	 VMOV.F32 S2,S21;
	 BL __and;					compute A1*A2*A3 
	 MOV R10,R3;				Store value in R10	

;    Compute OR for R7, R8, R9, R10

	 VMOV.F32 S0,R10;			Move the count in R4 to S0 (floating point register)
     VCVT.F32.S32 S0,S0; 		Convert into signed 32bit number
	 VMOV.F32 S1,R9;			Move the count in R5 to S1 (floating point register)
     VCVT.F32.S32 S1,S1; 		Convert into signed 32bit number
	 VMOV.F32 S2,R8;			Move the count in R6 to S2 (floating point register)
     VCVT.F32.S32 S2,S2; 		Convert into signed 32bit number
	 
	 BL __or;					Computes OR for R7+R6+R5
	 MOV R10,R3;					Store value in R10	
	 
	 VMOV.F32 S0,R7;			Move the count in R4 to S0 (floating point register)
     VCVT.F32.S32 S0,S0; 		Convert into signed 32bit number
	 VMOV.F32 S1,R10;			Move the count in R4 to S0 (floating point register)
     VCVT.F32.S32 S1,S1; 		Convert into signed 32bit number
	 VLDR.F32 S2, = 0;			3rd input
	 LTORG;	
	 
	 BL __or;					Computes AND for R7+R6+R5+R4

	 POP {LR};		
	 BX lr;
	 ENDFUNC

;----------------------------------------------------------------------------------------
;		logic XNOR

__xnor FUNCTION
	 PUSH {LR};		

	 BL __xor;
	 VMOV.F32 S0,R3;			Move the count in R4 to S0 (floating point register)
     VCVT.F32.S32 S0,S0; 		Convert into signed 32bit number
	 BL __not;
	 
	 POP {LR};	
	 BX lr;
	 ENDFUNC

;----------------------------------------------------------------------------------------
;		logic NAND

__nand FUNCTION
	 PUSH {LR};	 
	 VLDR.F32 S4,= -2;			Weight 1
	 VLDR.F32 S5,= -2;			Weight 2
	 VLDR.F32 S6,= -2;			Weight 3
	 VLDR.F32 S7,= 5;			Bias
	 
	 VMUL.F32 S0,S0,S4;			A1*W1
	 VMUL.F32 S1,S1,S5;			A2*W2
	 VMUL.F32 S2,S2,S6;			A3*W3
	 VADD.F32 S3,S0,S1;			A1*W1 + A2*W2 
	 VADD.F32 S3,S3,S2;			A1*W1 + A2*W2 + A3*W3 
	 VADD.F32 S3,S3,S7;			A1*W1 + A2*W2 + A3*W3 + B
	 
	 VMOV.F32 S10,S3;			S10 has the value of x
	 BL __val;
	 POP {LR};	
	 BX lr;
	 ENDFUNC

;----------------------------------------------------------------------------------------
;		logic NOR

__nor FUNCTION
	 PUSH {LR};	 
	 VLDR.F32 S4,= -10;			Weight 1
	 VLDR.F32 S5,= -10;			Weight 2
	 VLDR.F32 S6,= -10;			Weight 3
	 VLDR.F32 S7,= 5;			Bias
	 
	 VMUL.F32 S0,S0,S4;			A1*W1
	 VMUL.F32 S1,S1,S5;			A2*W2
	 VMUL.F32 S2,S2,S6;			A3*W3
	 VADD.F32 S3,S0,S1;			A1*W1 + A2*W2 
	 VADD.F32 S3,S3,S2;			A1*W1 + A2*W2 + A3*W3 
	 VADD.F32 S3,S3,S7;			A1*W1 + A2*W2 + A3*W3 + B
	 
	 VMOV.F32 S10,S3;			S10 has the value of x
	 BL __val;
	 POP {LR};	
	 BX lr;
	 ENDFUNC
	  	
;--------------------------------------------------------------------------------------------------	  
__andfunc FUNCTION	
	
	 PUSH {LR}; 
	 MOV R4,#0;					A1	-> Input 1
	 MOV R5,#0;					A2	-> Input 2
	 MOV R6,#0;					A3	-> Input 3
	 BL __loadval;
	 BL __and;
	 BL printMsg4p
	 
	 MOV R4,#0;					A1	-> Input 1
	 MOV R5,#0;					A2	-> Input 2
	 MOV R6,#1;					A3	-> Input 3
	 BL __loadval;
	 BL __and;
	 BL printMsg4p
	 
	 MOV R4,#0;					A1	-> Input 1
	 MOV R5,#1;					A2	-> Input 2
	 MOV R6,#0;					A3	-> Input 3
	 BL __loadval;
	 BL __and;
	 BL printMsg4p
	 
	 MOV R4,#0;					A1	-> Input 1
	 MOV R5,#1;					A2	-> Input 2
	 MOV R6,#1;					A3	-> Input 3
	 BL __loadval;
	 BL __and;
	 BL printMsg4p
	 
	 MOV R4,#1;					A1	-> Input 1
	 MOV R5,#0;					A2	-> Input 2
	 MOV R6,#0;					A3	-> Input 3
	 BL __loadval;
	 BL __and;
	 BL printMsg4p
	 
	 MOV R4,#1;					A1	-> Input 1
	 MOV R5,#0;					A2	-> Input 2
	 MOV R6,#1;					A3	-> Input 3
	 BL __loadval;
	 BL __and;
	 BL printMsg4p
	 
	 MOV R4,#1;					A1	-> Input 1
	 MOV R5,#1;					A2	-> Input 2
	 MOV R6,#0;					A3	-> Input 3
	 BL __loadval;
	 BL __and;
	 BL printMsg4p
	 
	 MOV R4,#1;					A1	-> Input 1
	 MOV R5,#1;					A2	-> Input 2
	 MOV R6,#1;					A3	-> Input 3
	 BL __loadval;
	 BL __and;
	 BL printMsg4p
	 
	 POP {LR};	
     BX lr;						
	 					
	 ENDFUNC 
;--------------------------------------------------------------------		 
__orfunc FUNCTION	
	
	 PUSH {LR}; 
	 MOV R4,#0;					A1	-> Input 1
	 MOV R5,#0;					A2	-> Input 2
	 MOV R6,#0;					A3	-> Input 3
	 BL __loadval;
	 BL __or;
	 BL printMsg4p
	 
	 MOV R4,#0;					A1	-> Input 1
	 MOV R5,#0;					A2	-> Input 2
	 MOV R6,#1;					A3	-> Input 3
	 BL __loadval;
	 BL __or;
	 BL printMsg4p
	 
	 MOV R4,#0;					A1	-> Input 1
	 MOV R5,#1;					A2	-> Input 2
	 MOV R6,#0;					A3	-> Input 3
	 BL __loadval;
	 BL __or;
	 BL printMsg4p
	 
	 MOV R4,#0;					A1	-> Input 1
	 MOV R5,#1;					A2	-> Input 2
	 MOV R6,#1;					A3	-> Input 3
	 BL __loadval;
	 BL __or;
	 BL printMsg4p
	 
	 MOV R4,#1;					A1	-> Input 1
	 MOV R5,#0;					A2	-> Input 2
	 MOV R6,#0;					A3	-> Input 3
	 BL __loadval;
	 BL __or;
	 BL printMsg4p
	 
	 MOV R4,#1;					A1	-> Input 1
	 MOV R5,#0;					A2	-> Input 2
	 MOV R6,#1;					A3	-> Input 3
	 BL __loadval;
	 BL __or;
	 BL printMsg4p
	 
	 MOV R4,#1;					A1	-> Input 1
	 MOV R5,#1;					A2	-> Input 2
	 MOV R6,#0;					A3	-> Input 3
	 BL __loadval;
	 BL __or;
	 BL printMsg4p
	 
	 MOV R4,#1;					A1	-> Input 1
	 MOV R5,#1;					A2	-> Input 2
	 MOV R6,#1;					A3	-> Input 3
	 BL __loadval;
	 BL __or;
	 BL printMsg4p
	 
	 POP {LR};	
     BX lr;						
	 					
	 ENDFUNC 

;--------------------------------------------------------------------		 
__xorfunc FUNCTION	
	
	 PUSH {LR}; 
	 MOV R4,#0;					A1	-> Input 1
	 MOV R5,#0;					A2	-> Input 2
	 MOV R6,#0;					A3	-> Input 3
	 BL __loadval; 
	 BL __xor; 
	 BL printMsg4p;
	 
	 MOV R4,#0;					A1	-> Input 1
	 MOV R5,#0;					A2	-> Input 2
	 MOV R6,#1;					A3	-> Input 3
	 BL __loadval; 
	 BL __xor; 
	 BL printMsg4p;
	 
	 MOV R4,#0;					A1	-> Input 1
	 MOV R5,#1;					A2	-> Input 2
	 MOV R6,#0;					A3	-> Input 3
	 BL __loadval; 
	 BL __xor; 
	 BL printMsg4p;
	 
	 MOV R4,#0;					A1	-> Input 1
	 MOV R5,#1;					A2	-> Input 2
	 MOV R6,#1;					A3	-> Input 3
	 BL __loadval; 
	 BL __xor; 
	 BL printMsg4p;
	 
	 MOV R4,#1;					A1	-> Input 1
	 MOV R5,#0;					A2	-> Input 2
	 MOV R6,#0;					A3	-> Input 3
	 BL __loadval; 
	 BL __xor; 
	 BL printMsg4p;
	 
	 MOV R4,#1;					A1	-> Input 1
	 MOV R5,#0;					A2	-> Input 2
	 MOV R6,#1;					A3	-> Input 3
	 BL __loadval; 
	 BL __xor; 
	 BL printMsg4p;
	 
	 MOV R4,#1;					A1	-> Input 1
	 MOV R5,#1;					A2	-> Input 2
	 MOV R6,#0;					A3	-> Input 3
	 BL __loadval; 
	 BL __xor; 
	 BL printMsg4p;
	 
	 MOV R4,#1;					A1	-> Input 1
	 MOV R5,#1;					A2	-> Input 2
	 MOV R6,#1;					A3	-> Input 3
	 BL __loadval; 
	 BL __xor; 
	 BL printMsg4p;
	 
	 POP {LR};	
     BX lr;						
	 					
	 ENDFUNC 
	 
;--------------------------------------------------------------------		 
__xnorfunc FUNCTION	
	
	 PUSH {LR}; 
	 MOV R4,#0;					A1	-> Input 1
	 MOV R5,#0;					A2	-> Input 2
	 MOV R6,#0;					A3	-> Input 3
	 BL __loadval; 
	 BL __xnor; 
	 BL printMsg4p;
	 
	 MOV R4,#0;					A1	-> Input 1
	 MOV R5,#0;					A2	-> Input 2
	 MOV R6,#1;					A3	-> Input 3
	 BL __loadval; 
	 BL __xnor; 
	 BL printMsg4p;
	 
	 MOV R4,#0;					A1	-> Input 1
	 MOV R5,#1;					A2	-> Input 2
	 MOV R6,#0;					A3	-> Input 3
	 BL __loadval; 
	 BL __xnor; 
	 BL printMsg4p;
	 
	 MOV R4,#0;					A1	-> Input 1
	 MOV R5,#1;					A2	-> Input 2
	 MOV R6,#1;					A3	-> Input 3
	 BL __loadval; 
	 BL __xnor; 
	 BL printMsg4p;
	 
	 MOV R4,#1;					A1	-> Input 1
	 MOV R5,#0;					A2	-> Input 2
	 MOV R6,#0;					A3	-> Input 3
	 BL __loadval; 
	 BL __xnor; 
	 BL printMsg4p;
	 
	 MOV R4,#1;					A1	-> Input 1
	 MOV R5,#0;					A2	-> Input 2
	 MOV R6,#1;					A3	-> Input 3
	 BL __loadval; 
	 BL __xnor; 
	 BL printMsg4p;
	 
	 MOV R4,#1;					A1	-> Input 1
	 MOV R5,#1;					A2	-> Input 2
	 MOV R6,#0;					A3	-> Input 3
	 BL __loadval; 
	 BL __xnor; 
	 BL printMsg4p;
	 
	 MOV R4,#1;					A1	-> Input 1
	 MOV R5,#1;					A2	-> Input 2
	 MOV R6,#1;					A3	-> Input 3
	 BL __loadval; 
	 BL __xnor; 
	 BL printMsg4p;
	 
	 POP {LR};	
     BX lr;						
	 					
	 ENDFUNC 
;--------------------------------------------------------------------		 
__nandfunc FUNCTION	
	
	 PUSH {LR}; 
	 MOV R4,#0;					A1	-> Input 1
	 MOV R5,#0;					A2	-> Input 2
	 MOV R6,#0;					A3	-> Input 3
	 BL __loadval; 
	 BL __nand; 
	 BL printMsg4p;
	 
	 MOV R4,#0;					A1	-> Input 1
	 MOV R5,#0;					A2	-> Input 2
	 MOV R6,#1;					A3	-> Input 3
	 BL __loadval; 
	 BL __nand; 
	 BL printMsg4p;
	 
	 MOV R4,#0;					A1	-> Input 1
	 MOV R5,#1;					A2	-> Input 2
	 MOV R6,#0;					A3	-> Input 3
	 BL __loadval; 
	 BL __nand; 
	 BL printMsg4p;
	 
	 MOV R4,#0;					A1	-> Input 1
	 MOV R5,#1;					A2	-> Input 2
	 MOV R6,#1;					A3	-> Input 3
	 BL __loadval; 
	 BL __nand; 
	 BL printMsg4p;
	 
	 MOV R4,#1;					A1	-> Input 1
	 MOV R5,#0;					A2	-> Input 2
	 MOV R6,#0;					A3	-> Input 3
	 BL __loadval; 
	 BL __nand; 
	 BL printMsg4p;
	 
	 MOV R4,#1;					A1	-> Input 1
	 MOV R5,#0;					A2	-> Input 2
	 MOV R6,#1;					A3	-> Input 3
	 BL __loadval; 
	 BL __nand; 
	 BL printMsg4p;
	 
	 MOV R4,#1;					A1	-> Input 1
	 MOV R5,#1;					A2	-> Input 2
	 MOV R6,#0;					A3	-> Input 3
	 BL __loadval; 
	 BL __nand; 
	 BL printMsg4p;
	 
	 MOV R4,#1;					A1	-> Input 1
	 MOV R5,#1;					A2	-> Input 2
	 MOV R6,#1;					A3	-> Input 3
	 BL __loadval; 
	 BL __nand; 
	 BL printMsg4p;
	 
	 POP {LR};	
     BX lr;						
	 					
	 ENDFUNC 
;--------------------------------------------------------------------		 
__norfunc FUNCTION	
	
	 PUSH {LR}; 
	 MOV R4,#0;					A1	-> Input 1
	 MOV R5,#0;					A2	-> Input 2
	 MOV R6,#0;					A3	-> Input 3
	 BL __loadval; 
	 BL __nor; 
	 BL printMsg4p;
	 
	 MOV R4,#0;					A1	-> Input 1
	 MOV R5,#0;					A2	-> Input 2
	 MOV R6,#1;					A3	-> Input 3
	 BL __loadval; 
	 BL __nor; 
	 BL printMsg4p;
	 
	 MOV R4,#0;					A1	-> Input 1
	 MOV R5,#1;					A2	-> Input 2
	 MOV R6,#0;					A3	-> Input 3
	 BL __loadval; 
	 BL __nor; 
	 BL printMsg4p;
	 
	 MOV R4,#0;					A1	-> Input 1
	 MOV R5,#1;					A2	-> Input 2
	 MOV R6,#1;					A3	-> Input 3
	 BL __loadval; 
	 BL __nor; 
	 BL printMsg4p;
	 
	 MOV R4,#1;					A1	-> Input 1
	 MOV R5,#0;					A2	-> Input 2
	 MOV R6,#0;					A3	-> Input 3
	 BL __loadval; 
	 BL __nor; 
	 BL printMsg4p;
	 
	 MOV R4,#1;					A1	-> Input 1
	 MOV R5,#0;					A2	-> Input 2
	 MOV R6,#1;					A3	-> Input 3
	 BL __loadval; 
	 BL __nor; 
	 BL printMsg4p;
	 
	 MOV R4,#1;					A1	-> Input 1
	 MOV R5,#1;					A2	-> Input 2
	 MOV R6,#0;					A3	-> Input 3
	 BL __loadval; 
	 BL __nor; 
	 BL printMsg4p;
	 
	 MOV R4,#1;					A1	-> Input 1
	 MOV R5,#1;					A2	-> Input 2
	 MOV R6,#1;					A3	-> Input 3
	 BL __loadval; 
	 BL __nor; 
	 BL printMsg4p;
	 
	 POP {LR};	
     BX lr;						
	 					
	 ENDFUNC 
;--------------------------------------------------------------------		 
__notfunc FUNCTION	
	
	 PUSH {LR}; 
	 MOV R4,#0;					A1	-> Input 1
	 BL __loadval; 
	 BL __not2; 
	 BL printMsg2p;
	 
	 
	 MOV R4,#1;					A1	-> Input 1
	 BL __loadval; 
	 BL __not2; 
	 BL printMsg2p;
	 
	 POP {LR};	
     BX lr;				
	 					
	 ENDFUNC  
	 
stop B stop
    END