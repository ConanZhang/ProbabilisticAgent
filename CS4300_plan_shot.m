function plan = CS4300_plan_shot(agent,Wumpus,visited,safe,board)
% CS4300_plan_shot - Plans a shot to a wumpus on the board
% On input:
%     agent: The current position of the agent
%     Wumpus:
%     board (set of cells): a set of squares that can form part of the
% On output:
%     plan (array of ints): sequence of actions to take shot
% Call:
%     plan = CS4300_plan_shot(agent,Wumpus, visited, safe, board);
% Author:
%     Rajul Ramchandani & Conan Zhang
%     UU
%     Fall 2016
%

plan = [];

% Find cell that is safe with same Wumpus row and col
safe_location.x = 1;
safe_location.y = 1;
safe_location.dir = 0;

[row,col] = find(Wumpus==1);
if(isempty(row) || isempty(col))
   return; 
end

for i = 1:4
    if(safe(row(1),i) == 1)
        safe_location.x = row(1);
        safe_location.y = i;
        if(safe_location.y < col(1))
            safe_location.dir = 0;
        else
            safe_location.dir = 2;
        end
        break;
    end
    
    if(safe(i, col(1)) == 1)
        safe_location.x = i;
        safe_location.y = col(1);
        if(safe_location.x > row(1))
            safe_location.dir = 1;
        else
            safe_location.dir = 3;
        end
        break;
    end
end

% Use A* to move to shot location
[solution, nodes] = CS4300_Wumpus_A_star(abs(safe), [agent.x, agent.y, agent.dir]...
, [safe_location.y, 5-safe_location.x, 0], 'CS4300_A_star_Man');

% Move there
for i = 1:size(solution)
    if(solution(i, 4) ~= 0)
        plan(end+1) = solution(i, 4);
    end
end

% Make sure direction is toward Wumpus
end_dir = solution(end, 3);
dif = abs(end_dir - safe_location.dir);

if(dif == 1)
   if(end_dir < safe_location.dir)
      plan(end+1) = 3;
   else
      plan(end+1) = 2;
   end
elseif(dif == 2)
    plan(end+1) = 3;
    plan(end+1) = 3;
elseif(dif == 3)
    plan(end+1) = 3;
end

% Shoot arrow
plan(end+1) = 5;
