clear all;
clear all;
clc;
% Define the directory of all data files
% *** Change here***
Pathdirection=[pwd,'/MuyAJg'];

filenameExtension='/*poly*.dat';

timestep=1;

% Find the number of file in folder name which starts with "part"
% Checking how many the system which we calculate
% *** Change here***
a=length(dir('MuyAJg/*part*'));


% create array for storing the average velocity in all part (column) and in all replica (row)
% This system has 100 replicas
vel_mean=zeros(100,a);

% This is main loop in this code
for i=1:a % Loop for each part
    
    for j=1:100 % Loop for each replica
        
        % Read all microtubule files of each replica 
        folder_name=[Pathdirection,'/part',int2str(i-1),'/',int2str(j),'/data',filenameExtension];
        
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
        
        % Create array for storing the velocity of all microtubule files in each replica
	% and then calculating the average velocity from these value 
        vel_mean_poly=zeros(b-1,1);
        
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
            % Calculate the average of x position (CoM of microtubules) 
            % And store values in array
            com1(L,:)=mean2(tmpdata1(:,1)); 
            
            % Read y position 
            % Calculate the average of x position (CoM of microtubules) 
            % And store values in array
            com2(L,:)=mean2(tmpdata1(:,2));
            
        end % End loop for reading data in all microtubule files
        
        % Loop for calculating average velocity of microtubule of each replica
        for t=1:b-1
            vel_mean_poly(t,i)=(sqrt((com1(t+1,:)-com1(t,:)).^2 + (com2(t+1,:)-com2(t,:)).^2)/timestep);
            vel_mean(j,i)=mean2(vel_mean_poly(:,i));
            
        end % End loop for calculating average velocity of microtubule of each replica
        
        % Clear data array of x and y position
        clear com1 com2;
        
        
        % Write the average velocity of microtubules which we calculate from each replica
        % *** Change here***
        filename=[pwd,'/velocity/','kinesin_2&1357/','velocity_all_part_fol.txt'];
        dlmwrite(filename,vel_mean)
 
        
    end % End loop for each replica
    
    % Calculate the average velocity of microtubules from all replica 
    % in order to get the average velocity of microtubules of each part
    speed_mean(i)=mean2(vel_mean(:,i));
    
    % Write the average velocity of microtubule which we calculate from each part
    % *** Change here***
    filename=[pwd,'/velocity/','kinesin_2&1357/','velocity_all_part_mean.txt'];
    dlmwrite(filename,speed_mean,'delimiter','\t','precision',5)

end % End loop for each part


% Create array for ploting format
for i=1:5
    velocity_plot(i,1)=0.2*(i-1);
end

% *** Change here***
for i=1:4 % the number of row that you want to input data for ploting format
    % |  0  | **** | **** | **** | **** |
    % | 0.2 | **** | **** | **** | **** |
    % | 0.4 | **** | **** | **** | **** |
    % | 0.6 | **** | **** | **** | **** |
    % | 0.8 | **** | **** | **** | **** |
    % 5 rows

    	for j=0:3 % the number of column that you want to input data for ploting format 
    	% *** kinesin 2 | kiknesin 3 | kinesin 5 | kinesin 7 *** 4 columns
    	% *** Change here***
    		velocity_plot(i+1,j+2)=speed_mean(i+j+3*(floor((2*i-1)/2)));
    	end
end

    % Write ploting format array to file
    % *** Change here***
    filename3=[pwd,'/velocity/','kinesin_2&1357/','velocity_all_part_plot.txt'];
    dlmwrite(filename3,velocity_plot,'delimiter','\t','precision',5)