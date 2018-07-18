
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


seq=1


% This is the main loop for this code
for part=1:1 % Loop for each part
    
    
    for fol=1:1 % Loop for each replica
        
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
            folder_name1=[Pathdirection,'/part',int2str(part-1),'/',int2str(fol),'/data','/',Fname(L).name];
            
            % Read data in microtubule file of each replica and keep them in array
            % Example 
            %    (x)        (y)
            % 000000000  00000000
            % 000000000  00000000
            % ........   ........
            % There are 2 column (x position and y position) 
            tmpdata1=dlmread(folder_name1,'');
            row=length(tmpdata1);
            
            % Read x position 
            % Calculate the average of x position (CoM of microtubules) 
            % And store values in array
            com1(L,:)=(tmpdata1(:,1)); 
            
            % Read y position 
            % Calculate the average of x position (CoM of microtubules) 
            % And store values in array
            com2(L,:)=(tmpdata1(:,2));
            
        end % End loop for reading data in all microtubule files
        size(com1);
        
        % Create picture from xy plot of microtubules
        for t=1:b
            xx(:,1)=com1(t,:);
            yy(:,1)=com2(t,:);
            plot(xx,yy);
	    axis([-15E-5 3.5E-5 0E-5 10E-5]);
	    print(sprintf('animate/kinesin_2&1357/%d_%d',j,t),'-dpng');
            
        end 
    
       
        
       
        
    end % End loop for each replica
    

end % End loop for each part

% aek edit    
% aek edit at repository
