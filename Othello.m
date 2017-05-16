function Othello

%--------------------------------------------------------------------------
%Othello
%Version 1.00
%Created by Stepen
%Created 14 October 2011
%Last modified 5 November 2011
%--------------------------------------------------------------------------
%Othello starts GUI game of Othello.
%--------------------------------------------------------------------------
%How to play othello:
%Each player takes turn to place chip on the board. For every chip placed
%in each turn, the placed chip together with one or more same-colored chips
%that are already in the board must block the opposing-colored chips and
%the blocked chips will swap color. To win, player's chip must be more than
%the opposing-color chips at the end of the game. The game ends when the
%board is full or there are no more available moves.
%--------------------------------------------------------------------------

%CodeStart-----------------------------------------------------------------
%Reseting MATLAB environment
    close all
    clear all
%Declaring global variable
    playermark=zeros(8);
    commark=zeros(8);
    turn=[];
    winner=[];
%Generating GUI
    ScreenSize=get(0,'ScreenSize');
    mainwindow=figure('Name','Othello',...
                      'NumberTitle','Off',...
                      'Menubar','none',...
                      'Resize','off',...
                      'Units','pixels',...
                      'Position',[0.5*(ScreenSize(3)-384),...
                                  0.5*(ScreenSize(4)-400),...
                                  384,400]);
    axes('Parent',mainwindow,...
         'Units','normalized',...
         'Position',[0.1,0.25,0.8,0.7]);
    uicontrol('Parent',mainwindow,...
              'Style','pushbutton',...
              'String','Start Game',...
              'Units','normalized',...
              'Position',[0.15,0.15,0.2,0.05],...
              'Callback',@startgamefcn);
    uicontrol('Parent',mainwindow,...
              'Style','pushbutton',...
              'String','Close Game',...
              'Units','normalized',...
              'Position',[0.65,0.15,0.2,0.05],...
              'Callback',@closegamefcn);
    uicontrol('Parent',mainwindow,...
              'Style','text',...
              'String','Player (White):',...
              'HorizontalAlignment','left',...
              'BackgroundColor',[0.8,0.8,0.8],...
              'Units','normalized',...
              'Position',[0.375,0.16,0.2,0.05]);
    playerscoretext=uicontrol('Parent',mainwindow,...
                              'Style','text',...
                              'String','0',...
                              'HorizontalAlignment','right',...
                              'BackgroundColor',[0.8,0.8,0.8],...
                              'Units','normalized',...
                              'Position',[0.575,0.16,0.05,0.05]);
    uicontrol('Parent',mainwindow,...
              'Style','text',...
              'String','COM (Black):',...
              'HorizontalAlignment','left',...
              'BackgroundColor',[0.8,0.8,0.8],...
              'Units','normalized',...
              'Position',[0.375,0.125,0.2,0.05]);
    comscoretext=uicontrol('Parent',mainwindow,...
                              'Style','text',...
                              'String','0',...
                              'HorizontalAlignment','right',...
                              'BackgroundColor',[0.8,0.8,0.8],...
                              'Units','normalized',...
                              'Position',[0.575,0.125,0.05,0.05]);
    instructionbox=uicontrol('Parent',mainwindow,...
                             'Style','text',...
                             'String',['Click Start Game button to',...
                                       ' begin the game...'],...
                             'Units','normalized',...
                             'Position',[0.1,0.05,0.8,0.04]);
%Inititiating graphics
    drawboard(playermark,commark)
%Declaring LocalFunction
    %Start of drawboard
    function drawboard(playermark,commark)
        %Drawing board background
        axis off
        axis([0.5 8.5 0.5 8.5])
        for i=1:8
        for j=1:8
            rectangle('Position',[i-0.5,j-0.5,1,1],'FaceColor','g')
        end
        end
        %Drawing player mark
        [row,col]=find(playermark==1);
        if ~isempty(row)
            for i=1:1:numel(row)
                rectangle('Position',[col(i)-0.3,8.7-row(i),...
                                      0.6,0.6],...
                          'Curvature',[1 1],...
                          'FaceColor','w')
            end
        end
        %Drawing com mark
        [row,col]=find(commark==1);
        if ~isempty(row)
            for i=1:1:numel(row)
                rectangle('Position',[col(i)-0.3,8.7-row(i),...
                                      0.6,0.6],...
                          'Curvature',[1 1],...
                          'FaceColor','k')
            end
        end
        %Writing player and COM score
        set(playerscoretext,'String',num2str(sum(sum(playermark))))
        set(comscoretext,'String',num2str(sum(sum(commark))))
    end
    %End of drawboard
    %Start of animateboard
    function animateboard(playermark,commark,row,col)
        %Drawing fixed board
        drawboard(playermark,commark)
        %Animating board
        for t=1:20
            for i=1:numel(row)
                if (playermark(row(i),col(i))==0)&&...
                   (commark(row(i),col(i))==1)
                    rectangle('Position',[col(i)-0.3,8.7-row(i),...
                                          0.6,0.6],...
                              'Curvature',[1,1],...
                              'FaceColor',t*ones(1,3)/20)
                elseif (playermark(row(i),col(i))==1)&&...
                       (commark(row(i),col(i))==0)
                    rectangle('Position',[col(i)-0.3,8.7-row(i),...
                                          0.6,0.6],...
                              'Curvature',[1,1],...
                              'FaceColor',(21-t)*ones(1,3)/20)
                end
            end
            pause(0.05)
        end
    end
    %End of animateboard
    %Start of playermove
    function [playermark,commark]=playermove(playermark,commark)
        endturn=0;
        set(instructionbox,'String','Your turn, choose your spot!')
        while endturn==0
            %Prompting player input
            try
                filename = uigetfile();
                %[x,y]=ginput(1);
            catch
                winner='n';
                return
            end
            %row=9-ceil(y(1)-0.5);
            %col=ceil(x(1)-0.5);
            %Checking player input
            oldmark = playermark; %Save the board state
            [newmark, commark] = green_seg(filename); %Get new state
            playermark = newmark;
            
            newmark = newmark - oldmark;
            [row, col] = find(newmark == 1);
            playermark(row, col) = 0;
            
            [endturn,r,c]=evaluateposition(playermark,commark,row,col,'p');
            %Updating board
            if endturn>0
                pause(0.5)
                cla
                playermark(row,col)=1;
                drawboard(playermark,commark)
                pause(0.5)
                animateboard(playermark,commark,r,c)
                for count=1:numel(r)
                    playermark(r(count),c(count))=1;
                    commark(r(count),c(count))=0;
                end
                pause(0.5)
                drawboard(playermark,commark)
            else
                set(instructionbox,'String',['Cannot choose that spot!',...
                                             ' Choose another spot!'])
            end
        end
    end
    %End of playermove
    %Start of commove
    function [playermark,commark]=commove(playermark,commark)
        set(instructionbox,'String','COM turn, please wait...')
        pause(0.5)
        %Finding position that give the most swap
        possiblemove=findpossiblemove(playermark,commark,'c');
        [row,col]=find(possiblemove==max(max(possiblemove)));
        randomchoice=ceil(rand*numel(row));
        row=row(randomchoice);
        col=col(randomchoice);
        %Applying decision
        [~,r,c]=evaluateposition(playermark,commark,row,col,'c');
        %Updating board
        pause(0.5)
        commark(row,col)=1;
        cla
        drawboard(playermark,commark)
        pause(0.5)
        animateboard(playermark,commark,r,c)
        for count=1:numel(r)
            playermark(r(count),c(count))=0;
            commark(r(count),c(count))=1;
        end
        pause(0.5)
        drawboard(playermark,commark)
    end
    %End of commove
    %Start of checkboard
    function winner=checkboard(playermark,commark)
        playerpmove=findpossiblemove(playermark,commark,'p');
        compmove=findpossiblemove(playermark,commark,'c');
        if sum(sum(playerpmove+compmove))==0
            if sum(sum(playermark))>sum(sum(commark))
                winner='p';
            elseif sum(sum(playermark))<sum(sum(commark))
                winner='c';
            elseif sum(sum(playermark))==sum(sum(commark))
                winner='d';
            end
        else
            winner=[];
        end
    end
    %End of checkboard
    %Start of findpossiblemove
    function possiblemove=findpossiblemove(playermark,commark,turn)
        possiblemove=zeros(8);
        %Finding possible swap count for all positions
        for i=1:8
        for j=1:8
            possiblemove(i,j)=evaluateposition(playermark,commark,...
                                               i,j,turn);
        end
        end
    end
    %End of findpossiblemove
    %Start of evaluateposition
    function [score,r,c]=evaluateposition(playermark,commark,row,col,turn)
        %Initiating result variables
        score=0;
        r=[];
        c=[];
        %Checking whether selected box is out of bound
        if (row<1)||(row>8)||(col<1)||(col>8)
            return
        end
        %Checking whether selected box had been marked
        if (playermark(row,col)==1)||(commark(row,col)==1)
            return
        end
        %Swapping between playermark and commark based on turn
        if strcmpi(turn,'p')
            currentturnmark=playermark;
            opposingturnmark=commark;
        elseif strcmpi(turn,'c')
            currentturnmark=commark;
            opposingturnmark=playermark;
        end
        %Evaluating position for possible swapping
            %Checking for possible swapping from upperside neighbor
            if row~=1
                tempval1=find(currentturnmark(1:row-1,col)==1);
                if ~isempty(tempval1)
                    upperpaircandidate=max(tempval1);
                    tempval2=opposingturnmark(upperpaircandidate+1:...
                                              row-1,...
                                              col);
                    if sum(tempval2)==numel(tempval2)
                        score=score+sum(tempval2);
                        r=[r,upperpaircandidate+1:row-1];
                        c=[c,col*(ones(1,numel(tempval2)))];
                    end
                end
                clear tempval1 tempval2 upperpaircandidate
            end
            %Checking for possible swapping from lowerside neighbor
            if row~=8
                tempval1=find(currentturnmark(row+1:8,col)==1);
                if ~isempty(tempval1)
                    lowerpaircandidate=row+min(tempval1);
                    tempval2=opposingturnmark(row+1:...
                                              lowerpaircandidate-1,...
                                              col);
                    if sum(tempval2)==numel(tempval2)
                        score=score+sum(tempval2);
                        r=[r,row+1:lowerpaircandidate-1];
                        c=[c,col*(ones(1,numel(tempval2)))];
                    end
                end
                clear tempval1 tempval2 lowerpaircandidate
            end
            %Checking for possible swapping from leftside neighbor
            if col~=1
                tempval1=find(currentturnmark(row,1:col-1)==1);
                if ~isempty(tempval1)
                    leftpaircandidate=max(tempval1);
                    tempval2=opposingturnmark(row,...
                                              leftpaircandidate+1:col-1);
                    if sum(tempval2)==numel(tempval2)
                        score=score+sum(tempval2);
                        r=[r,row*(ones(1,numel(tempval2)))];
                        c=[c,leftpaircandidate+1:col-1];
                    end
                end
                clear tempval1 tempval2 leftpaircandidate
            end
            %Checking for possible swapping from rightside neighbor
            if col~=8
                tempval1=find(currentturnmark(row,col+1:8)==1);
                if ~isempty(tempval1)
                    rightpaircandidate=col+min(tempval1);
                    tempval2=opposingturnmark(row,...
                                              col+1:rightpaircandidate-1);
                    if sum(tempval2)==numel(tempval2)
                        score=score+sum(tempval2);
                        r=[r,row*(ones(1,numel(tempval2)))];
                        c=[c,col+1:rightpaircandidate-1];
                    end
                end
                clear tempval1 tempval2 rightpaircandidate
            end
            %Checking for possible swapping from upperleftside neighbor
            if (row~=1)||(col~=1)
                elmncount=min(row,col)-1;
                testarray1=zeros(1,elmncount);
                testarray2=zeros(1,elmncount);
                for count=1:elmncount
                    testarray1(count)=currentturnmark(row-elmncount+...
                                                      count-1,...
                                                      col-elmncount+...
                                                      count-1);
                    testarray2(count)=opposingturnmark(row-elmncount+...
                                                       count-1,...
                                                       col-elmncount+...
                                                       count-1);
                end
                tempval1=find(testarray1==1);
                if ~isempty(tempval1)
                    paircandidate=max(tempval1);
                    tempval2=testarray2(paircandidate+1:end);
                    if sum(tempval2)==numel(tempval2)
                        score=score+sum(tempval2);
                        r=[r,row-numel(tempval2):row-1];
                        c=[c,col-numel(tempval2):col-1];
                    end
                end
                clear testarray1 testarray2 tempval1 tempval2 paircandidate
            end
            %Checking for possible swapping from upperrightside neighbor
            if (row~=1)||(col~=8)
                elmncount=min(row,9-col)-1;
                testarray1=zeros(1,elmncount);
                testarray2=zeros(1,elmncount);
                for count=1:elmncount
                    testarray1(count)=currentturnmark(row-elmncount+...
                                                      count-1,...
                                                      col+elmncount-...
                                                      count+1);
                    testarray2(count)=opposingturnmark(row-elmncount+...
                                                       count-1,...
                                                       col+elmncount-...
                                                       count+1);
                end
                tempval1=find(testarray1==1);
                if ~isempty(tempval1)
                    paircandidate=max(tempval1);
                    tempval2=testarray2(paircandidate+1:end);
                    if sum(tempval2)==numel(tempval2)
                        score=score+sum(tempval2);
                        r=[r,row-numel(tempval2):row-1];
                        c=[c,col+numel(tempval2):-1:col+1];
                    end
                end
                clear testarray1 testarray2 tempval1 tempval2 paircandidate
            end
            %Checking for possible swapping from lowerleftside neighbor
            if (row~=8)||(col~=1)
                elmncount=min(9-row,col)-1;
                testarray1=zeros(1,elmncount);
                testarray2=zeros(1,elmncount);
                for count=1:elmncount
                    testarray1(count)=currentturnmark(row+elmncount-...
                                                      count+1,...
                                                      col-elmncount+...
                                                      count-1);
                    testarray2(count)=opposingturnmark(row+elmncount-...
                                                       count+1,...
                                                       col-elmncount+...
                                                       count-1);
                end
                tempval1=find(testarray1==1);
                if ~isempty(tempval1)
                    paircandidate=max(tempval1);
                    tempval2=testarray2(paircandidate+1:end);
                    if sum(tempval2)==numel(tempval2)
                        score=score+sum(tempval2);
                        r=[r,row+numel(tempval2):-1:row+1];
                        c=[c,col-numel(tempval2):col-1];
                    end
                end
                clear testarray1 testarray2 tempval1 tempval2 paircandidate
            end
            %Checking for possible swapping from lowerrightside neighbor
            if (row~=8)||(col~=8)
                elmncount=min(9-row,9-col)-1;
                testarray1=zeros(1,elmncount);
                testarray2=zeros(1,elmncount);
                for count=1:elmncount
                    testarray1(count)=currentturnmark(row+elmncount-...
                                                      count+1,...
                                                      col+elmncount-...
                                                      count+1);
                    testarray2(count)=opposingturnmark(row+elmncount-...
                                                       count+1,...
                                                       col+elmncount-...
                                                       count+1);
                end
                tempval1=find(testarray1==1);
                if ~isempty(tempval1)
                    paircandidate=max(tempval1);
                    tempval2=testarray2(paircandidate+1:end);
                    if sum(tempval2)==numel(tempval2)
                        score=score+sum(tempval2);
                        r=[r,row+numel(tempval2):-1:row+1];
                        c=[c,col+numel(tempval2):-1:col+1];
                    end
                end
                clear testarray1 testarray2 tempval1 tempval2 paircandidate
            end
    end
    %End of evaluateposition
%Declaring CallbackFunction
    %Start of startgamefcn
    function startgamefcn(~,~)
        %Resetting mark
        playermark=zeros(8);
        playermark(4,4)=1;
        playermark(5,5)=1;
        commark=zeros(8);
        commark(4,5)=1;
        commark(5,4)=1;
        winner=[];
        %Resetting board
        cla
        drawboard(playermark,commark)
        %Randomly choose player for first turn
        decision=rand;
        if decision<=0.5
            turn='p';
        elseif decision>0.5
            turn='c';
        end
        %Playing games
        while isempty(winner)
            if strcmpi(turn,'p')
                possiblemove=findpossiblemove(playermark,commark,'p');
                if sum(sum(possiblemove))==0
                    set(instructionbox,...
                        'String',['No available move,',...
                                  ' skipping player turn'])
                    pause(0.5)
                else
                    [playermark,commark]=playermove(playermark,commark);
                end
                if ~strcmpi(winner,'n')
                    winner=checkboard(playermark,commark);
                end
                clear possiblemove
            elseif strcmpi(turn,'c')
                possiblemove=findpossiblemove(playermark,commark,'c');
                if sum(sum(possiblemove))==0
                    set(instructionbox,...
                        'String',['No available move,',...
                                  ' skipping COM turn'])
                    pause(0.5)
                else
                    [playermark,commark]=commove(playermark,commark);
                end
                winner=checkboard(playermark,commark);
                clear possiblemove
            end
            if isempty(winner)
                if strcmpi(turn,'p')
                    turn='c';
                elseif strcmpi(turn,'c')
                    turn='p';
                end
            else
                if strcmpi(winner,'p')
                    set(instructionbox,'String',['Congratulations!',...
                                                 ' You win!!!'])
                elseif strcmpi(winner,'c')
                    set(instructionbox,'String',['You lose!',...
                                                 ' Press Start to retry!'])
                elseif strcmpi(winner,'d')
                    set(instructionbox,'String',['It is a draw.',...
                                                 ' Press Start to retry!'])
                end
            end
        end
    end
    %End of startgamefcn
    %Start of closegamefcn
    function closegamefcn(~,~)
        if strcmpi(turn,'p')
            winner='n';
            pause(1)
            clear all
            close 'Othello'
        elseif strcmpi(turn,'p')
            set(instructionbox,...
                'String',['Cannot close the game during COM turn!',...
                          ' Please wait for your turn!'])
        end
    end
    %End of closegamefcn
%CodeEnd-------------------------------------------------------------------

end