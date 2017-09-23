function callback_16bit(s,BytesAvailable,p)
% 串口接收中断的回调函数
    global t;  
    global x;  
    global m;  
    global ii;
    global data;
    global SUBP
    
    %宏定义
    
    plot_length = 8000; %整个视图中，波形显示多少个点，
    
    n_bytes = s.BytesAvailable;         %获取串口接收到数据的个数
    
    out = fread(s,[1 n_bytes],'uint8'); %将串口数据以一行8位整型的形式显示出来
    mat = zeros(9,1);                   %8位转16位数据处理矩阵
    data = [data out];                  %合并缓存矩阵
    
    while(length(data) >= 21)           %当data长度大于21时，不停循环
        if(data(1) == 255 && data(2) == 165 && data(3) == 90)   %有符号整型帧头 0xff,0xa5,0x5a
            %确认为一帧数据
            data(1:3) = [];             %清空帧头位
            for i = 1:9                 %将7个通道的数据提取出来
                mat(i,1) = data(1)*256+data(2);     %将两个8位数据合并成16位数据
                if (mat(i,1) > 32768)               %提取符号位
                    mat(i,1) = -(65536-mat(i,1));   %求补码
                end
                data(1:2) = [];                     %清空提取到的data缓存数据
            end
            m = [m mat];    %合并波形显示矩阵
            ii = ii + 1;    %计数+1
            t = [t ii];     %合并采样点数矩阵
            x = x +  1;     %移动x轴
            if(length(t) <= plot_length)
                for j = 1:9     %刷新第一路的1-9通道显示
                    set(p(j),'xdata',t,'ydata',m(j,1:length(t)));
                end
            else
                for j = 1:9     %刷新第一路的1-9通道显示
                    set(p(j),'xdata',t(length(t)-plot_length:end),'ydata',m(j,length(t)-plot_length:length(t)));
                end
            end
            
        elseif(data(1) == 255 && data(2) == 165 && data(3) == 91)   %无符号整型帧头 0xff，0xa5，0x5b
            %确认为一帧数据
            data(1:3) = [];     %同上
            for i = 1:9
                mat(i,1) = data(1)*256+data(2);
                data(1:2) = [];
            end
            m = [m mat]; %读取帧数据
            ii = ii + 1;
            t = [t ii];
            x = x +  1;
            
           if(length(t) <= plot_length)
                for j = 1:9     %刷新第一路的1-9通道显示
                    set(p(j),'xdata',t,'ydata',m(j,1:length(t)));
                end
            else
                for j = 1:9     %刷新第一路的1-9通道显示
                    set(p(j),'xdata',t(length(t)-plot_length:end),'ydata',m(j,length(t)-plot_length:length(t)));
                end
            end
            
        else
            data(1) = [];       %如果不是帧头，则数据错误？？跳过错误数据直到找到帧头
        end
    end
    
    if(x <= 150)
        ymax = max(m');     %求整个矩阵的最大值
    else
        ymax = max(m(1:end,x-150:end)');     %求整个矩阵的最小值
    end
    
    if(x <= 150)
        ymin = min(m');     %求整个矩阵的最大值
    else
        ymin = min(m(1:end,x-150:end)');     %求整个矩阵的最小值
    end
    drawnow                 %更新图形窗口
    set(SUBP(1),'XLim',[x-350 x+50],'YLim',[ymin(1)-50 ymax(1)+50]);
    set(SUBP(2),'XLim',[x-350 x+50],'YLim',[ymin(2)-50 ymax(2)+50]);
    set(SUBP(3),'XLim',[x-350 x+50],'YLim',[ymin(3)-50 ymax(3)+50]);
    set(SUBP(4),'XLim',[x-350 x+50],'YLim',[ymin(4)-50 ymax(4)+50]);
    set(SUBP(5),'XLim',[x-350 x+50],'YLim',[ymin(5)-50 ymax(5)+50]);
    set(SUBP(6),'XLim',[x-350 x+50],'YLim',[ymin(6)-50 ymax(6)+50]);
    set(SUBP(7),'XLim',[x-350 x+50],'YLim',[ymin(7)-50 ymax(7)+50]);
    set(SUBP(8),'XLim',[x-350 x+50],'YLim',[ymin(8)-50 ymax(8)+50]);
    set(SUBP(9),'XLim',[x-350 x+50],'YLim',[ymin(9)-50 ymax(9)+50]);
end 
