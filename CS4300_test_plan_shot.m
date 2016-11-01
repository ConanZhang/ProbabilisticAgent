function test = CS4300_test_plan_shot()
% CS4300_test_plan_shot - Tester method for plan shot
% Call:
%     CS4300_test_plan_shot();
% Author:
%     Rajul Ramchandani & Conan Zhang
%     UU
%     Fall 2016
%

agent.x = 1;
agent.y = 1;
agent.dir = 0;
safe = -ones(4,4);
Wumpus = -ones(4,4);
board = -ones(4,4);
visited = zeros(4,4);
safe(4,1) = 1;
safe(4,2) = 1;
Wumpus(4,1) = 0;
Wumpus(3,2) = 1;
board(4,1) = 0;
board(4,2) = 0;
board(3,2) = 0;
board(3,3) = 0;

visited(4,1) = 1;


plan = CS4300_plan_shot(agent,Wumpus, visited, safe, board);
