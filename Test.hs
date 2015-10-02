{- 
 - IGNORE THIS FILE..
 - Just being used to test my understanding
 - of the MIDI API
 -}


import qualified Sound.MIDI.File as F
import Sound.MIDI.File.Load
import Sound.MIDI.File.Event
import Sound.MIDI.File.Event.Meta
import Sound.MIDI.Message.Channel
import Sound.MIDI.Message.Channel.Voice
import Sound.MIDI.Message.Channel.Mode
import Data.List
import qualified Data.EventList.Relative.TimeBody as EL
import Control.Exception

f = "samples/SearchAndDestroy.mid"
l = "samples/Loser.mid"

sad = do
    bigT   <- fromFile f 
    return (bigT)

loser = do 
    bigT   <- fromFile l
    return bigT

-- A setTempo MetaEvent is in MS per quarter note
-- This translates it to BPM
tempoToBPM t = round $ msPerMinute `div` t
    where msPerMinute = 60000000


handleDrumsAndGuitars ts =  let drumTracks = findDrums ts
                                guitarTracks = findGuitars ts 
                            in  if (null drumTracks) && (null guitarTracks)
                                then error "\tThe .mid file given is malformed, and/or doesn't define instruments\n" ++
                                           "\tThis program will not work with the given MIDI file. Sorry!\n"
                                else do handleDrums drumTracks
                                        handleGuitars guitarTracks

handleDrums ds = undefined

handleGuitars gs = undefined

hasMidi t = case EL.getBodies $ EL.filter isMidi t of
                []  -> False
                _   -> True

--------------Already added-------------------------

findDrums ts = filter isDrum ts
    where isDrum t = ("Drum" `isInfixOf'` getTrackName t) ||
                     ("Drum" `isInfixOf'` getInstrumentName t) ||
                     ("drum" `isInfixOf'` getTrackName t) ||
                     ("drum" `isInfixOf'` getInstrumentName t)

findGuitars ts = filter isGuitar ts
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


-- This isn't right yet, but it's close
{-
getNoteLength n p   =   let isSameNote  = (== "Note On") || np == p 
                            np          = getNewPitch
                        in  (n, (length . takeWhile (isSameNote)) 

getNewPitch = undefined
-}
