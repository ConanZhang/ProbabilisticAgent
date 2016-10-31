function ret = CS4300_WP_satisfies(breeze,stench,board)
ret = 1;
[rows, cols] = size(board);

for r= 1:rows
    for c = 1:cols
        adj = CS4300_get_adjacent(r, c); %adj.coord structure
        [col,row] = size(adj);
        
        if breeze(r,c) == 1
            good =0;
            for i = 1:row %check if there is at least one pit adj to the breeze
                adj_x = adj(i).coord(1);
                adj_y = adj(i).coord(2);
                if board(adj_x, adj_y)==1 %if there is atleast one put around the breeze, the board is good
                    good =1;
                    break;
                end
                
            end
            if good ==0 %did not find a pit
                ret = 0;
                return;
            end
        elseif breeze(r,c) == 0
            good =1;
            for i = 1:row %check if there is no pits adj to the breeze
                adj_x = adj(i).coord(1);
                adj_y = adj(i).coord(2);
                if board(adj_x, adj_y)==1 %if there is a pit near the breeze, the board is bad
                    good =0;
                    ret = 0;
                    return;
                    
                end 
            end
        elseif stench(r,c) == 1
            good =0;
            for i = 1:row %check if there is at least one wumpus adj to the stench
                adj_x = adj(i).coord(1);
                adj_y = adj(i).coord(2);
                if board(adj_x, adj_y)>=3 %if there is atleast one wumpus around the stench, the board is good
                    good =1;
                    break;
                end
                
            end
            if good ==0 %did not find a wumpus
                ret = 0;
                return;
            end
        elseif stench(r,c) == 0
            good =1;
            for i = 1:row %check if there is no wumpus adj to the stench
                adj_x = adj(i).coord(1);
                adj_y = adj(i).coord(2);
                if board(adj_x, adj_y)>=3 %if there is a wumpus near the stench, the board is bad
                    good =0;
                    ret = 0;
                    return;
                end 
            end
            
               
        end

    end
end    
    ret = 1;
    return;
end
