close all;
clear all;
clc;

global t;
global m;
global x;
global ii;
global data;
global SUBP

data = [0];
t = [0];
m = ones(9,1);
x = 1;
ii = 1;

%波形图形部分设置

figure('NumberTitle', 'off', 'Name', '东北师范大学 电磁翼十路示波器');
SUBP(1) = subplot(331);
hold on
h1 = plot(0,'r','LineWidth',3);
title('直立陀螺仪');
xlabel('采样点数');
ylabel('采样数值');

SUBP(2) = subplot(332);
hold on
h2 = plot(0,'g','LineWidth',3);
title('实际速度');
xlabel('采样点数');
ylabel('采样数值');

SUBP(3) = subplot(333);
hold on;
h3 = plot(0,'b','LineWidth',3);
title('加权位置偏差');
xlabel('采样点数');
ylabel('采样数值');

SUBP(4) = subplot(334);
hold on
h4 = plot(0,'b','LineWidth',3);
title('加速度计');
xlabel('采样点数');
ylabel('采样数值');

SUBP(5) = subplot(335);
hold on
h5 = plot(0,'r','LineWidth',3);
title('速度控制输出');
xlabel('采样点数');
ylabel('采样数值');

SUBP(6) = subplot(336);
hold on
h6 = plot(0,'g','LineWidth',3);
title('转向陀螺仪');
xlabel('采样点数');
ylabel('采样数值');

SUBP(7) = subplot(337);
hold on
h7 = plot(0,'g','LineWidth',3);
title('积分角度');
xlabel('采样点数');
ylabel('采样数值');

SUBP(8) = subplot(338);
hold on
h8 = plot(0,'b','LineWidth',3);
title('速度增益');
xlabel('采样点数');
ylabel('采样数值');

SUBP(9) = subplot(339);
hold on
h9 = plot(0,'r','LineWidth',3);
title('转向PWM');
xlabel('采样点数');
ylabel('采样数值');

H = [h1;h2;h3;h4;h5;h6;h7;h8;h9];


%串口部分设置
s = serial('COM17');            %选择串口~
s.BaudRate = 19200;              %选择波特率
s.DataBits = 8;                 %设置数据位数
s.StopBits = 1;                 %设置停止位
set(s,'Parity', 'none','FlowControl','none');   %无校验位，无流控制
s.ReadAsyncMode = 'continuous';                 %异步接收模式为连续
s.BytesAvailableFcnMode = 'byte';               %回调函数模式为字节
s.BytesAvailableFcnCount = 100;                  %每接收到100个字节，触发中断，调用回调函数，0xff,0xa5，0x5a(0x5b) 三位帧头+七位数据
s.BytesAvailableFcn = {@callback_16bit,H};      %回调函数地址，以及相应波形显示通道句柄

try
    fopen(s);                               %打开串口
    fprintf('串口打开成功\n');
catch err
    fprintf('串口打开失败。\n');
end
