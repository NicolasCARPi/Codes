function varargout = Rayon(varargin)
% RAYON M-file for Rayon.fig
%      RAYON, by itself, creates a new RAYON or raises the existing
%      singleton*.
%
%      H = RAYON returns the handle to a new RAYON or the handle to
%      the existing singleton*.
%
%      RAYON('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RAYON.M with the given input arguments.
%
%      RAYON('Property','Value',...) creates a new RAYON or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Rayon_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Rayon_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Rayon

% Last Modified by GUIDE v2.5 08-Nov-2005 18:13:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Rayon_OpeningFcn, ...
                   'gui_OutputFcn',  @Rayon_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Rayon is made visible.
function Rayon_OpeningFcn(hObject, eventdata, handles, varargin)
clc;
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Rayon (see VARARGIN)

% Choose default command line output for Rayon
handles.output = hObject;
handles.radius=[];
handles.theory=textread('manipe_theory.txt');
handles.mesure=textread('manipe.txt');
handles.simul=textread('lisse2.txt');
handles.rayon=textread('rayon.txt');
set(handles.pop_radius,'String',handles.rayon)
% Update handles structure
guidata(hObject, handles);

axes(handles.graph);
h=plot(handles.mesure(:,1)*1.17,handles.mesure(:,2)*0.98,'b.','Markersize',1);
hold on
%h=plot(handles.theory(:,1),handles.theory(:,2),'r.','Markersize',1)
h=plot(handles.simul(:,1),handles.simul(:,2),'g+','Markersize',3);
hold off
set(gca,'Xlim',[0 1024],'Ylim',[0 1024]);

% UIWAIT makes Rayon wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Rayon_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function pop_radius_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in pop_radius.
function pop_radius_Callback(hObject, eventdata, handles)
% hObject    handle to pop_radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns pop_radius contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_radius

result=get(handles.pop_radius,'Value') %indice selectionné
s=size(handles.simul);

for i=1:s(1)
    if handles.simul(i,3)==handles.rayon(result)
        in(i)=1;
    else in(i)=0;
    end
end
in=logical(in);
zer=rand(1,s(1)).*0;
axes(handles.graph);
h=plot(handles.mesure(~in,1)*1.17,handles.mesure(~in,2)*0.98,'bo','Markersize',1);
hold on
plot(handles.mesure(in,1)*1.17,handles.mesure(in,2)*0.98,'r*','Markersize',3);
hold off
set(gca,'Xlim',[0 1024],'Ylim',[0 1024]);


axes(handles.graph2)
cla;
bins=[10:1:10000];
if in==logical(zer)
xlim([1 10000])
set(gca,'Xscale','log');
set(handles.edit_moyenne,'String','Pas de points')
else
hist(10.^(handles.mesure(in,3)./256),bins);
xlim([1 10000])
set(gca,'Xscale','log');
a=mean(10.^(handles.mesure(in,3)./256))
set(handles.edit_moyenne,'String',a)

end





% --- Executes during object creation, after setting all properties.
function edit_moyenne_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_moyenne (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_moyenne_Callback(hObject, eventdata, handles)
% hObject    handle to edit_moyenne (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_moyenne as text
%        str2double(get(hObject,'String')) returns contents of edit_moyenne as a double


% --- Executes on button press in push_scan.
function push_scan_Callback(hObject, eventdata, handles)
% hObject    handle to push_scan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
p=size(handles.rayon)
s=size(handles.simul);
for j=1:1:p(1)
    
    for i=1:s(1)
        if handles.simul(i,3)==handles.rayon(j)
             in(i)=1;
        else in(i)=0;
        end
    end
    in=logical(in);
    zer=rand(1,s(1)).*0;
    axes(handles.graph2)
    cla;
    bins=[10:1:10000];
    if in==logical(zer)
        moyenne(j,1)=handles.rayon(j);
        moyenne(j,2)=0;       
    else   
        moyenne(j,1)=handles.rayon(j)
        moyenne(j,2)=mean(10.^(handles.mesure(in,3)./256))
    end
    
end
axes(handles.graph3);
dlmwrite('moyenne.txt', moyenne, '\t');
h=plot(moyenne(:,1),moyenne(:,2));
set(gca,'Xlim',[0 handles.rayon(p(1))],'Ylim',[0 10000]);


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


