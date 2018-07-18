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
a=length(dir('MuyAJg/*part*'));

% create array for storing the bias angle in all part (column) 
% This system has 100 replicas 
vel_mean=zeros(100,a);



% This is main loop in this code
for part=1:a % Loop for each part
    check=0;
    
    for fol=1:100 % Loop for each replica
        
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
        
        % Calculating the bias angle of microtubule tip for each replica
        data1=direction_bias(com1,com2,row,b);
        
        

        
        
        
        % Loop for storing the bias angle of microtubule tip for all replica 
        % This is the bias angle distribution of microtubule tip
        for store=check+1:b-1+check
            direc_distribution_all_part_bias(store,part)=data1(1,store-check);

        end % End loop for storing the bias angle of microtubule tip for all replica 
        
        
        
        
        check=check+b-1;
       
        
        % Clear data array of the previous bias angle in order to start calculating the new bias angle in a new replica
        clear data1;
        
        % Clear data array of x and y position
        clear com1 com2;
    end % End loop for each replica
    
    % Calculating standard devitation of the bias angle distribution
    direc_std_store(1,part)=std2(direc_distribution_all_part_bias(:,part));
    
    
    


end % End loop for each part


    % Write the bias angle of microtubule tip which we calculate from all part
    % Change the directory for keeping this file in other direction 
    % *** Change here***
    filename=[pwd,'/direc_distribution_bias/','kinesin_2&1357/','bias_angle_all_part.txt'];
    dlmwrite(filename,direc_distribution_all_part_bias,'delimiter','\t','precision',5);
    
    
% Create array for ploting format
for i=1:5
    direc_std(i,1)=0.2*(i-1);
end

for i=1:4 % the number of row that you want to input data for ploting format
    % |  0  | **** | **** | **** | **** |
    % | 0.2 | **** | **** | **** | **** |
    % | 0.4 | **** | **** | **** | **** |
    % | 0.6 | **** | **** | **** | **** |
    % | 0.8 | **** | **** | **** | **** |
    % 5 rows

    	for j=0:3 % the number of column that you want to input data for ploting format 
    	% *** kinesin 2 | kiknesin 3 | kinesin 5 | kinesin 7 *** 4 columns
    	
    direc_std(i+1,j+2)=direc_std_store(end,i+j+3*(floor((2*i-1)/2)));
    	end
end


     
    % Write ploting format array to file
    % *** Change here***
    filename3=[pwd,'/direc_distribution_bias/','kinesin_2&1357/','bias_angle_std_all_part.txt'];
    dlmwrite(filename3,direc_std,'delimiter','\t','precision',5)

    
   % plot cdf graph from the bias angle array
    for part_plot=1:a
    [h, stats] = cdfplot(direc_distribution_all_part_bias(:,part_plot));
    hold on;
    
    [cdf_y,cdf_x] = ecdf(direc_distribution_all_part_bias(:,part_plot));
    
    
    bfit_guess = [getfield(stats, 'mean') getfield(stats, 'std')];
    cumulative_gaussian = @(bfit,x)0.5*(1+erf((x-bfit(1))/(sqrt(2)*bfit(2))));
    bfit=nlinfit(cdf_x,cdf_y,cumulative_gaussian,bfit_guess);

    cdf_y_fit2 =  normcdf(cdf_x,bfit(1),bfit(2));
    plot(cdf_x,cdf_y_fit2,'r');
    xl=xlabel('Angle (degree)','FontSize',20);
    set(gcf,'color','w');
    xt = get(gca, 'XTick');
    set(gca, 'FontSize', 20);
    set(findall(gca, 'Type', 'Line'),'LineWidth',4);
    hold off;
    
    % Change the directory here!
    % *** Change here***
    saveas(gcf,sprintf('direc_distribution_bias/kinesin_2&1357/part-%d',part_plot),'jpeg');
    

    end
    
