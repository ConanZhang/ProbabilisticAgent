function adj = CS4300_get_adjacent(row,col)
    adj = [];
    if col-1>0 %add left element
        adj(end+1).coord = [row,col-1];
    end
    if col+1<5 %add right element
        adj(end+1).coord = [row,col+1];
    end

    if row-1>0 %up
        adj(end+1).coord = [row-1,col];
    end

     if row+1<5 %down
        adj(end+1).coord = [row+1,col];
     end
end