function plotSpectrograms(xs,xsfs,xg,xgfs,xb,xbfs)
    figure,subplot(1,2,1), spectrogram(xs(:,1),1024,200,1024,xsfs,'yaxis');
    clim([-120 -20]);
    subplot(1,2,2), spectrogram(xs(:,2),1024,200,1024,xsfs,'yaxis');
    clim([-120 -20]);
    title('Space Station Spectrogram');

    figure,subplot(1,2,1), spectrogram(xg(:,1),1024,200,1024,xgfs,'yaxis');
    clim([-130 -40]);
    subplot(1,2,2), spectrogram(xg(:,2),1024,200,1024,xgfs,'yaxis');
    clim([-130 -40]);
    title('Giant Steps Spectrogram');

    figure, spectrogram(xb,1024,200,1024,xbfs,'yaxis');
    clim([-120 -55]);
    title('Bird Noises Spectrogram');
end