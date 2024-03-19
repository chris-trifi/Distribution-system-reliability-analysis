[LOLP, CML, EENS, total] = run_simulations(100000000);
metrics = ["LOLP", "CML", "EENS"];

for i = 1:3
    x = total(:,i);
    SEM = std(x)/sqrt(length(x));               % Standard Error
    ts = tinv([0.025  0.975],length(x)-1);      % T-Score
    disp(metrics(i))
    CI = mean(x) + ts*SEM                       % Confidence Intervals
end






function [LOLP, CML, EENS, total] = run_simulations(amount)
    total = zeros(amount,3);
    unavailable = 0;
    for i = 1:amount
        time = randi(24);
        [var1, var2, var3, var4, var5, var6] = return_value();
        [a, b, c, d] = Is_Supplied(var1, var2, var3, var4, var5, var6);
        [LOL, CML, ENS, u] = evaluate_state(a, b, c, d, time);
        total(i,1) = total(i,1) + LOL;
        total(i,2) = total(i,2) + CML;
        total(i,3) = total(i,3) + ENS;
        unavailable = unavailable + u;
    end
    LOLP = mean(total(:,1));
    CML = mean(total(:,2));
    EENS = mean(total(:,3));
    unavailable = unavailable/amount;   %load unavailability rates
end



function [LOL, CML, ENS, unavailable] = evaluate_state(a, b, c, d, time)
    unavailable = [0,0,0,0];
    load_a = [1000,1000,1000,1000,1000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,3000,3000,3000,3000,3000,3000,1000];
    load_b = [1000,1000,1000,3000,3000,3000,3000,3000,3000,3000,3000,3000,3000,3000,3000,3000,3000,3000,3000,3000,3000,1000,1000,1000];
    load_c = [500,500,500,500,500,500,5000,5000,5000,5000,5000,5000,5000,5000,5000,5000,5000,5000,500,500,500,500,500,500];
    load_d = [1000,1000,1000,1000,1000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,3000,3000,3000,3000,3000,3000,1000];
    LOL = 0; %becomes 1 if at least one load gets no supply
    ENS = 0; 
    CML = 0;
    if a == 0
        ENS = ENS + load_a(time);
        CML = CML + 1000;
        unavailable(1) = 1;
    end
    if b == 0
        ENS = ENS + load_b(time);
        CML = CML + 1000;
        unavailable(2) = 1;
    end
    if c == 0
        ENS = ENS + load_c(time);
        CML = CML + 100;
        unavailable(3) = 1;
    end
    if d == 0
        ENS = ENS + load_d(time);
        CML = CML + 1000;
        unavailable(4) = 1;
    end    

    if ENS > 0
        LOL = 1;
    end
    ENS = ENS*8766;
    CML = (CML/3100)*525949; %this way we get the CML in minutes per year
end


function [a, b, c, d] = Is_Supplied(var1, var2, var3, var4, var5, var6)
    a = (var1 + var2)*var3;
    b = var1*var2*var4*(var5>0)*(var6 > 0);
    c = var1*var2*var4*(var5 == 2)*(var6>0);
    d = var1*var2*var4*(var5 == 2)*(var6 == 2);
end


%samples variable values
function [var1, var2, var3, var4, var5, var6] = return_value()

    num = rand;
    if num > 0.000684
        var1 = 1;
    else
        var1 = 0;
    end

    num = rand;
    if num > 0.000219
        var2 = 1;
    else
        var2 = 0;
    end
    
    num = rand;
    if num > 0.000171
        var3 = 1;
    else
        var3 = 0;
    end
    
    num = rand;
    if num > 0.000114
        var4 = 1;
    else
        var4 = 0;
    end
    
    num = rand;
    if num > 0.000171
        var5 = 2;
    elseif num > 0.0000171
        var5 = 1;
    else
        var5 = 0;
    end

    num = rand;
    if num > 0.000548
        var6 = 2;
    elseif num > 0.0000548
        var6 = 1;
    else
        var6 = 0;
    end        

end



