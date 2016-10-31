function agent = CS4300_agent_update(agent_in,action)

FORWARD = 1;
ROTATE_RIGHT = 2;
ROTATE_LEFT = 3;
GRAB = 4;
SHOOT = 5;
CLIMB = 6;

agent = agent_in; 
if action==2
    agent.dir = mod(agent.dir-1,4);
    return
end

if action==3
    agent.dir = mod(agent.dir+1,4);
    return
end
if action ==1
    if agent.dir==0 && agent.x~=4
        agent.x = agent.x+1;
        return
    end

    if agent.dir==1 && agent.y~=4
        agent.y = agent.y+1;
        return
    end
    
    if agent.dir==2 && agent.x~=1
        agent.x = agent.x-1;
        return
    end
    
    if agent.dir==3 && agent.y~=1
        agent.y = agent.y-1;
        return
    end
end
