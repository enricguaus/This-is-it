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
var bufferArray, recSynths, playSynths, knobValues, faderValues, wavFiles, wavSynths;
bufferArray = Array.fill(8, { Buffer.alloc(s, s.sampleRate * 5, 1)}); // ---- Durada del buffer ----
recSynths = Array.fill(8, { nil });
playSynths = Array.fill(8, { nil });
knobValues = Array.fill(8,0);
faderValues = Array.fill(8,0);
wavFiles = Array.new;
wavFiles = wavFiles.add(Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/sheepdog/alvincage/audio/1_IsIt_IsIt.wav"));
wavFiles = wavFiles.add(Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/sheepdog/alvincage/audio/2_IsIt_IsIsItIt.wav"));
wavFiles = wavFiles.add(Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/sheepdog/alvincage/audio/3_IsIt_WhatIsIt.wav"));
wavFiles = wavFiles.add(Buffer.read(s, "/Users/eguaus/Box\ Sync/Creacio/sheepdog/alvincage/audio/4_IsIt_NowItIs.wav"));
wavSynths = Array.fill(4,{ nil });

// ---------------------
// ---- OSC CONTROL ----
// ---------------------
n = NetAddr.new("127.0.0.1", 57120);

// ---- CHANNEL 0 ----
o = OSCdef(\rec,{ arg msg, time, addr, recvPort;
	var channel=msg[1].asFloat;
 	q = msg[2].asFloat;
	if(q>0,{
		recSynths[channel] = Synth(\recbuf, [\buffer, bufferArray[channel], \recLevel, knobValues[channel]]);
	},{
		recSynths[channel].free;
	});
	"Channel ".post; channel.post; " - Rec = ".post; q.postln;
},'/rec',n,argTemplate: [{|channel| channel<8}]);

o = OSCdef(\solo,{ arg msg, time, addr, recvPort;
	var channel=msg[1].asFloat;
 	q = msg[2].asFloat;
	if(q>0,{
		playSynths[channel] = Synth(\playbuf, [\buffer, bufferArray[channel], \amp, faderValues[channel]]);
	},{
		playSynths[channel].free;
	});
 	"Channel ".post; channel.post; " - Play = ".post; q.postln;
},'/solo',n,argTemplate: [{|channel| channel<8}]);

o = OSCdef(\knob,{ arg msg, time, addr, recvPort;
	var channel=msg[1].asFloat;
	knobValues[channel] = msg[2].asFloat;
 	recSynths[channel].set(\recLevel,knobValues[channel]);
	"Channel ".post; channel.post; " - Rec Level = ".post; knobValues[channel].postln;
},'/knob',n,argTemplate: [{|channel| channel<8}]);

o = OSCdef(\fader,{ arg msg, time, addr, recvPort;
	var channel=msg[1].asFloat;
	faderValues[channel] = msg[2].asFloat;
	playSynths[channel].set(\amp, faderValues[channel]);
	wavSynths[channel].set(\amp, faderValues[channel]);
	"Channel ".post; channel.post; " - Volume = ".post; faderValues[channel].postln;
},'/fader',n,argTemplate: [{|channel| channel<8}]);


o = OSCdef(\mute,{ arg msg, time, addr, recvPort;
	var channel=msg[1].asFloat.postln;
 	q = msg[2].asFloat;
	if(q>0,{
		wavSynths[channel] = Synth(\playbuf, [\buffer, wavFiles[channel], \amp, faderValues[channel]]);
	},{
		wavSynths[channel].free;
	});
 	"Channel ".post; channel.post; " - Play = ".post; q.postln;
},'/mute',n,argTemplate: [{|channel| channel<4}]);


)

(
// ---------------
// ---- CLOSE ----
// ---------------
o.free;
n.disconnect;
s.quit;
)


