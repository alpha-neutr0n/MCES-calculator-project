//This code only will work for arithemetic operations on 2-Digit Numbers
//Input format eaxmple
//04+45 for addition
//56-43 for subtraction (first number > second number)
//45*03 for multiplication
//34/21 for division

#include<LPC214x.h>
#include <stdio.h>
void delay(void);  //delay function
void serial(void);  //serial port initialization
void serialPrintStr(char *buf);    //Function to print on serial port
int main()
{
unsigned char name[]={"  Invalid  "};
unsigned int a,b,c,m,n,q,r,i;
unsigned char msg[100];  //buffer
serial();
while(1)
{
//Assuming two digit inputs
	// Taking input for the first number
	while(!(U0LSR & 0x01));
	m = U0RBR;       //first digit of first number
	while(!(U0LSR & 0x20));
	U0THR = m;       //Display the first digit 
	while(!(U0LSR & 0x01));
	n = U0RBR;      //second digit of second number
	while(!(U0LSR & 0x20));
	U0THR = n;       //Display the second digit 
		a=((m-0x30)*10)+(n-0x30);   //Converting the first number from string to integer
	
	//Taking operator input
	while(!(U0LSR & 0x01));
	b = U0RBR;  //Operator
	while(!(U0LSR & 0x20));
	U0THR = b;
	
	//Taking input for second number
	while(!(U0LSR & 0x01));
	q = U0RBR;      //first digit of second number
	while(!(U0LSR & 0x20));
	U0THR = q;
	while(!(U0LSR & 0x01));
	r = U0RBR;      //second digit of second number
	while(!(U0LSR & 0x20));
	U0THR = r;
		c=((q-0x30)*10)+(r-0x30);    //Converting the second number from string to integer
		
	serialPrintStr("\n");
	if(b=='+')
		{
			serialPrintStr("Result\n");
			sprintf((char *)msg,"%d+%d=%d",a,c,a+c);
			serialPrintStr((char*)msg);
			serialPrintStr("\n\n");
			continue;
		}
	else if(b=='-')
		{
			serialPrintStr("Result\n");
			sprintf((char *)msg,"%d-%d=%d",a,c,a-c);
			serialPrintStr((char*)msg);
			serialPrintStr("\n\n");
			continue;
		}
	else if(b=='*')
		{
			serialPrintStr("Result\n");
			sprintf((char *)msg,"%d*%d=%d",a,c,a*c);
			serialPrintStr((char*)msg);	
			serialPrintStr("\n\n");
			continue;
		}
	else if(b=='/')
		{
			serialPrintStr("Result\n");
			sprintf((char *)msg,"%d/%d=%f",a,c,(double)a/c);
			serialPrintStr((char*)msg);
			serialPrintStr("\n\n");
			continue;
		}
	else
		{
		 for(i=0;i<12;i++)
		 { 
			 while(!(U0LSR & 0x20));
			 U0THR = name[i];
			}
		 serialPrintStr("\n\n");
		}
	}
}

void serialPrintStr(char *buf)
{
	int i=0;
	char ch;
	while((ch = buf[i++])!= '\0')
	  {
		  while(!(U0LSR & 0x20)){};
      U0THR= ch;   
	  }
}

void serial()
{
	PINSEL0 = 0x00000005;  // P0.0 & P0.1 ARE CONFIGURED AS TXD0 & RXD0
	U0LCR = 0x83;   /* 8 bits, no Parity, 1 Stop bit & DLAB = 1 */
	U0DLL = 0x61;   //BaudRate calculation
	U0LCR = 0x03;   /* 8 bits, no Parity, 1 Stop bit & DLAB = 0 */
}

void delay()
{
	unsigned int i;
	for(i=0;i<10000;i++);
}
