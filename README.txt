Current state of the project (4/4/15):
BROKEN - was in the middle of refactoring a few months ago

I should rewrite this from scratch using the c++ midi library..might work a bit better.




For now I would run it strictly out of the command line (I've had problems porting it over to eclipse or some other IDE)

1) Make sure the GetMidiData.class/WriteMidiData.class/MainMidiTranslator.class are in the same directory
2) Make sure your .mid file is also in this directory
3) Run MainMidiTranslator.class and give it the name of the .mid file (i.e. sample.mid)
4) When prompted for the file to write the tabs to write console for now (this will print it to the command line)
  -Soon you should be able to give it a file name (i.e. sample.txt) and it will write it into the file.

5) Thank you for trying out my midi translator!

6) Soon to come:
	-mp3 and .flac translations
	-To-file support
	-web-page support



