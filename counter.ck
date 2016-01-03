/*
select : generator type: SinOsc  TriOsc .. 
         scale
         
control: adsr
         offset 
         number 
         pulse
*/


200::ms=>dur pulse;
pulse/64.0=>dur sync;
sync-now % sync =>now;


TriOsc s1 =>ADSR env1 => dac;
TriOsc s2 => ADSR env2 => dac;


env1.set(100::ms,18::ms,.6,100::ms);
env2.set(12::ms,10::ms,.3,1500::ms);

0.4=>s1.gain=>s2.gain;
0=>s1.freq=>s2.freq;
int scale[];
//[48,49,51,53,55,56,58,60,61,63,65,67,68,70,72,73,75,77,79,80,82,84,85] @=> scale;

[48,50,52,54,55,57,59,60,62,64,66,67,69,71,72,74,76,78,79,81,83,84] @=> scale;


int index[];
[0,1,1,2,3,5,8,13,21,34,55] @=> index;


// Random or not
1=>int isRand;

Math.random2(2,7) => int num1;
Math.random2(2,7) => int num2;
//if (num1==num2) num1+1=>num2;


Math.random2(0,7) => int off1;
Math.random2(0,7) => int off2;



//beautiful 
/*
3=> num1;
5=>num2;
3=>off1;
1=>off2;
*/

// 7 5 5 3

// 7 2 7 1

// 5 7 1 1 1 

// 2 5 4 5

// 4 5 0 3

// 6 5 7 2

// 7 5 5 2

<<<"conter harmony:">>>;
<<<num1,num2>>>;
<<<"offset:">>>;
<<<off1,off2>>>;

spork ~sec(num1,s1,env1,off1,1);
spork ~sec(num2,s2,env2,off2,0);
8::second=>now;

fun void sec(int num,TriOsc s,ADSR env,int offset,int isBass)
{
    now + 8::second=>time later;
    0=>int i;     
    while(now<later)
    {
        scale[index[i]+offset]-24*isBass+20+Math.random2(0,1)*(-12)*isRand*(1-isBass)=>Std.mtof=>s.freq;
        (i+1)%num=>i;
        env.keyOn();
        80::ms=>now;
        env.keyOff();
        pulse-80::ms=>now;
    }
}
