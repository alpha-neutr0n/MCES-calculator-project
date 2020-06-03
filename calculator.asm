#include<LPC214x.h>
#include <stdio.h>
void delay(void);
void serial(void);
void serialPrintStr(char * buf);    //Function to print on serial port
int main()
{
unsigned char name[]={"  Invalid  "};
unsigned int a,b,c,m,n,q,r,i;
unsigned char msg[100];
serial();
while(1)
{
//Assuming two digit inputs
	while(!(U0LSR & 0x01));
	m = U0RBR;       //first digit of first number
	while(!(U0LSR & 0x20));
	U0THR = m;       
	while(!(U0LSR & 0x01));
	n = U0RBR;      //second digit of second number
	while(!(U0LSR & 0x20));
	U0THR = n;
		a=((m-0x30)*10)+(n-0x30);   //Converting the first number from string to integer
	while(!(U0LSR & 0x01));
	b = U0RBR;  //Operator
	while(!(U0LSR & 0x20));
	U0THR = b;
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
			sprintf((char *)msg,"%d+%d=%d\x0d\xa\n",a,c,a+c);
			serialPrintStr((char*)msg);
			continue;
		}
	else if(b=='-')
		{
			serialPrintStr("Result\n");
			sprintf((char *)msg,"%d-%d=%d\x0d\xa\n",a,c,a-c);
			serialPrintStr((char*)msg);
			continue;
		}
	else if(b=='*')
		{
			serialPrintStr("Result\n");
			sprintf((char *)msg,"%d*%d=%d\x0d\xa\n",a,c,a*c);
			serialPrintStr((char*)msg);	
			continue;
		}
	else if(b=='/')
		{
			serialPrintStr("Result\n");
			sprintf((char *)msg,"%d/%d=%f\x0d\xa\n",a,c,(double)a/c);
			serialPrintStr((char*)msg);
			continue;
		}
	else
		{
		 for(i=0;i<12;i++)
		 { 
			 while(!(U0LSR & 0x20));
			 U0THR = name[i];
			}
		 serialPrintStr("\n");
		}
	}
}

void serialPrintStr(char * buf)
{
	int i=0;
	char ch;
	while((ch = buf[i++])!= '\0')
	  {
		  while((U0LSR & (1u<<5))== 0x00){}; 
      U0THR= ch;   
	  }
}

void serial()
{
	PINSEL0 = 0x00000005;
	U0LCR = 0x83;
	U0DLL = 0x61;
	U0LCR = 0x03;
}

void delay()
{
	unsigned int i;
	for(i=0;i<10000;i++);
}
