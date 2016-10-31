function KB_updated = CS4300_tell(KB, sentence)
% CS4300_tell - Notifies knowledge base of new sentence
% On input:
%     KB (array of sentences) : a knowledgebase, initially the atemporal “wumpus physics”
%     sentence (CNF data structure): array of conjuctive clauses
%       (i).clauses
%           each clause is a list of integers (- for negated literal)
% Call:
%     CS4300_tell(KB,sentence);
% Author:
%     Rajul Ramchandani & Conan Zhang
%     UU
%     Fall 2016
%
[n,m] = size(KB);
[x,z] = size(sentence);

    contains = 0;
    for i = 1:m
        if isequal(KB(i).clauses, sentence)
           contains = 1; 
        end
    end
    if contains == 0
        KB(end+1).clauses = sentence; 
    end


KB_updated = KB;