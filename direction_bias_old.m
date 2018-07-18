function a = direction_bias(a1,a2,delta_angle,angle_max,angle_min)
[row,col] = size(a1);
a = zeros(angle_max/delta_angle +1 ,2);
deg_count = 0;
%average_deg = zeros(angle_max/delta_angle,2);
for i=1:(abs(angle_max-angle_min)/delta_angle)+1
    
    deg = angle_min + (i-1)*delta_angle;
    a(i,1) = deg;
    direc1 = [a1(row,1)-a1(row-1,1),a1(row,2)-a1(row-1,2)];
    direc2 = [a2(row,1)-a2(row-1,1),a2(row,2)-a2(row-1,2)];
    if (direc1(1)>0) && (direc1(2)>=0) %Quadrant1
        direc_angle1 = atan(direc1(2)/direc1(1))*180/pi;
    elseif (direc1(1)<0) && (direc1(2)>=0) %Quadrant2
        direc_angle1 = (atan(direc1(2)/direc1(1))*180/pi) + 180;
    elseif (direc1(1)<0) && (direc1(2)<=0) %Quadrant3
        direc_angle1 = (atan(direc1(2)/direc1(1))*180/pi) - 180;
    elseif (direc1(1)>0) && (direc1(2)<=0) %Quadrant4
        direc_angle1 = (atan(direc1(2)/direc1(1))*180/pi);
    elseif (direc1(1)==0) && (direc1(2)>0) % perpendicular +y
        direc_angle1 = 90;
    elseif (direc1(1)==0) && (direc1(2)<0) % perpendicular -y
        direc_angle1 = -90;
    end
    
    if (direc2(1)>0) && (direc2(2)>=0) %Quadrant1
        direc_angle2 = atan(direc2(2)/direc2(1))*180/pi;
    elseif (direc2(1)<0) && (direc2(2)>=0) %Quadrant2
        direc_angle2 = (atan(direc2(2)/direc2(1))*180/pi) + 180;
    elseif (direc2(1)<0) && (direc2(2)<=0) %Quadrant3
        direc_angle2= (atan(direc2(2)/direc2(1))*180/pi) - 180;
    elseif (direc2(1)>0) && (direc2(2)<=0) %Quadrant4
        direc_angle2 = (atan(direc2(2)/direc2(1))*180/pi);
    elseif (direc2(1)==0) && (direc2(2)>0) % perpendicular +y
        direc_angle2 = 90;
    elseif (direc2(1)==0) && (direc2(2)<0) % perpendicular -y
        direc_angle2 = -90;
    end
    
    direc_angle=direc_angle2-direc_angle1;
    if (direc_angle>=(deg-(delta_angle*0.5))) && (direc_angle<(deg+(delta_angle*0.5)))
    a(i,2) = deg_count + 1; 
    end 
   
end
end