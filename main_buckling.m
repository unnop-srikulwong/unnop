clear all;
clear all;
clc;

% Define the directory of all data files
Pathdirection=[pwd,'/HsFA9T'];

filenameExtension='/*poly*.dat';

timestep=1;

% Find the number of file in folder name which starts with "part"
% Checking how many the system which we calculate
a=length(dir('HsFA9T/*part*'));

% Define the number of point for calculating the buckle
% Example
% We create 2 position vectors ( a vector points from 1' to 2' and a vector points from 1' to final point)
% If there are 5 points, the first vector will point from 1' to 2' and the second vector will point 
% from 1' to 5'. After that, we calculatting the angle between two vector positions and define 
% the angle which can probably occur the buckle of microtubules. In addition, we calculate the velocity 
% at the point which occur the buckle in order to compare the velocity before and after position of buckle.
% If these velocities are significantly different, it will cause the buckle.  
point=5;


% This is main loop in this code
for part=1:a % Loop for each part

    % Create file in order to write filename that occur the buckle
    fileID = fopen([pwd,'/distance/','buckle_part_',int2str(part-1),'.txt'],'w');
    store=1;
    
    for fol=1:100 % Loop for each replica
    
        % This value is defined for skipping some duplicate data since we want to check 
        % whether there are some buckle. If there are some buckle in a replica, skip 
        % that replica to other replica and keep on calculating for reducing the calculating time.
        cut_stack=fol;
        
        % Read all microtubule files of each replica 
        folder_name=[Pathdirection,'/part',int2str(part-1),'/',int2str(fol),'/data',filenameExtension];
        
        % List the filename of all microtubule files and keep them in array
	% Example
	% polymer_coordinate0010000000.dat
	% polymer_coordinate0020000000.dat
	% polymer_coordinate ....
        Fname=dir(folder_name);
        
        % Find the size of above array
        % Example
        % If there are 40 files in a replica, b = 40
        b=length(dir(folder_name));
        
        % Loop for reading data in all microtubule files
        for L=1:b
            
            % Read each microtubule file of each replica 
            folder_name1=[Pathdirection,'/part',int2str(i-1),'/',int2str(j),'/data','/',Fname(L).name];
            
            % Read data in microtubule file of each replica and keep them in array
            % Example 
            %    (x)        (y)
            % 000000000  00000000
            % 000000000  00000000
            % ........   ........
            % There are 2 column (x position and y position) 
            tmpdata1=dlmread(folder_name1,'');
            
            % Read x position 
            % and store values in array
            com1(L,:)=(tmpdata1(:,1)); 
            
            % Read y position 
            % And store values in array
            com2(L,:)=(tmpdata1(:,2));
            
        end % End loop for reading data in all microtubule files
        
        angle=zeros(52-point,b);
        vel=zeros(52-point,b);
        
        % Loop for finding the buckle of microtubule of each replica
        for t=1:b
                
                % Loop for creating two position vectors and calculating the angle between them
                for i=1:1:52-point
                
                    % Create two position vectors
                    vec1(:,1)=[com1(t,i+1)-com1(t,i),com2(t,i+1)-com2(t,i),0];
                    vec2(:,1)=[com1(t,i+point-1)-com1(t,i),com2(t,i+point-1)-com2(t,i),0];
                    
                    % Calculate the angle between two position vectors (degree)
                    angle(i,t) = atan2(norm(cross(vec1,vec2)),dot(vec1,vec2))*180/pi;
                    
                end % End loop for calculating two position vectors and the angle between them
                
                % Loop for calculating the velocity and define the diffrent velocities
                % for checking the buckle
                for i=1:1:52-point
                    if angle(i,t)>10
                            vel(i,t)=sqrt((com1(t,i)-com1(t-1,i)).^2+(com2(t,i)-com2(t-1,i)).^2);
                    end
                end
                
                velo=vel;
                velo(velo == 0 ) = NaN;
                
                % Find the maximum velocity 
                Max=max(velo);
                
                % Find the minimum velocity 
                Min=min(velo);
                
                Max(isnan(Max))=0;
                Min(isnan(Min))=0;
                % 
                    if abs(Max(t)-Min(t))>=2E-7
                          if fol==cut_stack % If there are no duplicate data, it will write this data to file
                          part-1
            		       cut_stack=cut_stack+1;
    			       fprintf(fileID,'%s\n',[Pathdirection,'/part',int2str(part-1),'/folder',int2str(fol),'/',Fname(t).name]);
        		  end
                    end
                
            
        end % End loop for finding the buckle of microtubule of each replica 

        
    end
    
fclose(fileID);
    
    
    
    
    
end



