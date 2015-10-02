-- Responsible for all the functions that dissect and 
-- reason about the midi file

module MidiParser (parseMidiIntoTemp) where 

import System.IO
import System.Directory(getTemporaryDirectory,removeFile)
import Control.Exception(finally,catch,IOException)
import qualified Sound.MIDI.File as F
import Sound.MIDI.File.Load
import Sound.MIDI.File.Event
import Sound.MIDI.File.Event.Meta
import Sound.MIDI.Message.Channel
import Sound.MIDI.Message.Channel.Voice
import Sound.MIDI.Message.Channel.Mode
import Data.List
import qualified Data.EventList.Relative.TimeBody as EL


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

doParse inFile tempFile tempHandle = do processGeneralInfo inFile tempFile tempHandle 
                                        processDrumsAndGuitars inFile tempFile tempHandle 

getGeneralInfo = undefined

processDrumTracks ds = undefined

processGuitarTracks gs = undefined

{- Functions on finding general information about
 - the MIDI, tempo, title, etc
 -}

tempoToBPM t = round $ msPerMinute `div` t
    where msPerMinute = 60000000

--TODO: how to -> getET (EL.Cons tm bd)   = tm


{- Functions on processing the instrument tracks
 - and recording them into temp files
 -}

processDrumsAndGuitars ts = let drumTracks = getDrumTracks ts
                                guitarTracks = getGuitarTracks ts 
                            in if (null drumTracks) && (null guitarTracks)
                               then error "\tThe .mid file given is malformed, and/or doesn't define instruments\n" ++
                                          "\tThis program will not work with the given MIDI file. Sorry!\n"
                               else do processDrumsTracks drumTracks
                                       processGuitarsTracks guitarTracks

{- Functions on isolating the separate instruments' tracks
 - in order to process them 
 -}

getDrumTracks ts = filter isDrum ts
    where isDrum t = ("Drum" `isInfixOfM` getTrackName t) ||
                     ("Drum" `isInfixOfM` getInstrumentName t) ||
                     ("drum" `isInfixOfM` getTrackName t) ||
                     ("drum" `isInfixOfM` getInstrumentName t)

getGuitarTracks ts = filter isGuitar ts
    where isGuitar t = ("Guitar" `isInfixOfM` getTrackName t) ||
                       ("Guitar" `isInfixOfM` getInstrumentName t) ||
                       ("guitar" `isInfixOfM` getTrackName t) ||
                       ("guitar" `isInfixOfM` getInstrumentName t)

getTrackName t = case EL.getBodies $ EL.filter isTN t of
                    (x:[])  -> Just $ getTN $ fromMeta x
                    _       -> Nothing

getInstrumentName t = case EL.getBodies $ EL.filter isIN t of
                        (x:[])  -> Just $ getIN $ fromMeta x
                        _       -> Nothing

isInfixOfM pat (Just s)     = pat `isInfixOf` s
isInfixOfM pat (Nothing)    = False

isMidi (MIDIEvent e)    = True
isMidi _                = False

isMeta (MetaEvent e)    = True
isMeta _                = False

isTrackName (TrackName s)   = True
isTrackName _               = False

isInstrumentName (InstrumentName s) = True
isInstrumentName _                  = False

isTN e = if isMeta e then isTrackName (fromMeta e) else False

isIN e = if isMeta e then isInstrumentName (fromMeta e) else False

getIN (InstrumentName s)    = s
getIN _                     = error "Not a trackname meta event"

getTN (TrackName s) = s
getTN _             = error "Not a trackname meta event"

fromMeta (MetaEvent e)  = e
fromMeta _              = error "Not a meta event"

