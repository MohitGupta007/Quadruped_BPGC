%clear all;close all;
l1 = 6;
l2=8;
l3=8;
bl=36;bw=20;
XY = zeros(5,3,4);
XY(1,:,:) = [[ bl/2,bl/2,-bl/2 + l3,-bl/2 + l3];[-bw/2,bw/2,bw/2,-bw/2];[0,0,0,0]];
XY(5,:,:) = [[bl/2-l3,bl/2-l3,-bl/2,-bl/2];[-bw/2,bw/2,bw/2,-bw/2];[0,0,0,0]];
XY(3,:,:) = [[ bl/2,bl/2,-bl/2 + l3,-bl/2 + l3];[-bw/2,bw/2,bw/2,-bw/2];[0,0,0,0]];
ox = [0,0,0,0]; oy = [11,11,11,11];rx = [1,1,1,1];rz = [1.5,1.5,1.5,1.5];
ml1 = [0.1,0.1,0.1,0.1];mb=4;
cmx=[0,0,0,0];
cmy=[0,0,0,0];
cmz=[0,0,0,0];
ph = [0,pi,0,pi];
t=0;

front1 = t_matrix(0,0,bl/2,0);
front2 = t_matrix(0,0,bl/2-l3,0);
back1 = t_matrix(0,0,-bl/2+l3,0);
back2 = t_matrix(0,0,-bl/2,0);

frontlf = front1*t_matrix(0,0,0,-pi/2)*t_matrix(-bw/2,0,0,0);
frontlb = front2*t_matrix(0,0,0,-pi/2)*t_matrix(-bw/2,0,0,0);
frontrf = front1*t_matrix(0,0,0,-pi/2)*t_matrix(bw/2,0,0,0);
frontrb = front2*t_matrix(0,0,0,-pi/2)*t_matrix(bw/2,0,0,0);

backlf = back1*t_matrix(0,0,0,-pi/2)*t_matrix(-bw/2,0,0,0);
backlb = back2*t_matrix(0,0,0,-pi/2)*t_matrix(-bw/2,0,0,0);
backrf = back1*t_matrix(0,0,0,-pi/2)*t_matrix(bw/2,0,0,0);
backrb = back2*t_matrix(0,0,0,-pi/2)*t_matrix(bw/2,0,0,0);
t1sm = zeros(4,1280);
t2sm = zeros(4,1280);
count = 0;
% time = zeros(1,1280);
time = 0:0.01:16*0.8-0.01;

%%
% tic
for jj=1:length(time)  
%while count<1280
    count = count+1;
    %time(1,count+1) = time(1,count) + 0.01;
for i=1:4
    
%     XY(3,:,i) = [rx(i)*cos(t + ph(i))+ox(i)+(XY(1,1,i)+XY(5,1,i))/2, XY(1,2,i),-1*(rz(i)*sin(t + ph(i)) + oy(i))];
%     if XY(3,3,i)<-oy(i)
%         XY(3,3,i) = -oy(i);
%     end
    XY(3,:,i) = [x2(2*i-1,jj)+(XY(1,1,i)+XY(5,1,i))/2 , XY(1,2,i),x2(2*i,jj)];
    l4 = sqrt((XY(3,1,i) - XY(1,1,i))^2 + (XY(3,3,i))^2);
    l5 = sqrt((XY(3,1,i) - XY(5,1,i))^2 + (XY(3,3,i))^2);
    th1 = pi - acos((l1^2 + l4^2 - l2^2)/(2*l1*l4)) - acos((l4^2 + l3^2 - l5^2)/(2*l4*l3));
    th2 = pi - acos((l1^2 + l2^2 - l4^2)/(2*l1*l2));
    th3 = acos((l1^2 + l5^2 - l2^2)/(2*l1*l5)) + acos((l5^2 + l3^2 - l4^2)/(2*l5*l3));
    th4 = -pi + acos((l1^2 + l2^2 - l5^2)/(2*l1*l2));
    
    t2sm(i,count) = -(acos((l1^2 + l4^2 - l2^2)/(2*l1*l4)) + acos((l4^2 + l3^2 - l5^2)/(2*l4*l3)))*180/pi +90;
    t1sm(i,count) = th3*180/pi - 90 ;
    
    fr = [frontlf,frontrf,backrf,backlf];
    ba = [frontlb,frontrb,backrb,backlb];

    b = t_matrix(0,th1,l1,0);
    b2 = t_matrix(0,th3,l1,0);
    
    fkn = fr(1:4,4*(i-1)+1:4*i)*b;
    bkn = ba(1:4,4*(i-1)+1:4*i)*b2;
    
    XY(2,:,i) = [fkn(1,4),XY(1,2,i),fkn(3,4)];
    XY(4,:,i) = [bkn(1,4),XY(1,2,i),bkn(3,4)];
    
    xc = [(XY(1,1,i)+XY(2,1,i))/2,(XY(2,1,i)+XY(3,1,i))/2,(XY(4,1,i)+XY(3,1,i))/2,(XY(4,1,i)+XY(5,1,i))/2];
    yc = [(XY(1,2,i)+XY(2,2,i))/2,(XY(2,2,i)+XY(3,2,i))/2,(XY(4,2,i)+XY(3,2,i))/2,(XY(4,2,i)+XY(5,2,i))/2];
    zc = [(XY(1,3,i)+XY(2,3,i))/2,(XY(2,3,i)+XY(3,3,i))/2,(XY(4,3,i)+XY(3,3,i))/2,(XY(4,3,i)+XY(5,3,i))/2];
    
    m = sum(ml1);mt = m*4 + mb;
    for j=1:4
        cmx(1,i) = cmx(i) + ml1(1,j)*xc(1,j)/m;
        cmy(1,i) = cmy(i) + ml1(1,j)*yc(1,j)/m;
        cmz(1,i) = cmz(i) + ml1(1,j)*zc(1,j)/m;
    end
    cbx=0;cby=0;cbz=0;
    if(i==4)
    for o=1:4
       cbx = cbx + m*cmx(1,o)/mt;
       cby = cby + m*cmy(1,o)/mt;
       cbz = cbz + m*cmz(1,o)/mt;
    end
    end
    
%     plot3(XY(:,1,1),XY(:,2,1),XY(:,3,1))
%     hold on
%     grid on; xlabel('x'); ylabel('y'); zlabel('z'); xlim([-25,25]);
    %     ylim([-20,20]); zlim([-20,20]); view(45,45); pause(0.001) hold on
    %     plot3(XY(:,1,2),XY(:,2,2),XY(:,3,2)) pause(0.001) hold on
    %     plot3(XY(:,1,3),XY(:,2,3),XY(:,3,3)) pause(0.001) hold on
    %     plot3(XY(:,1,4),XY(:,2,4),XY(:,3,4)) pause(0.001) hold on
    %     plot3(xc(1,:),yc(1,:),zc(1,:),'-') pause(0.001) hold on
    %     plot3(cmx(1,:),cmy(1,:),cmz(1,:),'o') hold on pause(0.001)
    %     plot3(cbx,cby,cbz,'o') pause(0.01)
%     toc
end
cmx=[0,0,0,0];
cmy=[0,0,0,0];
cmz=[0,0,0,0];
t=t+0.1;
end
toc
figure
plot(time(1,:),t1sm(1,:));
hold on
plot(time(1,:),t2sm(1,:))
grid on
legend;

figure
plot(time(1,:),t1sm(2,:));
hold on
plot(time(1,:),t2sm(2,:))
grid on
legend;

function out=t_matrix(d,th ,a,al)
     out = [cos(th)  -1*sin(th)*cos(al) sin(th)*sin(al)    a*cos(th)
            sin(th)  cos(th)*cos(al)   -1*cos(th)*sin(al)  a*sin(th)
            0        sin(al)           cos(al)             d
            0        0                 0                   1];
 end