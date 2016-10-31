function adj = CS4300_get_adjacent(x,y)
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