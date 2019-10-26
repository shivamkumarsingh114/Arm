 	
	
	AREA appcode, CODE, READONLY

	EXPORT __main
	ENTRY

__main FUNCTION
 
	MOV R5,#14;    NO. TO BE EXAMINED
	MOV R6,#1;   
	AND R5,R5,R6; CHECK LSB IS HIGH OR NOT(EVEN OR ODD)  
 
    ;IF 1 IN R5 THEN OUR NO. IS ODD, ELSE EVEN
	
stop B stop; STOPS PROG.  
	ENDFUNC
	END	
	
	
	
	
	
	
	
	