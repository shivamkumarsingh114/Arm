#include "stm32f4xx.h"
#include <string.h>

void printh(const int a)
{
char *ptr_n;
ptr_n="Format is (a,b,c,y) where a,b,c are inputs and y is outout";
	
	 while(*ptr_n != '\0'){
      ITM_SendChar(*ptr_n);
      ++ptr_n;
   }
	 return;
}

void printp(const int a)
{
char *ptr_n;
	 
	if(a==0){ ptr_n = "\nTruth Table of AND(a,b,c,y):\n"; }
	 if(a==1){ ptr_n = "\nTruth Table of OR(a,b,c,y):\n"; }
	 if(a==2){ ptr_n = "\nTruth Table of NAND(a,b,c,y):\n"; }
	 if(a==3){ ptr_n = "\nTruth Table of NOR(a,b,c,y):\n"; }
	 if(a==4){ ptr_n = "\nTruth Table of XOR(a,b,c,y):\n"; }
	 if(a==5){ ptr_n = "\nTruth Table of XNOR(a,b,c,y):\n"; }
	 if(a==6){ ptr_n = "\nTruth Table of NOT(a,y):\n"; }
	
	 while(*ptr_n != '\0'){
      ITM_SendChar(*ptr_n);
      ++ptr_n;
   }
	 return;}

void printMsgn()
{
	char Msg[100];
	 char *ptr;
	 sprintf(Msg,"Invalid Operation Type\n");
	 ptr = Msg ;
   while(*ptr != '\0'){
      ITM_SendChar(*ptr);
      ++ptr;
   }
}
void printMsg(const int a)
{
	 char Msg[100];
	 char *ptr;
	 sprintf(Msg, "%x", a);
	 ptr = Msg ;
   while(*ptr != '\0'){
      ITM_SendChar(*ptr);
      ++ptr;
   }
}
void printMsg2p(const int a, const int b)
{
	 char Msg[100];
	 char *ptr;
	 // Printing the message
	 sprintf(Msg, "%x", a);
	 ptr = Msg ;
   while(*ptr != '\0')
	 {
      ITM_SendChar(*ptr);
      ++ptr;
   }
	  // Printing the message
	 sprintf(Msg, "%x\n", b);
	 ptr = Msg ;
   while(*ptr != '\0')
	 {
      ITM_SendChar(*ptr);
      ++ptr;
   }
}

void printMsg4p(const int a, const int b, const int c, const int d, const int e)
{
	 char Msg[100];
	 char *ptr;
	 // Printing the message
	/*sprintf(Msg,"\nPrinting First parameter a:  ");
	 ptr = Msg ;
   while(*ptr != '\0')
	 {
      ITM_SendChar(*ptr);
      ++ptr;
   }*/
	 //Printing the first parameter
	 sprintf(Msg, "%x", a);
	 ptr = Msg ;
   while(*ptr != '\0')
	 {
      ITM_SendChar(*ptr);
      ++ptr;
   }
	 // Printing the message
	 /*sprintf(Msg,"\nPrinting Second parameter b: ");
	 ptr = Msg ;
   while(*ptr != '\0')
	 {
      ITM_SendChar(*ptr);
      ++ptr;
   }*/
	 sprintf(Msg, "%x", b);
	 ptr = Msg ;
   while(*ptr != '\0')
	 {
      ITM_SendChar(*ptr);
      ++ptr;
   }
	 // Printing the message
	 /*sprintf(Msg,"\nPrinting Third parameter c: ");
	 ptr = Msg ;
   while(*ptr != '\0')
	 {
      ITM_SendChar(*ptr);
      ++ptr;
   }*/
	 sprintf(Msg, "%x", c);
	 ptr = Msg ;
   while(*ptr != '\0')
	 {
      ITM_SendChar(*ptr);
      ++ptr;
   }
	 // Printing the message
	 /*sprintf(Msg,"\nPrinting Fourth parameter y: ");
	 ptr = Msg ;
   while(*ptr != '\0')
	 {
      ITM_SendChar(*ptr);
      ++ptr;
   }*/
	 sprintf(Msg, "%x\n", d);
	 ptr = Msg ;
   while(*ptr != '\0')
	 {
      ITM_SendChar(*ptr);
      ++ptr;
	 }

	 // Printing the message
	 //sprintf(Msg,"\nPrinting Fifth parameter e: ");
	 //ptr = Msg ;
   //while(*ptr != '\0')
	 //{
     // ITM_SendChar(*ptr);
      //++ptr;
   //}

	  //sprintf(Msg, "%x", e);
	 //ptr = Msg ;
   //while(*ptr != '\0')
	 //{
     // ITM_SendChar(*ptr);
      //++ptr;
   //}
}

