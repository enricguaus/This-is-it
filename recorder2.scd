(
// -------------------------------
// ---- BUFFERS AND SYNTHDEFS ----
// -------------------------------
Server.default = Server.internal;
s = Server.default;
//s.options.memSize = 2*65536;
s.waitForBoot({
	SynthDef(\recbuf, {arg buffer, recLevel=0;
		RecordBuf.ar(SoundIn.ar(0), buffer, 0, recLevel: recLevel, preLevel:1-recLevel, loop:1);
	}).add;
	SynthDef(\playbuf, {arg buffer, out=0, rate=1, amp=0;
		var signal;
		signal = PlayBuf.ar(1, buffer, rate:rate, loop:1) * amp;
		Out.ar(out, Pan2.ar(signal, 0));
	}).add;
});
)

(
// -----------------
// ---- BUFFERS ----
// -----------------
var bufferArray, recSynths, playSynths, knobValues, faderValues;
bufferArray = Array.fill(8, { Buffer.alloc(s, s.sampleRate * 2.0, 1)});
recSynths = Array.fill(8, { nil });
playSynths = Array.fill(8, { nil });
knobValues = Array.fill(8,0);
faderValues = Array.fill(8,0);

// ---------------------
// ---- OSC CONTROL ----
// ---------------------
n = NetAddr.new("127.0.0.1", 57120);

// ---- CHANNEL 0 ----
o = OSCdef(\rec0,{ arg msg, time, addr, recvPort;
 	q = msg[1].asFloat;
	if(q>0,{
		recSynths[0] = Synth(\recbuf, [\buffer, bufferArray[0], \recLevel, knobValues[0]]);
	},{
		recSynths[0].free;
	});
	"Channel 0 - Rec = ".post; q.postln;
},'/0/rec',n);
o = OSCdef(\solo0,{ arg msg, time, addr, recvPort;
 	q = msg[1].asFloat;
	if(q>0,{
		playSynths[0] = Synth(\playbuf, [\buffer, bufferArray[0], \amp, faderValues[0]]);
	},{
		playSynths[0].free;
	});
 	"Channel 0 - Play = ".post; q.postln;
},'/0/solo',n);
o = OSCdef(\knob0,{ arg msg, time, addr, recvPort;
	knobValues[0] = msg[1].asFloat;
 	recSynths[0].set(\recLevel,knobValues[0]);
	"Channel 0 - Rec Level = ".post; knobValues[0].postln;
},'/0/knob',n);
o = OSCdef(\fader0,{ arg msg, time, addr, recvPort;
	faderValues[0] = msg[1].asFloat;
	playSynths[0].set(\amp, faderValues[0]);
	"Channel 0 - Volume = ".post; faderValues[0].postln;
},'/0/fader',n);

// ---- CHANNEL 1 ----
o = OSCdef(\rec1,{ arg msg, time, addr, recvPort;
 	q = msg[1].asFloat;
	if(q>0,{
		recSynths[1] = Synth(\recbuf, [\buffer, bufferArray[1], \recLevel, knobValues[1]]);
	},{
		recSynths[1].free;
	});
	"Channel 1 - Rec = ".post; q.postln;
},'/1/rec',n);
o = OSCdef(\solo1,{ arg msg, time, addr, recvPort;
 	q = msg[1].asFloat;
	if(q>0,{
		playSynths[1] = Synth(\playbuf, [\buffer, bufferArray[1], \amp, faderValues[1]]);
	},{
		playSynths[1].free;
	});
 	"Channel 1 - Play = ".post; q.postln;
},'/1/solo',n);
o = OSCdef(\knob1,{ arg msg, time, addr, recvPort;
	knobValues[1] = msg[1].asFloat;
 	recSynths[1].set(\recLevel,knobValues[1]);
	"Channel 1 - Rec Level = ".post; knobValues[1].postln;
},'/1/knob',n);
o = OSCdef(\fader1,{ arg msg, time, addr, recvPort;
	faderValues[1] = msg[1].asFloat;
	playSynths[1].set(\amp, faderValues[1]);
	"Channel 1 - Volume = ".post; faderValues[1].postln;
},'/1/fader',n);

// ---- CHANNEL 2 ----
o = OSCdef(\rec2,{ arg msg, time, addr, recvPort;
 	q = msg[1].asFloat;
	if(q>0,{
		recSynths[2] = Synth(\recbuf, [\buffer, bufferArray[2], \recLevel, knobValues[2]]);
	},{
		recSynths[2].free;
	});
	"Channel 2 - Rec = ".post; q.postln;
},'/2/rec',n);
o = OSCdef(\solo2,{ arg msg, time, addr, recvPort;
 	q = msg[1].asFloat;
	if(q>0,{
		playSynths[2] = Synth(\playbuf, [\buffer, bufferArray[2], \amp, faderValues[2]]);
	},{
		playSynths[2].free;
	});
 	"Channel 2 - Play = ".post; q.postln;
},'/2/solo',n);
o = OSCdef(\knob2,{ arg msg, time, addr, recvPort;
	knobValues[2] = msg[1].asFloat;
 	recSynths[2].set(\recLevel,knobValues[2]);
	"Channel 2 - Rec Level = ".post; knobValues[2].postln;
},'/2/knob',n);
o = OSCdef(\fader2,{ arg msg, time, addr, recvPort;
	faderValues[2] = msg[1].asFloat;
	playSynths[2].set(\amp, faderValues[2]);
	"Channel 2 - Volume = ".post; faderValues[2].postln;
},'/2/fader',n);

// ---- CHANNEL 3 ----
o = OSCdef(\rec3,{ arg msg, time, addr, recvPort;
 	q = msg[1].asFloat;
	if(q>0,{
		recSynths[3] = Synth(\recbuf, [\buffer, bufferArray[3], \recLevel, knobValues[3]]);
	},{
		recSynths[3].free;
	});
	"Channel 3 - Rec = ".post; q.postln;
},'/3/rec',n);
o = OSCdef(\solo3,{ arg msg, time, addr, recvPort;
 	q = msg[1].asFloat;
	if(q>0,{
		playSynths[3] = Synth(\playbuf, [\buffer, bufferArray[3], \amp, faderValues[3]]);
	},{
		playSynths[3].free;
	});
 	"Channel 3 - Play = ".post; q.postln;
},'/3/solo',n);
o = OSCdef(\knob3,{ arg msg, time, addr, recvPort;
	knobValues[3] = msg[1].asFloat;
 	recSynths[3].set(\recLevel,knobValues[3]);
	"Channel 3 - Rec Level = ".post; knobValues[3].postln;
},'/3/knob',n);
o = OSCdef(\fader3,{ arg msg, time, addr, recvPort;
	faderValues[3] = msg[1].asFloat;
	playSynths[3].set(\amp, faderValues[3]);
	"Channel 3 - Volume = ".post; faderValues[3].postln;
},'/3/fader',n);
)


(
// ---------------
// ---- CLOSE ----
// ---------------
o.free;
n.disconnect;
s.quit;
)
