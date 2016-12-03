%% Test DesignObserver on the one-link system

my_A = [0    1.0000;
        10.4051         0];
   
my_B = [0;
        3];
     
my_C = [1     0];
     
L = DesignObserver(my_A, my_B, my_C, [2.0*10, 2.0*10]);   