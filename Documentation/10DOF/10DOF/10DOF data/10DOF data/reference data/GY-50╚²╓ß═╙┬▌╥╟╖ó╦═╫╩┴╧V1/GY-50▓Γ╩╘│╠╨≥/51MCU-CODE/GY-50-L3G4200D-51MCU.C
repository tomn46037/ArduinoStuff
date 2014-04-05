//***************************************
// GY-50 L3G4200D IIC测试程序
// 使用单片机STC89C51 
// 晶振：11.0592M
// 显示：LCD1602
// 编译环境 Keil uVision2
// 参考宏晶网站24c04通信程序
// 时间：2011年9月1日
// QQ：531389319
//****************************************
#include  <REG51.H>	
#include  <math.h>    //Keil library  
#include  <stdio.h>   //Keil library	
#include  <INTRINS.H>
#define   uchar unsigned char
#define   uint unsigned int	
#define   DataPort P0    //LCD1602数据端口
sbit	  SCL=P1^0;      //IIC时钟引脚定义
sbit 	  SDA=P1^1;      //IIC数据引脚定义
sbit      LCM_RS=P2^0;   //LCD1602命令端口		
sbit      LCM_RW=P2^1;   //LCD1602命令端口		
sbit      LCM_EN=P2^2;   //LCD1602命令端口 

//**********L3G4200D内部寄存器地址*********
#define WHO_AM_I 0x0F
#define CTRL_REG1 0x20
#define CTRL_REG2 0x21
#define CTRL_REG3 0x22
#define CTRL_REG4 0x23
#define CTRL_REG5 0x24
#define REFERENCE 0x25
#define OUT_TEMP 0x26
#define STATUS_REG 0x27
#define OUT_X_L 0x28
#define OUT_X_H 0x29
#define OUT_Y_L 0x2A
#define OUT_Y_H 0x2B
#define OUT_Z_L 0x2C
#define OUT_Z_H 0x2D
#define FIFO_CTRL_REG 0x2E
#define FIFO_SRC_REG 0x2F
#define INT1_CFG 0x30
#define INT1_SRC 0x31
#define INT1_TSH_XH 0x32
#define INT1_TSH_XL 0x33
#define INT1_TSH_YH 0x34
#define INT1_TSH_YL 0x35
#define INT1_TSH_ZH 0x36
#define INT1_TSH_ZL 0x37
#define INT1_DURATION 0x38
//****************************************
#define	SlaveAddress   0xD2	  //定义器件在IIC总线中的从地址,根据ALT  ADDRESS地址引脚不同修改
                          
typedef unsigned char  BYTE;
typedef unsigned short WORD;

uchar dis[4];                        //显示数组
BYTE  BUF[8];                        //接收数据缓存区      	
uchar ge,shi,bai,qian,wan;           //显示变量
int  dis_data;                       //变量
float temp; 

void delay(unsigned int k);
void InitLcd();                     //初始化lcd1602
void InitL3G4200D();                //初始化L3G4200D

void WriteDataLCM(uchar dataW);
void WriteCommandLCM(uchar CMD,uchar Attribc);
void DisplayOneChar(uchar X,uchar Y,uchar DData);
void DisplayListChar(uchar X,uchar Y,uchar *DData,L);

void  Single_WriteL3G4200D(uchar REG_Address,uchar REG_data);   //单个写入数据
uchar Single_ReadL3G4200D(uchar REG_Address);                   //单个读取内部寄存器数据
                             
//------------------------------------
void Delay5us();
void L3G4200D_Start();
void L3G4200D_Stop();
void L3G4200D_SendACK(bit ack);
bit  L3G4200D_RecvACK();
void L3G4200D_SendByte(BYTE dat);
BYTE L3G4200D_RecvByte();
void L3G4200D_ReadPage();
void L3G4200D_WritePage();

void display_x();
void display_y();
void display_z();

/*******************************/
void lcd_printf(uchar *s,int temp_data)
{
	if(temp_data<0){
	temp_data=-temp_data;
    *s='-';
	}
	else *s=' ';
    *++s =temp_data/100+0x30;
    temp_data=temp_data%100;     //取余运算
    *++s =temp_data/10+0x30;
    temp_data=temp_data%10;      //取余运算
    *++s =temp_data+0x30; 	
}
/*******************************/
void delay(unsigned int k)	
{						
unsigned int i,j;				
for(i=0;i<k;i++)
{			
for(j=0;j<121;j++)			
{;}}						
}
/*******************************/
void WaitForEnable(void)	
{					
DataPort=0xff;		
LCM_RS=0;LCM_RW=1;_nop_();
LCM_EN=1;_nop_();_nop_();
while(DataPort&0x80);	
LCM_EN=0;				
}					
/*******************************/
void WriteCommandLCM(uchar CMD,uchar Attribc)
{					
if(Attribc)WaitForEnable();	
LCM_RS=0;LCM_RW=0;_nop_();
DataPort=CMD;_nop_();	
LCM_EN=1;_nop_();_nop_();LCM_EN=0;
}					
/*******************************/
void WriteDataLCM(uchar dataW)
{					
WaitForEnable();		
LCM_RS=1;LCM_RW=0;_nop_();
DataPort=dataW;_nop_();	
LCM_EN=1;_nop_();_nop_();LCM_EN=0;
}		
/***********************************/
void InitLcd()				
{			
WriteCommandLCM(0x38,1);	
WriteCommandLCM(0x08,1);	
WriteCommandLCM(0x01,1);	
WriteCommandLCM(0x06,1);	
WriteCommandLCM(0x0c,1);

DisplayOneChar(0,0,'x');
DisplayOneChar(1,0,':');
DisplayOneChar(0,1,'y');
DisplayOneChar(1,1,':');
DisplayOneChar(9,0,'z');
DisplayOneChar(10,0,':');
}			
/***********************************/
void DisplayOneChar(uchar X,uchar Y,uchar DData)
{						
Y&=1;						
X&=15;						
if(Y)X|=0x40;					
X|=0x80;			
WriteCommandLCM(X,0);		
WriteDataLCM(DData);		
}						
//*******************************************
void DisplayListChar(uchar X,uchar Y,uchar *DData,L)
{
uchar ListLength=0; 
Y&=0x1;                
X&=0xF;                
while(L--)             
{                       
DisplayOneChar(X,Y,DData[ListLength]);
ListLength++;  
X++;                        
}    
}
/**************************************
延时5微秒(STC90C52RC@12M)
不同的工作环境,需要调整此函数，注意时钟过快时需要修改
当改用1T的MCU时,请调整此延时函数
**************************************/
void Delay5us()
{
    _nop_();_nop_();_nop_();_nop_();
    _nop_();_nop_();_nop_();_nop_();
	_nop_();_nop_();_nop_();_nop_();
	_nop_();_nop_();_nop_();_nop_();
    _nop_();_nop_();_nop_();_nop_();
	_nop_();_nop_();_nop_();_nop_();
}

/**************************************
起始信号
**************************************/
void L3G4200D_Start()
{
    SDA = 1;                    //拉高数据线
    SCL = 1;                    //拉高时钟线
    Delay5us();                 //延时
    SDA = 0;                    //产生下降沿
    Delay5us();                 //延时
    SCL = 0;                    //拉低时钟线
}

/**************************************
停止信号
**************************************/
void L3G4200D_Stop()
{
    SDA = 0;                    //拉低数据线
    SCL = 1;                    //拉高时钟线
    Delay5us();                 //延时
    SDA = 1;                    //产生上升沿
    Delay5us();                 //延时
}

/**************************************
发送应答信号
入口参数:ack (0:ACK 1:NAK)
**************************************/
void L3G4200D_SendACK(bit ack)
{
    SDA = ack;                  //写应答信号
    SCL = 1;                    //拉高时钟线
    Delay5us();                 //延时
    SCL = 0;                    //拉低时钟线
    Delay5us();                 //延时
}

/**************************************
接收应答信号
**************************************/
bit L3G4200D_RecvACK()
{
    SCL = 1;                    //拉高时钟线
    Delay5us();                 //延时
    CY = SDA;                   //读应答信号
    SCL = 0;                    //拉低时钟线
    Delay5us();                 //延时

    return CY;
}

/**************************************
向IIC总线发送一个字节数据
**************************************/
void L3G4200D_SendByte(BYTE dat)
{
    BYTE i;

    for (i=0; i<8; i++)         //8位计数器
    {
        dat <<= 1;              //移出数据的最高位
        SDA = CY;               //送数据口
        SCL = 1;                //拉高时钟线
        Delay5us();             //延时
        SCL = 0;                //拉低时钟线
        Delay5us();             //延时
    }
    L3G4200D_RecvACK();
}

/**************************************
从IIC总线接收一个字节数据
**************************************/
BYTE L3G4200D_RecvByte()
{
    BYTE i;
    BYTE dat = 0;

    SDA = 1;                    //使能内部上拉,准备读取数据,
    for (i=0; i<8; i++)         //8位计数器
    {
        dat <<= 1;
        SCL = 1;                //拉高时钟线
        Delay5us();             //延时
        dat |= SDA;             //读数据               
        SCL = 0;                //拉低时钟线
        Delay5us();             //延时
    }
    return dat;
}
//单字节写入*******************************************

void Single_WriteL3G4200D(uchar REG_Address,uchar REG_data)
{
    L3G4200D_Start();                  //起始信号
    L3G4200D_SendByte(SlaveAddress);   //发送设备地址+写信号
    L3G4200D_SendByte(REG_Address);    //内部寄存器地址，请参考中文pdf22页 
    L3G4200D_SendByte(REG_data);       //内部寄存器数据，请参考中文pdf22页 
    L3G4200D_Stop();                   //发送停止信号
}

//单字节读取*****************************************
uchar Single_ReadL3G4200D(uchar REG_Address)
{  uchar REG_data;
    L3G4200D_Start();                          //起始信号
    L3G4200D_SendByte(SlaveAddress);           //发送设备地址+写信号
    L3G4200D_SendByte(REG_Address);            //发送存储单元地址，从0开始	
    L3G4200D_Start();                          //起始信号
    L3G4200D_SendByte(SlaveAddress+1);         //发送设备地址+读信号
    REG_data=L3G4200D_RecvByte();              //读出寄存器数据
	L3G4200D_SendACK(1);   
	L3G4200D_Stop();                           //停止信号
    return REG_data; 
}

//*****************************************************************

//初始化L3G4200D，根据需要请参考pdf进行修改************************
void InitL3G4200D()
{
   Single_WriteL3G4200D(CTRL_REG1, 0x0f);   //
   Single_WriteL3G4200D(CTRL_REG2, 0x00);   //
   Single_WriteL3G4200D(CTRL_REG3, 0x08);   //
   Single_WriteL3G4200D(CTRL_REG4, 0x30);  //+-2000dps
   Single_WriteL3G4200D(CTRL_REG5, 0x00);
}
//***********************************************************************
//显示x轴
void display_x()
{ 
    BUF[0]= Single_ReadL3G4200D(OUT_X_L);
    BUF[1]= Single_ReadL3G4200D(OUT_X_H); //读取X轴数据

    dis_data=(BUF[1]<<8)+BUF[0];       //合成数据   
    temp=(float)dis_data*0.07;         // 数据手册 第9页，2000度/秒量程
    dis_data=(int)temp;
    lcd_printf(dis, dis_data);     //转换数据显示  
    DisplayListChar(2,0,dis,4);    //启始列，行，显示数组，显示长度
}

//***********************************************************************
//显示y轴
void display_y()
{  
    BUF[2]= Single_ReadL3G4200D(OUT_Y_L);
    BUF[3]= Single_ReadL3G4200D(OUT_Y_H);//读取Y轴数据

    dis_data=(BUF[3]<<8)+BUF[2];              //合成数据   
	temp=(float)dis_data*0.07;                // 数据手册 第9页，2000度/秒量程
    dis_data=(int)temp;
    lcd_printf(dis, dis_data);            //转换数据显示  
    DisplayListChar(2,1,dis,4);           //启始列，行，显示数组，显示长度 
}
//***********************************************************************
//显示z轴
void display_z()
{     
    BUF[4]= Single_ReadL3G4200D(OUT_Z_L);
    BUF[5]= Single_ReadL3G4200D(OUT_Z_H);//读取Z轴数据
    dis_data=(BUF[5]<<8)+BUF[4];             //合成数据  
	temp=(float)dis_data*0.07;               // 数据手册 第9页，2000度/秒量程
	dis_data=(int)temp;              
    lcd_printf(dis, dis_data);           //转换数据显示  
    DisplayListChar(11,0,dis,4);         //启始列，行，显示数组，显示长度 
}

//*********************************************************
//******主程序********
//*********************************************************
void main()
{ uchar Temperature;
  delay(500);	                   //上电延时		
  InitLcd();                       //液晶初始化
  InitL3G4200D();                  //初始化L3G4200D
  Temperature=Single_ReadL3G4200D(OUT_TEMP); //读取温度
  while(1)                         //循环
  {   
    display_x();                   //---------显示X轴
    display_y();                   //---------显示Y轴
    display_z();                   //---------显示Z轴
    delay(100);                    //延时            
  }
} 
