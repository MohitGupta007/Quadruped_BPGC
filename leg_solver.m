function leg_solver(r,ox,oy)
X(1:2,1:5)=zeros(2,5);
k=0;
syms x y;
l1=8.0;
l2=6.0;
l3=8.0;
l4=0.0;
l5=0.0;
t1=0;
t2=0;
t3 = 0;
h = figure;
axis tight manual
filename = 'quadruped.gif';
for v=1:1:1000
    X(1,3) = (r*cos(t3))+ ox;
    X(2,3) = (r*sin(t3))+ oy;
    y = (r^2 - x^2)^0.5 + oy;
    ezplot(y);
    hold on
    y = -y + 2*oy;
    ezplot(y);
    hold on
    l5 = ((X(1,3)-(l1/2.0))^2 + X(2,3)^2)^0.5;
    l4 = ((X(1,3)+(l1/2.0))^2 + X(2,3)^2)^0.5;
    theta = acos((l2^2 + l4^2 - l3^2)/(2*l2*l4))+acos((l1^2 + l4^2 - l5^2)/(2*l1*l4));
    phi = acos((l2^2 + l5^2 - l3^2)/(2*l2*l5)) + acos((l1^2 +l5^2 - l4^2)/(2*l1*l5));    
    X(1,1) = -l1/2;
    X(1,5) = l1/2;
    X(1,2) = l2*cos(theta) + X(1,1);
    X(2,2) = -l2*sin(theta);
    X(1,4) = -l2*cos(phi) + X(1,5);
    X(2,4) = -l2*sin(phi);
    plot(X(1,:),X(2,:),'-o','linewidth',3)
    axis([-15 15 -15 15])
    legend('leg_config')
    t3=t3+0.5;
    hold 	
    %pause(0.001)
    drawnow
    frame = getframe(h);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
     if v == 1 
         imwrite(imind,cm,filename,'gif', 'Loopcount',inf); 
     else 
         imwrite(imind,cm,filename,'gif','WriteMode','append'); 
     end 
    pause(0.00001);
end
end