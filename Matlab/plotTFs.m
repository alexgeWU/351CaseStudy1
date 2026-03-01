function plotTFs(tfLP,tf1,tf2,tf3,tfHP)
    figure();
    tiledlayout(1, 5, 'TileSpacing', 'compact', 'Padding', 'compact');
    
    options = bodeoptions;
    options.FreqUnits = 'Hz';

    nexttile; bode(tfLP, options); title('tfLP');
    nexttile; bode(tf1, options);  title('tf1');
    nexttile; bode(tf2, options);  title('tf2');
    nexttile; bode(tf3, options);  title('tf3');
    nexttile; bode(tfHP, options); title('tfHP');
end