import Sound.MIDI.File
import Sound.MIDI.File.Load

f = "samples/SearchAndDestroy.mid"

main = do
    bigT   <- fromFile f
    return $ getET $ head $ drop 1 $ getTracks bigT


getTPQN (Cons _ d _)   = fromTempo $ ticksPerQuarterNote d

getET (t et t')     = fromElapsedTime et

-- This isn't right yet, but it's close
{-
getNoteLength n p   =   let isSameNote  = (== "Note On") || np == p 
                            np          = getNewPitch
                        in  (n, (length . takeWhile (isSameNote)) 

getNewPitch = undefined
-}
