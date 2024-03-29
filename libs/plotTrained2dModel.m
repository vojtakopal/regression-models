function [ f ] = plotTrained2dModel( model, N, maxVal, minVal, savePath, fig, Xbw, Ybw)

if nargin < 3 
    maxVal = 5;
end

if nargin < 4 
    minVal = -maxVal;
end

if nargin < 5
    savePath = 0;
end

if nargin < 6 || fig == 0
    fig = figure;
end

if nargin < 7
    Xbw = 0;
end

if nargin < 8
    Ybw = 0;
end

if nargin < 2
    error('Incorrect number of parameter. 2 are mandatory. Example: plotTrainedModel( mdl, 100 )');
end

if size(minVal, 2) == 2
    minValX = minVal(1);
    minValY = minVal(2);
else
    minValX = minVal;
    minValY = minVal;
end

if size(maxVal, 2) == 2
    maxValX = maxVal(1);
    maxValY = maxVal(2);
else
    maxValX = maxVal;
    maxValY = maxVal;
end

[XS, YS] = meshgrid(linspace(minValX,maxValX,N),linspace(minValY,maxValY,N));
ZS = zeros(N,N);

X2 = [XS(:) YS(:)];

%if nargout('model.predict') > 1
    [ZS, StdTr] = model.predict(X2);
%else
%    StdTr = 0;
%    ZS = model.predict(X2);
%end

if iscell(Xbw)
    XS = Xbw{1}(XS);
    YS = Xbw{2}(YS);
    X2 = [XS(:) YS(:)];
end

if isa(Ybw, 'function_handle')
    ZS = Ybw(ZS);
    if StdTr
        StdTr = Ybw(StdTr);
    end
end

if 0 && ~isempty(StdTr)
    hold on;
    
    if size(StdTr, 2) == 1
        XU = ZS' + StdTr';
        XL = ZS' - StdTr';
    else
        XU = StdTr(:,1)';
        XL = StdTr(:,2)';
    end

    XU = reshape(XU, [N N]);
    XL = reshape(XL, [N N]);
    
    me = mesh(XS, YS, XU);
    set(me,'FaceColor',[1 0 0],'FaceAlpha',0.5);
    
    me = mesh(XS, YS, XL);
    set(me,'FaceColor',[1 0 0],'FaceAlpha',0.5);
    
end

ZS = reshape(ZS, [N N]);
f = fig;
mesh(XS, YS, ZS);
hold off;

if savePath
    savefig(savePath);
    saveas(f, savePath, 'png');
end

end

