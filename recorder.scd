(
// -------------------------------
// ---- BUFFERS AND SYNTHDEFS ----
// -------------------------------
Server.default = Server.internal;
s = Server.default;
//s.options.memSize = 2*65536;
s.waitForBoot({
	//~buffOrig0 = Buffer.alloc(s, 65536, 1);
	//~buffOrig0.write("/Users/eguaus/Box\ Sync/Creacio/sheepdog/alvincage/audio/loop0.wav", "wav", "int16", -1, 0, true);
	~buffLoop0 = Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/sheepdog/alvincage/audio/loop0.wav");
	SynthDef(\playFile, {arg bufnum, amp = 0, gate = 1, rate=1;
		var env = EnvGen.kr(Env.asr(0.1, 1, 3), gate, doneAction: 0);
		var snd = PlayBuf.ar(1, bufnum, rate, loop: 1, doneAction: 0);
		Out.ar(0, env * amp * snd);
	}).add;
	SynthDef(\recAudio, {arg bufnum;
		var snd = SoundIn.ar();
		Out.ar(bufnum, snd);
	}).add;
});
)

(
// ---------------------
// ---- OSC CONTROL ----
// ---------------------
n = NetAddr.new("127.0.0.1", 57120);
// ---- CHANNEL 0 ----
~synLoop0=Synth.new(\playFile, [\bufnum, ~buffLoop0, \amp, 1, \gate, 0, \rate, 1]).register;
//~synOrig0=Synth.new(\recAudio, [\bufnum, ~buffOrig0]).register;
//~synLoop0.isRunning(false);
//~synOrig0.isRunning(false);
o = OSCdef(\fader0,{ arg msg, time, addr, recvPort;
	q = msg[1].asFloat;
	if(q>0,{
		if(~synLoop0.isRunning,{~synLoop0.set(\amp,q)});
	});
	"Channel 0 - Volume = ".post; q.postln;
},'/0/fader',n);
// o = OSCdef(\knob0,{ arg msg, time, addr, recvPort;
// 	q = msg[1].asFloat;
// 	x.set(\rate,q.linlin(0,1,0.1,20));
// },'/0/knob',n);
o = OSCdef(\rec0,{ arg msg, time, addr, recvPort;
 	q = msg[1].asFloat;
	if(q>0,{
		//if(~synOrig0.isRunning,{~synOrig0.free;});
		~synOrig0=Synth.new(\recAudio, [\bufnum, ~buffOrig0]).register;
	},{
		if(~synOrig0.isRunning,{
			~synOrig0.free;
			~buffOrig0.close()
		});
	});
	"Channel 0 - Rec = ".post; q.postln;
 },'/0/rec',n);
// o = OSCdef(\mute0,{ arg msg, time, addr, recvPort;
// 	q = msg[1].asFloat;
// 	if(q>0,{~case0=~case0+2},{~case0=~case0-2});
// 	x.set(\case, ~case0);
// 	"Channel 0 - case = ".post; ~case0.postln;
// },'/0/mute',n);
o = OSCdef(\solo0,{ arg msg, time, addr, recvPort;
 	q = msg[1].asFloat;
	if(q>0,{
		if(~synLoop0.isRunning,{~synLoop0.free;});
		~synLoop0=Synth.new(\playFile, [\bufnum, ~buffLoop0, \amp, 1, \gate, 1, \rate, 1]).register;
	},{
		if(~synLoop0.isRunning,{~synLoop0.set(\gate, 0)});
	});
 	"Channel 0 - Play = ".post; q.postln;
},'/0/solo',n);
)

(
// ---------------
// ---- CLOSE ----
// ---------------
//~buffOrig0.close;
//~buffOrig0.free;
~loopOrig0.free;

~synOrig0.free;
~synLoop0.free;

o.free;
n.disconnect;
s.quit;
)




Task({
	20.wait; // To allow Quicktime screen recording
	s.record;
	c.sendMsg("/recOn",1.asFloat);
	x=Synth(\accelerando, [\start, 0.01, \stop, 300, \length, 360]);
	359.wait;
	y=Synth(\decelerando, [\start, 300, \stop, 0.01, \length, 60]);
	62.wait;
	c.sendMsg("/glass", 1.asFloat);
	1.wait;
	c.sendMsg("/recOff",1.asFloat);
    s.stopRecording;
	o.free;
	c.clear;
	s.quit;
}).start;
)
