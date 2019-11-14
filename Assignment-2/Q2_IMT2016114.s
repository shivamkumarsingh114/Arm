; tan(x) series
;using the fact that tan(x)=sin(x)/cos(x)
     AREA    tan,CODE,READONLY
     EXPORT __main
     ENTRY
__main  FUNCTION  
        MOV R0,#10	;index of last expansion term i.e n
        MOV R1,#1	;counter 'i'
        VLDR.F32 S0,=1	;S0 will store the final value i.e tan(x)
        VLDR.F32 S1,=1	;Temp Variable to store the second last series element 't'
        VLDR.F32 S2,=45	;storing value of x(in degrees)
	 	VLDR.F32 S7,=0.0174533; changing degree to radians 
		VMUL.F32 S2,S2,S7 ; changing degree to radians 
		VMOV.F32 S1,S2; t=x for first term sine
		VMOV.F32 S0,S2; sum=x for sine first term
		VLDR.F32 S8,=1; t=1 for cosine first term
		VLDR.F32 S9,=1; sum=1 for cosine first term
		
LOOP1   CMP R1,R0	;if i==n i.e. reached the last index or not
        BLE LOOP	;if i < n if not go to loop
		B stop	;else goto stop

LOOP  	VMOV.F32 S3,R1	;move 'i' to GP register
        VCVT.F32.U32 S3,S3	;Convert it to 32 bit unsigned fp Number
		VNMUL.F32 S4,S2,S2	;-1*x*x
		MOV R5,#2
		MUL R2,R1,R5	;2i
		ADD R3,R2,#1	;2i+1 for sine
		SUB R6,R2,#1	;2i-1 for cosine
		MUL R3,R2,R3	;2i*(2i+1)  for sine
		MUL R7,R2,R6	;2i*(2i-1) for cosine
        VMOV.F32 S5,R3	;move 2i*(2i+1) in FP register
		VMOV.F32 S10,R7	;move 2i*(2i-1) in FP register
        VCVT.F32.U32 S5,S5	;Convert it to 32 bit unsigned fp Number
		VCVT.F32.U32 S10,S10	;Convert it to 32 bit unsigned fp Number
		VDIV.F32 S6,S4,S5	;-(x*x)/2i*(2i+1)
		VDIV.F32 S11,S4,S10	;-(x*x)/2i*(2i-1)
		VMUL.F32 S1,S1,S6	;t=t*(-1)*(x*x)/2i*(2i+1)
		VMUL.F32 S8,S8,S11	;t=t*(-1)*(x*x)/2i*(2i-1)
		VADD.F32 S0,S0,S1	;add t to s for sine
		VADD.F32 S9,S9,S8;add t to s for cosine
		VDIV.F32 S12,S0,S9; final tanx value
		ADD R1,R1,#1; increment the value of i by 1
		B LOOP1	;Again goto comparision
		
stop    B stop  ; stop program
        endfunc
        end