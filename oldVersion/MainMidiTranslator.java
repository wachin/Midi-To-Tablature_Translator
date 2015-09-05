import java.util.*;
import javax.sound.midi.*;
import java.io.*;


public class MainMidiTranslator{

	public static void main(String[] args) throws Exception{
		Scanner scan1 = new Scanner(System.in);
		System.out.println("What is the .mid file you would like to translate?");
		String whichMid = scan1.next();
		System.out.println("Which text file do you want to write to? (It will be overwritten if it already exists)\nWriting console will only print the tabs to the command line, no file will be written.");
		String whichFile = scan1.next();

		Sequence seqer = MidiSystem.getSequence(new File(whichMid));
		
		if (whichFile.equals("console") || whichFile.equals("cline")){
			WriteMidiData.writeToCLine(GetMidiData.getMidiData(seqer));
		}
		else {
//			WriteMidiData.writeToTxt(writeToCline(GetMidiData.getMidiData(seqer),whichFile));
		
		//WriteMidiData.writeToTxt(GetMidiData.getMidiData(seqer));
		
	}
}
}
