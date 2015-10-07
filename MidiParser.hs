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

getUniqueVelocities trk = nub $ getVelocities trk

getVelocities trk = map (fromVelocity . fromNoteOnEventGetVelocity) nes
    where nes = EL.getBodies $ EL.filter fromEventIsNoteOn trk

getUniquePitches trk = nub $ getPitches trk

getPitches trk = map (fromPitch . fromNoteOnEventGetPitch) nes
    where nes = EL.getBodies $ EL.filter fromEventIsNoteOn trk

hasMidi t = case EL.getBodies $ EL.filter isMidi t of
                []  -> False
                _   -> True

getMidiMessageBody (MIDIEvent (Cons c b)) = b
getMidiMessageBody _          = error "given malformed MIDI message"

isVoice (Voice _) = True
isVoice _         = False

getVoiceMessage (Voice m) = m
getVoiceMessage _         = error "not a voice message"

fromEventIsNoteOn e = if (isMidi e) && (isVoice $ v) then isNoteOn n else False
    where v = getMidiMessageBody e
          n = getVoiceMessage v  

fromNoteOnEventGetPitch (MIDIEvent (Cons c (Voice (NoteOn p v)))) = p

fromNoteOnEventGetVelocity (MIDIEvent (Cons c (Voice (NoteOn p v)))) = v

isMode (Mode _) = True
isMode _        = False

getModeMessage (Mode m) = m
getModeMessage _        = error "not a mode message"


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
    where isDrum t = ("Dru" `isInfixOfM` getTrackName t) ||
                     ("Dru" `isInfixOfM` getInstrumentName t) ||
                     ("dru" `isInfixOfM` getTrackName t) ||
                     ("dru" `isInfixOfM` getInstrumentName t) ||
                     ("Perc" `isInfixOf'` getTrackName t) ||
                     ("Perc" `isInfixOf'` getInstrumentName t) ||
                     ("perc" `isInfixOf'` getTrackName t) ||
                     ("perc" `isInfixOf'` getInstrumentName t) 

getGuitarTracks ts = filter isGuitar ts
    where isGuitar t = ("Guit" `isInfixOfM` getTrackName t) ||
                       ("Guit" `isInfixOfM` getInstrumentName t) ||
                       ("guit" `isInfixOfM` getTrackName t) ||
                       ("guit" `isInfixOfM` getInstrumentName t) ||
                       ("gtr" `isInfixOfM` getTrackName t) ||
                       ("gtr" `isInfixOfM` getInstrumentName t) ||
                       ("Gtr" `isInfixOfM` getTrackName t) ||
                       ("Gtr" `isInfixOfM` getInstrumentName t) 

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

