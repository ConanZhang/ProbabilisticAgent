function KB = CS4300_generate_default_KB()
% CS4300_generate_default_KB - Generates default KB for a 4x4 board
% On output:
%     KB 
% Call:
%     KB = CS4300_generate_defaultKB;
% Author:
%     Rajul Ramchandani & Conan Zhang
%     UU
%     Fall 2016
%
KB = [];

pit_numbers= [1,2,3,4;5,6,7,8;9,10,11,12; 13,14,15,16];

k = [];

% Pits 1-16 and Breezes 17-32
for i = 1:3
    for j = 1:3
        pno = pit_numbers(i,j);
        bno = pno+16;        
        k(end+1) = -bno;
        if j-1>0 %add left element
            k(end+1) = pno-1;
            KB(end+1).clauses = [bno, -(pno-1)];
        end
        if j+1<5 %add right element
            k(end+1) = pno+1;
            KB(end+1).clauses = [bno, -(pno+1)];
        end
        
        if i-1>0
            k(end+1) = pno-4;
            KB(end+1).clauses = [bno, -(pno-4)];
        end
        
         if i+1<5
            k(end+1) = pno+4;
            KB(end+1).clauses = [bno, -(pno+4)];
        end
        KB(end+1).clauses = k;
        k=[];
    end        
end

% Wumpuses 33-48 and Stenches 49-64
for i = 1:3
    for j = 1:3
        wno = 32+pit_numbers(i,j);
        sno = wno+16;        
        k(end+1) = -sno;
        if j-1>0 %add left element
            k(end+1) = wno-1;
            KB(end+1).clauses = [sno, -(wno-1)];
        end
        if j+1<5 %add right element
            k(end+1) = wno+1;
            KB(end+1).clauses = [sno, -(wno+1)];
        end
        
        if i-1>0
            k(end+1) = wno-4;
            KB(end+1).clauses = [sno, -(wno-4)];
        end
        
         if i+1<5
            k(end+1) = wno+4;
            KB(end+1).clauses = [sno, -(wno+4)];
        end
        KB(end+1).clauses = k;
        k=[];
    end        
end

% No wumpus or pit in starting position
KB(end+1).clauses = [-1];
KB(end+1).clauses = [-33];

% Two diagonal stenches
%KB(end+1).clauses = [-33];