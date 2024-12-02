
# Congiure
- Debian 12 with GHC and Cabal.

Install

```
sudo apt update
sudo apt install ghc cabal-install
```

see:

```
ghc --version
cabal --version
```

then
```
cabal update
cabal build
```



Fail to build:

```
$ cabal build
Build profile: -w ghc-9.0.2 -O1
In order, the following will be built (use -v for more details):
 - midi-to-tabs-0.1.0.0 (exe:midi-to-tabs) (first run)
Preprocessing executable 'midi-to-tabs' for midi-to-tabs-0.1.0.0..
Building executable 'midi-to-tabs' for midi-to-tabs-0.1.0.0..
[1 of 3] Compiling MidiParser       ( MidiParser.hs, /home/wachin/Dev-Wid-Forks/Midi-To-Tablature_Translator/dist-newstyle/build/x86_64-linux/ghc-9.0.2/midi-to-tabs-0.1.0.0/x/midi-to-tabs/build/midi-to-tabs/midi-to-tabs-tmp/MidiParser.o )

MidiParser.hs:27:26: error:
    Not in scope: ‘MIDI.tracks’
    Perhaps you meant one of these:
      data constructor ‘MIDI.Ticks’ (imported from Sound.MIDI.File),
      ‘MIDI.getTracks’ (imported from Sound.MIDI.File)
    Neither ‘Sound.MIDI.File’ nor ‘Sound.MIDI.File.Load’ exports ‘tracks’.
   |
27 |             let tracks = MIDI.tracks midi
   |                          ^^^^^^^^^^^

```

to probe in the future when work:

cabal run midi-to-tabs garden.mid salida.txt
