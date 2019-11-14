; exponential function e^x
;e^= elementwise sum for i=1:n of x^i/i!
     AREA    exponential,CODE,READONLY
     EXPORT __main
     ENTRY
__main  FUNCTION 
        MOV R0,#13	;index of last expansion term i.e n
        MOV R1,#1	;counter 'i'
        VLDR.F32 S0,=1	;S0 will store the final value i.e e^x
        VLDR.F32 S1,=1	;Temp Variable to store the second last series element 't'
        VLDR.F32 S2,=10	;storing the value of x i.e. 10
LOOP1   CMP R1,R0	;if i==n i.e. reached the last index or not
        BLE LOOP	;if i < n if not go to loop
        B stop	;else goto stop

LOOP    VMUL.F32 S1,S1,S2	;t = t*x esentially doing x^i
        B fact	;calculate i!
facm    VMOV.F32 S5,R7	;move i! to S5 i.e. a floating point register
        VCVT.F32.U32 S5,S5 ;convert i! to an unsigned 32 bit fp number
        VDIV.F32 S3,S1,S5	;Store t/i! in s3
        VADD.F32 S0,S0,S3	;Add s3 to s
        ADD R1,R1,#1	;Increment the counter
        B LOOP1	;Repeat Again

 ; find factorial of a variable 
fact	MOV r7,#1 ; if n = 0, at least factorial = 1
        MOV R6,R1 ; move value of i stored in R1 to R6 to store intermediate value during operation
loop2   CMP r6, #0 ; compare the value of n to zero
        MULGT r7, r6, r7 ; if i!=0 multiply
        SUBGT r6, r6, #1 ; decrement n
        BGT loop2 ; repeat till n=0
        B facm ; pass the factorial value when n=0
	
stop    B stop  ; stop program
        endfunc
        end