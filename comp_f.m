function [ ] = comp_f( func_no, D, N, settings_script, prod_env )

setup;

try
    setup_mail;
catch
    display('Cannot initiate mail. Skipping.');
end

%%

if nargin < 5
    prod_env = 0;
end
 
% get rid of some mess from bash
D = str2double(int2str(D));
N = str2double(int2str(N));
func_no = str2double(int2str(func_no));

%%

func_name = strcat('f', int2str(func_no));
func = str2func(func_name);
[X, Y] = dataSample(func, D, N);

%%

system('ulimit -t unlimited');
name = [func_name,'-', int2str(D), 'd-', int2str(N), '-', datetimestr];
fprintf('\n[%s %dd %d]\n------\n', func_name, D, N);

%%

settings_inited = 0;

if nargin > 3
    
    try
        eval(settings_script);
        settings_inited = 1;
        fprintf('Loaded external settings from %s\n', settings_script);
    end

end
    
if settings_inited == 0
    
    I = 0;

    %I = I + 1;
    %models{I} = struct('name', 'SVM', 'model', @svmSim);
    %models{1}.params = {{3}, {2}, { 0.001, 0.01, 0.1, 1, 2, 5, 10, 15, 20, 30, 50, 100, 150, 200, 250, 300, 350, 400, 500, 600, 700}};

    %I = I + 1;
    %models{I} = struct('name', 'Poly', 'model', @polyfitSim);
    %models{I}.params = {{'quadratic'}};

    I = I + 1;
    models{I} = struct('name', 'RBF-NN', 'model', @nnSim);
    %models{I}.params = {{4,2,1.5,1.2,1.1,1,0.1,0.01,0.001},{ 0.00001},{150}};
    models{I}.params = explodeStruct(struct(), ...
        allcombs([4,2,1.5,1.2,1.1,1,0.1,0.01,0.001], [0.00001], [150]), ...
        {'sc' 'eq' 'max'});

    %I = I + 1;
    %models{I} = struct('name', 'Forests', 'model', @forestsSim);
    %models{I}.params = {num2cell(50:50:900), {1, 2, 5, 10, 20, 50}};

    %I = I + 1;
    %models{I} = struct('name', 'GP', 'model', @gpSim);
    %models{I}.params = {{5e-8, 5e-8, 1e-7, 5e-7, 1e-6, 5e-6, 1e-5, 5e-5, 1e-4, 0.001}, {0}};

    settings_inited = 1;
    
end

%%

if prod_env
    ping = @() system('');
else
    ping = @() fprintf('');
end

results = crossValidateModelsWithParams(models, X, Y, @(results, models) ...
    save(['data/',name,'.mat'], 'results', 'models'), ...
    ping ...
);

%%

save(['data/',name,'.mat'], 'results', 'models');

try 
    sendmail('vojtech.kopal@gmail.com', ['MATLAB Results: ', name], 'Computation done.', ['data/',name,'.mat']); 
catch
    display('Could not sent email with result. Skipping.');
end

end

