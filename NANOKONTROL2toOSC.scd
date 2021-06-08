// Title: LPD8toOSC.scd
// Author: Enric Guaus
// Date: 11/11/2017

(
// --------------------------------
// ---- PREPARE OSC CONNECTION ----
// --------------------------------
m = NetAddr("127.0.0.1", 57120); // <---- Put your IP address and port here.
MIDIIn.connectAll;

MIDIdef.cc(\radio , { |vel, note, chan, port|
	var te, ve;
	//postf("vel:%, note:%,chan:%, port:%\n",vel,note,chan,port);
	postf("Sending OSC: ");
	switch(note,
		7,  {te=postf("/%/fader",chan)},
		16, {te=postf("/%/knob", chan)},
		17, {te=postf("/%/knob", chan)},
		18, {te=postf("/%/knob", chan)},
		19, {te=postf("/%/knob", chan)},
		20, {te=postf("/%/knob", chan)},
		21, {te=postf("/%/knob", chan)},
		22, {te=postf("/%/knob", chan)},
		23, {te=postf("/%/knob", chan)},
		32, {te=postf("/%/solo", chan)},
		33, {te=postf("/%/solo", chan)},
		34, {te=postf("/%/solo", chan)},
		35, {te=postf("/%/solo", chan)},
		36, {te=postf("/%/solo", chan)},
		37, {te=postf("/%/solo", chan)},
		38, {te=postf("/%/solo", chan)},
		39, {te=postf("/%/solo", chan)},
		48, {te=postf("/%/mute", chan)},
		49, {te=postf("/%/mute", chan)},
		50, {te=postf("/%/mute", chan)},
		51, {te=postf("/%/mute", chan)},
		52, {te=postf("/%/mute", chan)},
		53, {te=postf("/%/mute", chan)},
		54, {te=postf("/%/mute", chan)},
		55, {te=postf("/%/mute", chan)},
		64, {te=postf("/%/rec",  chan)},
		65, {te=postf("/%/rec",  chan)},
		66, {te=postf("/%/rec",  chan)},
		67, {te=postf("/%/rec",  chan)},
		68, {te=postf("/%/rec",  chan)},
		69, {te=postf("/%/rec",  chan)},
		70, {te=postf("/%/rec",  chan)},
		71, {te=postf("/%/rec",  chan)},
		{te=postf("/%/unknown", chan)}
	);
	ve=vel/127;
	postf(" %\n",ve);
	m.sendMsg(te,ve.asString)
});
)

(
// --------------------------------
// ---- RUN THIS WHEN FINISHED ----
// --------------------------------
m.disconnect;
MIDIdef.freeAll; // stop responding
)



