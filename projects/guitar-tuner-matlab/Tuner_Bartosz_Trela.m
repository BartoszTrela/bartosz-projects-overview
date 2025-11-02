classdef Tuner_Bartosz_Trela < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                       matlab.ui.Figure
        GridLayout                     matlab.ui.container.GridLayout
        LeftPanel                      matlab.ui.container.Panel
        StatusLabel                    matlab.ui.control.Label
        PowciniciuprzyciskuzagrajdwikdonastrojeniaLabel  matlab.ui.control.Label
        WybierzstrunButtonGroup        matlab.ui.container.ButtonGroup
        E6Button                       matlab.ui.control.RadioButton
        B5Button                       matlab.ui.control.RadioButton
        G4Button                       matlab.ui.control.RadioButton
        D3Button                       matlab.ui.control.RadioButton
        A2Button                       matlab.ui.control.RadioButton
        E1Button                       matlab.ui.control.RadioButton
        StartstrojeniaButton           matlab.ui.control.Button
        RightPanel                     matlab.ui.container.Panel
        Fq                             matlab.ui.control.NumericEditField
        CzstotliwoEditFieldLabel       matlab.ui.control.Label
        Stroikdogitary6strunowejLabel  matlab.ui.control.Label
        Gauge                          matlab.ui.control.SemicircularGauge
        UIAxes                         matlab.ui.control.UIAxes
    end

    % Properties that correspond to apps with auto-reflow
    properties (Access = private)
        onePanelWidth = 576;
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: StartstrojeniaButton
        function StartstrojeniaButtonPushed(app, ~)
%% Zapisujemy strojony dźwięk do pliku (niby nie trzeba ale łatwiej będzie rozbudować o porównanie dźwięku wzorcowego ze strojonym:)
aDR = audioDeviceReader(44100, 4410);
Writer = dsp.AudioFileWriter('strojone.wav', 'FileFormat','WAV');
tic
while toc < 5
    acquiredAudio = aDR();
    Writer(acquiredAudio);
end
app.StatusLabel.Text = 'nagrywanie zakończone!';
release(aDR)
release(Writer)

%%Filtrujemy dla danej struny + ustawiamy podziałkę dla wskazówki
S = audioread('strojone.wav');
if app.E1Button.Value == true
    filtr_S = filtracja_E(S);
    Writer = dsp.AudioFileWriter('strojone.wav', 'FileFormat','WAV');
    Writer(filtr_S);
    release(Writer)
%wskazówka
    app.Gauge.Limits = [52.4 112.4];
    app.Gauge.MajorTicks = [52.4 82.4 112.4];
    app.Gauge.MajorTickLabels = {'Low' 'E[82,4Hz]' 'High'};
    wzor = 82.4;
elseif app.A2Button.Value == true
    filtr_S = filtracja_A(S);
    Writer = dsp.AudioFileWriter('strojone.wav', 'FileFormat','WAV');
    Writer(filtr_S);
    release(Writer)
    %wskazówka
    app.Gauge.Limits = [80 140];
    app.Gauge.MajorTicks = [80 110 140];
    app.Gauge.MajorTickLabels = {'Low' 'A[110Hz]' 'High'};
    wzor = 110;
elseif app.D3Button.Value == true
    filtr_S = filtracja_D(S);
    Writer = dsp.AudioFileWriter('strojone.wav', 'FileFormat','WAV');
    Writer(filtr_S);
    release(Writer)
    %wskazówka
    app.Gauge.Limits = [116.8 176.8];
    app.Gauge.MajorTicks = [116.8 146.8 176.8];
    app.Gauge.MajorTickLabels = {'Low' 'D[146,8Hz]' 'High'};
    wzor = 146.8;
elseif app.G4Button.Value == true
    filtr_S = filtracja_G(S);
    Writer = dsp.AudioFileWriter('strojone.wav', 'FileFormat','WAV');
    Writer(filtr_S);
    release(Writer)
    %wskazówka
    app.Gauge.Limits = [166 226];
    app.Gauge.MajorTicks = [166 196 226];
    app.Gauge.MajorTickLabels = {'Low' 'G[196Hz]' 'High'};
    wzor = 196;
elseif app.B5Button.Value == true
    filtr_S = filtracja_B(S);
    Writer = dsp.AudioFileWriter('strojone.wav', 'FileFormat','WAV');
    Writer(filtr_S);
    release(Writer)
    %wskazówka
    app.Gauge.Limits = [217 277];
    app.Gauge.MajorTicks = [217 247 277];
    app.Gauge.MajorTickLabels = {'Low' 'B[247Hz]' 'High'};
    wzor = 247;
elseif app.E6Button.Value == true
    filtr_S = filtracja_E6(S);
    Writer = dsp.AudioFileWriter('strojone.wav', 'FileFormat','WAV');
    Writer(filtr_S);
    release(Writer)
    %wskazówka
    app.Gauge.Limits = [299.6 359.6];
    app.Gauge.MajorTicks = [299.6 329.6 359.6];
    app.Gauge.MajorTickLabels = {'Low' 'E[329,6Hz]' 'High'};
    wzor = 329.6;
end

%%Czytamy nagrany sygnał i robimy transformatę
[y,A] = audioread('strojone.wav');
fp = A;
L_strojone = length(y);
FFT_strojone = abs(fft(y)/L_strojone);
FFT_strojone = FFT_strojone(1:L_strojone/2);
f = (0:length(y)/2-1)/5;

%%Ucinamy częstotliwości poniżej 60Hz
%bo mikrofon mi robi dziwne szumy przy 50Hz i nie da się pracować
logicf = f > 60;
f_logic = f(logicf);
logicFFT = FFT_strojone(1:(length(y)/2));
FFT_logic = logicFFT(302:110250,:);

%% WYŚWIETLANIE
%Wykres
plot(app.UIAxes, f_logic, FFT_logic, 'o-');

%Częstotliwość
[~,czest] = max(FFT_logic);
app.Fq.Value = f_logic(czest);

%wskazówka
app.Gauge.Value = f_logic(czest);
%wyświetl status
if f_logic(czest) < wzor
    app.StatusLabel.Text = 'Częstotliwość za niska';
elseif f_logic(czest) > wzor
    app.StatusLabel.Text = 'Częstotliwość za wysoka';
elseif f_logic(czest) == wzor
    app.StatusLabel.Text = 'Częstotliwość poprawna';
else 
    app.StatusLabel.Text = 'Error 404 przełamanie 4-tej bariery';
end
        end

        % Changes arrangement of the app based on UIFigure width
        function updateAppLayout(app, event)
            currentFigureWidth = app.UIFigure.Position(3);
            if(currentFigureWidth <= app.onePanelWidth)
                % Change to a 2x1 grid
                app.GridLayout.RowHeight = {480, 480};
                app.GridLayout.ColumnWidth = {'1x'};
                app.RightPanel.Layout.Row = 2;
                app.RightPanel.Layout.Column = 1;
            else
                % Change to a 1x2 grid
                app.GridLayout.RowHeight = {'1x'};
                app.GridLayout.ColumnWidth = {220, '1x'};
                app.RightPanel.Layout.Row = 1;
                app.RightPanel.Layout.Column = 2;
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.AutoResizeChildren = 'off';
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'MATLAB App';
            app.UIFigure.SizeChangedFcn = createCallbackFcn(app, @updateAppLayout, true);

            % Create GridLayout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.ColumnWidth = {220, '1x'};
            app.GridLayout.RowHeight = {'1x'};
            app.GridLayout.ColumnSpacing = 0;
            app.GridLayout.RowSpacing = 0;
            app.GridLayout.Padding = [0 0 0 0];
            app.GridLayout.Scrollable = 'on';

            % Create LeftPanel
            app.LeftPanel = uipanel(app.GridLayout);
            app.LeftPanel.Layout.Row = 1;
            app.LeftPanel.Layout.Column = 1;

            % Create StartstrojeniaButton
            app.StartstrojeniaButton = uibutton(app.LeftPanel, 'push');
            app.StartstrojeniaButton.ButtonPushedFcn = createCallbackFcn(app, @StartstrojeniaButtonPushed, true);
            app.StartstrojeniaButton.Position = [48 341 123 49];
            app.StartstrojeniaButton.Text = 'Start strojenia';

            % Create WybierzstrunButtonGroup
            app.WybierzstrunButtonGroup = uibuttongroup(app.LeftPanel);
            app.WybierzstrunButtonGroup.TitlePosition = 'centertop';
            app.WybierzstrunButtonGroup.Title = 'Wybierz strunę';
            app.WybierzstrunButtonGroup.Position = [48 89 123 158];

            % Create E1Button
            app.E1Button = uiradiobutton(app.WybierzstrunButtonGroup);
            app.E1Button.Text = 'E1';
            app.E1Button.Position = [11 112 58 22];
            app.E1Button.Value = true;

            % Create A2Button
            app.A2Button = uiradiobutton(app.WybierzstrunButtonGroup);
            app.A2Button.Text = 'A2';
            app.A2Button.Position = [11 91 65 22];

            % Create D3Button
            app.D3Button = uiradiobutton(app.WybierzstrunButtonGroup);
            app.D3Button.Text = 'D3';
            app.D3Button.Position = [11 70 65 22];

            % Create G4Button
            app.G4Button = uiradiobutton(app.WybierzstrunButtonGroup);
            app.G4Button.Text = 'G4';
            app.G4Button.Position = [11 49 65 22];

            % Create B5Button
            app.B5Button = uiradiobutton(app.WybierzstrunButtonGroup);
            app.B5Button.Text = 'B5';
            app.B5Button.Position = [11 28 65 22];

            % Create E6Button
            app.E6Button = uiradiobutton(app.WybierzstrunButtonGroup);
            app.E6Button.Text = 'E6';
            app.E6Button.Position = [11 7 65 22];

            % Create PowciniciuprzyciskuzagrajdwikdonastrojeniaLabel
            app.PowciniciuprzyciskuzagrajdwikdonastrojeniaLabel = uilabel(app.LeftPanel);
            app.PowciniciuprzyciskuzagrajdwikdonastrojeniaLabel.HorizontalAlignment = 'center';
            app.PowciniciuprzyciskuzagrajdwikdonastrojeniaLabel.Position = [32 305 156 29];
            app.PowciniciuprzyciskuzagrajdwikdonastrojeniaLabel.Text = {'Po wciśnięciu przycisku'; 'zagraj dźwięk do nastrojenia'};

            % Create StatusLabel
            app.StatusLabel = uilabel(app.LeftPanel);
            app.StatusLabel.Position = [40 34 139 22];
            app.StatusLabel.Text = '';

            % Create RightPanel
            app.RightPanel = uipanel(app.GridLayout);
            app.RightPanel.Layout.Row = 1;
            app.RightPanel.Layout.Column = 2;

            % Create UIAxes
            app.UIAxes = uiaxes(app.RightPanel);
            title(app.UIAxes, 'FFT')
            xlabel(app.UIAxes, 'Częstotliwość [Hz]')
            ylabel(app.UIAxes, 'Amplituda')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.XLim = [60 400];
            app.UIAxes.XTick = [60 82.4 110 146.8 196 247 329.6 400];
            app.UIAxes.XTickLabel = {'60'; '82.4'; '110'; '146.8'; '196'; '247'; '329.6'; '400'};
            app.UIAxes.Position = [60 34 300 185];

            % Create Gauge
            app.Gauge = uigauge(app.RightPanel, 'semicircular');
            app.Gauge.MajorTicks = [0 50 100];
            app.Gauge.MajorTickLabels = {'Low', '', 'High'};
            app.Gauge.Position = [105 277 209 113];
            app.Gauge.Value = 50;

            % Create Stroikdogitary6strunowejLabel
            app.Stroikdogitary6strunowejLabel = uilabel(app.RightPanel);
            app.Stroikdogitary6strunowejLabel.HorizontalAlignment = 'center';
            app.Stroikdogitary6strunowejLabel.FontName = 'Arial Rounded MT Bold';
            app.Stroikdogitary6strunowejLabel.FontSize = 24;
            app.Stroikdogitary6strunowejLabel.FontWeight = 'bold';
            app.Stroikdogitary6strunowejLabel.Position = [47 418 327 31];
            app.Stroikdogitary6strunowejLabel.Text = 'Stroik do gitary 6-strunowej';

            % Create CzstotliwoEditFieldLabel
            app.CzstotliwoEditFieldLabel = uilabel(app.RightPanel);
            app.CzstotliwoEditFieldLabel.HorizontalAlignment = 'right';
            app.CzstotliwoEditFieldLabel.Position = [129 246 78 22];
            app.CzstotliwoEditFieldLabel.Text = 'Częstotliwość';

            % Create Fq
            app.Fq = uieditfield(app.RightPanel, 'numeric');
            app.Fq.Position = [222 246 69 22];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = Tuner_Bartosz_Trela

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end