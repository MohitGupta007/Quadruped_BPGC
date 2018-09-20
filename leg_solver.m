function leg_solver(r,ox,oy)
X(1:2,1:5)=zeros(2,5);
k=0;
syms x y;
l1=5;
l2=3.5;
l3=5.5;
t1=0;
t2=0;
t3 = 0;
f = fopen('anglesr.txt','a');
f2 = fopen('anglesl.txt','a');
%syms x; syms y;
%ezplot((x-ox).^2+(y-oy).^2-r.^2)
for v=1:1:1000
    X(1,3) = (r*cos(t3))+ ox;
    X(2,3) = (r*sin(t3))+ oy;
    y = (r^2-(x-ox)^2)^0.5 + oy;
    ezplot(y)
    hold on
    y1 = -1*((r^2-(x-ox)^2)^0.5 - oy);
    ezplot(y1)
    lh=sqrt(X(1,3)^2 + X(2,3)^2);
    X(:,1)=[1,0];
    X(:,5)=[-1,0];
    syms a b
    vars = [a b];
    eqn = [(a - X(1,3))^2 + (b - X(2,3))^2 == l3^2, (a - (l1/2))^2 + b^2 == l2^2];
    S = solve(eqn,vars);
    syms c d
    vars2 = [c d];
    eqn2 = [(c-X(1,3))^2 + (d-X(2,3))^2 == l3^2, (c + (l1/2))^2 + d^2 == l2^2];
    S2 = solve(eqn2,vars2);
    
    if(double(S.a(1))>0 && double(S2.c(1)>0))
        X(1,2) = double(S.a(1));
        X(2,2) = double(S.b(1));
        X(1,4) = double(S2.c(2));
        X(2,4) = double(S2.d(2));
    elseif(double(S.a(1))<0 && double(S2.c(1))>0)
        X(1,2) = double(S.a(2));
        X(2,2) = double(S.b(2));
        X(1,4) = double(S2.c(2));
        X(2,4) = double(S2.d(2));
    elseif(double(S.a(1))>0 && double(S2.c(1)<0))
        X(1,2) = double(S.a(1));
        X(2,2) = double(S.b(1));
        X(1,4) = double(S2.c(1));
        X(2,4) = double(S2.d(1));
    elseif(double(S.a(1))<0 && double(S2.c(1)<0))
        X(1,2) = double(S.a(2));
        X(2,2) = double(S.b(2));
        X(1,4) = double(S2.c(1));
        X(2,4) = double(S2.d(1));
    end
    ar = atan(X(2,2)/(X(1,2)-(l1/2)));
    al = atan(X(2,4)/(X(1,4)+(l1/2)));
    ar = abs(ar*180/3.142);
    al = abs(al*180/3.142);
    fprintf(f2,"%f\n",al);
    fprintf(f,"%f\n",ar);
    plot(X(1,:),X(2,:),'-o','linewidth',3)
    axis([-10 10 -10 10])
    legend('leg_config')
    t3=t3+0.1;
    hold 	
    pause(0.001)
end
end