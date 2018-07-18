clear all;
close all;

%assign which files (filaments) to use
%In this case, use file Con_MC_actin_PtoM0001.dat to Con_MC_actin_PtoM0100.dat
%This part will be changed to whatever needed to take the input files
Vstart=1; %first filament
Vend=10;%last filament

%From which m (skipping) to which m to measure the curvature of those filaments
% m = 1 >> no skipping
% m = 30 >> skip 30 nodes for each measurement
%For the plugin, mstart will be fixed to 1 and mend will be assigned by the user
mstart = 1; %first m
mend = 5; %last
partstart=1;
partend=16;
% Create array for storing the curvature 
curvature=zeros(6000,1);
curvature_store=zeros(6000,partend);
curvature_std=zeros(5,5);
% Create the fist column of curvature_std 
% This array is used for write the data in ploting format
curvature_std(1,1)=0;
curvature_std(2,1)=0.2;
curvature_std(3,1)=0.4;
curvature_std(4,1)=0.6;
curvature_std(5,1)=0.8;

%Count m
countm = 0;

%Loop over curvature calculation for all skipping indices (m)
for m=mstart:1:mend;%skipping over m-1 nodes
    %At the start of each loop, deallocate all matrices except the followings
    %clearvars -except mstart mend max_t m countm curvature part;
    
    %declare L_av for average filament length calculation
    L_av=0;
    
    
    
    %sizedx is an index for storing the bond spacing on the filament
    sizeds =1;
    
    for part=partstart:1:partend
    
    iteration = 100;
    %kk is an index for storing curvature
    kk=1;
    for fol=1:1:iteration
        %Loop over specified filaments
        clear files max_t
         
        files = dir(sprintf('MuyAJg/part%d/%d/data/polymer*',part-1,fol));
        max_t = length(files);
        sprintf('MuyAJg/part%d/%d/data/polymer*',part-1,fol);
        max_t;
        
        
        for v = max_t:max_t

            clear filename A
            %clear all necessary matrices
            clear theta x y xx yy ds C D E F xskip yskip store state storej;
            
            filename = sprintf('MuyAJg/part%d/%d/data/polymer_coordinate0%02d0000000.dat',part-1,fol,v-1);
            
            %Load coordinates from a file into array A
            A = load(filename);
            
            %B stores the size of the array A >> example output B = [95 2]
            B = size(A);
            
            %M stores the number of coordinate points (number of bonds)
            %pick the first column from B
            M = B(1);
            
            % store x and y coordinates from the files
            % subtract the first coordinates to make the filament starts at(0,0)
            for j = 1:M
                x(j) = A(j,1);
                y(j) = A(j,2);
            end
            
            %---- calculate the bond spacing in x- and y-projection
            %Filament Length
            for j = 1:M-1
                xx(j) = x(j+1)-x(j); %displacement in x
                yy(j) = y(j+1)-y(j); %displacement in y
            end
            
            % calculate the bond spacing using pythagoras
            for j = 1:M-1
                ds(j) = sqrt((xx(j))^2 + (yy(j))^2);
            end
            
            %Loop for doing recursion
            %Recursion is the proccess to get more data out of a filament
            %If we skipped some nodes and measure the curvature, the
            %information on those skipped nodes would be wasted
            %Therefore, after measuring the curvature for the first sets of
            %coordinates on the filament, starting from the first point, we
            %now start skipping and measuring the curvature from the second
            %point on the chian (This point was previously wasted during the
            %last calculation.
            %for q = 1:m % recursion
               for q = 1:1
                
                %deallocate necessary array
                clear C D dss E F
                
                %Loop to find out how many big bonds (after skipping) the
                %filament can have
                b = floor ((M-q)/m);
                
                %Loop to find the bond spacing of the big bonds
                for i = 1:b
                    C(i) = x(q+(m)*i)-x(q+(m)*(i-1));  %displacement in x
                    D(i) = y(q+(m)*i)-y(q+(m)*(i-1));  %displacement in y
                    dss(i) = sqrt(C(i).^2 + D(i).^2);  %bond spacing
                    acdss(sizeds) = dss(i); %store bond spacing
                    sizeds = sizeds+1; % ready to store the next one
                end
                
                %Loop to calculate curvature
                for i = 1:b-1
                    
                    if (C(i+1)>C(i)) && (D(i+1)>D(i)) %if pointing in 1st quadrant
                        dtheta_all(i) = acos((C(i)*C(i+1) + D(i)*D(i+1))/(dss(i)*dss(i+1))); %calculate angle
                    elseif (C(i+1)<C(i)) && (D(i+1)<D(i)) %3rd quadrant
                        dtheta_all(i) = acos((C(i)*C(i+1) + D(i)*D(i+1))/(dss(i)*dss(i+1))); %calculate angle
                    else %2nd and 4th quadrant
                        dtheta_all(i) = -acos((C(i)*C(i+1) + D(i)*D(i+1))/(dss(i)*dss(i+1))); %calculate angle
                    end
                    
                    %Calculate and store curvature from the angle and bond
                    %length
                    curvature(kk,1)= dtheta_all(i)/((dss(i)+dss(i+1))*0.5);
                    
                    kk=kk+1; %ready to store the next one
                end
            end % end recursion loop
        end % end loop over filament in each folder
    end % end loop over folder in each part
    
    curvature_store(:,part)=curvature(:,1);
    curvature_store(6000,part)=std2(curvature(:,1));
    curvature=zeros(6000,1);
    

    
    end % end loop over part in each m
    % plot cdf graph
    for part_plot=partstart:1:partend
    [h, stats] = cdfplot(curvature_store(:,part_plot));
    hold on;
    [cdf_y,cdf_x] = ecdf(curvature_store(:,part_plot));
    bfit_guess = [getfield(stats, 'mean') getfield(stats, 'std')];
    cumulative_gaussian = @(bfit,x)0.5*(1+erf((x-bfit(1))/(sqrt(2)*bfit(2))));
    bfit=nlinfit(cdf_x,cdf_y,cumulative_gaussian,bfit_guess);

    cdf_y_fit2 =  normcdf(cdf_x,bfit(1),bfit(2));
    plot(cdf_x,cdf_y_fit2,'r');
    xl=xlabel('Curvature (1/micron)','FontSize',20);
    set(gcf,'color','w');
    xt = get(gca, 'XTick');
    set(gca, 'FontSize', 20);
    set(findall(gca, 'Type', 'Line'),'LineWidth',4);
    hold off;
    saveas(gcf,sprintf('curvature/kinesin_2&1357/m-%d_%d',m,part_plot),'jpeg');
    

    end
    
    for i=1:4
    	for j=0:3
    curvature_std(i+1,j+2)=curvature_store(6000,i+j+3*(floor((2*i-1)/2)))
    	end
    end
    filename3=[pwd,'/curvature','/kinesin_2&1357','/curvature','_m_',int2str(m),'.txt'];
    dlmwrite(filename3,curvature_store,'delimiter','\t','precision',5)
    filename3=[pwd,'/curvature','/kinesin_2&1357','/curvature','_m_',int2str(m),'_std.txt'];
    dlmwrite(filename3,curvature_std,'delimiter','\t','precision',5)
    

    

    curvature_store=zeros(6000,partend);
end
    

