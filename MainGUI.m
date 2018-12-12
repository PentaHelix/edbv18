function varargout = MainGUI(varargin)
% MAINGUI MATLAB code for MainGUI.fig
%      MAINGUI, by itself, creates a new MAINGUI or raises the existing
%      singleton*.
%
%      H = MAINGUI returns the handle to a new MAINGUI or the handle to
%      the existing singleton*.
%
%      MAINGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAINGUI.M with the given input arguments.
%
%      MAINGUI('Property','Value',...) creates a new MAINGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MainGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MainGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MainGUI

% Last Modified by GUIDE v2.5 26-Nov-2018 22:45:07

% Begin initialization code - DO NOT EDIT
%edit GUI with 'guide'
clc;
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MainGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @MainGUI_OutputFcn, ...
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


% --- Executes just before MainGUI is made visible.
function MainGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MainGUI (see VARARGIN)

% Choose default command line output for MainGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MainGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MainGUI_OutputFcn(hObject, eventdata, handles) 
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
cla(handles.axes1);
axes(handles.axes1);
hold off;
cla reset;
LoadImage(handles);
handles.img=0;
handles.imgs=0;
handles.region=0;
handles.data=0;
handles.ret=0;
handles.count =0;
guidata(handles.pushbutton4,handles);
set(handles.text1, 'String', '...');

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.checkbox1, 'Value');
    set(handles.text1, 'String', 'running...');
    Main(handles, getimage(handles.axes1), false, true);
else
    set(handles.text1, 'String', 'running...');
    Main(handles, getimage(handles.axes1), false, false);
end

% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Step-Button

%data=get(handles.pushbutton4,'UserData');
if get(handles.checkbox1, 'Value')
    h=guidata(handles.pushbutton4);
    if h.count == 0
        [raster, img, imgs, region] = Main(handles, getimage(handles.axes1), true, get(handles.checkbox1, 'Value'));
        handles.raster = raster;%[raster, img, imgs, region, count+1];
        handles.img = img;
        handles.imgs = imgs;
        handles.region = region;
        handles.count = h.count+1;
        guidata(handles.pushbutton4,handles);
        rectangle('Position', region{1}, ...
            'Linewidth', 3, 'EdgeColor', 'r', 'LineStyle', '--');
    else 
        if h.count <= 24 && ~strcmp(h.ret,'end') && ~strcmp(h.ret,'error')
            if h.count > 1
               delete(h.oldRect); 
            end
            [resultImg, ret, data] = GeneratePath(h.raster, h.img, h.imgs, h.region, h.count, h.data, h.ret, get(handles.checkbox1, 'Value'));
            imshow(resultImg,'Parent',handles.axes1);
            k=6*(data(3)-1)+data(4);
            handles.oldRect = rectangle('Position', h.region{k}, ...
            'Linewidth', 3, 'EdgeColor', 'r', 'LineStyle', '--');
            %handles.raster = h.raster;%[raster, img, imgs, region, count+1];
            handles.img = resultImg;
            handles.data = data;
            handles.ret=ret;
            handles.count = h.count+1;
            guidata(handles.pushbutton4,handles);
            set(handles.text2, 'String', h.raster(k));
            if strcmp(ret,'end') || strcmp(ret,'error')
               set(handles.text1, 'String', h.ret);
            end
        end 
    end
end


%figure, imshow(resultImg);
%set(handles.text1, 'String', result);

% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
value = get(handles.checkbox2, 'Value');
t1='off';
t2='on';
if ~value
    t1 = 'on';
    t2 = 'off';
end
set(handles.pushbutton2,'Enable',t1)
set(handles.pushbutton4,'Enable',t2)
%handles.img=0;
%handles.imgs=0;
%handles.region=0;
%handles.data=0;
%handles.ret=0;
%handles.count =0;
%guidata(handles.pushbutton4,handles);
% Hint: get(hObject,'Value') returns toggle state of checkbox2
