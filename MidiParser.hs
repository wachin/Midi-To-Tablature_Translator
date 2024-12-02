module MidiParser (parseMidiFile) where

import qualified Sound.MIDI.File as MIDI
import qualified Sound.MIDI.File.Load as MIDI
import qualified Sound.MIDI.Message as Message
import qualified Sound.MIDI.Message.Channel as Channel
import qualified Sound.MIDI.Message.Channel.Voice as Voice
import Data.Maybe (mapMaybe)

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
    result <- MIDI.fromFile path
    case result of
        Left err -> return $ Left ("Error al cargar el archivo MIDI: " ++ show err)
        Right midi ->
            let tracks = MIDI.tracks midi
                drumTrack = findDrumTrack tracks
            in case drumTrack of
                Nothing -> return $ Left "No se encontró una pista de batería."
                Just track -> return $ Right (processDrumTrack track)

-- Encuentra la pista de batería (canal 10 en MIDI)
findDrumTrack :: [MIDI.Track Message.T] -> Maybe (MIDI.Track Message.T)
findDrumTrack = find isDrumTrack

isDrumTrack :: MIDI.Track Message.T -> Bool
isDrumTrack = any isDrumEvent

isDrumEvent :: Message.T -> Bool
isDrumEvent (Message.Channel (Channel.Voice (Voice.NoteOn _ _))) = True
isDrumEvent _ = False

-- Procesa la pista de batería y genera la tablatura
processDrumTrack :: MIDI.Track Message.T -> String
processDrumTrack track =
    let drumEvents = mapMaybe extractDrumEvent track
    in formatTab drumEvents

-- Extrae eventos de batería relevantes
extractDrumEvent :: Message.T -> Maybe String
extractDrumEvent (Message.Channel (Channel.Voice (Voice.NoteOn pitch _))) =
    noteToInstrument pitch
extractDrumEvent _ = Nothing

-- Formatea la salida de la tablatura
formatTab :: [String] -> String
formatTab events = unlines events
