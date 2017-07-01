%% File to run the generated genes with obstacles
% be sure to run "run_max_slow" before running this file
tic
GA = genes;
gene_count = 200; % the amount of genes to be generated *MUST BE EVEN*
gen_max = 1000; % change to change the mount of generations to be run rqmts say 1000
field_count = 100;
% From requirements:
% Number of obstacles = 5;
% First get best genes
new_gene_pool = zeros(200,243); % initialise new gene pool
new_gene_pool(1:100,:) = new_gene_pool(1:100,:); % change G to whatever the gene pool is named in the your initial run
for i = 101:200
    new_gene_pool(i,:) = GA.generate_gene(); % generate random genes for the final 100 members in the population
end
clear new_theatre
for i = 1:field_count
    new_theatre(i,:,:) = GA.generate_field_with_obstacles(5);
end

clear gene_score
for generation = 1:gen_max 
    generation
    
    % perform the run with the hundred genes on 100 fields
    for i = 1:gene_count
        total_score=0;
        for j = 1:field_count
            % generate field with obstacles
            %new_theatre = GA.generate_field_with_obstacles(5); % number represents amount of obstacles
            gene_scores(i,j) = GA.score_gene(squeeze(new_theatre(j,:,:)), new_gene_pool(i,:)); %score gene
            total_score = total_score + gene_scores(i,j); %get the totl score for this gene
        end
        gene_score(generation,i)=total_score/field_count;
    end
    % sort the results to get the best genes
    [new_sorted_scores, new_sorted_index] = sort(gene_score(generation,:), 'descend');
    for i = 1:gene_count
        new_gene_pool(i,:)=new_gene_pool(new_sorted_index(i),:);
    end
    
    %record the max scores
    o_max_scores(generation)=max(gene_score(generation));
    
    % get new genes
     new_gene_pool = GA.get_next_generation(new_gene_pool,gene_count);
    
end
% display the max scores
[max_gene_score, max_gene_index] = max(gene_score(generation,:));
disp(sprintf('The max score obtained was %f given by the %f gene. \n', max_gene_score, max_gene_index));

% The effect on the best gene from previous runs
if gene_score(1)>o_max_scores(end) %change max_scores(end) to either the array of the max scores from previous run or the final max score
    change = sprintf('increased from %f to %f',o_max_scores(end),gene_score(1,1));
elseif gene_score(1)<o_max_scores(end)
    change = sprintf('decreased from %f to %f',o_max_scores(end),gene_score(1,1));
else
    change = 'remained constant';
end
disp(sprintf('The score of the best gene from the previous run has %s. \n', change));
figure
plot(o_max_scores);
disp(sprintf('Elapsed time %f seconds',toc))