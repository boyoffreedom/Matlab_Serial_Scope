# Matlab_Serial_Scope
use Matlab plot function to show serial data
使用MATLAB的plot函数将串口数据转换成可视化波形，对串口通信数据格式有一定的要求。使用C语言描述串口通信格式为：
void send_matlab(uint8 mode,int ch1, int ch2, int ch3, int ch4, int ch5, int ch6, int ch7, int ch8, int ch9)
{
    uint8 send_data[21]={0};
    uint8 i;
    send_data[ 0] = 0xff;
    send_data[ 1] = 0xa5;
    send_data[ 2] = 0x5a+mode;
    send_data[ 3] = (uint8)((ch1&0xff00)>>8);
    send_data[ 4] = (uint8)(ch1&0x00ff);
    send_data[ 5] = (uint8)((ch2&0xff00)>>8);
    send_data[ 6] = (uint8)(ch2&0x00ff);
    send_data[ 7] = (uint8)((ch3&0xff00)>>8);
    send_data[ 8] = (uint8)(ch3&0x00ff);
    send_data[ 9] = (uint8)((ch4&0xff00)>>8);
    send_data[10] = (uint8)(ch4&0x00ff);
    send_data[11] = (uint8)((ch5&0xff00)>>8);
    send_data[12] = (uint8)(ch5&0x00ff);
    send_data[13] = (uint8)((ch6&0xff00)>>8);
    send_data[14] = (uint8)(ch6&0x00ff);
    send_data[15] = (uint8)((ch7&0xff00)>>8);
    send_data[16] = (uint8)(ch7&0x00ff);
    send_data[17] = (uint8)((ch8&0xff00)>>8);
    send_data[18] = (uint8)(ch8&0x00ff);
    send_data[19] = (uint8)((ch9&0xff00)>>8);
    send_data[20] = (uint8)(ch9&0x00ff);
    for(i=0;i<21;i++)
    {
        uart_send1(UART3,send_data[i]);
    }
}
