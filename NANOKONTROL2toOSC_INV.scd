// Title: LPD8toOSC.scd
// Author: Enric Guaus
// Date: 11/11/2017


(
// --------------------------------
// ---- PREPARE OSC CONNECTION ----
// --------------------------------
m = NetAddr("127.0.0.1", 57120); // <---- Put your IP address and port here.
MIDIIn.connectAll;

MIDIdef.cc(\nanoKONTROL2 , { |vel, note, chan, port|
	//postf("Sending OSC: vel:%, note:%, chan:%, port:%\n",vel,note,chan,port);
	switch(note,
		7,  {m.sendMsg("/fader", chan, vel/127)},
		16, {m.sendMsg("/knob", chan, vel/127)},
		17, {m.sendMsg("/knob", chan, vel/127)},
		18, {m.sendMsg("/knob", chan, vel/127)},
		19, {m.sendMsg("/knob", chan, vel/127)},
		20, {m.sendMsg("/knob", chan, vel/127)},
		21, {m.sendMsg("/knob", chan, vel/127)},
		22, {m.sendMsg("/knob", chan, vel/127)},
		23, {m.sendMsg("/knob", chan, vel/127)},
		32, {m.sendMsg("/solo", chan, vel/127)},
		33, {m.sendMsg("/solo", chan, vel/127)},
		34, {m.sendMsg("/solo", chan, vel/127)},
		35, {m.sendMsg("/solo", chan, vel/127)},
		36, {m.sendMsg("/solo", chan, vel/127)},
		37, {m.sendMsg("/solo", chan, vel/127)},
		38, {m.sendMsg("/solo", chan, vel/127)},
		39, {m.sendMsg("/solo", chan, vel/127)},
		48, {m.sendMsg("/mute", chan, vel/127)},
		49, {m.sendMsg("/mute", chan, vel/127)},
		50, {m.sendMsg("/mute", chan, vel/127)},
		51, {m.sendMsg("/mute", chan, vel/127)},
		52, {m.sendMsg("/mute", chan, vel/127)},
		53, {m.sendMsg("/mute", chan, vel/127)},
		54, {m.sendMsg("/mute", chan, vel/127)},
		55, {m.sendMsg("/mute", chan, vel/127)},
		64, {m.sendMsg("/rec", chan, vel/127)},
		65, {m.sendMsg("/rec", chan, vel/127)},
		66, {m.sendMsg("/rec", chan, vel/127)},
		67, {m.sendMsg("/rec", chan, vel/127)},
		68, {m.sendMsg("/rec", chan, vel/127)},
		69, {m.sendMsg("/rec", chan, vel/127)},
		70, {m.sendMsg("/rec", chan, vel/127)},
		71, {m.sendMsg("/rec", chan, vel/127)},
		{m.sendMsg("/unknown", chan, vel/127)}
	);
});
)

(
// --------------------------------
// ---- RUN THIS WHEN FINISHED ----
// --------------------------------
m.disconnect;
MIDIdef.freeAll; // stop responding
)



