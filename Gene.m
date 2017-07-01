classdef Gene
    
    properties
        id;
        pos_x = 1;
        pos_y = 1;
        mom;
        dad;
        mutations;
        generations;
        scores;
        avg_scores;
        genome;
    end
    methods
        function obj = Gene(id,gen, gnome)
            obj.id = id;
            obj.generations = gen;
            obj.genome = gnome;
        end
        function obj = add_generation(obj, gen)
            obj.generations = cat(1,obj.generations,gen);
        end
        function obj = add_score(obj, score)
            if length(obj.scores)<1
                obj.scores = score;
            else
                obj.scores = cat(1, obj.scores, score);
            end
        end
        
        function obj = add_avg_score(obj, score)
            if length(obj.avg_scores)<1
                obj.avg_scores = score;
            else
                obj.avg_scores = cat(1, obj.avg_scores, score);
            end
        end
        
        function obj = mutate_gene(obj, pos)
            %% mutate the gene at a specific position
            obj.genome(pos)=floor(rand*6)+1;
        end
    end
end