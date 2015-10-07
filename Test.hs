{- 
 - IGNORE THIS FILE..
 - Just being used to test my understanding
 - of the MIDI API
 -}

import System.IO
import qualified Sound.MIDI.File as F
import Sound.MIDI.File.Load
import Sound.MIDI.File.Event
import Sound.MIDI.File.Event.Meta
import Sound.MIDI.Message.Channel
import Sound.MIDI.Message.Channel.Voice
import Sound.MIDI.Message.Channel.Mode
import Data.List
import qualified Data.EventList.Relative.TimeBody as EL

--processGeneralInfo htrk temph = EL.traverse_ (writeTime temph . calcTime) (writeBody temph) htrk 


-- I think I need a way to carry the last calculated time (or accumulate the times) 
-- In order for this to work 
{-
calcTime t 
    | t >= 3600000  = let h = t / 360000 
                          m = in (round t', 
    | t >= 60000    =
    | otherwise     =
                            
                    = 
-}

writeTime han (h,m,s) = do
                        hPutStr han (show h ++ ":" ++ show m ++ ":" ++ show s)

-- This isn't right yet, but it's close
{-
getNoteLength n p   =   let isSameNote  = (== "Note On") || np == p 
                            np          = getNewPitch
                        in  (n, (length . takeWhile (isSameNote)) 

getNewPitch = undefined
-}

--------------Already added-------------------------

-- A setTempo MetaEvent is in MS per quarter note
-- This translates it to BPM
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

handleDrumsAndGuitars ts =  let drumTracks = findDrums ts
                                guitarTracks = findGuitars ts 
                            in  if (null drumTracks) && (null guitarTracks)
                                then error "\tThe .mid file given is malformed, and/or doesn't define instruments\n" ++
                                           "\tThis program will not work with the given MIDI file. Sorry!\n"
                                else do handleDrums drumTracks
                                        handleGuitars guitarTracks

handleDrums ds = undefined

handleGuitars gs = undefined

findDrums ts = filter isDrum ts
    where isDrum t = ("Dru" `isInfixOf'` getTrackName t) ||
                     ("Dru" `isInfixOf'` getInstrumentName t) ||
                     ("dru" `isInfixOf'` getTrackName t) ||
                     ("dru" `isInfixOf'` getInstrumentName t) ||
                     ("Perc" `isInfixOf'` getTrackName t) ||
                     ("Perc" `isInfixOf'` getInstrumentName t) ||
                     ("perc" `isInfixOf'` getTrackName t) ||
                     ("perc" `isInfixOf'` getInstrumentName t) 

findGuitars ts = filter isGuitar ts
    where isGuitar t = ("Guit" `isInfixOf'` getTrackName t) ||
                       ("Guit" `isInfixOf'` getInstrumentName t) ||
                       ("guit" `isInfixOf'` getTrackName t) ||
                       ("guit" `isInfixOf'` getInstrumentName t) ||
                       ("gtr" `isInfixOf'` getTrackName t) ||
                       ("gtr" `isInfixOf'` getInstrumentName t) ||
                       ("Gtr" `isInfixOf'` getTrackName t) ||
                       ("Gtr" `isInfixOf'` getInstrumentName t) 

getTrackName t = case EL.getBodies $ EL.filter isTN t of
                    (x:[])  -> Just $ getTN $ fromMeta x
                    _       -> Nothing

getInstrumentName t = case EL.getBodies $ EL.filter isIN t of
                        (x:[])  -> Just $ getIN $ fromMeta x
                        _       -> Nothing

isInfixOf' pat (Just s)     = pat `isInfixOf` s
isInfixOf' pat (Nothing)    = False


--getET (EL.Cons tm bd)   = tm


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

f = "samples/SearchAndDestroy.mid"
l = "samples/Loser.mid"
d = "samples/1dru2gui.mid"
d' = "samples/rooster.mid"
d'' = "samples/zombie.mid"
f' = "samples/Hakuna_Matata.mid"

dis = do
    bigT   <- fromFile f'
    return (F.getTracks bigT)

dg = do
    bigT   <- fromFile d
    return (F.getTracks bigT)

roo = do
    bigT   <- fromFile d'
    return (F.getTracks bigT)

zom = do
    bigT   <- fromFile d''
    return (F.getTracks bigT)

sad = do
    bigT   <- fromFile f 
    return (F.getTracks bigT)

los = do 
    bigT   <- fromFile l
    return (F.getTracks bigT)
