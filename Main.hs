-- Entry point for Midi-To-Tablature executable

import MidiParser
import NotationFormatter
import NotationWriter

main = do 
    (inF,outF) <- processArguments      -- Can do that in here
    maybeTempF <- parseMidiIntoTemp inf -- in MidiParser
    formatData maybeTempF               -- in NotationFormatter
    outputNotation                      -- in NotationWriter




