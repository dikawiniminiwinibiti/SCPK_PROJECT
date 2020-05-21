function varargout = Main(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Main_OpeningFcn, ...
                   'gui_OutputFcn',  @Main_OutputFcn, ...
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
function Main_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;

guidata(hObject, handles);

function varargout = Main_OutputFcn(~, eventdata, handles) 

varargout{1} = handles.output;


function pushbutton1_Callback(hObject, ~, handles)
%MASUKKAN GAMBAR
[filename,pathname] = uigetfile('*.jpg');
Img = imread(fullfile(pathname,filename));
handles.I = Img;
guidata(hObject,handles)
axes(handles.axes1)
imshow(Img)
title(filename);


function pushbutton3_Callback(hObject, eventdata, handles)

Img = handles.I;
%cari nilai HSI
RGB     = im2double(Img);
Red     = RGB(:,:,1);
Green   = RGB(:,:,2);
Blue    = RGB(:,:,3);
%H /hue (lihat rumus)
atas=1/2*((Red-Green)+(Red-Blue)); %Variabel atas
bawah=((Red-Green).^2+((Red-Blue).*(Green-Blue))).^0.5; %Variabel Bwh
teta = acosd(atas./(bawah));
if Blue > Green
    H = 360 - teta;
else
    H = teta;
end

H = H/360;
[r c] = size(H);
for i=1 : r
    for j=1 : c
        z = H(i,j);
        z(isnan(z)) = 0; %isnan adalah is not none artinya jika bukan angka dia akan memberi 0
        H(i,j) = z;
    end
end
%S (lihat rumus)
S=1-(3./(sum(RGB,3))).*min(RGB,[],3);
[r c] = size(S);
for i=1 : r
    for j=1 : c
        z = S(i,j);
        z(isnan(z)) = 0;
        S(i,j) = z;
    end
end
%I (Lihat rumus)
I=(Red+Green+Blue)/3;

nilaiR = mean2(Red);
nilaiG = mean2(Green);
nilaiB = mean2(Blue);
nilaiH = mean2(H);
nilaiS = mean2(S);
nilaiI = mean2(I);

data = get(handles.uitable2,'Data');
data{1,1} = num2str(nilaiR);
data{2,1} = num2str(nilaiG);
data{3,1} = num2str(nilaiB);
data{4,1} = num2str(nilaiH);
data{5,1} = num2str(nilaiS);
data{6,1} = num2str(nilaiI);

set(handles.uitable2,'Data',data,'ForegroundColor',[0 0 0])
Z=[nilaiR; nilaiG; nilaiB; nilaiH; nilaiS; nilaiI];
load master

kategori = round(sim(net,Z));

if kategori==1
    x='Mentah';
else
    x='Matang';
end
set(handles.edit2,'String',x);



function edit2_Callback(hObject, eventdata, handles)

function edit2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function uitable2_CellEditCallback(hObject, ~, handles)
