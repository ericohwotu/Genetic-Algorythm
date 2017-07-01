%% file to run the Genetic Algorythm
tic
GA = genes; %initialising the genetic algarythm
ts = 0; %leave alone
gen_max = 100; % change to change the mount of generations to be run rqmts say 1000
gene_count = 200 % the amount of genes to be generated *MUST BE EVEN*
field_count = 100 % amount of field distributions for each gene
rand('state',sum(clock));

%% generate initial genes
for i = 1:gene_count
        G(i,:) = GA.generate_gene();
end

%% runn for X amount of generations
for generation = 1:gen_max
    generation
    % perform the run with the hundred genes on 100 fields
    for i = 1:gene_count
        for j = 1:field_count
            F = GA.generate_field(); 
            S(i,j) = GA.score_gene(F,G(i,:));
            ts = ts + S(i,j);
        end
        s(generation, i) = ts/field_count;
        ts=0;
    end
    % sort the results to get the best hundred genes
    [sorted_scores, sorted_index] = sort(s(generation,:), 'descend');
    
    for i = 1:gene_count
        G(i,:)=G(sorted_index(i),:);
    end
    
    %record the max scores
    max_scores(generation)=max(s(generation));
    
    %perform crossover
    %current_offspring = 1;
    for i = 1:(gene_count/2)
       %TODO: Optimise this section for speed.
       parent1 = G(i,:);
       parent2 = G(i+100,:);
       offspring = GA.crossover_gene(parent1, parent2, floor(rand*200)+1);
       G(i+100,:) = offspring; %replace the worse ones with the offsprings
       %*much faster but not used
       
       %check if mutation should occur
       %mutation occurs at 5% chance
       for j = 1:243
           if (rand*100)<5
               G(i+1,:) = GA.mutate_gene(G(i,:),j); %mutating the parent that will remain
           end
           if (rand*100)<5
               G(i+100,:) = GA.mutate_gene(G(i+100,:),j); %mutating the offspring
           end
       end
       %current_offspring = current_offspring + 2; % to aide the slection of pairs of genes
    end
    
    %assign the offspring to the last 100 in the current population
    %G(end-99:end,:)=offspring; %<-- method very slow
    %G = cat(1,G(1:100,:),offspring);
    
end
figure
plot (max_scores) %plot max results
sprintf('Elapsed time %f',toc)