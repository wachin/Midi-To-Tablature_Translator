-- Entry point for Midi-To-Tablature executable

import MidiParser
import NotationWriter
import System.Environment

main = do 
    (inFile,outFile) <- processArguments    -- Can do that in here
    tempFile <- parseMidiIntoTemp inFile    -- in MidiParser
    outputNotation tempFile outFile         -- in NotationWriter

-- processArguments is hardcoded to check for 2 arguments
-- from stdin
processArguments = do 
    args <- getArgs
    let isCorrectLength xs = length xs == 2 in
        if isCorrectLength args 
        then let h = head args
                 s = head $ tail args in
                    return (h,s)
        else error ("\n ----- Incorrect Argument Format for MidiTranslator -----\n" ++
                   "Arguments must be of the form:\n\n" ++
                   "\t.\\midi-to-tabs path\\to\\midi-file path\\to\\desired\\output-file\n\n" ++
                   "Note: If the output file exists, it will be deleted.\n\n")

