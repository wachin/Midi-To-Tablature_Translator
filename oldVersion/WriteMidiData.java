import java.io.*;
import java.util.*;

public class WriteMidiData{
	public static final String[] DRUM_NAMES = {"HH", "S ", "B ", "T1", "T2","C1"};
	public static final String[] NOTE_NAMES = {"C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"};
	/*FOR REFERENCE:
	 * gotArr[0] = sonInfo
	 * gotArr[1] = cString
	 * gotArr[2] = dString
	 * gotArr[3] = eString
	 * gotArr[4] = fString
	 * gotArr[5] = gString
	 * gotArr[6] = aString
	 * gotArr[7] = bString
	 */



	/*This write sends it directly to the command line...
	 * mostly for testing
	 */

	public static String writeToCLine(ArrayList<String> gotArr){
		
		String[] infoLegend = {"MicrosecondLength", "MinutesInSong", "SecondsInSong", "TotalSixteenthNotes", "TotalTicksInSong", "TicksPerSixteenthNote", "TicksPerMinute", "BeatsPerMinute"};
		String[] cString = gotArr.get(1).split("");
		String[] dString = gotArr.get(2).split("");
		String[] eString = gotArr.get(3).split("");
		String[] fString = gotArr.get(4).split("");
		String[] gString = gotArr.get(5).split("");
		String[] aString = gotArr.get(6).split("");
		String[] bString = gotArr.get(7).split("");
		String toWrite = "";

		int tempHold = 0;
		int tempSet = 0;

		//Prints out the song info at the beginning of the tabs
		String[] sonSplit = gotArr.get(0).split(" ");

		for (int i =0; i<sonSplit.length; i++){
			System.out.print(infoLegend[i] + ": ");
			System.out.println(sonSplit[i]);
		}
		
		//Prints out the rest of the song in 104 unit long lines
		boolean tator = true;
		while (tator == true){

			if ((tempHold + 104) < cString.length){
				System.out.print("C: ");
				toWrite += "C: ";
				for (int kk = 0; kk < (tempHold + 104); kk++){
					System.out.print(cString[kk]);
					toWrite += cString[kk];}
				System.out.println();
				toWrite += "\n";
				System.out.print("D: ");
				toWrite += "D: ";
				for (int jj = 0; jj < (tempHold + 104); jj++){
					System.out.print(dString[jj]);
					toWrite += dString[jj];}
				System.out.println();
				toWrite += "\n";
				System.out.print("E: ");
				toWrite += "E: ";
				for (int ll = 0; ll < (tempHold + 104); ll++){
					System.out.print(eString[ll]);
					toWrite += eString[ll];}
				System.out.println();
				toWrite += "\n";
				System.out.print("F: ");
				toWrite += "F: ";
				for (int mm = 0; mm < (tempHold + 104); mm++){
					System.out.print(fString[mm]);
					toWrite += fString[mm];}
				System.out.println();
				toWrite += "\n";
				System.out.print("G: ");
				toWrite += "G: ";
				for (int nn = 0; nn < (tempHold + 104); nn++){
					System.out.print(gString[nn]);
					toWrite += gString[nn];}
				System.out.println();
				toWrite += "\n";
				System.out.print("A: ");
				toWrite += "A: ";
				for (int bb = 0; bb < (tempHold + 104); bb++){
					System.out.print(aString[bb]);
					toWrite += aString[bb];}
				System.out.println();
				toWrite += "\n";
				System.out.print("B: ");
				toWrite += "B: ";
				for (int vv = 0; vv < (tempHold + 104); vv++){
					System.out.print(bString[vv]);
					toWrite += bString[vv];}
				System.out.println();
				toWrite += "\n";
				System.out.println();
				toWrite += "\n";
				tempHold += 104;

			}
			else {
				tempSet = cString.length - tempHold;
				System.out.print("C: ");
				toWrite += "C: ";
				for (int k = 0; k < tempSet; k++){
					System.out.print(cString[k]);
					toWrite += cString[k];}
				System.out.println();
				toWrite += "\n";
				System.out.print("D: ");
				toWrite += "D: ";
				for (int j = 0; j < tempSet; j++){
					System.out.print(dString[j]);
					toWrite += dString[j];}
				System.out.println();
				toWrite += "\n";
				System.out.print("E: ");
				toWrite += "E: ";
				for (int l = 0; l < tempSet; l++){
					System.out.print(eString[l]);
					toWrite += eString[l];}
				System.out.println();
				toWrite += "\n";
				System.out.print("F: ");
				toWrite += "F: ";
				for (int m = 0; m < tempSet; m++){
					System.out.print(fString[m]);
					toWrite += fString[m];}
				System.out.println();
				toWrite += "\n";
				System.out.print("G: ");
				toWrite += "G: ";
				for (int n = 0; n < tempSet; n++){
					System.out.print(gString[n]);
					toWrite += gString[n];}
				System.out.println();
				toWrite += "\n";
				System.out.print("A: ");
				toWrite += "A: ";
				for (int b = 0; b < tempSet; b++){
					System.out.print(aString[b]);
					toWrite += aString[b];}
				System.out.println();
				toWrite += "\n";
				System.out.print("B: ");
				toWrite += "B: ";
				for (int v = 0; v < tempSet; v++){
					System.out.print(bString[v]);
					toWrite += bString[v];}
				System.out.println();
				toWrite += "\n";
				System.out.println();
				toWrite += "\n";
				tempHold = cString.length;
			}
			
			if (tempHold == cString.length){
				tator = false;
				break;
			}

			
		}
		return toWrite;
/*How to print grids with nested loops
 * 		String[][] lines = new String[6][104];
		for (int k = 0; k < 6; k++){

			for (int i = 0; i<6; i++){;
				System.out.print(Drum[i] + " ");
				for (int j = 0; j<104; j++){
					lines[i][j] = "-";
					System.out.print(lines[i][j]);
				}
				System.out.println();
			}
			System.out.println();
		}

	
	/*This sends to a text file
	 

	public static void writeToTxt(String toWrite, String whichFile) throws Exception{
		try {
			BufferedWriter out = new BufferedWriter(new FileWriter(whichFile));
	
			out.write(toWrite);
			out.close();
	
			System.out.println("File written!");
		} catch (IOException e) {}
		
	}*/
}
}
