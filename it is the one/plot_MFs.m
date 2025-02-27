
fis = readfis('original.fis');
subplot(2, 4, 1)
plotmf(fis,'input',1)
title("input1 before optimization")
subplot(2, 4, 2)
plotmf(fis,'input',2)
title("input2 before optimization")
subplot(2, 4, 3)
plotmf(fis,'input',3)
title("input3 before optimization")
subplot(2, 4, 4)
plotmf(fis,'input',4)
title("input4 before optimization")

And = ["prod", "min"];
fis.AndMethod = And(numAnd);

Or = ["probor", "max"];
fis.OrMethod = Or(numOr);

fis.rules(1,2).weight = weight(1,1);
fis.rules(1,2).weight = weight(1,2);
fis.rules(1,3).weight = weight(1,3);
Defuzzi = ["centroid", "mom", "lom", "som"];
fis.DefuzzificationMethod = Defuzzi(numDefuzzi);


fis.Inputs(1, 1).MembershipFunctions(1, 1).Parameters = [-0.3223 + parameter1(1,1), 4.0836 + parameter2(1,1)];
fis.Inputs(1, 1).MembershipFunctions(1, 2).Parameters = [abs(0.7139 + parameter1(1,2)), 1.3500 + parameter2(1,2)];

fis.Inputs(1, 2).MembershipFunctions(1, 1).Parameters = [ -4.0879 + parameter1(2,1), -1.5516 + parameter2(2,1)];
fis.Inputs(1, 2).MembershipFunctions(1, 2).Parameters = [ abs(0.7500 + parameter1(2,2)), -2.9630 + parameter2(2,2)];
fis.Inputs(1, 2).MembershipFunctions(1, 3).Parameters = [ abs(0.7500 + parameter1(2,3)), -2.0472 + parameter2(2,3)];

fis.Inputs(1, 3).MembershipFunctions(1, 3).Parameters = [ abs(0.3000 + parameter1(3,2)), -0.5000 + parameter2(3,2)];

parameter1(1, 3) = 0;parameter2(1, 3) = 0;
parameter1(3, 1) = 0;parameter2(3, 1) = 0;
parameter1(3, 3) = 0;parameter2(3, 3) = 0;


fis.Inputs(1, 4).MembershipFunctions(1, 1).Parameters = [ 0.9000 + parameter1(4,1), 2.0000 + parameter2(4,1)];
fis.Inputs(1, 4).MembershipFunctions(1, 2).Parameters = [ abs(0.4300 + parameter1(4,2)), 0.9200 + parameter2(4,2)];
fis.Inputs(1, 4).MembershipFunctions(1, 3).Parameters = [ abs(0.4300 + parameter1(4,3)),  0.4000 + parameter2(4,3)];



subplot(2, 4, 5)
plotmf(fis,'input',1)
title("input1 after optimization")
subplot(2, 4, 6)
plotmf(fis,'input',2)
title("input2 after optimization")
subplot(2, 4, 7)
plotmf(fis,'input',3)
title("input3 after optimization")
subplot(2, 4, 8)
plotmf(fis,'input',4)
title("input4 after optimization")







