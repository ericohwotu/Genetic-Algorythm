%% file to run the Genetic Algorythm
tic
GA = genes; %initialising the genetic algarythm
ts = 0; %leave alone
gen_max = 100; % change to change the mount of generations to be run rqmts say 1000
gene_count = 200; % the amount of genes to be generated *MUST BE EVEN*
field_count = 100; % amount of field distributions for each gene
parents_to_remain = 120; % variables to know how many parents to keep
plot_type=2;
rand('state',sum(clock));

%% generate initial genes
for i = 1:gene_count
        G(i,:) = GA.generate_gene();
end

%% runn for X amount of generations
for generation = 1:gen_max
    fprintf('currently in %d generation \n',generation)
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
    % sort the results to get the best genes
    [sorted_scores, sorted_index] = sort(s(generation,:), 'descend');
    for i = 1:gene_count
        G(i,:)=G(sorted_index(i),:);
    end
    
    %record the max scores
    max_scores(generation)=max(s(generation,:));
    fprintf('max score for this generation is %3f \n',max_scores(generation));
    
    max_parents(generation)=max(s(generation,1:parents_to_remain));
    max_children(generation)=max(s(generation,parents_to_remain:200));
    
    %max_parents_3 = 
    
    %perform crossover
    G = GA.get_next_generation(G, gene_count, parents_to_remain);
    
end
if plot_type == 1
    figure
    plot (max_scores,'b');
    title(sprintf('Results where Parents retained is %d.',parents_to_remain));
elseif plot_type == 2
    figure
    hold on
    plot (max_parents,'b')
    plot (max_children, 'g')
    plot (max_scores,'r'); %plot max results
    legend('Max Parents','Max Children','Max Scores');
    title(sprintf('Results where Parents retained is %d.',parents_to_remain));
    hold off
elseif plot_type == 3
    figure
    hold on
    subplot(3,1,1);
    plot (max_scores,'b'); %plot max results
    title('max scores');
    subplot(3,1,2);
    plot (max_parents,'b')
    title('max parents');
    subplot(3,1,3);
    plot (max_children, 'b')
    title('max children');
    hold off
end
disp(sprintf('Elapsed time %f seconds',toc))