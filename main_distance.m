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

% create array for storing the length of microtubules in all part (column) and in all replica (row)
% This system has 100 replicas
dist_mean=zeros(100,a);

seq=1

% Create file in order to write filename for checking the length of microtubules
fileID = fopen([pwd,'/distance/','length_6-to-7-micron.txt'],'w');


for i=1:a % Loop for each part

    store=1;
    for j=1:100 % Loop for each replica
        
        
        % This value is defined for skipping some duplicate data since we want to check 
        % whether there are some buckle. If there are some buckle in a replica, skip 
        % that replica to other replica and keep on calculating for reducing the calculating time.
        cut_stack=j;
        
        
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
        
        % Loop for calculating the length of microtubules and define the specific length 
        for t=1:b
        
            % Create array for storing the length of microtubules in all microtubule files of each part
            dist_poly(store,i)=(sqrt((com1(t,1)-com1(t,52)).^2 + (com2(t,1)-com2(t,52)).^2));
            
            	if dist_mean_poly(store,i)<=9E-6 % Define the specific length here!
            	
            	        % Write filename which its length (microtubule length) corresponding to the specific length 
            		if j==cut_stack
            		cut_stack=cut_stack+1;
    			fprintf(fileID,'%s\n',[Pathdirection,'/part',int2str(i-1),'/folder',int2str(j),'/',Fname(t).name]);
    			seq=seq+1
        		end
        	end
        	
            store=store+1;
            
        end
    
       
        
       
        
    end
    

end
fclose(fileID);

    % Create file in order to write filename for checking the length of microtubules
    filename=[pwd,'/distance/','mt_all_part_mean.txt'];
    dlmwrite(filename,dist_poly,'delimiter','\t','precision',5)

    