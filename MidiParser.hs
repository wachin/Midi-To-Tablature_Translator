-- Responsible for all the functions that dissect and 
-- reason about the midi file

module MidiParser (parseMidiIntoTemp, getGeneralInfo, getDrumTrack
                  , processDrumTrack, getTPQN) where

import System.IO
import System.Directory(getTemporaryDirectory,removeFile)
import Control.Exception(finally,catch,IOException)
import Sound.MIDI.File
import Sound.MIDI.File.Load

parseMidiIntoTemp inFile = do
    tempDir <- catch (getTemporaryDirectory) 
                     (\e -> do
                        let _ = e :: IOException
                        return ".")
    (tempFile,tempHandle) <- openTempFile tempDir "tempMidiInfo.txt"
    finally (doParse inFile tempFile tempHandle)
            (do hClose tempHandle
                removeFile tempFile
                return ())

doParse inFile tempFile tempHandle = undefined --getGeneralInfo . getDrumTrack . processDrumTrack

getGeneralInfo = undefined

getDrumTrack = undefined

processDrumTrack = undefined

getTPQN (Cons _ d _)   = fromTempo $ ticksPerQuarterNote d

--getET (t et t')     = fromElapsedTime et

