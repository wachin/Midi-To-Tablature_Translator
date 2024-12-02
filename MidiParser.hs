module MidiParser (parseMidiFile) where

import qualified Sound.MIDI.File as MIDI
import qualified Sound.MIDI.File.Event as Event
import qualified Data.EventList.Relative.TimeBody as EventList
import Data.Maybe (catMaybes)
import Data.List (intercalate)

-- Mapea notas MIDI a instrumentos de batería
noteToInstrument :: Int -> Maybe String
noteToInstrument note = case note of
    35 -> Just "KickDrum: o"
    36 -> Just "KickDrum: o"
    38 -> Just "Snare: o"
    42 -> Just "HiHat: x"
    49 -> Just "Cymbal: x"
    _  -> Nothing

-- Parsea un archivo MIDI y retorna la tablatura
parseMidiFile :: FilePath -> IO (Either String String)
parseMidiFile path = do
    midiFile <- MIDI.load path
    let tracks = MIDI.tracks $ MIDI.toFile midiFile
    case filter isDrumTrack tracks of
        [] -> return $ Left "No se encontró una pista de batería."
        (drumTrack:_) -> return $ Right (processDrumTrack drumTrack)

-- Verifica si la pista contiene eventos de la batería (canal 10 en MIDI)
isDrumTrack :: MIDI.Track Event.T -> Bool
isDrumTrack = any isDrumEvent
  where
    isDrumEvent event = case Event.body event of
        Event.MIDIEvent (Event.ChannelEvent (Event.VoiceEvent _ (Event.NoteOn note _))) ->
            noteToInstrument note /= Nothing
        _ -> False

-- Procesa la pista de batería y genera la tablatura
processDrumTrack :: MIDI.Track Event.T -> String
processDrumTrack track = 
    let events = EventList.toPairList $ MIDI.events track
        drumEvents = catMaybes $ map extractDrumEvent events
    in formatTab drumEvents

-- Extrae eventos de batería relevantes
extractDrumEvent :: (Int, Event.T) -> Maybe (Int, String)
extractDrumEvent (time, event) = case Event.body event of
    Event.MIDIEvent (Event.ChannelEvent (Event.VoiceEvent _ (Event.NoteOn note _))) ->
        case noteToInstrument note of
            Just inst -> Just (time, inst)
            Nothing -> Nothing
    _ -> Nothing

-- Formatea la salida de la tablatura
formatTab :: [(Int, String)] -> String
formatTab events = intercalate "\n" $ map formatLine groupedEvents
  where
    groupedEvents = groupByInstrument events
    formatLine (instrument, hits) = instrument ++ ": " ++ concatMap showHit hits

    showHit time = if time `mod` 480 == 0 then "o" else "-"
