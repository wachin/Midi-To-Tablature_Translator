-- Responsible for writing the notation
-- that has been formatted, to the text file.

import System.IO


outputNotation outF = do 
    outh <- openFile outF AppendMode
    
    hClose outh

