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

f = "samples/SearchAndDestroy.mid"

main = do
    bigT   <- fromFile f 
 --   putStrLn "There are " ++ (show length ts) ++ "tracks in the song\n"
--    ds <- findDrums ts []
--    return (head ds)
    return (F.getTracks bigT)


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

getTPQN (F.Cons _ d@(F.Ticks t) _)   = F.fromTempo $ F.ticksPerQuarterNote d
--getTPQN (F.Cons _ (F.SMPTE d d') _)   = 

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

--Probably don't need
mapTrack :: (F.Track -> F.Track) -> F.T -> F.T
mapTrack f (F.Cons mfType division tracks) =
   F.Cons mfType division (map f tracks)

--getT 

-- This isn't right yet, but it's close
{-
getNoteLength n p   =   let isSameNote  = (== "Note On") || np == p 
                            np          = getNewPitch
                        in  (n, (length . takeWhile (isSameNote)) 

getNewPitch = undefined
-}
