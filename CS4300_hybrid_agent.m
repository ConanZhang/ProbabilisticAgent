function action = CS4300_hybrid_agent(percept)
% CS4300_make_percept_sentence - Takes an agent percept and converts it
% into a sentence
% On input:
%     percept (1x5 Boolean array): percept values
%       (1): Stench variable (neighbors wumpus)
%       (2): Breeze variable (neighbors pit)
%       (3): Glitter variable (cell contains gold)
%       (4): Bump variable (hit wall trying to move)
%       (5): Scream variable (arrow killed wumpus)
% On output:
%     action (int): action for wumpus to take
%       FORWARD = 1;
%       RIGHT = 2;
%       LEFT = 3;
%       GRAB = 4;
%       SHOOT = 5;
%       CLIMB = 6;
% Call:
%     CS4300_hybrid_agent(50);
% Author:
%     Rajul Ramchandani & Conan Zhang
%     UU
%     Fall 2016
%

persistent KB;
persistent t;
persistent plan;
persistent safe;
persistent not_unsafe;
persistent visited;
persistent unvisited;
persistent current;
persistent haveGold;

if isempty(KB)
    KB = CS4300_generate_default_KB();
end

if isempty(safe)
    safe = ones(4,4); %current spots and unvisited safe spots
    safe = -1*safe;
end

if isempty(not_unsafe)
    not_unsafe = zeros(4,4); % Spots that can be proven to be safe or unsafe
end

if isempty(visited)
    visited = zeros(4,4); %all spots you have visited yourself
end

if isempty(unvisited)
    unvisited = zeros(4,4); %all unvisited explored spots will be 1, real unvisited spots you know nothing about will be 0
end

if isempty(t)
   t = 0; 
end

if isempty(haveGold)
   haveGold = 0; 
end

if isempty(current)
   current.x = 1;
   current.y = 1; 
   current.r = 0; 
end

pit_numbers= [1,2,3,4;5,6,7,8;9,10,11,12; 13,14,15,16];
pit_numbers = flipud(pit_numbers);
pno = pit_numbers(5-current.y,current.x);
temp = [];
percept_sentences =[];
percept_sentences = CS4300_make_percept_sentence(current, percept, t);
[n,m] = size(percept_sentences);

for i= 1:m
    KB = CS4300_tell(KB, percept_sentences(i).clauses);
end

temp(1).clauses = -(pno);
KB = CS4300_tell(KB, -(pno)); %no pit
temp(1).clauses = -(pno + 32);
KB = CS4300_tell(KB, -(pno + 32)); %no wumpus
visited( 5-current.y, current.x) = 1;
unvisited(5-current.y, current.x) = 0;
safe( 5-current.y,current.x) = 0;

adj = get_adjacent(current.x, current.y); %adj.coord structure

[col,row] = size(adj);
for i = 1:row
    adj_x = adj(i).coord(1);
    adj_y = adj(i).coord(2);
    adj_pno = pit_numbers( 5-adj_y, adj_x);
        
    if CS4300_ask(KB,-(adj_pno+ 32))==1 && CS4300_ask(KB,  -(adj_pno))==1 %check for no w and p in adjacent spots and add to safe
        safe(5-adj_y,adj_x) = 0;
    end
     if CS4300_ask(KB,(adj_pno+ 32))==1 || CS4300_ask(KB, (adj_pno))==1 %check for w and p in adjacent spots and add to safe
        safe(5-adj_y,adj_x) = 1;
    end
end

% Glitter Ask
if haveGold==0 && CS4300_ask(KB, pno + 64)
    plan(end+1) = 4;
    % Does third parameter of [1,1,0] need to be 1?
    solution = CS4300_plan_route(current, [1,1,0], safe);
    % Add solution into plan
    [n, m] = size(solution);
    for i = 1:m
       plan(end+1) = solution(i); 
    end
    plan(end+1) = 6;
    haveGold = 1;
end

% unvisited Ask
if isempty(plan)
   %look at adjacent spots and add to unvisited if they havent been visited
   for i = 1:row
       adj_x = adj(i).coord(1);
       adj_y = adj(i).coord(2);
       if visited(5-adj_y, adj_x) == 0
           unvisited( 5-adj_y, adj_x)= 1;
       end
   end
   %TODO: wait for Tom to reply on how to pick destination for A*
   % in plan route - find the point with least manhattan distance and
   % use that for the A* call
   
   % Intersect safe and unvisited
%    safe_inv = ~safe;
    [n,m] = size(safe);
    safe_copy = safe;
    for i=1:m
        for j=1:n
            if safe(i,j)==1
                safe_copy(i,j) = 0;
            elseif safe(i,j)==0
                safe_copy(i,j) = 1;
            end
        end
    end
   unvisited_safe = safe_copy + unvisited; 
   [row,col] = find(unvisited_safe==2);
   
   if ~isempty(row) && ~isempty(col)
       % Add solution into plan
       abs_safe = abs(safe);
       solution = CS4300_plan_route(current, [col(1), 5-row(1), 0], abs_safe);
       [n, m] = size(solution);
       for i = 1:m
          plan(end+1) = solution(i); 
       end
   end
end

% Take Risk
if isempty(plan)
   % Calculate not_unsafe spaces
   [col,row] = size(adj);
    for i = 1:row
        adj_x = adj(i).coord(1);
        adj_y = adj(i).coord(2);
        adj_pno = pit_numbers(5-adj_y, adj_x );

        %if CS4300_ask(KB,[(adj_pno+ 32), adj_pno]) == 0%check for w or p in adjacent spots and add to not_unsafe if there are none
        if safe(5-adj_y, adj_x) == -1
            not_unsafe( 5-adj_y, adj_x) = 1;
        end
    end
    
    unvisited_not_unsafe = not_unsafe + unvisited; 
    [row,col] = find(unvisited_not_unsafe == 2); 
   
    if ~isempty(row) && ~isempty(col)
        % Add solution into plan
        
        solution = CS4300_plan_route(current, [col(1),5-row(1), 0], safe);
        [n, m] = size(solution);
        for i = 1:m
          plan(end+1) = solution(i); 
        end
    end
end

% Last is Empty check
% if isempty(plan)
%     plan(end+1) = CS4300_plan_route(current, [1,1,0], safe);
%     plan(end+1) = 6;
% end

% Pop action and do it


action = plan(1);


plan = plan(:,2:end);
current = move_agent(current, action); %move agent

t = t + 1;

[a,b] = size(KB);
t, b

end

function adj = get_adjacent(x,y)
    adj = [];
    if x-1>0 %add left element
        adj(end+1).coord = [x-1,y];
    end
    if x+1<5 %add right element
        adj(end+1).coord = [x+1,y];
    end

    if y-1>0
        adj(end+1).coord = [x,y-1];
    end

     if y+1<5
        adj(end+1).coord = [x,y+1];
     end
end

function agent = move_agent(current, action)
agent = current; 
if action==2
    agent.r = mod(agent.r-1,4);
    return
end

if action==3
    agent.r = mod(agent.r+1,4);
    return
end
if action ==1
    if agent.r==0 && agent.x~=4
        agent.x = agent.x+1;
        return
    end

    if agent.r==1 && agent.y~=4
        agent.y = agent.y+1;
        return
    end
    
    if agent.r==2 && agent.x~=1
        agent.x = agent.x-1;
        return
    end
    
    if agent.r==3 && agent.y~=1
        agent.y = agent.y-1;
        return
    end
end

end