function [ res ] = eval_exp( params )

fprintf('Running evaluation: dim=%d, gen=%d, numtrains=%d, trainrange=%d\n', ...
    params.dim, params.gen, params.numtrains, params.trainrange );
load(['exp_data/', 'exp_cmaeslog1_purecmaes_', int2str(params.fun), '_', int2str(params.dim), 'D_', int2str(params.fun)]);

ErrAcc = 0;
Errs = zeros(1,30);
for ExpId = 1:30
    CmaesOut = cmaes_out{ExpId};
    G = params.gen;
    NumTrain = params.numtrains * params.dim;
    TrainRange = params.trainrange * CmaesOut.sigmas(G)^2;
    M = CmaesOut.means(:, G);

    [X, Y] = loadArchive(@(x) (x.generations <= G), CmaesOut, ...
        struct('m', M, 'range', TrainRange, 'num', NumTrain));

    X = X - repmat(mean(X,2), 1, length(Y));
    model = gpSim(X', Y', struct('sn',0.02));

    [Xtrain, Dtrain] = loadArchive(@(x) (x.generations == G + params.testgen), CmaesOut);

    Err = (1/length(Dtrain))*(sum((Dtrain - model.predict(Xtrain')').^2));
    Errs(ExpId) = Err;
    ErrAcc = ErrAcc + Err;
end

res = struct('err', Err/30, 'errors', Errs);

end
