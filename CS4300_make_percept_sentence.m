function sentence = CS4300_make_percept_sentence(current, percept, t)
% CS4300_make_percept_sentence - Takes an agent percept and converts it
% into a sentence
% On input:
%     current: The current position of the agent
%     percept (1x5 Boolean array): percept values
%       (1): Stench variable (neighbors wumpus)
%       (2): Breeze variable (neighbors pit)
%       (3): Glitter variable (cell contains gold)
%       (4): Bump variable (hit wall trying to move)
%       (5): Scream variable (arrow killed wumpus)
%     t (int): a counter indicating time
% On output:
%     sentence (CNF data structure): conjuctive clauses
%       (i).clauses
%           each clause is a list of integers (- for negated literal)
% Call:
%     [s,t] = CS4300_make_percept_sentence(current, 50,'CS4300_hybrid_agent');
% Author:
%     Rajul Ramchandani & Conan Zhang
%     UU
%     Fall 2016
%

pit_numbers= [1,2,3,4;5,6,7,8;9,10,11,12; 13,14,15,16];
pit_numbers = flipud(pit_numbers);
pno = pit_numbers( 5-current.y, current.x);
sentence = [];

% There's a stench
if percept(1) == 1
    sentence(end+1).clauses= pno + 48;
else
    sentence(end+1).clauses= -(pno + 48);
end

% There's a breeze
if percept(2) == 1
    sentence(end+1).clauses = pno + 16;
else
    sentence(end+1).clauses= -(pno + 16);
end

% There's gold
if percept(3) == 1
    sentence(end+1).clauses = pno + 64;
else
    sentence(end+1).clauses= -(pno + 64);
end