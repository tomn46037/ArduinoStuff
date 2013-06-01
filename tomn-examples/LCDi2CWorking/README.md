
You can set the I2C address of your expander when you define the lcd
object.  In my case, I'm using the default for my board which is 0x27.

My board uses jumpers on the bottom to set the address.  They're labeled
A0, A1, and A2.  If they're open, they float high.  If they're shorted
they're low.  So, no jumpbers is 0x27.  Display number 1 is A1 and A2
shored.  

I've expanded on this example a little to attempt to initialize all 
8 display addresses and give you the number of the display in the 
Init message.  

