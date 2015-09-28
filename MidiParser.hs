-- Responsible for all the functions that dissect and 
-- reason about the midi file

module MidiParser (parseMidiIntoTemp, getGeneralInfo, getDrumTracks
                  , processDrumTracks, getGuitarTracks, processGuitarTracks, getTPQN) where

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

doParse inFile tempFile tempHandle = undefined --getGeneralInfo . getDrumTracks . processDrumTracks

getGeneralInfo = undefined

processDrumTracks = undefined

processGuitarTracks = undefined

{- Functions on finding general information about
 - the MIDI, tempo, title, etc
 -}

getTPQN (F.Cons _ d@(F.Ticks t) _)   = F.fromTempo $ F.ticksPerQuarterNote d
--TODO: figure out wat SMPTE getTPQN (F.Cons _ (F.SMPTE d d') _)   = 

--TODO: how to -> getET (EL.Cons tm bd)   = tm



{- Functions on isolating the separate instruments' tracks
 - in order to process them individually into their temp files 
 -}

getDrumTracks ts = filter isDrum ts
    where isDrum t = ("Drum" `isInfixOf'` getTrackName t) ||
                     ("Drum" `isInfixOf'` getInstrumentName t) ||
                     ("drum" `isInfixOf'` getTrackName t) ||
                     ("drum" `isInfixOf'` getInstrumentName t)

getGuitarTracks ts = filter isGuitar ts
    where isGuitar t = ("Guitar" `isInfixOf'` getTrackName t) ||
                       ("Guitar" `isInfixOf'` getInstrumentName t) ||
                       ("guitar" `isInfixOf'` getTrackName t) ||
                       ("guitar" `isInfixOf'` getInstrumentName t)

getTrackName t = case EL.getBodies $ EL.filter isTN t of
                    (x:[])  -> Just $ getTN $ fromMeta x
                    _       -> Nothing

getInstrumentName t = case EL.getBodies $ EL.filter isIN t of
                        (x:[])  -> Just $ getIN $ fromMeta x
                        _       -> Nothing

isInfixOf' pat (Just s)     = pat `isInfixOf` s
isInfixOf' pat (Nothing)    = False

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

