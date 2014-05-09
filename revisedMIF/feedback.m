function f = feedback(u,fbset)
%FEEDBACK Summary of this function goes here
%   Detailed explanation goes here
if u >= 1
    f=fbset(1);
else if u >= 0.85
        f=fbset(2);
else if u >= 0.6
        f=fbset(3);
else if u >=0.5
        f=fbset(4);
else if u > 0
        f=fbset(5);
    else
        f=0;
    end
    end
    end
    end
end
end

