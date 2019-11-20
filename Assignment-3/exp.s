     AREA     exp, CODE, READONLY
     EXPORT __exp
     ENTRY 
__exp  FUNCTION	
; IGNORE THIS PART 	
;Compute e^-x for value in S10 and store in S11	

	 ; S10 has value of x
	 VNEG.F32 S10,S10;			S10 has -x
	 
	 MOV R8,#200;				No of terms in the series
     MOV R9,#1;	    			Count
	 
     VLDR.F32 S11,=1;			Store value of e^x
     VLDR.F32 S12,=1;			Temp variable to hold the previous term     
	 
LOOP1 
	 CMP R9,R8;					Compare count and no of term
     BLE LOOP2;				If count is < no og terms enter LOOP1	
     BX LR;						else STOP
	 
LOOP2  
	 VMUL.F32 S12,S12,S10; 		Temp_var = temp_var * x
     VMOV.F32 S13,R9;			Move the count in R9 to S13 (floating point register)
     VCVT.F32.S32 S13,S13; 		Convert into signed 32bit number
     VDIV.F32 S12,S12,S13;		Divide temp_var by count (Now the term is finished)
     VADD.F32 S11,S11,S12;		Add temp_var to the sum
     ADD R9,R9,#1;				Increment the count
     B LOOP1;
	 
	 ENDFUNC
	 END
	 