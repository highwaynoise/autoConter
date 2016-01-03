/*
select : generator type: SinOsc  TriOsc .. 
scale

control: adsr
offset 
number 
pulse
*/
MidiOut mout;

mout.open(0);




200::ms=>dur pulse;
pulse/64.0=>dur sync;
sync-now % sync =>now;

//mout.close();



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

spork ~sec(num1,off1,1,0);
spork ~sec(num2,off2,0,1);
while(true) { 1::second=>now; }


fun void sec(int num,int offset,int isBass,int chn)
{
    now + 8::second=>time later;
    0=>int i;     
    while(now<later)
    {
        MidiMsg msg;
        
        scale[index[i]+offset]-24*isBass+20+Math.random2(0,1)*(-12)*isRand*(1-isBass)=>int pitch;
        0x90+chn=>msg.data1;
        pitch=>msg.data2;
        Math.random2(40,127)=>msg.data3;
        mout.send(msg);
        
        pulse-80::ms=>now;
        
        0x80+chn=>msg.data1;
        pitch=>msg.data2;
        0=>msg.data3;
        mout.send(msg);
        
        80::ms=>now;

        (i+1) % num => i;
    }
}
