function action = CS4300_MC_agent(percept)
% CS4300_MC_agent - Monte Carlo agent with a few informal rules
% On input:
%     percept (1x5 Boolean vector): percept from Wumpus world
%       (1): stench
%       (2): breeze
%       (3): glitter
%       (4): bump
%       (5): scream
% On output:
%     action (int): action to take
%       1: FORWARD
%       2: RIGHT
%       3: LEFT
%       4: GRAB
%       5: SHOOT
%       6: CLIMB
% Call:
%     a = CS4300_MC_agent(percept);
% Author:
%     T. Henderson
%     UU
%     Fall 2016
%

FORWARD = 1;
RIGHT = 2;
LEFT = 3;
GRAB = 4;
SHOOT = 5;
CLIMB = 6;

persistent safe pits Wumpus breezes stench board have_gold have_arrow wumpus_killed plan
persistent agent frontier visited t

if isempty(agent)
    t = 0;
    agent.x = 1;
    agent.y = 1;
    agent.dir = 0;
    safe = -ones(4,4);
    pits = -ones(4,4);
    Wumpus = -ones(4,4);
    breezes = -ones(4,4);
    stench = -ones(4,4);
    board = -ones(4,4);
    visited = zeros(4,4);
    frontier = zeros(4,4);
    safe(4,1) = 1;
    pits(4,1) = 0;
    Wumpus(4,1) = 0;
    board(4,1) = 0;
    visited(4,1) = 1;
    have_gold = 0;
    have_arrow = 1;
    wumpus_killed = 0;
end

if have_gold==1&~isempty(plan)
    action = plan(1);
    plan = plan(2:end);
    return
end

% incorporate new percepts
% Stench
if(percept(1) == 1 && ~wumpus_killed)
    stench(5 - agent.y, agent.x) = 1;
else
    stench(5 - agent.y, agent.x) = 0;
end
% Breezes
if(percept(2) == 1)
    breezes(5 - agent.y, agent.x) = 1;
else
    breezes(5 - agent.y, agent.x) = 0;
end
% Scream
if(percept(5) == 1)
    wumpus_killed = 1;
    stench = zeros(4,4);
end



% find safest place to go
[pits,Wumpus] = CS4300_WP_estimates(breezes,stench,20);




% update info
visited(5 - agent.y, agent.x) = 1;
board(5 - agent.y, agent.x) = 0;
safe(5 - agent.y, agent.x) = 1;

% Update safe
safe(5 - agent.y, agent.x) = 1;
[safe_rows, safe_cols] = find(pits == 0&Wumpus == 0);
for i = 1:size(safe_rows)
    if safe(safe_rows(i), safe_cols(i)) == -1
        safe(safe_rows(i), safe_cols(i)) = 1;
    end
    if board(safe_rows(i), safe_cols(i)) == -1
        board(safe_rows(i), safe_cols(i)) = 0;
    end
end

% Update by pits
[pit_rows, pit_cols] = find(pits == 1);
for i = 1:size(pit_rows)
    if board(pit_rows(i), pit_cols(i)) == -1
        board(pit_rows(i), pit_cols(i)) = 1;
    end
    if safe(pit_rows(i), pit_cols(i)) == -1
        safe(pit_rows(i), pit_cols(i)) = 0;
    end
end

% Update by Wumpus
[wumpus_row, wumpus_col] = find(Wumpus == 1);
if board(wumpus_row, wumpus_col) == -1
    board(wumpus_row, wumpus_col) = 3;
end
if safe(wumpus_row, wumpus_col) ==-1
    safe(wumpus_row, wumpus_col) = 0;
end

% Update frontier
adj =[];
adj = CS4300_get_adjacent(agent.x, agent.y);
[col,row] = size(adj);
for i = 1:row
    adj_x = adj(i).coord(1);
    adj_y = adj(i).coord(2);
    frontier(5-adj_y, adj_x) = 1;
end

% Glitter Check
if percept(3)==1
    plan = [GRAB];
    have_gold = 1;
    [so,no] = CS4300_Wumpus_A_star(abs(board),...
        [agent.x,agent.y,agent.dir],...
        [1,1,0],'CS4300_A_star_Man');
    for i = 1:size(so)
        if(so(i, 4) ~= 0)
            plan(end+1) = so(i, 4);
        end
    end
    plan(end+1) = CLIMB;
end

% Unvisited Safe Spaces
if isempty(plan)
    [cand_rows,cand_cols] = find(frontier==1&safe==1&visited==0);
    if ~isempty(cand_rows)
        cand_x = cand_cols;
        cand_y = 4 - cand_rows + 1;
        [so,no] = CS4300_Wumpus_A_star(abs(board),...
            [agent.x,agent.y,agent.dir],...
            [cand_x(1),cand_y(1),0],'CS4300_A_star_Man');
        
        for i = 1:size(so)
            if(so(i, 4) ~= 0)
                plan(end+1) = so(i, 4);
            end
        end
    end
end

% No Wumpus shot yet
if have_arrow==1&isempty(plan)
    % Use probability to generate Wumpus board
    plan = CS4300_plan_shot(agent,Wumpus,visited,safe,board);
end

% Take a risk
if isempty(plan)
    [cand_rows,cand_cols] = find(frontier==1&safe==-1&visited==0);
    % Have agent kill itself
    if isempty(cand_rows)
        [cand_rows,cand_cols] = find(frontier==1&visited==0);
    end
    probs = ones(4,4)*2;
    for i = 1:size(cand_rows)
        probs(cand_rows(i), cand_cols(i)) = pits(cand_rows(i), cand_cols(i))...
                                       + Wumpus(cand_rows(i), cand_cols(i));
    end
     minValue = min(probs(:));
    [row,col] = find(probs == minValue);
    board(row(1), col(1)) = 0;
    [so,no] = CS4300_Wumpus_A_star(abs(board),...
            [agent.x,agent.y,agent.dir],...
            [col(1),5-row(1),0],'CS4300_A_star_Man');
        
    for i = 1:size(so)
        if(so(i, 4) ~= 0)
            plan(end+1) = so(i, 4);
        end
    end
end

if isempty(plan)
    bleh
end
action = plan(1);
plan = plan(2:end);

% Update agent's idea of state
agent = CS4300_agent_update(agent,action);
visited(4-agent.y+1,agent.x) = 1;

if action==SHOOT
    have_arrow = 0;
end

tch = 0;