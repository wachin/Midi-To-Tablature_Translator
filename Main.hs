-- Entry point for Midi-To-Tablature executable

import MidiParser
import NotationRuler

main = do processArguments  -- Can do that in here
        . getGeneralInfo    -- in MidiParser
        . getDrumTrack      -- in MidiParser
        . processDrumTrack  -- in MidiParser
        . outputNotation    -- in NotationRuler




