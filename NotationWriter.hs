-- Responsible for writing the notation
-- that has been formatted, to the text file.

module NotationWriter (outputNotation) where

import System.IO

outputNotation outFile tempFile = do 
    outh <- openFile outFile AppendMode
    hClose outh

