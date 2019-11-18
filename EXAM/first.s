     AREA    circle,CODE,READONLY
     EXPORT __main
	 IMPORT printMsg4p
	 IMPORT get_trig_fn
     ENTRY
__main  FUNCTION  
		VLDR.F32 S13,=10	;value of r=10
        VLDR.F32 S0,=0;storing value of theta(in degrees)
	 	VLDR.F32 S15,=0.0174533; changing degree	to radians
		VMUL.F32 S0,S0,S15 ; changing degree to radians
		VLDR.F32 S14,=6.3
		
MAIN	MOV R0,#20	;vlaue of x=20
		MOV R1,#30	;value of y=25
		VLDR.F32 S16,=320	;vlaue of x=20
		VLDR.F32 S17,=240	;value of y=25
		VLDR.F32 S12,=1	;resolution of theta
		VMUL.F32 S12,S12,S15 ; changing degree to radians
		BL get_trig_fn
		B CALC
		
CALC	VMUL.F32 S8,S8,S13	;calc y'=r*sinx
		VMUL.F32 S9,S9,S13	;calc x'=r*cosx
		VADD.F32 S9,S9,S16
		VADD.F32 S8,S8,S17
		VCVTR.U32.F32 S8,S8	;convert to 32bit unsigned
		VCVTR.U32.F32 S9,S9	;convert to 32bit unsigned
		VMOV R8,S8	;Move y' value to R8
		VMOV R9,S9	;Move x' value to R9
		ADD R0,R0,R9	;x=x+x'
		ADD R1,R1,R8	;Y=Y+Y'
		MOV R2,#10
		VCVTR.U32.F32 S18,S0
		VMOV R3,S18
		BL printMsg4p
		VADD.F32 S0,S0,S12
		VCMP.F32 S0,S14
		VMRS APSR_nzcv, FPSCR
		BLE MAIN ;repeat for the next theta value
		B stop;		;if theta is more than 2pi stop
		
stop    B stop  ; stop program
        endfunc
        end