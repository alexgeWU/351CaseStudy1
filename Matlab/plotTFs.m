function plotTFs(tfLP,tf1,tf2,tf3,tfHP)
    figure();
    tiledlayout(1, 5, 'TileSpacing', 'compact', 'Padding', 'compact');
    
    nexttile; bode(tfLP); title('tfLP');
    nexttile; bode(tf1);  title('tf1');
    nexttile; bode(tf2);  title('tf2');
    nexttile; bode(tf3);  title('tf3');
    nexttile; bode(tfHP); title('tfHP');
end