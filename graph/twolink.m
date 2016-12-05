y0 = [pi/2+0.01 0 0 0];
tspan = [0 20];
[t,y] = ode45(@fu,tspan,y0);
plot(t,y(:,1));
%draw graph
hold on
plot(t,y(:,2));
plot(t,y(:,3));
plot(t,y(:,4));
hold off
legend('TA','TAdot','TB','TBdot');


% the formula = -(3/2)*(g/L)cos(theta) + 3/(mL^2)*T
%T = sqrt(2)/4*mgL +Te
%Te = K*Xe = (k(1)* (y(1)- pi/4) + (k(2) * (y(2)- 0))

function ydot = fu(t,y)
    mAB = 1;
    mBC = 1;
    LAB = 1;
    LBC = 1;
    g = 9.81;

    k1 = -3912217897761505259/316002218803200;
    k2 = -470992000/2943;
    k3 = -5527228547083215680015886857790905318172186528767/1115037259926531157076785913632418075299020800;
    k4 = -5192296858534827628538654133464761545/81129638414606681695789005144064;

    KXerr = k1*(y(1)-pi/2)+k2*(y(2)-0)+k3*(y(3)-0)+k4*(y(4)-0);

    ydot = zeros(4,1);
    ydot(1) = y(2);
    ydot(2) = -3/(mAB*LAB*LAB)*((1/2*mAB*g*LAB + mBC*g*LAB)*cos(y(1))+mBC*g*LBC*cos(y(1)+y(3)));
    ydot(3) = y(4);
    ydot(4) = 1/(2*LBC)*(-g*cos(y(1)+y(3))+g*cos(0+pi/2))+KXerr/(2*mBC*LBC*LBC) ;
end
