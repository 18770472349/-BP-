%% 参数配置
function GUI_figure_input()
global gpData

im_outsize = [128, 128];
im_buffer = ones(im_outsize);

gpData.im_outsize = im_outsize;
gpData.im_buffer = im_buffer;
gpData.mouse_keydown_flag = 0;
gpData.lastpoint = [-1, -1];
%% 
try  close('数字识别'); catch; end

hf = figure('Units','normalized',...
    'Position',[0.3 0.25 0.4 0.5]...
    , 'Menu','none'...
    , 'Name', '数字识别'...
    , 'numbertitle', 'off');
  
ha = axes('Parent',hf,'Units','normalized',...
    'tag','axesObj',...
    'Position',[0.0 0.1 0.8 0.8]);

hm = imshow(im_buffer);
set(hm,'Parent',ha...
  , 'tag', 'imObj'...
  )
hb1 = uicontrol(...
    'Style','pushbutton',...
    'Callback',"closereq",...
    'String','关闭',...
    'Units','normalized',...
    'fontsize',16,....
    'Position',[0.74 0.20, 0.2 0.1]);

hb2 = uicontrol(...
    'Style','pushbutton',...
    'Callback',@image_clear,...
    'String','清除',...
    'Units','normalized',...
    'fontsize',16,....
    'Position',[0.74 0.55 0.2 0.1]);
hb3 = uicontrol(...
    'Style','pushbutton',...
    'Callback',@image_recognition,...
    'String','开始识别',...
    'Units','normalized',...
    'fontsize',16,....
    'Position',[0.74 0.70 0.2 0.1]);
  
set(ha,'Units','normalized',...
    'tag','axesObj'...
    );

set(hf,'keypressfcn',@keyfcn...
  , 'ButtonDownFcn',@buttonfcn...
  , 'WindowKeyPressFcn',@WindowKeyPressFcn...
  , 'WindowScrollWheelFcn',@WindowScrollWheelFcn...
  , 'WindowButtonDownFcn',@WindowButtonDownFcn...
  , 'WindowButtonUpFcn',@WindowButtonUpFcn...
  , 'WindowButtonMotionFcn',@WindowButtonMotionFcn...
  , 'WindowScrollWheelFcn',@WindowScrollWheelFcn...
  , 'WindowScrollWheelFcn',@WindowScrollWheelFcn...
  , 'windowstyle', 'normal'); % modal normal
  

end


%% 画图功能函数
function plot_dot(x,y, r)
  global gpData
  
  r = round(r);
  
  hm = findobj('Tag','imObj'); %查找图像对象
  if ~isempty(hm)
    tmpx=0; tmpy=0;
    for i = -r:r
      for j = -r:r
        tmpx = x+i;
        tmpy = y+j;
        if tmpx>0&&tmpy>0 && tmpy<=gpData.im_outsize(1)&&tmpx<=gpData.im_outsize(2)...
             && i^2+j^2<=r^2
          hm.CData(tmpy, tmpx) = 0;
        end
      end
    end
    
  end
  
end
function plot_line(pos1, pos2, r)
  hm = findobj('Tag','imObj'); %查找图像对象
  if isempty(hm)
    return
  end
  
  index = abs(pos1-pos2);
  if sum(pos1<=0) || sum(pos2<=0)
    return
  elseif index(1)==0 && index(2)==0
    point = pos1;
  elseif index(1) > index(2) %插值连续化
    point(:,1) = linspace(pos1(1),pos2(1),index(1));
    point(:,2) = ...
    interp1([pos1(1),pos2(1)], [pos1(2),pos2(2)], ...
     point(:,1));
  else
    point(:,2) = linspace(pos1(2),pos2(2),index(2));
    point(:,1) = ...
    interp1([pos1(2),pos2(2)], [pos1(1),pos2(1)], ...
     point(:,2));
  end
  point = round(point); %结果取整
  
  [cols,~] = size(point);
  for i=1:cols
    if point(i,2)>512 || point(i,1)>512 || point(i,2)<=0 || point(i,1)<=0
      continue
    end
    try 
%       hm.CData(point(i,2), point(i,1)) = 0;
      plot_dot(point(i,1), point(i,2),r);
    catch
      point
      pos1
      pos2
    end
  end
end


%% gui回调函数
function image_clear(handles, eventdata)
  hm = findobj('Tag','imObj'); %查找图像对象
  if isempty(hm)
    return
  end
  hm.CData = hm.CData>-1;
end
function image_recognition(handles, eventdata)
global gpData
hm = findobj('Tag','imObj'); %查找图像对象
str = "无结果"; %输出字符串
if ~isempty(hm) 
%   im = imresize(hm.CData,[28,28],'Method','bicubic');
  im = imresize(hm.CData,[28,28],'Method','bilinear');
  im = round(((1-im)*255));
  gpData.inputIm = im;
  out_data = figure_judge(im); %调用神经网络判断数字
  
  str = sprintf("有%.2f%%把握判断识别结果为%d", out_data(2)*100, out_data(1));
  fprintf("\n%s\n\n",str);
  if out_data(2)<0.5
    str = "未识别出数字";
  end
end
%  *************** 弹出对话框 ***************** %
  h=dialog('name','数字识别结果...','Units','normalized'...
    , 'Position',[0.35 0.4 0.3 0.2]);
  uicontrol('parent',h,'style','text','string',str...
    , 'Units','normalized'...
    , 'position',[0.0 0.5 1.0 0.2],'fontsize',24);
  uicontrol('parent',h,'style','pushbutton'...
    , 'Units','normalized'...
    , 'position', [0.3 0.1 0.4 0.2],'string','确定'...
    ,'fontsize',16....
    ,'callback','delete(gcbf)');
  
%   figure
%   imshow(im)
end


function buttonfcn(handles, eventdata)
%   disp('buttonfcn')
end

function keyfcn(handles, eventdata)
%   disp('keyfcn')
end

function WindowKeyPressFcn(handles, eventdata)
%   disp('WindowKeyPressFcn')
end

function WindowScrollWheelFcn(handles, eventdata)
%   disp('WindowScrollWheelFcn')
%   disp(eventdata.EventName)
  eventdata.VerticalScrollAmount
  eventdata.VerticalScrollCount
end

function WindowButtonDownFcn(handles, eventdata)
  global gpData
  gpData.mouse_keydown_flag = 1;
 
%   disp('WindowButtonDownFcn')
%   disp(eventdata.EventName)
%   eventdata.
end
function WindowButtonUpFcn(handles, eventdata)
  global gpData
  gpData.mouse_keydown_flag = 0;
  
%   disp('WindowButtonUpFcn')
%   disp(eventdata.EventName)
%   eventdata.
end

function WindowButtonMotionFcn(handles, eventdata)
  global gpData
  pre_pos = [gpData.lastpoint(2), gpData.lastpoint(1)];
  
  if gpData.mouse_keydown_flag == 1
    ha = findobj('tag','axesObj');
    point = get(ha, 'currentpoint');
    pos = round(point(1, 2:-1:1));
    if pos(1)>=1 && pos(1)<=gpData.im_outsize(1) && pos(2)>=1 && pos(2)<=gpData.im_outsize(2)
%       plot_dot(pos, 2); %画点
      if pre_pos(1)>=1 && pre_pos(1)<=gpData.im_outsize(1) && pre_pos(2)>=1 && pre_pos(2)<=gpData.im_outsize(2)
        plot_line([pre_pos(2), pre_pos(1)],[pos(2), pos(1)], 5);
      end
      gpData.lastpoint = [pos(2), pos(1)];
    else
      gpData.lastpoint = [-1, -1];
    end
  else
    gpData.lastpoint = [-1, -1];
  end
  
%   disp('WindowButtonMotionFcn')
%   disp(eventdata.EventName)
end




