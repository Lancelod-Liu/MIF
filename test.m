function varargout = test(varargin)
% TEST MATLAB code for test.fig
%      TEST, by itself, creates a new TEST or raises the existing
%      singleton*.
%
%      H = TEST returns the handle to a new TEST or the handle to
%      the existing singleton*.
%
%      TEST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TEST.M with the given input arguments.
%
%      TEST('Property','Value',...) creates a new TEST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before test_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to test_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help test

% Last Modified by GUIDE v2.5 12-Mar-2013 13:54:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @test_OpeningFcn, ...
                   'gui_OutputFcn',  @test_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before test is made visible.
function test_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to test (see VARARGIN)

% Choose default command line output for test
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes test wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = test_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Associate learning & correcting in memristive NN
%Method used is MIF——Max-Input-Feedback.
%This is the release 1.0 version coded at 21'29'' on 2013 .3.6
t1=get(handles.edit1,'string');
t1=str2num(t1);
t2=get(handles.edit2,'string');
t2=str2num(t2);
r1=get(handles.edit3,'string');
r1=str2num(r1);
r2=get(handles.edit4,'string');
r2=str2num(r2);
r3=get(handles.edit5,'string');
r3=str2num(r3);
fv=1:1:5;
temp=get(handles.edit6,'string');
fv(1)=str2num(temp);
temp=get(handles.edit7,'string');
fv(2)=str2num(temp);
temp=get(handles.edit8,'string');
fv(3)=str2num(temp);
temp=get(handles.edit9,'string');
fv(4)=str2num(temp);
temp=get(handles.edit10,'string');
fv(5)=str2num(temp);

cla(handles.axes4,'reset')
cla(handles.axes5,'reset')
cla(handles.axes6,'reset')
cla(handles.axes7,'reset')
cla(handles.axes8,'reset')
cla(handles.axes9,'reset')
cla(handles.axes10,'reset')
cla(handles.axes11,'reset')
cla(handles.axes12,'reset')
cla(handles.axes13,'reset')
MIF(t1,t2,r1,r2,r3,fv,handles);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close



%Associate learning & correcting in memristive NN
%Method used is MIF——Max-Input-Feedback.
%This is the release 1.0 version coded at 21'29'' on 2013 .3.6

function MIF(traintime1,traintime2,r1,r2,r3,fv,handles)
%仿真参数设置 RoS 是初始化的值
RoS=[r1 r2 r3];%S1~S3 三个突触的忆阻器值
Roff=160000;%高阻态
Ron=1000;%低阻态
D=10^-8;%忆阻器厚度
uv=10^-14;%电子迁移速率
X=(Roff-RoS)/(Roff-Ron);%S1~S3权值矩阵
l=uv*Ron/(D^2);
k=(Ron-Roff)*l;
t=0.1;%脉冲宽度
%一些常量
TrainTime1=traintime1;
TrainTime2=traintime2;
MaxLen=TrainTime1+TrainTime2+17;
%生成1行MaxLen列的向量用于存储状态
N1_state=zeros(1,MaxLen);%输入序列
R1=zeros(1,MaxLen+1);%突触阻值
X1=zeros(1,MaxLen+1);%突触权值
V1=zeros(1,MaxLen);%突触工作电压
N2_state=zeros(1,MaxLen);
R2=zeros(1,MaxLen+1);
X2=zeros(1,MaxLen+1);
V2=zeros(1,MaxLen);
N3_state=zeros(1,MaxLen);
R3=zeros(1,MaxLen+1);
X3=zeros(1,MaxLen+1);
V3=zeros(1,MaxLen);
N4_state=zeros(1,MaxLen);%总输出
F4=zeros(1,MaxLen);%反馈序列


%初始化训练电压
N1_state(1)=2;
N1_state(5 : 7)=2;
N1_state(9 : 9+TrainTime1-1)=2; %N3训练长度为TrainTime1
N1_state(MaxLen-2)=2;
N2_state(2)=1;
N2_state(5 : 7)=1;
N2_state(TrainTime1+13: TrainTime1+13+TrainTime2-1)=1;%N2训练长度为TrainTime2
N2_state(MaxLen-1)=1;
N3_state(3)=1;
N3_state(5 : 7)=1;
N3_state(9 : 9+TrainTime1-1+2)=1;%N3训练长度为TrainTime1+2
N3_state(MaxLen)=1;
X1(1)=X(1);
X2(1)=X(2);
X3(1)=X(3);
R1(1)=RoS(1);
R2(1)=RoS(2);
R3(1)=RoS(3);
%训练开始
for ct=1:MaxLen
    inij=[N1_state(ct) N2_state(ct) N3_state(ct)];%输入序列
    in=[inij(1)*X1(ct) inij(2)*X2(ct) inij(3)*X3(ct)];%加权
    u=max(in);%取最值
    o=o(u);
    fb=f(u,fv);%根据定义好的输出/反馈函数产生反馈、输出
    pij=inij-fb;%取差值做控制量
    %突触工作电压记录
    %仅当突触前端神经元有输入时才改变权值 
    %否则工作电压为默认值 0
    if inij(1) ~=0
    V1(ct)=pij(1);
    end
    if inij(2) ~=0
    V2(ct)=pij(2);
    end
    if inij(3) ~=0
    V3(ct)=pij(3);
    end
    %突触系数更改
    %系数，若工作电压为0则不变
    X1(ct+1)=X1(ct)+k*V1(ct)*t/((Roff-X1(ct)*(Roff-Ron))*(Ron-Roff));
    X2(ct+1)=X2(ct)+k*V2(ct)*t/((Roff-X2(ct)*(Roff-Ron))*(Ron-Roff));
    X3(ct+1)=X3(ct)+k*V3(ct)*t/((Roff-X3(ct)*(Roff-Ron))*(Ron-Roff));
    %阻值，同上
    R1(ct+1)=R1(ct)+k*V1(ct)*t/R1(ct);
    R2(ct+1)=R2(ct)+k*V2(ct)*t/R2(ct);
    R3(ct+1)=R3(ct)+k*V3(ct)*t/R3(ct);
    %反馈电压记录
    F4(ct)=fb;
    N4_state(ct)=o;%把输入写入N4
    %将权值和阻值限制在[0,1]，符合现实意义
    if X1(ct+1)<0
        X1(ct+1)=0;
    end
     if X1(ct+1)>=1
        X1(ct+1)=1;
     end
    if X2(ct+1)<=0
        X2(ct+1)=0;
    end
     if X2(ct+1)>=1
        X2(ct+1)=1;
     end
    if X3(ct+1)<=0
        X3(ct+1)=0;
    end
     if X3(ct+1)>=1
        X3(ct+1)=1;
     end
 
     if R1(ct+1)<=Ron
        R1(ct+1)=Ron;
    end
     if R1(ct+1)>=Roff
        R1(ct+1)=Roff;
     end
    if R2(ct+1)<=Ron
        R2(ct+1)=Ron;
    end
     if R2(ct+1)>=Roff
        R2(ct+1)=Roff;
     end
    if R3(ct+1)<=Ron
        R3(ct+1)=Ron;
    end
     if R3(ct+1)>=Roff
        R3(ct+1)=Roff;
     end
end    

%显示
plot(handles.axes4,X1,'m:.');
hold(handles.axes4);
plot(handles.axes4,X2,'k:.');
plot(handles.axes4,X3,'b:.');
box(handles.axes4);
title(handles.axes4,'\fontsize{11}Weight','FontWeight','Bold');
legend(handles.axes4,'S1','S2','S3',0);
xlabel(handles.axes4,'\fontsize{10}Train Time','Color','k','FontWeight','Bold');
ylabel(handles.axes4,'\fontsize{10}Weight','Color','k','FontWeight','Bold');

maxin=0.001:0.001:2.2;
fdbk=maxin;
k=1;
for i=maxin
    fdbk(k)=f(i,fv);k=k+1;
end
plot(handles.axes5,maxin,fdbk,'k');
box(handles.axes5);
title(handles.axes5,'\fontsize{11}Feedback Function','FontWeight','Bold');
xlabel(handles.axes5,'\fontsize{10}Max Input','Color','k','FontWeight','Bold');
ylabel(handles.axes5,'\fontsize{10}Feedback Voltage','Color','k','FontWeight','Bold');
% plot(handles.axes5,R1,'m:.');
% hold(handles.axes5);
% plot(handles.axes5,R2,'k:.');
% plot(handles.axes5,R3,'b:.');
% box(handles.axes5);
% title(handles.axes5,'\fontsize{11}阻值');
% legend(handles.axes5,'R1','R2','R3',0);
bar(handles.axes6,N1_state,'m');
title(handles.axes6,'\fontsize{11}N1 Food Neuron State','Color','r','FontWeight','Bold');
xlabel(handles.axes6,'\fontsize{9}Train Time','Color','k','FontWeight','Bold');
ylabel(handles.axes6,'\fontsize{10}State','Color','k','FontWeight','Bold');
bar(handles.axes7,N2_state,'k');
title(handles.axes7,'\fontsize{11}N2 Ring Neuron State','Color','r','FontWeight','Bold');
xlabel(handles.axes7,'\fontsize{9}Train Time','Color','k','FontWeight','Bold');
ylabel(handles.axes7,'\fontsize{10}State','Color','k','FontWeight','Bold');
bar(handles.axes8,N3_state,'b');
title(handles.axes8,'\fontsize{11}N3 Light Neuron State','Color','r','FontWeight','Bold');
xlabel(handles.axes8,'\fontsize{9}Train Time','Color','k','FontWeight','Bold');
ylabel(handles.axes8,'\fontsize{10}State','Color','k','FontWeight','Bold');
bar(handles.axes9,N4_state,'r');
title(handles.axes9,'\fontsize{11}N4 Salivation Neuron State','Color','r','FontWeight','Bold');
xlabel(handles.axes9,'\fontsize{9}Train Time','Color','k','FontWeight','Bold');
ylabel(handles.axes9,'\fontsize{10}State','Color','k','FontWeight','Bold');
bar(handles.axes10,V1,'m');
title(handles.axes10,'\fontsize{11}S1  Working Volt','Color','r','FontWeight','Bold');
xlabel(handles.axes10,'\fontsize{9}Train Time','Color','k','FontWeight','Bold');
ylabel(handles.axes10,'\fontsize{10}Bias','Color','k','FontWeight','Bold');
bar(handles.axes11,V2,'k');
title(handles.axes11,'\fontsize{11}S2  Working Volt','Color','r','FontWeight','Bold');
xlabel(handles.axes11,'\fontsize{9}Train Time','Color','k','FontWeight','Bold');
ylabel(handles.axes11,'\fontsize{10}Bias','Color','k','FontWeight','Bold');
bar(handles.axes12,V3,'b');
title(handles.axes12,'\fontsize{11}S3  Working Volt','Color','r','FontWeight','Bold');
xlabel(handles.axes12,'\fontsize{9}Train Time','Color','k','FontWeight','Bold');
ylabel(handles.axes12,'\fontsize{10}Bias','Color','k','FontWeight','Bold');
bar(handles.axes13,F4,'r');
title(handles.axes13,'\fontsize{11}N4 Salivation Neuron Feedback Volt','Color','r','FontWeight','Bold');
xlabel(handles.axes13,'\fontsize{9}Train Time','Color','k','FontWeight','Bold');
ylabel(handles.axes13,'\fontsize{10}Feedback','Color','k','FontWeight','Bold');

%神经元空间函数定义
function o=o(u)
if u<0.5
    o=0;
else if u <1
        o=1;
    else
        o=2;
    end
end
%反馈函数定义
function f=f(u,fv)
if u>=1
    f=fv(1);%0.9
else if u >=0.85
        f=fv(2);%1.2
        else if u >=0.6
        f=fv(3);%1.3
        else if u >=0.5
        f=fv(4);%1.4
        else if u >0
        f=fv(5);%1.5
            else 
                f=0;
            end
            end
            end
    end
end

% function f=f(u,fv)
% if u>=2
%     f=0.6;%0.9
% else if u >=1.75
%         f=0.7;%1.2
%         else if u >=1.5
%         f=0.8;%1.3
%         else if u >=1
%         f=0.9;%1.4
%         else if u >=0.75
%         f=1.8;%1.5
%                 else if u >=0.5
%         f=1.3;%1.5
%             else 
%                 f=1.5;
%                     end
%             end
%             end
%             end
%     end
% end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on figure1 and none of its controls.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in togglebutton1.


% --- Executes on mouse press over axes background.
function axes4_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu1_Callback(hObject, eventdata, handles)
% hObject    handle to menu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
