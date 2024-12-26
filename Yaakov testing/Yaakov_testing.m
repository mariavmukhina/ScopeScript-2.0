%%

%loadNikonTI2();

%%


for i=1:24*2

    ti2.tirf2XPOSITION.Value = 500*i;
    pause(1);
    disp(i*500)

end


%%