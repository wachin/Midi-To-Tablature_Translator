import javax.sound.midi.*;
import java.io.*;

public class TestSoundMidiLib{
	
	public static void main(String[] args) throws Exception{

		File tester = new File("samples/test.mid");
		Sequence sequence = MidiSystem.getSequence(tester);
		
		
		
		Sequencer singer = MidiSystem.getSequencer();
		//if (singer == null) {
		//	System.out.println("Sequencer is not support!");}
		//else {
		//	singer.open(); }
		
		//singer.setSequence(sequence);
		
	
		for (MidiDevice.Info info : MidiDevice.getDeviceInfo()){
			System.out.println(info); }


		//System.out.println(MidiDevice.getDeviceInfo());

		System.out.println("getMidiDeviceInfo():");
		

		//System.out.println("getMidiFileFormat(File file):");
		//System.out.println(MidiSystem.getMidiFileFormat(tester));

		//Cannot get SoundBank from Stream
		//System.out.println("getSoundBank(File file):");
		//System.out.println(MidiSystem.getSoundbank(tester));

//		Sequencer.setMasterSyncMode(singer.SyncMode);
		//System.out.println("SyncMode Set");
/*		
		System.out.println("getMicrosecondLength");
		long msLength = sequence.getMicrosecondLength();
		System.out.println(msLength);
		long sLength = msLength / 1000000;
		System.out.println("Stream is " + sLength + " seconds long!");
		float mLength = (float)sLength / 60;
		System.out.println("Stream is " + mLength + " minutes long!");

		float bpmTempo = singer.getTempoInBPM();
		System.out.println("Tempo in BPM: " + bpmTempo);
		float tempFact = singer.getTempoFactor();
		System.out.println("Tempo Factor is: " + tempFact);
		float mpqTempo = singer.getTempoInMPQ();
		System.out.println("Tempo in Microseconds per quarternotr: " + mpqTempo);
		

		System.out.println("start()");
		
		//seq2.start();
*/
	}
}
