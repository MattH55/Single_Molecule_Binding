function  divide_image(image,lower_bd_x,upper_bd_x,ndiv)

im=imagesc(image);
hold on;

total_duration=numel(image(1,:,1));
t_kymo=[0,total_duration];

%plot(t_kymo,upper_bd_x,'r',t_kymo,lower_bd_x,'r','LineWidth',6)

kymo_total_width=upper_bd_x(1)-lower_bd_x(1);
kymo_window_width=kymo_total_width./[1:ndiv];
C = {'#808080','b','r','g','y',[.5 .6 .7],[.8 .2 .6]}; % Cell array of colros.
legend_label=cell(ndiv,1);
lbl_ct=1;
for i=1:ndiv
    %kymo_window_width(i)=kymo_total_width/i;
    for j=0:round(kymo_total_width/kymo_window_width(i))
        a=plot(t_kymo,lower_bd_x+ones(size(lower_bd_x))*j*kymo_window_width(i),'color',C{i},'Linewidth',6-i)
        uistack(a,'bottom')
        if j==1
            if i==1
                legend_label{lbl_ct}=sprintf("1 full window")
            else
                legend_label{lbl_ct}=sprintf("%d windows of 1/%d width",i,i)
            end
        else
            legend_label{lbl_ct}=""
        end
        lbl_ct=lbl_ct+1;

    end

end
legend_label(end:-1:1)=legend_label(:);
uistack(im,'bottom')
legend(legend_label)
uistack(im,'bottom')
%lbord=plot(t_kymo,lower_bd_x,'w','LineWidth',6)
%uistack(lbord,'top')
end