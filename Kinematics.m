1clear; clc;
syms v u a t s
f = sym('0');

eqn1 = v == u+a*t;
eqn2 = v^2 == u^2 + 2*a*s;
eqn3 = s == u*t + 0.5*a*(t^2);
eqn = [eqn1 eqn2 eqn3];
for i = 1:5
    for j = 1:3
        soln(i,j) = f;
    end
end
soln(:,:,2)=f;
var = [v u a s t];
c=0;
for i = 1:5
    for j = 1:3
        temp = solve(eqn(j),var(i));
        tempSize = size(temp);
        if(tempSize(1)==2)
            soln(i,j,1) = temp(1);
            soln(i,j,2) = temp(2);
        elseif (tempSize==1)
            soln(i,j,1) = temp;
        else
        end
    end
end
vVar = input("Input v =>  ");
uVar = input("Input u =>  ");
aVar = input("Input a =>  ");
sVar = input("Input s =>  ");
tVar = input("Input t =>  ");

check = [1 1 1 1 1];
comp = zeros(1,1);
known = zeros(1,3);

if isempty(vVar)
    check(1)=0;
end
if isempty(uVar)
    check(2)=0;
end
if isempty(aVar)
    check(3)=0;
end
if isempty(sVar)
    check(4)=0;
end
if isempty(tVar)
    check(5)=0;
end

values = [vVar uVar aVar sVar tVar];

c=1; d=1;
for i=1:5
    if check(i)==0
        comp(c)=i;
        c=c+1;
    else
        known(d)=i;
        d=d+1;
    end
end

if sum(check)<3
    disp("Not enough Data");
elseif sum(check)==3 && check(1)+check(4)+check(5)==3
    disp("Not enough Data");
else
    for i=1:length(comp)
        for j = 1:3
            skip = false;
            unK = symvar(soln(comp(i),j,1));
            for k = 1:length(known)
                if isempty(find(unK==var(known(k))))
                    skip = true;
                    break;
                end
            end
            if skip==true && length(known)<4
                continue;
            else
                fprintf("\nCalculating %s\n",char(var(comp(i))));
                fprintf("Using equation %s\n", char(eqn(j)));
                temp = soln(comp(i),j,1);
                for k = 1:length(known)
                    temp = subs(temp,var(known(k)),values(k));
                end
                fprintf("%s = %f\n",char(var(comp(i))),temp);
                known(end+1) = comp(i);
                known = sort(known);
                index = find(known==comp(i));
                values = [values(1:index-1) temp values(index:end)];
                fprintf("\n----------------------\n")
                break;
            end
        end
    end
end