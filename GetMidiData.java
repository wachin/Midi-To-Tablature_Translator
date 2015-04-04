import java.io.*;
import javax.sound.midi.MidiEvent;
import javax.sound.midi.MidiMessage;
import javax.sound.midi.MidiSystem;
import javax.sound.midi.Sequence;
import javax.sound.midi.ShortMessage;
import javax.sound.midi.Track;
import java.util.*;


public class GetMidiData {
	public static final int NOTE_ON = 0x90;
	public static final int NOTE_OFF = 0x80;
	public static final String[] NOTE_NAMES = {"C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"};
		
	public static ArrayList<String> getMidiData(Sequence seqTest) throws Exception{
		//seqTest = MidiSystem.getSequence(new File("test.mid"));
			
	
/*The section following gives info on the length and tempo of the song according to the
 * Midi file chosen..
 *
 * It factors in the messages that may not be sound, but should be very near the value 
 * for BPM.
 */
		ArrayList<String> songInfo = new ArrayList<String>();
		ArrayList<Integer> tickArr = new ArrayList<Integer>();
		ArrayList<Integer> chanArr = new ArrayList<Integer>();
		ArrayList<String> noteArr = new ArrayList<String>();
		ArrayList<String> octArr = new ArrayList<String>();
		ArrayList<String> keyArr = new ArrayList<String>();
		ArrayList<Integer> velArr = new ArrayList<Integer>();
		
		String[] infoLegend = {"MicroSecondLength", "Minutes", "Seconds", "MinutesAndSecsAsInMinutes", "TicksInSong", "TicksPerSixteenthNote", "TotalSixteenthNotes" , "TicksPerMinute", "BeatsPerMinute"};

		long msLength = seqTest.getMicrosecondLength();
		songInfo.add("" + msLength);		//songInfo(0) = msLength
		int sLength = (int)msLength / 1000000;
		int mLength = sLength/60;
		int secsInLen = sLength%60;
		songInfo.add("" + mLength);		//songInfo(1) = mLength
		songInfo.add("" + secsInLen); 	//songInfo(2) = secsLength
		
		

		double totLenInSixNotes = (double)(seqTest.getTickLength()/(double)(seqTest.getResolution()/4));		//songInfo(3) = totLenInSixteenth notes
		songInfo.add("" + (int)totLenInSixNotes);

		songInfo.add("" + seqTest.getTickLength());		//songInfo(4) = Ticks in song
		long ticksPerSixteenth = seqTest.getResolution() / 4;
		songInfo.add("" + ticksPerSixteenth);		//songInfo(5) = Ticks per sixteenth note
		double ticksPerMin = (double)seqTest.getTickLength() / (mLength +((float)secsInLen / 60));
		songInfo.add("" + ticksPerMin);		//songInfo(6) = ticksPerMin

		//BPM would be: ((ticks per minute) / (ticks per quarter not))
		songInfo.add("" + ((int)ticksPerMin / (double)seqTest.getResolution()));	//songInfo(7) = BPM

/*This section parses through the tracks (sections of sound) for messages (instances 
 * of sound [ie. NOTE_ON(0x90), NOTE_OFF(0x80)])	
 * It describes the note, key, octave, and velocity
 */
		int trackNumber = 0;
		
		for (Track track : seqTest.getTracks()) {
			trackNumber++;
			if (track.size() > 15){
				for (int i = 0; i<track.size(); i++){
					MidiEvent event = track.get(i);

			//Check where tick is here...put it with its 16th note
					double sixtTick = (double)event.getTick() / (double)ticksPerSixteenth;
						
	//Creates new message in each loop to check if it is a message
					MidiMessage message = event.getMessage();

					if (message instanceof ShortMessage) {
						ShortMessage sm = (ShortMessage) message;
						chanArr.add((int)sm.getChannel());	//Puts the channel number in i
						tickArr.add((int)sixtTick);	//Puts the Location by sixteenth notes in i

	//getData1 is the first byte of the shortmessage, generally note
	//getData2 is the second byte, generally velocity (how loud)

						int key = sm.getData1();
						int octave = (key / 12) - 1;
						int note = key%12;
						String noteName = NOTE_NAMES[note];
						String noctave = "" + noteName + octave;
						long velocity = sm.getData2();
					
						if (sm.getCommand() == NOTE_ON) {
							noteArr.add(""+note);	//puts the note and octave ("E5" etc) into i
							octArr.add("" +octave);
							keyArr.add(""+key);	//puts the key into i
							velArr.add((int)velocity);	//puts the velocity into i	
						} else if (sm.getCommand() == NOTE_OFF) {
							noteArr.add(""+note);	//puts the note and octave into i
							octArr.add(""+octave);
							keyArr.add(""+key);	//puts the key into i
							velArr.add(0);	//puts 0 into i
						} 
					} 
				}
			}

		}
		//Here I am creating the strings to be outputed and storing them in an ArrayList of Strings
		ArrayList<String> toBePrinted = new ArrayList<String>();
		
		String sIn = "";//songInfo initializing the indices 0-7
		String cSt = "";//cString
		String dSt = "";//dString
		String eSt = "";//eString
		String fSt = "";//fString
		String gSt = "";//gString
		String aSt = "";//aString
		String bSt = "";//bString
		
		for (int teq = 0; teq < songInfo.size(); teq++){
			sIn += (songInfo.get(teq) + " ");
		}

		//Because the strings grow at different rates, we need to track them with individual variables
		int cLenStart = 0;
		int cLenEnd = 0;
		int dLenStart = 0;
		int dLenEnd = 0;
		int eLenStart = 0;
		int eLenEnd = 0;
		int fLenStart = 0;
		int fLenEnd = 0;
		int gLenStart = 0;
		int gLenEnd = 0;
		int aLenStart = 0;
		int aLenEnd = 0;
		int bLenStart = 0;
		int bLenEnd = 0;

		for (int ch = 0; ch < chanArr.size(); ch++){
			
			
			if ((ch == (chanArr.size() - 1)) || (chanArr.get(ch) == (chanArr.get(ch + 1)))){
				
				for (int doge = 0; doge < noteArr.size(); doge++){
					//This is where I sort the notes into their strings
					//
					//

					String op = noteArr.get(doge);

					if (op.equals("C") && (velArr.get(doge) != 0)){
						if ((doge > 0) && tickArr.get(doge) == cLenEnd){
							cLenStart = tickArr.get(doge) - 1;
						}
						cLenEnd = tickArr.get(doge);
						for (int l1 = 0; l1 < (cLenEnd - cLenStart);l1++){
							cSt += "-";
						}
						cSt += " " + octArr.get(doge);
						cLenStart = cLenEnd + 1;
					}
					else if (op.equals("C") && (velArr.get(doge) == 0)){
						if ((doge > 0) && tickArr.get(doge) == cLenEnd){
							cLenStart = tickArr.get(doge) - 1;
						}
						cLenEnd = tickArr.get(doge);
						for (int l2 = 0; l2 < (cLenEnd - cLenStart); l2++){
						   cSt += " " + octArr.get(doge);
						}
						cSt += "-";
						cLenStart = cLenEnd + 1;
				 	}		
					else if (op.equals("C#") && (velArr.get(doge) != 0)){
						if ((doge > 0) && tickArr.get(doge) == cLenEnd){
							cLenStart = tickArr.get(doge) - 1;
						}
						cLenEnd = tickArr.get(doge);
						for (int l3 = 0; l3 < (cLenEnd - cLenStart); l3++){
							cSt += "-";
						}
						cSt +=  octArr.get(doge) + "#";
						cLenStart = cLenEnd + 1;
					}
					else if (op.equals("C#") && (velArr.get(doge) == 0)){
						if ((doge > 0) && tickArr.get(doge) == cLenEnd){
							cLenStart = tickArr.get(doge) - 1;
						}
						cLenEnd = tickArr.get(doge);
						for (int l4 = 0; l4 < (cLenEnd - cLenStart); l4++){
							cSt += octArr.get(doge) + "#";
						}
						cSt += "-";
						cLenStart = cLenEnd + 1;
					}
					else if (op.equals("D") && (velArr.get(doge) != 0)){
					    if ((doge > 0) && tickArr.get(doge) == dLenEnd){
							dLenStart = tickArr.get(doge) - 1;
						}	
						dLenEnd = tickArr.get(doge);
						for (int l5 = 0; l5 < (dLenEnd - dLenStart); l5++){
							dSt += "-";
						}
						dSt += " " + octArr.get(doge);
						dLenStart = dLenEnd + 1;
					}
					else if (op.equals("D") && (velArr.get(doge) == 0)){
						if ((doge > 0) && tickArr.get(doge) == dLenEnd){
							dLenStart = dLenEnd - 1;
						}
						dLenEnd = tickArr.get(doge);
						for (int l6 = 0; l6 < (dLenEnd - dLenStart); l6++){
							dSt += " " + octArr.get(doge);
						}
						dSt += "-";
						dLenStart = dLenEnd + 1;
					}
					else if (op.equals("D#") && (velArr.get(doge) != 0)){
						if ((doge > 0) && tickArr.get(doge) == dLenEnd) {
							dLenStart = dLenEnd - 1;
						}
						dLenEnd = tickArr.get(doge);
						for (int l7 = 0; l7 < (dLenEnd - dLenStart); l7++){
							dSt += "-";
						}
						dSt += octArr.get(doge) + "#";
						dLenStart = dLenEnd + 1;
					}
					else if (op.equals("D#") && (velArr.get(doge) == 0)){
						if ((doge > 0) && tickArr.get(doge) == dLenEnd){
							dLenStart = dLenEnd - 1;
						}
						dLenEnd = tickArr.get(doge);
						for (int l8 = 0; l8 < (dLenEnd - dLenStart); l8++){
							dSt += octArr.get(doge) + "#";
						}
						dSt += "-";
						dLenStart = dLenEnd + 1;
					}
					else if (op.equals("E") && (velArr.get(doge) != 0)){
						if ((doge > 0) && tickArr.get(doge) == eLenEnd) {
							eLenStart = eLenEnd - 1;
						}
						eLenEnd = tickArr.get(doge);
						for (int l9 = 0; l9 < (eLenEnd - eLenStart); l9++){
							eSt += "-";
						}
						eSt += " " + octArr.get(doge);
						eLenStart = eLenEnd + 1;
					}
					else if (op.equals("E") && (velArr.get(doge) == 0)){
						if ((doge > 0) && tickArr.get(doge) == eLenEnd) {
							eLenStart = eLenEnd - 1;
						}
						eLenEnd = tickArr.get(doge);
						for (int l10 = 0; l10 < (eLenEnd - eLenStart); l10++){
							eSt += " " + octArr.get(doge);
						}
						eSt += "-";
						eLenStart = eLenEnd + 1;
					}
					else if (op.equals("F") && (velArr.get(doge) != 0)){
						if ((doge > 0) && tickArr.get(doge) == fLenEnd){
							fLenStart = fLenEnd - 1;
						}
						fLenEnd = tickArr.get(doge);
						for (int l11 = 0; l11 < (fLenEnd - fLenStart); l11++){
							fSt += "-";
						}
						fSt += " " + octArr.get(doge);
						fLenStart = fLenEnd + 1;
					}
					else if (op.equals("F") && (velArr.get(doge) == 0)){
						if ((doge > 0) && tickArr.get(doge) == fLenEnd) {
							fLenStart = fLenEnd - 1;
						}
						fLenEnd = tickArr.get(doge);
						for (int l12 = 0; l12 < (fLenEnd - fLenStart); l12++){
							fSt += " " + octArr.get(doge);
						}
						fSt += "-";
						fLenStart = fLenEnd + 1;
					}
					else if (op.equals("F#") && (velArr.get(doge) != 0)){
						if ((doge > 0) && tickArr.get(doge) == fLenEnd){
							fLenStart = fLenEnd - 1;
						}
						fLenEnd = tickArr.get(doge);
						for (int l13 = 0;l13 < (fLenEnd - fLenStart); l13++){
							fSt += "-";
						}
						fSt += octArr.get(doge) + "#";
						fLenStart = fLenEnd + 1;
					}
					else if (op.equals("F#") && (velArr.get(doge) == 0)){
						if ((doge > 0) && tickArr.get(doge) == fLenEnd) {
							fLenStart = fLenEnd - 1;
						}
						fLenEnd = tickArr.get(doge);
						for (int l14 = 0; l14 < (fLenEnd - fLenStart); l14++){
							fSt += octArr.get(doge) + "#";
						}
						fSt += "-";
						fLenStart = fLenEnd + 1;
					}
					else if (op.equals("G") && (velArr.get(doge) != 0)){
						if ((doge > 0) && tickArr.get(doge) == gLenEnd){
							gLenStart = gLenEnd - 1;
						}
						gLenEnd = tickArr.get(doge);
						for (int l15 = 0; l15 < (gLenEnd - gLenStart); l15++){
							gSt += "-";
						}
						gSt += " " + octArr.get(doge);
						gLenStart = gLenEnd + 1;
					}
					else if (op.equals("G") && (velArr.get(doge) == 0)){
						if ((doge > 0) && (tickArr.get(doge) == gLenEnd)){
							gLenStart = gLenEnd - 1;
						}
						gLenEnd = tickArr.get(doge);
						for (int l16 = 0; l16 < (gLenEnd- gLenStart); l16++){
							gSt += " " + octArr.get(doge);
						}
						gSt += "-";
						gLenStart = gLenEnd + 1;
					}
					else if (op.equals("G#") && (velArr.get(doge) != 0)){
						if ((doge > 0) && tickArr.get(doge) == gLenEnd) {
							gLenStart = gLenEnd - 1;
						}
						gLenEnd = tickArr.get(doge);
						for (int l17 = 0; l17 < (gLenEnd - gLenStart); l17++){
							gSt += "-";
						}
						gSt += octArr.get(doge) + "#";
						gLenStart = gLenEnd + 1;
					}
					else if (op.equals("G#") && (velArr.get(doge) == 0)){
						if ((doge > 0) && tickArr.get(doge) == gLenEnd){
							gLenStart = gLenEnd - 1;
						}
						gLenEnd = tickArr.get(doge);
						for (int l18 = 0; l18 < (gLenEnd - gLenStart); l18++){
							gSt += octArr.get(doge) + "#";
						}
						gSt += "-";
						gLenStart = gLenEnd + 1;
					}
					else if (op.equals("A") && (velArr.get(doge) != 0)){
						if ((doge > 0) && tickArr.get(doge) == aLenEnd){
							aLenStart = aLenEnd - 1;
						}
						aLenEnd = tickArr.get(doge);
						for (int l19 = 0; l19 < (aLenEnd - aLenStart); l19++){
							aSt  += "-";
						}
						aSt += " " + octArr.get(doge);
						aLenStart = aLenEnd + 1;
					}
					else if (op.equals("A") && (velArr.get(doge) == 0)){
						if ((doge > 0) && tickArr.get(doge) == aLenEnd){
							aLenStart = aLenEnd - 1;
						}
						aLenEnd = tickArr.get(doge);
						for (int l20 = 0; l20 < (aLenEnd - aLenStart); l20++){
							aSt += " " + octArr.get(doge);
						}
						aSt += "-";
						aLenStart = aLenEnd + 1;
					}
					else if (op.equals("A#") && (velArr.get(doge) != 0)){
						if ((doge > 0) && tickArr.get(doge) == aLenEnd){
							aLenStart = aLenEnd - 1;
						}
						aLenEnd = tickArr.get(doge);
						for (int l21 = 0; l21 < (aLenEnd - aLenStart); l21++){
							aSt += "-";
						}
						aSt += octArr.get(doge) + "#";
						aLenStart = aLenEnd + 1;
					}
					else if (op.equals("A#") && (velArr.get(doge) == 0)){
						if ((doge > 0) && tickArr.get(doge) == aLenEnd){
							aLenStart = aLenEnd - 1;
						}
						aLenEnd = tickArr.get(doge);
						for (int l22 = 0; l22 < (aLenEnd - aLenStart); l22++){
							aSt += octArr.get(doge) + "#";
						}
						aSt += "-";
						aLenStart = aLenEnd + 1;
					}
					else if (op.equals("B") && (velArr.get(doge) != 0)){
						if ((doge > 0) && tickArr.get(doge) == bLenEnd){
							bLenStart = bLenEnd - 1;
						}
						bLenEnd = tickArr.get(doge);
						for (int l23 = 0; l23 < (bLenEnd - bLenStart); l23++){
							bSt += "-";
						}
						bSt += " " + octArr.get(doge);
						bLenStart = bLenEnd - 1;
					}
					else {
						if ((doge > 0) && tickArr.get(doge) == bLenEnd){
							bLenStart = bLenEnd - 1;
						}
						bLenEnd = tickArr.get(doge);
						for (int l24 = 0; l24 < (bLenEnd - bLenStart); l24++){
							bSt += " " + octArr.get(doge);
						}
						bSt += "-";
						bLenStart = bLenEnd + 1;
					}
				}

			}
			else{
				
				String ab =  " New Instrument\n";
				cSt += ab;
				dSt += ab;
				eSt += ab;
				gSt += ab;
				aSt += ab;
				bSt += ab;
				fSt += ab;
				ch++;
			}
			toBePrinted.add(sIn);
			toBePrinted.add(cSt);
			toBePrinted.add(dSt);
			toBePrinted.add(eSt);
			toBePrinted.add(fSt);
			toBePrinted.add(gSt);
			toBePrinted.add(aSt);
			toBePrinted.add(bSt);
		}

		return toBePrinted;	//Have to return each array
	}
}
