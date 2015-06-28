function [ ] = store( method, dataset_name, datetime_started, models, results, time, noisy )

    results.method = method;
    results.dataset = dataset_name;
    results.parameters = struct2str(models);
    results.time = time;
    results.noisy = noisy;
    
    paramstr = struct2str(results, '&');
    %system(['php php/save.php ', paramstr]);
    urlread(['http://vojtechkopal.cz/regressions/save.php?', paramstr]);

end

