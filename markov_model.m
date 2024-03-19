
[CML,ENS] = yearly_evolution(2000)


function [total_CML, total_ENS] = yearly_evolution(samples)
    load_a = [1000,1000,1000,1000,1000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,3000,3000,3000,3000,3000,3000,1000];
    load_b = [1000,1000,1000,3000,3000,3000,3000,3000,3000,3000,3000,3000,3000,3000,3000,3000,3000,3000,3000,3000,3000,1000,1000,1000];
    load_c = [500,500,500,500,500,500,5000,5000,5000,5000,5000,5000,5000,5000,5000,5000,5000,5000,500,500,500,500,500,500];
    load_d = [1000,1000,1000,1000,1000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,3000,3000,3000,3000,3000,3000,1000];
    time = 1;
    state = [1,1,1,1,2,2];
    total_CML = 0;
    total_ENS = 0;
    for i = 1:8766*samples
        [a, b, c, d] = Is_Supplied(state(1), state(2), state(3), state(4), state(5), state(6));
        ENS = 0; 
        CML = 0;
        if a == 0
            ENS = ENS + load_a(time);
            CML = CML + 1000;
        end
        if b == 0
            ENS = ENS + load_b(time);
            CML = CML + 1000;
        end
        if c == 0
            ENS = ENS + load_c(time);
            CML = CML + 100;
        end
        if d == 0
            ENS = ENS + load_d(time);
            CML = CML + 1000;
        end    
    
        CML = (CML/3100)*60; 

        total_CML = total_CML + CML;
        total_ENS = total_ENS + ENS;
        new_state = step(state);
        state = new_state;
        if time == 24
            time = 1;
        else 
            time = time + 1;
        end
    end
    total_CML = total_CML/samples;
    total_ENS = total_ENS/samples;
end


function new_state = step(state)
    failure_rates = [0.00000570776, 0.00000456621, 0.00001902587, 0.00001141552, 0.00001141552, 0.00002283105];
    repair_rates = [0.00833333333, 0.02083333333, 0.11111111111, 0.1, 0.06666666666, 0.04166666666];
    new_state = state;
    for i = 1:4
        num = rand;
        if state(i) == 1
            if num < failure_rates(i)
                new_state(i) = 0;
            end
        else
            if num < repair_rates(i)
                new_state(i) = 1;
            end            
        end
    end
    for i = 5:6
        num = rand;
        if state(i) == 2
            if num < failure_rates(i)
                if rand < 0.1
                    new_state(i) = 0;
                else
                    new_state(i) = 1; 
                end
            end
        else
            if num < repair_rates(i) 
                new_state(i) = 2;
            end
        end
    end
end

function [a, b, c, d] = Is_Supplied(var1, var2, var3, var4, var5, var6)
    a = (var1 + var2)*var3;
    b = var1*var2*var4*(var5>0)*(var6 > 0);
    c = var1*var2*var4*(var5 == 2)*(var6 > 0);
    d = var1*var2*var4*(var5 == 2)*(var6 == 2);
end

