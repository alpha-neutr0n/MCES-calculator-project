#include<LPC214x.h>
#include <stdio.h>
void delay(void);
void serial(void);
void serialPrintStr(char * buf);
int main()
{
unsigned char name[]={"  Invalid  "};
unsigned int a,b,c,s,res,i;
unsigned char msg[100];
serial();
while(1)
{

while(!(U0LSR & 0x01));
a = U0RBR;
while(!(U0LSR & 0x20));
U0THR = a;

while(!(U0LSR & 0x01));
b = U0RBR;
while(!(U0LSR & 0x20));
U0THR = b;

while(!(U0LSR & 0x01));
c = U0RBR;
while(!(U0LSR & 0x20));
U0THR = c;

if(b=='+')
{
   res=(a+c)-0x30;
}
else if(b=='-')
{
   res=(a-c)+0x30;
}

else if(b=='*')
{
   //res=((a-0x30)*(c-0x30))+0x30;
	sprintf((char *)msg,"%c*%c=%d\x0d\xa",a,c,(a-0x30)*(c-0x30));
	serialPrintStr("\n");
	serialPrintStr((char*)msg);	
	continue;
}
else if(b=='/')
{
   res=((a-0x30)/(c-0x30))+0x30;
}

else
{
 for(i=0;i<12;i++)
 { 
   while(!(U0LSR & 0x20));
   U0THR = name[i];
}
}

while(!(U0LSR & 0x01));
s = U0RBR;
while(!(U0LSR & 0x20));
U0THR = s;
serialPrintStr("Result\n");
while(!(U0LSR & 0x20));
U0THR = res;
serialPrintStr("\n");
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
