-- Responsible for all the functions that dissect and 
-- reason about the midi file

import System.IO
import System.Directory(getTemporaryDirectory,removeFile)
import System.IO.Error(catch)
import Control.Exception(finally)

parseMidiIntoTemp = do
    tempDir <- catch (getTemporaryDirectory) (\_ -> return ".")
    (tempf,temph) <- openTempFile "tempMidiInfo"
    finally (getGeneralInfo . getDrumTrack . processDrumTrack) 
            (do hClose temph
                removeFile tempf)

getGeneralInfo = undefined

getDrumTrack = undefined

processDrumTrack = undefined
