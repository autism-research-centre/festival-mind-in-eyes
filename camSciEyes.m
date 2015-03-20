function camSciEyes
try
load('variablenames.mat', 'imageIDs', 'options');

scr = Screen('OpenWindow', 0, 100);
screenSize = Screen('Rect', scr);

[buttonSound, buttonFreq] = audioread('two_tone_nav.mp3');
% paHandle = PsychPortAudio('Open');
% buttonBuffer = PsychPortAudio('CreateBuffer', paHandle, buttonSound);
% PsychPortAudio('FillBuffer', paHandle, buttonBuffer);

ycen = screenSize(4)/2;
xcen = screenSize(3)/2;



buttonRect{1} = [0 + 0.3*screenSize(3), 0.75*screenSize(4), 0 + 0.4*screenSize(3), 0.85*screenSize(4) ];
buttonRect{2} = [0 + 0.45*screenSize(3), 0.75*screenSize(4), 0 + 0.55*screenSize(3), 0.85*screenSize(4) ];
buttonRect{3} = [0 + 0.6*screenSize(3), 0.75*screenSize(4), 0 + 0.7*screenSize(3), 0.85*screenSize(4) ];

while 1

    order = randperm(15);
    score = 0;
    
    ShowCursor(0);
    
    DrawFormattedText(scr, 'How well can you read people''s minds?\nClick anywhere to start the experiment!', 'center', 'center', 0, [], [], [], 3);
    Screen('Flip', scr);
    
    GetClicks;
    
    
    
    for trial = order
        
        optionOrder = randperm(2);
        
        imMatrix = imread(imageIDs{trial});
        
        Screen('PutImage', scr, imMatrix);
        
        Screen('FillRect', scr, 255, buttonRect{1});
%         Screen('FillRect', scr, 255, buttonRect{2});
        Screen('FillRect', scr, 255, buttonRect{3});
        
        DrawFormattedText(scr, options{trial, optionOrder(1)}, 'center', 'center', 0, [], [], [], [], [], buttonRect{1});
%         DrawFormattedText(scr, options{trial, optionOrder(2)}, 'center', 'center', 0, [], [], [], [], [], buttonRect{2});
        DrawFormattedText(scr, options{trial, optionOrder(2)}, 'center', 'center', 0, [], [], [], [], [], buttonRect{3});
        
        Screen('DrawLine', scr, [255 0 0], 0, 0, 20, 20, 3);
        Screen('DrawLine', scr, [255 0 0], 20, 0, 0, 20, 3);
        Screen('Flip', scr);
        
        while 1
            [x, y, buttons] = GetMouse;
            if buttons(1)==1 && y > 0.75*screenSize(4) && y < 0.85*screenSize(4)
                if x > 0.3*screenSize(3) && x < 0.4*screenSize(3)
                    % button 1
                    response = 1;
                    break
%                 elseif x > 0.45*screenSize(3) && x < 0.55*screenSize(3)
%                     % button 2
%                     response = 2;
%                     break
                elseif x > 0.6*screenSize(3) && x < 0.7*screenSize(3)
                    % button 3
                    response = 2;
                    break
                end
            elseif buttons(1)==1 && x < 20 && y < 20
                error('You closed the experiment!');
            end
        end
        
        soundsc(buttonSound, buttonFreq);
        
        if optionOrder(response) == 1;
            score = score+1;
        end
        WaitSecs(0.2);
    end
    
    mess = sprintf('Great, thanks! Your score is:\n %i', score);
    DrawFormattedText(scr, mess, 'center', 'center', 0, [], [], [], 3);
    
    Screen('Flip', scr);
    
    GetClicks;
    
end
    
catch err
    
    sca;
    rethrow(err);
        
end
end