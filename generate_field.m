% max_rotation

%% generate the field
function f = generate_field()
rand('state',sum(clock));
% for loop to initialise the field
for i = 1:10
    for j = 1:10
        f(i,j) = floor(3*rand); % put either an empty space, trash or wall in place
    end
end
end