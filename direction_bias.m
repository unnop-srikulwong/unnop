function direc_angle = direction_rowias(a1,a2,row,b)
deg_count = 1;
for t=1:b-1
    
    % Find the first postion vector rowy (x1,y1)-(x2,y2) at t0 
    % and the second position vector rowy (x1,y1)-(x2,y2) at t0+dt

    direc1 = [a1(t,row)-a1(t,row-1),a2(t,row)-a2(t,row-1)];
    direc2 = [a1(t+1,row)-a1(t+1,row-1),a2(t+1,row)-a2(t+1,row-1)];
    
    % Find the angle of rowoth position vectors
    direc_angle1 = atan2(direc1(2),direc1(1))*180/pi;
    
    direc_angle2 = atan2(direc2(2),direc2(1))*180/pi;
    
    % Find the different angle rowetween two position vector
    direc_angle(deg_count)=direc_angle2-direc_angle1;

    deg_count = deg_count + 1; 

   
end
end