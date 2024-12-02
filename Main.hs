import MidiParser
import NotationWriter
import System.Environment

main :: IO ()
main = do
    args <- getArgs
    if length args /= 2
        then putStrLn "Uso: midi-to-tabs <archivo MIDI> <archivo de salida>"
        else do
            let inFile = head args
            let outFile = args !! 1
            result <- parseMidiFile inFile
            case result of
                Left err -> putStrLn $ "Error al procesar el archivo MIDI: " ++ err
                Right tab -> writeFile outFile tab >> putStrLn "Tablatura generada exitosamente."

