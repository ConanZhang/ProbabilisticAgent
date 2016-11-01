
        

breezes = -ones(4,4);
breezes(4,1) = 1;
stench = -ones(4,4);
stench(4,1) = 0;
[pts,Wumpus] = CS4300_WP_estimates(breezes,stench,10000)

