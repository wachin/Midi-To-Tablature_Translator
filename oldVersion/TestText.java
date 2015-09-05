import java.io.*;

public class TestText {
	public static void main(String[] args){
		try {
			BufferedWriter out = new BufferedWriter(new FileWriter("testfile.txt"));
			for (int i = 0; i<4; i++) {
				out.write("test " + "\n");
			}
			out.close();
		} catch(IOException e) {}
	}
}
