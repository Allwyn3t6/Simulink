classdef app1_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure             matlab.ui.Figure
        NEditField           matlab.ui.control.NumericEditField
        NEditFieldLabel      matlab.ui.control.Label
        fcEditField          matlab.ui.control.NumericEditField
        fcEditFieldLabel     matlab.ui.control.Label
        fsEditField          matlab.ui.control.NumericEditField
        fsEditFieldLabel     matlab.ui.control.Label
        FilteringwavesLabel  matlab.ui.control.Label
        FilterButton         matlab.ui.control.Button
        SineButton           matlab.ui.control.Button
        UIAxes               matlab.ui.control.UIAxes
    end

    
    properties (Access = private)
        fc % Description
        fs
        N
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: SineButton
        function SineButtonPushed(app, event)
            % Generate sine wave and plot on UIAxes
            t = linspace(0, 2*pi, 1000); % Time vector for one period
            f = 1; % Frequency of the sine wave
            amplitude = 2;
            y = amplitude * sin(2*pi*f*t); % Sine wave signal
            plot(app.UIAxes, t, y);
            title(app.UIAxes, 'Sine Wave');
            xlabel(app.UIAxes, 'Time');
            ylabel(app.UIAxes, 'Amplitude');
        end

        % Button pushed function: FilterButton
        function FilterButtonPushed(app, event)
    % Ensure that fc is in the range [0, 1] and fs is greater than 0
    app.fc =app.fcEditField.Value;
    app.fs = max(0, app.fsEditField.Value);

    % Ensure fs is not zero to avoid division by zero
    if app.fs == 0
        app.fs = 1; % set a default value (you can adjust this as needed)
    end
    
    app.N = app.NEditField.Value;  % Filter order

    % Create a low-pass filter using the fir1 function
    b = fir1(app.N, app.fc / (app.fs / 2));

    % Frequency response calculation
    [h, w] = freqz(b, 1, 512, app.fs);

    % Plot the magnitude response on UIAxes
    plot(app.UIAxes, w, 20*log10(abs(h)));
    title(app.UIAxes, 'Low-pass Filter Frequency Response');
    xlabel(app.UIAxes, 'Frequency (Hz)');
    ylabel(app.UIAxes, 'Magnitude (dB)');
        end

        % Value changed function: NEditField
        function NEditFieldValueChanged(app, event)

        end

        % Value changed function: fcEditField
        function fcEditFieldValueChanged(app, event)

        end

        % Value changed function: fsEditField
        function fsEditFieldValueChanged(app, event)
       
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'MATLAB App';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, 'Title')
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.Position = [46 213 550 243];

            % Create SineButton
            app.SineButton = uibutton(app.UIFigure, 'push');
            app.SineButton.ButtonPushedFcn = createCallbackFcn(app, @SineButtonPushed, true);
            app.SineButton.Position = [67 133 100 23];
            app.SineButton.Text = 'Sine';

            % Create FilterButton
            app.FilterButton = uibutton(app.UIFigure, 'push');
            app.FilterButton.ButtonPushedFcn = createCallbackFcn(app, @FilterButtonPushed, true);
            app.FilterButton.Position = [194 133 100 23];
            app.FilterButton.Text = 'Filter';

            % Create FilteringwavesLabel
            app.FilteringwavesLabel = uilabel(app.UIFigure);
            app.FilteringwavesLabel.Position = [127 18 357 33];
            app.FilteringwavesLabel.Text = 'Filtering waves';

            % Create fsEditFieldLabel
            app.fsEditFieldLabel = uilabel(app.UIFigure);
            app.fsEditFieldLabel.HorizontalAlignment = 'right';
            app.fsEditFieldLabel.Position = [464 133 25 22];
            app.fsEditFieldLabel.Text = 'fs';

            % Create fsEditField
            app.fsEditField = uieditfield(app.UIFigure, 'numeric');
            app.fsEditField.ValueChangedFcn = createCallbackFcn(app, @fsEditFieldValueChanged, true);
            app.fsEditField.Position = [504 133 100 22];

            % Create fcEditFieldLabel
            app.fcEditFieldLabel = uilabel(app.UIFigure);
            app.fcEditFieldLabel.HorizontalAlignment = 'right';
            app.fcEditFieldLabel.Position = [464 101 25 22];
            app.fcEditFieldLabel.Text = 'fc';

            % Create fcEditField
            app.fcEditField = uieditfield(app.UIFigure, 'numeric');
            app.fcEditField.ValueChangedFcn = createCallbackFcn(app, @fcEditFieldValueChanged, true);
            app.fcEditField.Position = [504 101 100 22];

            % Create NEditFieldLabel
            app.NEditFieldLabel = uilabel(app.UIFigure);
            app.NEditFieldLabel.HorizontalAlignment = 'right';
            app.NEditFieldLabel.Position = [464 72 25 22];
            app.NEditFieldLabel.Text = 'N';

            % Create NEditField
            app.NEditField = uieditfield(app.UIFigure, 'numeric');
            app.NEditField.ValueChangedFcn = createCallbackFcn(app, @NEditFieldValueChanged, true);
            app.NEditField.Position = [504 72 100 22];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = app1_exported

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