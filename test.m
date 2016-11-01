
        

breezes = -ones(4,4);
breezes(4,1) = 1;
stench = zeros(4,4);
[pts,Wumpus] = CS4300_WP_estimates(breezes,stench,1000)

