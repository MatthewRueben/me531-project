tspan = [0 20];
y0 = [pi/2+1 0];
[t,y] = ode45(@fu,tspan,y0);
plotyy(t,y(:,1),t,y(:,2))

% the formula = -(3/2)*(g/L)cos(theta) + 3/(mL^2)*T
%T = sqrt(2)/4*mgL +Te
%Te = K*Xe = (k(1)* (y(1)- pi/4) + (k(2) * (y(2)- 0))

function ydot = fu(t,y)
m = 1;
L = 1;
g = 9.81;
%k1 = -2140162387832453/562949953421312;
k1 = -2703112341253765/562949953421312;
%k2 = -2/3;
k2 = -4/3;
ydot = zeros(2,1);
ydot(1) = y(2);
ydot(2) = -3*g/(2*L)*cos(y(1)) + 3*sqrt(2)*g/(4*L) + 3/(m*L*L) * (k1 * (y(1) - pi/4) + k2 * y(2));

end
