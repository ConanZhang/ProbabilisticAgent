function action_sequence = CS4300_plan_route(current, goals, board)
% CS4300_ask - Tells whether can resolve theorem with knowledge base
% On input:
%     current: The current position of the agent
%     goals(set of cells) : a set of squares; try to plan a route to one of them
%     board (set of cells): a set of squares that can form part of the
%     row and col: coordinates of the destination
%     route
% On output:
%     action_sequence (array of ints): sequence of actions to reach goal
% Call:
%     action_sequence = CS4300_plan_route(current, goals, allowed);
% Author:
%     Rajul Ramchandani & Conan Zhang
%     UU
%     Fall 2016
%
action_sequence = [];
board(goals(2), 5-goals(1)) = 0;


[solution, nodes] = CS4300_Wumpus_A_star(board, [current.x, current.y, current.r], goals, 'CS4300_A_star_Man');

for i = 1:size(solution)
    if(solution(i, 4) ~= 0)
        action_sequence(end+1) = solution(i, 4);
    end
end
