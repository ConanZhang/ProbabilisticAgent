function [scores,traces] = CS4300_WW3(max_steps,f_name)
% CS4300_WW3 - Wumpus World 3 (hybrid agent) simulator
% On input:
%     max_steps (int): maximum number of simulation steps
%     f_name (string): name of agent function
% On output:
%     score (int): agent score on game
%     trace (nx3 int array): trace of state
%       (i,1): x location
%       (i,2): y location
%       (i,3): action selected at time i
% Call:
%     [s,t] = CS4300_WW3(50,'CS4300_hybrid_agent');
% Author:
%     T. Henderson
%     UU
%     Summer 2015
%

traces = [];

agent.x = 1;
agent.y = 1;
agent.alive = 1;  
agent.gold = 0;  % grabbed gold in same room
agent.dir = 0;  % facing right
agent.succeed = 0;  % has gold and climbed out
agent.climbed = 0; % climbed out

clear(f_name);
b = load('A5_boards.mat');

success =0;
failure = 0;
scores = [];

for i = 1:50
    for trials = 1:5
        
        board = b(1).boards(i).board;
        clear(f_name);
        [score,trace] = CS4300_WW1(max_steps,f_name,board);
        scores(i,trials) = score;
        if score>=0
            success = success +1;
        else
            failure = failure +1;
        end
    end
end
scores
