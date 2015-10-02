module Paths_midi_to_tabs (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/home/zack/Github/Midi-To-Tablature_Translator/.cabal-sandbox/bin"
libdir     = "/home/zack/Github/Midi-To-Tablature_Translator/.cabal-sandbox/lib/x86_64-linux-ghc-7.10.2/midi-to-tabs-0.1.0.0-7nMm4su1SdKIeyNHZ7diD6"
datadir    = "/home/zack/Github/Midi-To-Tablature_Translator/.cabal-sandbox/share/x86_64-linux-ghc-7.10.2/midi-to-tabs-0.1.0.0"
libexecdir = "/home/zack/Github/Midi-To-Tablature_Translator/.cabal-sandbox/libexec"
sysconfdir = "/home/zack/Github/Midi-To-Tablature_Translator/.cabal-sandbox/etc"

getBinDir, getLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "midi_to_tabs_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "midi_to_tabs_libdir") (\_ -> return libdir)
getDataDir = catchIO (getEnv "midi_to_tabs_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "midi_to_tabs_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "midi_to_tabs_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
