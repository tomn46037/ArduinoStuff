	.module AVR_GY-29.c
	.area text(rom, con, rel)
	.dbfile D:\MCU_Project\MCU_AVR\AVR_GY-29\AVR_GY-29.c
	.dbfile D:\MCU_Project\MCU_AVR\AVR_GY-29\delay.h
	.dbfunc e delay_1us _delay_1us fV
	.even
_delay_1us::
	.dbline -1
	.dbline 15
; /*-----------------------------------------------------------------------
; ��ʱ����
; ��������ICC-AVR v6.31A 
; Ŀ��оƬ : M16
; ʱ��: 8.0000Mhz
; -----------------------------------------------------------------------*/
; #ifndef __delay_h
; #define __delay_h
; void delay_nus(unsigned int n);
; void delay_nms(unsigned int n);
; void delay_1us(void);
; void delay_1ms(void) ; 
; 
; void delay_1us(void)                 //1us��ʱ����
;   {
	.dbline 16
;    asm("nop");
	nop
	.dbline 17
;    asm("nop");
	nop
	.dbline 18
;    asm("nop");
	nop
	.dbline 19
;    asm("nop");
	nop
	.dbline 20
;    asm("nop");
	nop
	.dbline -2
L1:
	.dbline 0 ; func end
	ret
	.dbend
	.dbfunc e delay_nus _delay_nus fV
;              i -> R20,R21
;              n -> R10,R11
	.even
_delay_nus::
	xcall push_xgset300C
	movw R10,R16
	.dbline -1
	.dbline 24
;   }
; 
; void delay_nus(unsigned int n)       //N us��ʱ����
;   {
	.dbline 25
;    unsigned int i=0;
	clr R20
	clr R21
	.dbline 26
;    for (i=0;i<n;i++)
	xjmp L6
L3:
	.dbline 27
;    delay_1us();
	xcall _delay_1us
L4:
	.dbline 26
	subi R20,255  ; offset = 1
	sbci R21,255
L6:
	.dbline 26
	cp R20,R10
	cpc R21,R11
	brlo L3
X0:
	.dbline -2
L2:
	.dbline 0 ; func end
	xjmp pop_xgset300C
	.dbsym r i 20 i
	.dbsym r n 10 i
	.dbend
	.dbfunc e delay_1ms _delay_1ms fV
;              i -> R16,R17
	.even
_delay_1ms::
	.dbline -1
	.dbline 31
;   }
;   
; void delay_1ms(void)                 //1ms��ʱ����
;   {
	.dbline 33
;    unsigned int i;
;    for (i=0;i<500;i++);
	clr R16
	clr R17
	xjmp L11
L8:
	.dbline 33
L9:
	.dbline 33
	subi R16,255  ; offset = 1
	sbci R17,255
L11:
	.dbline 33
	cpi R16,244
	ldi R30,1
	cpc R17,R30
	brlo L8
X1:
	.dbline -2
L7:
	.dbline 0 ; func end
	ret
	.dbsym r i 16 i
	.dbend
	.dbfunc e delay_nms _delay_nms fV
;              i -> R20,R21
;              n -> R10,R11
	.even
_delay_nms::
	xcall push_xgset300C
	movw R10,R16
	.dbline -1
	.dbline 37
;   }
;   
; void delay_nms(unsigned int n)       //N ms��ʱ����
;   {
	.dbline 38
;    unsigned int i=0;
	clr R20
	clr R21
	.dbline 39
;    for (i=0;i<n;i++)
	xjmp L16
L13:
	.dbline 40
;    delay_1ms();
	xcall _delay_1ms
L14:
	.dbline 39
	subi R20,255  ; offset = 1
	sbci R21,255
L16:
	.dbline 39
	cp R20,R10
	cpc R21,R11
	brlo L13
X2:
	.dbline -2
L12:
	.dbline 0 ; func end
	xjmp pop_xgset300C
	.dbsym r i 20 i
	.dbsym r n 10 i
	.dbend
	.dbfile D:\MCU_Project\MCU_AVR\AVR_GY-29\I2C.h
	.dbfunc e I2C_Write _I2C_Write fc
;          Wdata -> R18
;     RegAddress -> R16
	.even
_I2C_Write::
	.dbline -1
	.dbline 41
; #include <macros.h>
; #include "delay.h"
; 
; //ʹ��AVR�ڲ�Ӳ��iic�����Ŷ���
; //PC0->SCL  ;  PC1->SDA
; //I2C ״̬����
; //MT ����ʽ���� MR ����ʽ����
; #define START			0x08
; #define RE_START		0x10
; #define MT_SLA_ACK		0x18
; #define MT_SLA_NOACK 	0x20
; #define MT_DATA_ACK		0x28
; #define MT_DATA_NOACK	0x30
; #define MR_SLA_ACK		0x40
; #define MR_SLA_NOACK	0x48
; #define MR_DATA_ACK		0x50
; #define MR_DATA_NOACK	0x58	
; 	                            
; #define RD_DEVICE_ADDR  0xA7	   //����������IIC�����еĴӵ�ַ,����ALT ADDRESS��ַ���Ų�ͬ�޸�
; #define WD_DEVICE_ADDR  0xA6	   //ALT  ADDRESS���Žӵ�ʱ��ַΪ0xA6���ӵ�Դʱ��ַΪ0x3A
; 
; //����TWI����(��ģʽд�Ͷ�)
; #define Start()			(TWCR=(1<<TWINT)|(1<<TWSTA)|(1<<TWEN))		//����I2C
; #define Stop()			(TWCR=(1<<TWINT)|(1<<TWSTO)|(1<<TWEN))		//ֹͣI2C
; #define Wait()			{while(!(TWCR&(1<<TWINT)));}				//�ȴ��жϷ���
; #define TestAck()		(TWSR&0xf8)									//�۲췵��״̬
; #define SetAck			(TWCR|=(1<<TWEA))							//����ACKӦ��
; #define SetNoAck		(TWCR&=~(1<<TWEA))							//����Not AckӦ��
; #define Twi()			(TWCR=(1<<TWINT)|(1<<TWEN))				    //����I2C
; #define Write8Bit(x)	{TWDR=(x);TWCR=(1<<TWINT)|(1<<TWEN);}		//д���ݵ�TWDR
; 
; unsigned char I2C_Write(unsigned char RegAddress,unsigned char Wdata);
; unsigned char I2C_Read(unsigned RegAddress);
; 
; /*********************************************
; I2C����дһ���ֽ�
; ����0:д�ɹ�
; ����1:дʧ��
; **********************************************/
; unsigned char I2C_Write(unsigned char RegAddress,unsigned char Wdata)
; {
	.dbline 42
; 	  Start();						//I2C����
	ldi R24,164
	out 0x36,R24
	.dbline 43
; 	  Wait();
L18:
	.dbline 43
L19:
	.dbline 43
	in R2,0x36
	sbrs R2,7
	rjmp L18
X3:
	.dbline 43
	.dbline 43
	.dbline 44
; 	  if(TestAck()!=START) 
	in R24,0x1
	andi R24,248
	cpi R24,8
	breq L21
X4:
	.dbline 45
; 		return 1;					//ACK
	ldi R16,1
	xjmp L17
L21:
	.dbline 47
; 	  
; 	  Write8Bit(WD_DEVICE_ADDR);	//дI2C��������ַ��д��ʽ
	.dbline 47
	ldi R24,166
	out 0x3,R24
	.dbline 47
	ldi R24,132
	out 0x36,R24
	.dbline 47
	.dbline 47
	.dbline 48
; 	  Wait();
L23:
	.dbline 48
L24:
	.dbline 48
	in R2,0x36
	sbrs R2,7
	rjmp L23
X5:
	.dbline 48
	.dbline 48
	.dbline 49
; 	  if(TestAck()!=MT_SLA_ACK) 
	in R24,0x1
	andi R24,248
	cpi R24,24
	breq L26
X6:
	.dbline 50
; 		return 1;					//ACK
	ldi R16,1
	xjmp L17
L26:
	.dbline 52
; 	  
; 	  Write8Bit(RegAddress);		//д������Ӧ�Ĵ�����ַ
	.dbline 52
	out 0x3,R16
	.dbline 52
	ldi R24,132
	out 0x36,R24
	.dbline 52
	.dbline 52
	.dbline 53
; 	  Wait();
L28:
	.dbline 53
L29:
	.dbline 53
	in R2,0x36
	sbrs R2,7
	rjmp L28
X7:
	.dbline 53
	.dbline 53
	.dbline 54
; 	  if(TestAck()!=MT_DATA_ACK) 
	in R24,0x1
	andi R24,248
	cpi R24,40
	breq L31
X8:
	.dbline 55
; 	  	return 1;				    //ACK
	ldi R16,1
	xjmp L17
L31:
	.dbline 57
; 	  
; 	  Write8Bit(Wdata);			 	//д���ݵ�������Ӧ�Ĵ���
	.dbline 57
	out 0x3,R18
	.dbline 57
	ldi R24,132
	out 0x36,R24
	.dbline 57
	.dbline 57
	.dbline 58
; 	  Wait();
L33:
	.dbline 58
L34:
	.dbline 58
	in R2,0x36
	sbrs R2,7
	rjmp L33
X9:
	.dbline 58
	.dbline 58
	.dbline 59
; 	  if(TestAck()!=MT_DATA_ACK) 
	in R24,0x1
	andi R24,248
	cpi R24,40
	breq L36
X10:
	.dbline 60
; 	  	return 1;				    //ACK	 
	ldi R16,1
	xjmp L17
L36:
	.dbline 61
; 	  Stop();  						//I2Cֹͣ
	ldi R24,148
	out 0x36,R24
	.dbline 63
;  	//delay_nms(10);				//��ʱ  
; 	  return 0;
	clr R16
	.dbline -2
L17:
	.dbline 0 ; func end
	ret
	.dbsym r Wdata 18 c
	.dbsym r RegAddress 16 c
	.dbend
	.dbfunc e I2C_Read _I2C_Read fc
;           temp -> R10
;     RegAddress -> R16,R17
	.even
_I2C_Read::
	st -y,R10
	.dbline -1
	.dbline 74
; }
; 
; /*********************************************
; I2C���߶�һ���ֽ�
; ����0:���ɹ�
; ����1:��ʧ��
; **********************************************/
; 
; unsigned char I2C_Read(unsigned RegAddress)
; 
;  {
	.dbline 76
; 	   unsigned char temp;
; 	   Start();//I2C����
	ldi R24,164
	out 0x36,R24
	.dbline 77
; 	   Wait();
L39:
	.dbline 77
L40:
	.dbline 77
	in R2,0x36
	sbrs R2,7
	rjmp L39
X11:
	.dbline 77
	.dbline 77
	.dbline 78
; 	   if (TestAck()!=START) 
	in R24,0x1
	andi R24,248
	cpi R24,8
	breq L42
X12:
	.dbline 79
; 	   	  return 1;			 		//ACK	   
	ldi R16,1
	xjmp L38
L42:
	.dbline 81
; 	   
; 	   Write8Bit(WD_DEVICE_ADDR);	//дI2C��������ַ��д��ʽ
	.dbline 81
	ldi R24,166
	out 0x3,R24
	.dbline 81
	ldi R24,132
	out 0x36,R24
	.dbline 81
	.dbline 81
	.dbline 82
; 	   Wait(); 
L44:
	.dbline 82
L45:
	.dbline 82
	in R2,0x36
	sbrs R2,7
	rjmp L44
X13:
	.dbline 82
	.dbline 82
	.dbline 83
; 	   if (TestAck()!=MT_SLA_ACK) 
	in R24,0x1
	andi R24,248
	cpi R24,24
	breq L47
X14:
	.dbline 84
; 	   	  return 1;				    //ACK
	ldi R16,1
	xjmp L38
L47:
	.dbline 86
; 	   
; 	   Write8Bit(RegAddress);		//д������Ӧ�Ĵ�����ַ
	.dbline 86
	out 0x3,R16
	.dbline 86
	ldi R24,132
	out 0x36,R24
	.dbline 86
	.dbline 86
	.dbline 87
; 	   Wait();
L49:
	.dbline 87
L50:
	.dbline 87
	in R2,0x36
	sbrs R2,7
	rjmp L49
X15:
	.dbline 87
	.dbline 87
	.dbline 88
; 	   if (TestAck()!=MT_DATA_ACK) 
	in R24,0x1
	andi R24,248
	cpi R24,40
	breq L52
X16:
	.dbline 89
; 	   	  return 1;
	ldi R16,1
	xjmp L38
L52:
	.dbline 91
; 	   
; 	   Start();	   				   	//I2C��������
	ldi R24,164
	out 0x36,R24
	.dbline 92
; 	   Wait();
L54:
	.dbline 92
L55:
	.dbline 92
	in R2,0x36
	sbrs R2,7
	rjmp L54
X17:
	.dbline 92
	.dbline 92
	.dbline 93
; 	   if (TestAck()!=RE_START)  
	in R24,0x1
	andi R24,248
	cpi R24,16
	breq L57
X18:
	.dbline 94
; 	   	  return 1;
	ldi R16,1
	xjmp L38
L57:
	.dbline 96
; 	   
; 	   Write8Bit(RD_DEVICE_ADDR);	//дI2C��������ַ�Ͷ���ʽ
	.dbline 96
	ldi R24,167
	out 0x3,R24
	.dbline 96
	ldi R24,132
	out 0x36,R24
	.dbline 96
	.dbline 96
	.dbline 97
; 	   Wait();
L59:
	.dbline 97
L60:
	.dbline 97
	in R2,0x36
	sbrs R2,7
	rjmp L59
X19:
	.dbline 97
	.dbline 97
	.dbline 98
; 	   if(TestAck()!=MR_SLA_ACK)  
	in R24,0x1
	andi R24,248
	cpi R24,64
	breq L62
X20:
	.dbline 99
; 	   	  return 1;				   //ACK
	ldi R16,1
	xjmp L38
L62:
	.dbline 101
; 	   
; 	   Twi();	 				   //������I2C����ʽ
	ldi R24,132
	out 0x36,R24
	.dbline 102
; 	   Wait();
L64:
	.dbline 102
L65:
	.dbline 102
	in R2,0x36
	sbrs R2,7
	rjmp L64
X21:
	.dbline 102
	.dbline 102
	.dbline 103
; 	   if(TestAck()!=MR_DATA_NOACK) 
	in R24,0x1
	andi R24,248
	cpi R24,88
	breq L67
X22:
	.dbline 104
; 	   	 return 1;					//ACK	
	ldi R16,1
	xjmp L38
L67:
	.dbline 106
; 	   
; 	   temp=TWDR;//��ȡI2C��������
	in R10,0x3
	.dbline 107
;        Stop();//I2Cֹͣ
	ldi R24,148
	out 0x36,R24
	.dbline 108
; 	   return temp;
	mov R16,R10
	.dbline -2
L38:
	.dbline 0 ; func end
	ld R10,y+
	ret
	.dbsym r temp 10 c
	.dbsym r RegAddress 16 i
	.dbend
	.dbfile D:\MCU_Project\MCU_AVR\AVR_GY-29\1602.h
	.dbfunc e LCD_init _LCD_init fV
	.even
_LCD_init::
	.dbline -1
	.dbline 44
; /* �÷���
;    LCD_init();
;    LCD_write_string(��,��,"�ַ���");
;    LCD_write_char(��,��,'�ַ�'); 
;  ---------------------------------------------------------------
; ������AVR��LCD������Ϣ
;   PC6 ->RS
;   PC7 ->EN
;   ��  ->RW
;   PA4 ->D4
;   PA5 ->D5
;   PA6 ->D6
;   PA7 ->D7
; ʹ�ö˿ڣ�1602:PC6,PC7,PA4~PA7 	
; Ҫʹ�ñ��������ı�����������Ϣ����
; -----------------------------------------------------------------*/
; #define LCD_EN_PORT    PORTC   //����2��Ҫ��Ϊͬһ����
; #define LCD_EN_DDR     DDRC
; #define LCD_RS_PORT    PORTC   //����2��Ҫ��Ϊͬһ����
; #define LCD_RS_DDR     DDRC
; #define LCD_DATA_PORT  PORTA   //����3��Ҫ��Ϊͬһ����
; #define LCD_DATA_DDR   DDRA    //Ĭ����������߱���ʹ�ø���λ�˿�,���������ע���޸�
; #define LCD_DATA_PIN   PINA
; #define LCD_RS         (1<<PC6) //0x20   portC6       out
; #define LCD_EN         (1<<PC7) //0x40   portC7       out
; #define LCD_DATA       ((1<<PA4)|(1<<PA5)|(1<<PA6)|(1<<PA7)) //0xf0   portA 4/5/6/7 out
; /*--------------------------------------------------------------------------------------------------
; ����˵��
; --------------------------------------------------------------------------------------------------*/
; void LCD_init(void);
; void LCD_en_write(void);
; void LCD_write_command(unsigned  char command) ;
; void LCD_write_data(unsigned char data);
; void LCD_set_xy (unsigned char x, unsigned char y);
; void LCD_write_string(unsigned char X,unsigned char Y,unsigned char *s);
; void LCD_write_char(unsigned char X,unsigned char Y,unsigned char data);
; 
; //-----------------------------------------------------------------------------------------
; 
; #include <macros.h>
; #include "delay.h"
; 
; void LCD_init(void)         //Һ����ʼ��
; {
	.dbline 45
;   LCD_DATA_DDR|=LCD_DATA;   //���ݿڷ���Ϊ���
	in R24,0x1a
	ori R24,240
	out 0x1a,R24
	.dbline 46
;   LCD_EN_DDR|=LCD_EN;       //����EN����Ϊ���
	sbi 0x14,7
	.dbline 47
;   LCD_RS_DDR|=LCD_RS;       //����RS����Ϊ���
	sbi 0x14,6
	.dbline 48
;   LCD_write_command(0x28); 
	ldi R16,40
	xcall _LCD_write_command
	.dbline 49
;   LCD_en_write();
	xcall _LCD_en_write
	.dbline 50
;   delay_nus(40);
	ldi R16,40
	ldi R17,0
	xcall _delay_nus
	.dbline 51
;   LCD_write_command(0x28);  //4λ��ʾ
	ldi R16,40
	xcall _LCD_write_command
	.dbline 52
;   LCD_write_command(0x0c);  //��ʾ��
	ldi R16,12
	xcall _LCD_write_command
	.dbline 53
;   LCD_write_command(0x01);  //����
	ldi R16,1
	xcall _LCD_write_command
	.dbline 54
;   delay_nms(10);
	ldi R16,10
	ldi R17,0
	xcall _delay_nms
	.dbline -2
L69:
	.dbline 0 ; func end
	ret
	.dbend
	.dbfunc e LCD_en_write _LCD_en_write fV
	.even
_LCD_en_write::
	.dbline -1
	.dbline 58
; }
; 
; void LCD_en_write(void)  //Һ��ʹ��
; {
	.dbline 59
;   LCD_EN_PORT|=LCD_EN;
	sbi 0x15,7
	.dbline 60
;   delay_nus(1);
	ldi R16,1
	ldi R17,0
	xcall _delay_nus
	.dbline 61
;   LCD_EN_PORT&=~LCD_EN;
	cbi 0x15,7
	.dbline -2
L70:
	.dbline 0 ; func end
	ret
	.dbend
	.dbfunc e LCD_write_command _LCD_write_command fV
;        command -> R20
	.even
_LCD_write_command::
	st -y,R20
	mov R20,R16
	.dbline -1
	.dbline 65
; }
; 
; void LCD_write_command(unsigned char command) //дָ��
; {
	.dbline 67
;   //����Ϊ��4λ��д��
;   delay_nus(16);
	ldi R16,16
	ldi R17,0
	xcall _delay_nus
	.dbline 68
;   LCD_RS_PORT&=~LCD_RS;        //RS=0
	cbi 0x15,6
	.dbline 69
;   LCD_DATA_PORT&=0X0f;         //�����λ
	in R24,0x1b
	andi R24,15
	out 0x1b,R24
	.dbline 70
;   LCD_DATA_PORT|=command&0xf0; //д����λ
	mov R24,R20
	andi R24,240
	in R2,0x1b
	or R2,R24
	out 0x1b,R2
	.dbline 71
;   LCD_en_write();
	xcall _LCD_en_write
	.dbline 72
;   command=command<<4;          //����λ�Ƶ�����λ
	mov R24,R20
	andi R24,#0x0F
	swap R24
	mov R20,R24
	.dbline 73
;   LCD_DATA_PORT&=0x0f;         //�����λ
	in R24,0x1b
	andi R24,15
	out 0x1b,R24
	.dbline 74
;   LCD_DATA_PORT|=command&0xf0; //д����λ
	mov R24,R20
	andi R24,240
	in R2,0x1b
	or R2,R24
	out 0x1b,R2
	.dbline 75
;   LCD_en_write();
	xcall _LCD_en_write
	.dbline -2
L71:
	.dbline 0 ; func end
	ld R20,y+
	ret
	.dbsym r command 20 c
	.dbend
	.dbfunc e LCD_write_data _LCD_write_data fV
;           data -> R20
	.even
_LCD_write_data::
	st -y,R20
	mov R20,R16
	.dbline -1
	.dbline 92
;  
; /*
;   //����Ϊ����λ��д��
;   delay_nus(16);
;   LCD_RS_PORT&=~LCD_RS;        //RS=0
;   LCD_DATA_PORT&=0xf0;         //�����λ
;   LCD_DATA_PORT|=(command>>4)&0x0f; //д����λ
;   LCD_en_write();
;   LCD_DATA_PORT&=0xf0;         //�����λ
;   LCD_DATA_PORT|=command&0x0f; //д����λ
;   LCD_en_write(); 
; */
;   
; }
; 
; void LCD_write_data(unsigned char data) //д����
; {
	.dbline 94
;   //����Ϊ��4λ��д��
;   delay_nus(16);
	ldi R16,16
	ldi R17,0
	xcall _delay_nus
	.dbline 95
;   LCD_RS_PORT|=LCD_RS;       //RS=1
	sbi 0x15,6
	.dbline 96
;   LCD_DATA_PORT&=0X0f;       //�����λ
	in R24,0x1b
	andi R24,15
	out 0x1b,R24
	.dbline 97
;   LCD_DATA_PORT|=data&0xf0;  //д����λ
	mov R24,R20
	andi R24,240
	in R2,0x1b
	or R2,R24
	out 0x1b,R2
	.dbline 98
;   LCD_en_write();
	xcall _LCD_en_write
	.dbline 99
;   data=data<<4;               //����λ�Ƶ�����λ
	mov R24,R20
	andi R24,#0x0F
	swap R24
	mov R20,R24
	.dbline 100
;   LCD_DATA_PORT&=0X0f;        //�����λ
	in R24,0x1b
	andi R24,15
	out 0x1b,R24
	.dbline 101
;   LCD_DATA_PORT|=data&0xf0;   //д����λ
	mov R24,R20
	andi R24,240
	in R2,0x1b
	or R2,R24
	out 0x1b,R2
	.dbline 102
;   LCD_en_write();
	xcall _LCD_en_write
	.dbline -2
L72:
	.dbline 0 ; func end
	ld R20,y+
	ret
	.dbsym r data 20 c
	.dbend
	.dbfunc e LCD_set_xy _LCD_set_xy fV
;        address -> R20
;              y -> R10
;              x -> R22
	.even
_LCD_set_xy::
	xcall push_xgsetF00C
	mov R10,R18
	mov R22,R16
	.dbline -1
	.dbline 121
;   
; /*
;   //����Ϊ����λ��д�� 
;   delay_nus(16);
;   LCD_RS_PORT|=LCD_RS;       //RS=1
;   LCD_DATA_PORT&=0Xf0;       //�����λ
;   LCD_DATA_PORT|=(data>>4)&0x0f;  //д����λ
;   LCD_en_write();
;  
;   LCD_DATA_PORT&=0Xf0;        //�����λ
;   LCD_DATA_PORT|=data&0x0f;   //д����λ
;   LCD_en_write();
; */
;   
; }
; 
; 
; void LCD_set_xy( unsigned char x, unsigned char y )  //д��ַ����
; {
	.dbline 123
;     unsigned char address;
;     if (y == 0) address = 0x80 + x;
	tst R10
	brne L74
X23:
	.dbline 123
	mov R20,R22
	subi R20,128    ; addi 128
	xjmp L75
L74:
	.dbline 124
;     else   address = 0xc0 + x;
	mov R20,R22
	subi R20,64    ; addi 192
L75:
	.dbline 125
;     LCD_write_command( address);
	mov R16,R20
	xcall _LCD_write_command
	.dbline -2
L73:
	.dbline 0 ; func end
	xjmp pop_xgsetF00C
	.dbsym r address 20 c
	.dbsym r y 10 c
	.dbsym r x 22 c
	.dbend
	.dbfunc e LCD_write_string _LCD_write_string fV
;              s -> R20,R21
;              Y -> R12
;              X -> R10
	.even
_LCD_write_string::
	xcall push_xgset303C
	mov R12,R18
	mov R10,R16
	ldd R20,y+6
	ldd R21,y+7
	.dbline -1
	.dbline 129
; }
;   
; void LCD_write_string(unsigned char X,unsigned char Y,unsigned char *s) //��x=0~15,��y=0,1
; {
	.dbline 130
;     LCD_set_xy( X, Y ); //д��ַ    
	mov R18,R12
	mov R16,R10
	xcall _LCD_set_xy
	xjmp L78
L77:
	.dbline 132
;     while (*s)  // д��ʾ�ַ�
;     {
	.dbline 133
;       LCD_write_data( *s );
	movw R30,R20
	ldd R16,z+0
	xcall _LCD_write_data
	.dbline 134
;       s ++;
	subi R20,255  ; offset = 1
	sbci R21,255
	.dbline 135
;     }
L78:
	.dbline 131
	movw R30,R20
	ldd R2,z+0
	tst R2
	brne L77
X24:
	.dbline -2
L76:
	.dbline 0 ; func end
	xjmp pop_xgset303C
	.dbsym r s 20 pc
	.dbsym r Y 12 c
	.dbsym r X 10 c
	.dbend
	.dbfunc e LCD_write_char _LCD_write_char fV
;           data -> y+2
;              Y -> R12
;              X -> R10
	.even
_LCD_write_char::
	st -y,R10
	st -y,R12
	mov R12,R18
	mov R10,R16
	.dbline -1
	.dbline 140
;       
; }
; 
; void LCD_write_char(unsigned char X,unsigned char Y,unsigned char data) //��x=0~15,��y=0,1
; {
	.dbline 141
;   LCD_set_xy( X, Y ); //д��ַ
	mov R18,R12
	mov R16,R10
	xcall _LCD_set_xy
	.dbline 142
;   LCD_write_data( data);
	ldd R16,y+2
	xcall _LCD_write_data
	.dbline -2
L80:
	.dbline 0 ; func end
	ld R12,y+
	ld R10,y+
	ret
	.dbsym l data 2 c
	.dbsym r Y 12 c
	.dbsym r X 10 c
	.dbend
	.area data(ram, con, rel)
	.dbfile D:\MCU_Project\MCU_AVR\AVR_GY-29\1602.h
_display::
	.blkb 2
	.area idata
	.byte 0,0
	.area data(ram, con, rel)
	.dbfile D:\MCU_Project\MCU_AVR\AVR_GY-29\1602.h
	.blkb 2
	.area idata
	.byte 0,'g
	.area data(ram, con, rel)
	.dbfile D:\MCU_Project\MCU_AVR\AVR_GY-29\1602.h
	.dbfile D:\MCU_Project\MCU_AVR\AVR_GY-29\AVR_GY-29.c
	.dbsym e display _display A[4:4]c
	.area text(rom, con, rel)
	.dbfile D:\MCU_Project\MCU_AVR\AVR_GY-29\AVR_GY-29.c
	.dbfunc e conversion _conversion fV
;              i -> R10,R11
	.even
_conversion::
	st -y,R10
	st -y,R11
	movw R10,R16
	.dbline -1
	.dbline 26
; /*****************************************
; * ����AVR��Ƭ��GY-29ģ��ͨ�ų��� 		 *
; * ��    �ܣ�IICͨ�Ŷ�ȡ���ݲ���ʾ        *
; * ʱ��Ƶ�ʣ��ڲ�1M 						 *
; * ��    �ƣ����˵���					 *
; * �޸����ڣ�2011��4��20��				 *
; * ���뻷����ICC-AVR7.14					 *
; * ʵ�黷����ATmega16+1602    			 *
; * ʹ�ö˿ڣ�PC0,PC1,PC6,PC7,PA4~PA7 	 *
; * ��    ����Ī����ʵ�����24c02��ȡʵ��  *
; *****************************************/
; #include <iom16v.h>
; #include "I2C.h"
; #include "1602.h"
; #include "delay.h"
; void conversion(unsigned int i);
; void ADXL345_init(void); 
; unsigned char display[4]={0,0,0,'g'};//��ʾ����
; 
; /*********************************************
; ����ת��,ʮ����������ת����10����
; ����ʮ�����Ʒ�Χ��0x0000-0x270f��0-9999��
; ����ֳɸ�ʮ��ǧλ����ascii������ʾ��
; **********************************************/
; void conversion(unsigned int i)  
; {  
	.dbline 29
;   // 	display[0]=i/10000+0x30 ;
;   //  i=i%10000;    //ȡ������
; 	display[0]=i/1000+0x30 ;
	ldi R18,1000
	ldi R19,3
	movw R16,R10
	xcall div16u
	movw R24,R16
	adiw R24,48
	sts _display,R24
	.dbline 30
;     i=i%1000;    //ȡ������
	ldi R18,1000
	ldi R19,3
	movw R16,R10
	xcall mod16u
	movw R10,R16
	.dbline 31
;     display[1]=i/100+0x30 ;
	ldi R18,100
	ldi R19,0
	xcall div16u
	movw R24,R16
	adiw R24,48
	sts _display+1,R24
	.dbline 32
;     i=i%100;    //ȡ������
	ldi R18,100
	ldi R19,0
	movw R16,R10
	xcall mod16u
	movw R10,R16
	.dbline 33
;     display[2]=i/10+0x30 ;
	ldi R18,10
	ldi R19,0
	xcall div16u
	movw R24,R16
	adiw R24,48
	sts _display+2,R24
	.dbline -2
L81:
	.dbline 0 ; func end
	ld R11,y+
	ld R10,y+
	ret
	.dbsym r i 10 i
	.dbend
	.dbfunc e display_x _display_x fV
;           temp -> y+1
;              x -> R20,R21
	.even
_display_x::
	st -y,R20
	st -y,R21
	sbiw R28,5
	.dbline -1
	.dbline 40
;  //  i=i%10;     //ȡ������
;  //   display[3]=i+0x30;  
; }
; //*******************************
; //��ʾx
; void display_x(void)
; {   float temp;
	.dbline 43
;     int x;
; 
;      x=I2C_Read(0x33);
	ldi R16,51
	ldi R17,0
	xcall _I2C_Read
	mov R20,R16
	clr R21
	.dbline 44
; 	 x=(x<<8)+I2C_Read(0x32);
	ldi R16,50
	ldi R17,0
	xcall _I2C_Read
	mov R21,R20
	mov R20,R16
	.dbline 46
; 	 
; 	if(x<0){
	cpi R20,0
	ldi R30,0
	cpc R21,R30
	brge L85
X25:
	.dbline 46
	.dbline 47
; 	 x=-x;
	com R20
	com R21
	subi R20,0xFF
	sbci R21,0xFF
	.dbline 48
;      LCD_write_char(2,0,'-');       //��ʾ������λ
	ldi R24,45
	std y+0,R24
	clr R18
	ldi R16,2
	xcall _LCD_write_char
	.dbline 49
; 	}
	xjmp L86
L85:
	.dbline 51
; 	else 
; 	LCD_write_char(2,0,' ');        //��ʾ�ո�
	ldi R24,32
	std y+0,R24
	clr R18
	ldi R16,2
	xcall _LCD_write_char
L86:
	.dbline 52
;     temp=(float)x*3.9;  //�������ݺ���ʾ,�鿼ADXL345�������ŵ�4ҳ
	ldi R16,<L87
	ldi R17,>L87
	xcall elpm32
	movw R2,R16
	movw R4,R18
	movw R16,R20
	xcall int2fp
	st -y,R19
	st -y,R18
	st -y,R17
	st -y,R16
	movw R16,R2
	movw R18,R4
	xcall fpmule2
	std y+1,R16
	std y+2,R17
	std y+3,R18
	std y+4,R19
	.dbline 53
;     conversion(temp);          //ת������ʾ��Ҫ������
	ldd R16,y+1
	ldd R17,y+2
	ldd R18,y+3
	ldd R19,y+4
	xcall fpint
	xcall _conversion
	.dbline 54
; 	LCD_write_char(0,0,'X');   //��0�У���0�� ��ʾX
	ldi R24,88
	std y+0,R24
	clr R18
	clr R16
	xcall _LCD_write_char
	.dbline 55
;     LCD_write_char(1,0,':'); 
	ldi R24,58
	std y+0,R24
	clr R18
	ldi R16,1
	xcall _LCD_write_char
	.dbline 56
;     LCD_write_char(3,0,display[0]); 
	lds R2,_display
	std y+0,R2
	clr R18
	ldi R16,3
	xcall _LCD_write_char
	.dbline 57
; 	LCD_write_char(4,0,'.'); 
	ldi R24,46
	std y+0,R24
	clr R18
	ldi R16,4
	xcall _LCD_write_char
	.dbline 58
;     LCD_write_char(5,0,display[1]); 
	lds R2,_display+1
	std y+0,R2
	clr R18
	ldi R16,5
	xcall _LCD_write_char
	.dbline 59
;     LCD_write_char(6,0,display[2]); 
	lds R2,_display+2
	std y+0,R2
	clr R18
	ldi R16,6
	xcall _LCD_write_char
	.dbline 60
; 	LCD_write_char(7,0,'g'); 
	ldi R24,103
	std y+0,R24
	clr R18
	ldi R16,7
	xcall _LCD_write_char
	.dbline -2
L84:
	.dbline 0 ; func end
	adiw R28,5
	ld R21,y+
	ld R20,y+
	ret
	.dbsym l temp 1 D
	.dbsym r x 20 I
	.dbend
	.dbfunc e display_y _display_y fV
;           temp -> y+1
;              y -> R20,R21
	.even
_display_y::
	st -y,R20
	st -y,R21
	sbiw R28,5
	.dbline -1
	.dbline 66
; 
; }
; //*******************************
; //��ʾy
; void display_y(void)
; {   float temp;
	.dbline 68
;     int y;
;      y=I2C_Read(0x35);
	ldi R16,53
	ldi R17,0
	xcall _I2C_Read
	mov R20,R16
	clr R21
	.dbline 69
; 	 y=(y<<8)+I2C_Read(0x34);
	ldi R16,52
	ldi R17,0
	xcall _I2C_Read
	mov R21,R20
	mov R20,R16
	.dbline 71
; 	 
; 	if(y<0){
	cpi R20,0
	ldi R30,0
	cpc R21,R30
	brge L91
X26:
	.dbline 71
	.dbline 72
; 	 y=-y;
	com R20
	com R21
	subi R20,0xFF
	sbci R21,0xFF
	.dbline 73
;      LCD_write_char(2,1,'-');       //��ʾ������λ
	ldi R24,45
	std y+0,R24
	ldi R18,1
	ldi R16,2
	xcall _LCD_write_char
	.dbline 74
; 	}
	xjmp L92
L91:
	.dbline 76
; 	else 
; 	LCD_write_char(2,1,' ');        //��ʾ�ո�
	ldi R24,32
	std y+0,R24
	ldi R18,1
	ldi R16,2
	xcall _LCD_write_char
L92:
	.dbline 77
;     temp=(float)y*3.9;  //�������ݺ���ʾ,�鿼ADXL345�������ŵ�4ҳ
	ldi R16,<L87
	ldi R17,>L87
	xcall elpm32
	movw R2,R16
	movw R4,R18
	movw R16,R20
	xcall int2fp
	st -y,R19
	st -y,R18
	st -y,R17
	st -y,R16
	movw R16,R2
	movw R18,R4
	xcall fpmule2
	std y+1,R16
	std y+2,R17
	std y+3,R18
	std y+4,R19
	.dbline 78
;     conversion(temp);          //ת������ʾ��Ҫ������
	ldd R16,y+1
	ldd R17,y+2
	ldd R18,y+3
	ldd R19,y+4
	xcall fpint
	xcall _conversion
	.dbline 79
; 	LCD_write_char(0,1,'y');   //��0�У���0�� ��ʾX
	ldi R24,121
	std y+0,R24
	ldi R18,1
	clr R16
	xcall _LCD_write_char
	.dbline 80
;     LCD_write_char(1,1,':'); 
	ldi R24,58
	std y+0,R24
	ldi R18,1
	ldi R16,1
	xcall _LCD_write_char
	.dbline 81
;     LCD_write_char(3,1,display[0]); 
	lds R2,_display
	std y+0,R2
	ldi R18,1
	ldi R16,3
	xcall _LCD_write_char
	.dbline 82
; 	LCD_write_char(4,1,'.'); 
	ldi R24,46
	std y+0,R24
	ldi R18,1
	ldi R16,4
	xcall _LCD_write_char
	.dbline 83
;     LCD_write_char(5,1,display[1]); 
	lds R2,_display+1
	std y+0,R2
	ldi R18,1
	ldi R16,5
	xcall _LCD_write_char
	.dbline 84
;     LCD_write_char(6,1,display[2]); 
	lds R2,_display+2
	std y+0,R2
	ldi R18,1
	ldi R16,6
	xcall _LCD_write_char
	.dbline 85
; 	LCD_write_char(7,1,'g'); 
	ldi R24,103
	std y+0,R24
	ldi R18,1
	ldi R16,7
	xcall _LCD_write_char
	.dbline -2
L90:
	.dbline 0 ; func end
	adiw R28,5
	ld R21,y+
	ld R20,y+
	ret
	.dbsym l temp 1 D
	.dbsym r y 20 I
	.dbend
	.dbfunc e display_z _display_z fV
;           temp -> y+1
;              z -> R20,R21
	.even
_display_z::
	st -y,R20
	st -y,R21
	sbiw R28,5
	.dbline -1
	.dbline 91
; }
; 
; //*******************************
; //��ʾz
; void display_z(void)
; {   float temp;
	.dbline 94
;     int z;
; 
;      z=I2C_Read(0x37);
	ldi R16,55
	ldi R17,0
	xcall _I2C_Read
	mov R20,R16
	clr R21
	.dbline 95
; 	 z=(z<<8)+I2C_Read(0x36);
	ldi R16,54
	ldi R17,0
	xcall _I2C_Read
	mov R21,R20
	mov R20,R16
	.dbline 97
; 	 
; 	if(z<0){
	cpi R20,0
	ldi R30,0
	cpc R21,R30
	brge L96
X27:
	.dbline 97
	.dbline 98
; 	 z=-z;
	com R20
	com R21
	subi R20,0xFF
	sbci R21,0xFF
	.dbline 99
;      LCD_write_char(10,1,'-');       //��ʾ������λ
	ldi R24,45
	std y+0,R24
	ldi R18,1
	ldi R16,10
	xcall _LCD_write_char
	.dbline 100
; 	}
	xjmp L97
L96:
	.dbline 102
; 	else 
; 	LCD_write_char(10,1,' ');        //��ʾ�ո�
	ldi R24,32
	std y+0,R24
	ldi R18,1
	ldi R16,10
	xcall _LCD_write_char
L97:
	.dbline 103
;     temp=(float)z*3.9;  //�������ݺ���ʾ,�鿼ADXL345�������ŵ�4ҳ
	ldi R16,<L87
	ldi R17,>L87
	xcall elpm32
	movw R2,R16
	movw R4,R18
	movw R16,R20
	xcall int2fp
	st -y,R19
	st -y,R18
	st -y,R17
	st -y,R16
	movw R16,R2
	movw R18,R4
	xcall fpmule2
	std y+1,R16
	std y+2,R17
	std y+3,R18
	std y+4,R19
	.dbline 104
;     conversion(temp);          //ת������ʾ��Ҫ������
	ldd R16,y+1
	ldd R17,y+2
	ldd R18,y+3
	ldd R19,y+4
	xcall fpint
	xcall _conversion
	.dbline 105
; 	LCD_write_char(10,0,'z');   //��0�У���0�� ��ʾX
	ldi R24,122
	std y+0,R24
	clr R18
	ldi R16,10
	xcall _LCD_write_char
	.dbline 106
;     LCD_write_char(11,0,':'); 
	ldi R24,58
	std y+0,R24
	clr R18
	ldi R16,11
	xcall _LCD_write_char
	.dbline 107
;     LCD_write_char(11,1,display[0]); 
	lds R2,_display
	std y+0,R2
	ldi R18,1
	ldi R16,11
	xcall _LCD_write_char
	.dbline 108
; 	LCD_write_char(12,1,'.'); 
	ldi R24,46
	std y+0,R24
	ldi R18,1
	ldi R16,12
	xcall _LCD_write_char
	.dbline 109
;     LCD_write_char(13,1,display[1]); 
	lds R2,_display+1
	std y+0,R2
	ldi R18,1
	ldi R16,13
	xcall _LCD_write_char
	.dbline 110
;     LCD_write_char(14,1,display[2]); 
	lds R2,_display+2
	std y+0,R2
	ldi R18,1
	ldi R16,14
	xcall _LCD_write_char
	.dbline 111
; 	LCD_write_char(15,1,'g'); 
	ldi R24,103
	std y+0,R24
	ldi R18,1
	ldi R16,15
	xcall _LCD_write_char
	.dbline -2
L95:
	.dbline 0 ; func end
	adiw R28,5
	ld R21,y+
	ld R20,y+
	ret
	.dbsym l temp 1 D
	.dbsym r z 20 I
	.dbend
	.dbfunc e ADXL345_init _ADXL345_init fV
	.even
_ADXL345_init::
	.dbline -1
	.dbline 117
; 
; }
; 
; //***********************************************
; void ADXL345_init(void)             //adxl345��ʼ��
; {
	.dbline 118
; 	 I2C_Write(0x31,0x0B);   //������Χ,����16g��13λģʽ
	ldi R18,11
	ldi R16,49
	xcall _I2C_Write
	.dbline 119
; 	 I2C_Write(0x2C,0x08);   //�����趨Ϊ12.5 �ο�pdf13ҳ
	ldi R18,8
	ldi R16,44
	xcall _I2C_Write
	.dbline 120
; 	 I2C_Write(0x2D,0x08);   //ѡ���Դģʽ   �ο�pdf24ҳ
	ldi R18,8
	ldi R16,45
	xcall _I2C_Write
	.dbline 121
; 	 I2C_Write(0x2E,0x80);   //ʹ�� DATA_READY �ж�
	ldi R18,128
	ldi R16,46
	xcall _I2C_Write
	.dbline 122
; 	 I2C_Write(0x1E,0x00);   //X ƫ���� ���ݲ��Դ�������״̬д��pdf29ҳ
	clr R18
	ldi R16,30
	xcall _I2C_Write
	.dbline 123
; 	 I2C_Write(0x1F,0x00);   //Y ƫ���� ���ݲ��Դ�������״̬д��pdf29ҳ
	clr R18
	ldi R16,31
	xcall _I2C_Write
	.dbline 124
; 	 I2C_Write(0x20,0x05);   //Z ƫ���� ���ݲ��Դ�������״̬д��pdf29ҳ
	ldi R18,5
	ldi R16,32
	xcall _I2C_Write
	.dbline -2
L100:
	.dbline 0 ; func end
	ret
	.dbend
	.dbfunc e main _main fV
;              i -> <dead>
	.even
_main::
	.dbline -1
	.dbline 131
; }
; 
; /*******************************
; ������
; *******************************/
; void main(void)
; {	
	.dbline 134
; 	unsigned char i;
; 		
; 	 delay_nms(20);          //lcd�ϵ���ʱ
	ldi R16,20
	ldi R17,0
	xcall _delay_nms
	.dbline 135
; 	 LCD_init();             //lcd��ʼ��
	xcall _LCD_init
	.dbline 136
; 	 ADXL345_init(); 
	xcall _ADXL345_init
	xjmp L103
L102:
	.dbline 138
;      
; 	while(1){               //ѭ��  
	.dbline 140
; 	
; 	display_x();      //��ʾx
	xcall _display_x
	.dbline 141
; 	display_y();      //��ʾy
	xcall _display_y
	.dbline 142
; 	display_z();      //��ʾz
	xcall _display_z
	.dbline 144
; 
; 	delay_nms(100); 
	ldi R16,100
	ldi R17,0
	xcall _delay_nms
	.dbline 145
;     }
L103:
	.dbline 138
	xjmp L102
X28:
	.dbline -2
L101:
	.dbline 0 ; func end
	ret
	.dbsym l i 1 c
	.dbend
	.area lit(rom, con, rel)
L87:
	.word 0x999a,0x4079
; }
; 
