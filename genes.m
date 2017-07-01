classdef genes
    %class to control the creation of genes
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function f = generate_field(obj)
            %% generate the hall currently only filled with trash or nothing
            trash_spots = randperm(100,50); % creates 50 random locations for the trash
            f = zeros(10,10); %initialise the field to all empty. for randomly filling the hall use *floor(rand(10,10)*2)*;
            for i = 1:length(trash_spots)
                f(trash_spots(i))=1; % place trash in the hall
            end
        end
        
        function f = generate_field_with_obstacles(obj, obs_count)
            %% generate the hall filled with trash, obstacle or nothing
            item_spots = randperm(100,50+obs_count); % creates 50 random locations for the trash
            f = zeros(10,10); %initialise the field to all empty. for randomly filling the hall use *floor(rand(10,10)*2)*;
            for i = 1:length(item_spots)
                f(item_spots(i))=1; % place trash in the hall
                if i > (length(item_spots)-obs_count)
                    f(item_spots(i))=2; % place obstacle in the hall
                end
            end
        end
        function g = generate_gene(obj)
            %% generate the gene
            g = floor(rand(1,243)*6)+1;
        end
        function next_gen = get_next_generation(obj, g, gene_count, keep_main)
            %% get the next generation of genes to be run
            %keep_main = 6;% variables to know how many best genes to keep
            keep_off = (gene_count - keep_main)/2;% amount of each offspring to keep
            current_offspring=1;
            for i = 1:(gene_count/2)
                %TODO: Optimise this section for speed.
                parent1 = g(current_offspring,:);
                parent2 = g(current_offspring+1,:);
                cross_point = floor(rand*200)+1; % test cross point
                offspring1(i,:) = obj.crossover_gene(parent1, parent2, cross_point);
                offspring2(i,:) = obj.crossover_gene(parent2, parent1, cross_point);
                %G(i+100,:) = offspring; %replace the worse ones with the offsprings
                %*much faster but not used

                %check if mutation should occur
                %mutation occurs at 5% chance
                for j = 1:243
                    if (rand*100)<2
                        g(i+1,:) = obj.mutate_gene(g(i,:),j); %mutating the parent that will remain
                    end
                    if (rand*100)<2
                        offspring1(i,:) = obj.mutate_gene(offspring1(i,:),j); %mutating the offspring
                    end
                    if (rand*100)<2
                        offspring2(i,:) = obj.mutate_gene(offspring2(i,:),j); %mutating the offspring
                    end
                end
                current_offspring = current_offspring + 2; % to aide the slection of pairs of genes
            end
            next_gen = cat(1,g(1:keep_main,:),offspring1(1:keep_off,:),offspring2(1:keep_off,:));
        end
        function g = mutate_gene(obj, gene, pos)
            %% mutate the gene at a specific position
            gene(pos)=floor(rand*6)+1;
            g = gene;
        end
        function offspring = crossover_gene(obj, dad, mom, pos, gen, num)
            %% perform the corssover of 2 genes from a point passed to it
            dad(end-pos:end) = mom(end-pos:end);
            
            
            offspring = dad;
        end
        function score = score_gene(obj,field, gene)
            x = 1; %current x position
            y = 1; %current y position
            score = 0; % initial score
            for i=1:200 %amount of steps per room
                %% ensure that no index out of bound error occurs
                %action = gene(i);
                current = field(x,y);
                if x == 1
                    west = 2;
                    east = field(x+1,y);
                elseif x == 10
                    east = 2;
                    west = field(x-1,y);
                end
                % do the same for north and south
                if y == 1
                    north = 2;
                    south = field(x,y+1);
                elseif y == 10
                    south = 2;
                    north = field(x,y-1);
                end
                
                %% set the locale of the current cell
                %locale = sprintf('%d%d%d%d%d',north,south,east,west,current);%[int2str(north),int2str(south),int2str(east),int2str(west),int2str(current)];
                %action = gene(base2dec(locale,3));
                locale = (north*81)+(south*27)+(east*9)+(west*3)+(current*1); % for speed convert directly to decimal from base3
                action = gene(locale);
                
                
                 %% random north
                if (action == 6)
                    action = (rand*5)+1;
                end
                
                %% move north
                if (action == 1) && (north == 2)
                    score = score - 5;
                elseif (action == 1)
                    y = y-1;
                end
                
                %% move south
                if (action == 2) && (south == 2)
                    score = score - 5;
                elseif (action == 2)
                    y = y + 1;
                end
                
                %% move east
                if (action == 3) && (east == 2)
                    score = score - 5;
                elseif (action == 3)
                    x = x + 1;
                end
                
                %% move west
                if (action == 4) && (west == 2)
                    score = score - 5;
                elseif (action == 4)
                    x = x - 1;
                end
                
                %% pick up trash
                if (action == 5) && (current == 1)
                    score = score + 10;
                    field(x,y)=0; % empty the cell once trash is picked up
                elseif (action == 5) && (current == 0)
                    score = score - 1;
                end
            end
        end
        
    end
    
end

