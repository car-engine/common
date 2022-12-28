%% find_nice_factors
% Finds a number > input with nice factorisations 

%% Begin function
function output = find_nice_factors(input)

    output = input+1;
    
    while max(factor(output))>7
        output = output+1;
    end
   
end
