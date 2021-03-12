clearvars
clearvars -GLOBAL
close all
set(0,'DefaultFigureWindowStyle', 'docked')

Is = 0.01e-12;
Ib = 0.1e-12;
Vb = 1.3;
Gp = 0.1;

V = linspace(-1.95,0.7,200);
I = Is * (exp((1.2/0.25).*V) - 1) + Gp.*V - Ib * (exp((-1.2/0.25).*(V + Vb)) - 1) ;
for i = 1:200
    Irand(i) = V(i)-0.2*V(i) + ((V(i)+0.2*V(i)) - (V(i)-0.2*V(i)))*rand;
end    
subplot(3,2,1)
plot (V,Irand,'r');
title(' Voltage versus Current - linear');
hold on
plot (V, I,'b');
legend('I noise', 'I');
xlabel('V');
ylabel('I');

subplot(3,2,2)
semilogy(V,Irand,'r');
title('Voltage versus Current semilog');
hold on
semilogy(V, I,'b');
legend('I noise', 'I');
xlabel('V');
ylabel('I');

pI4 = polyfit(V,Irand,4);
pI8 = polyfit(V,Irand,8);
pIrand4 = polyfit(V,Irand,4);
pIrand8 = polyfit(V,Irand,8);

subplot(3,2,3)
plot(V,Irand,'b');
title('Fit4 and Fit8 plots');
hold on
plot(V,polyval(pI4,V),'-g');
hold on
plot(V,polyval(pI8,V),'.r');
legend('I','fit4','fit8');
xlabel('V');
ylabel('I');

% Non Linear curve fitting

% Setting B & D explictly
fo = fittype('A.*(exp(1.2*x/25e-3)-1) + 0.1.*x - C*(exp(1.2*(-(x+1.3))/25e-3)-1)');
fofit = fit(V.',I.',fo);

% Setting D explictly
f1 = fittype('A.*(exp(1.2*x/25e-3)-1) + B.*x - C*(exp(1.2*(-(x+1.3))/25e-3)-1)');
f1fit = fit(V.',I.',f1);

% Setting D explictly
f2 = fittype('A.*(exp(1.2*x/25e-3)-1) + B.*x - C*(exp(1.2*(-(x+D))/25e-3)-1)');
f2fit = fit(V.',I.',f2);

subplot(3,2,4)
plot(V,fofit(I),'b');
title('Non linear curve fitting')
hold on
plot(V,f1fit(I),'r');
hold on
plot(V,f2fit(I),'g');
hold on
legend('B & D set','D set','None Set');

% Neural net
inputs = V.';
targets = I.';
hiddenLayerSize = 10;
net = fitnet(hiddenLayerSize);
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;
[net,tr] = train(net,inputs,targets);
outputs = net(inputs);
errors = gsubtract(outputs,targets);
performance = perform(net,targets,outputs)
view(net)
Inn = outputs



