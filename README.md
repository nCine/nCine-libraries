[![Linux](https://github.com/nCine/nCine-libraries/workflows/Linux/badge.svg)](https://github.com/nCine/nCine-libraries/actions?workflow=Linux)
[![macOS](https://github.com/nCine/nCine-libraries/workflows/macOS/badge.svg)](https://github.com/nCine/nCine-libraries/actions?workflow=macOS)
[![Windows](https://github.com/nCine/nCine-libraries/workflows/Windows/badge.svg)](https://github.com/nCine/nCine-libraries/actions?workflow=Windows)
[![MinGW](https://github.com/nCine/nCine-libraries/workflows/MinGW/badge.svg)](https://github.com/nCine/nCine-libraries/actions?workflow=MinGW)
[![Emscripten](https://github.com/nCine/nCine-libraries/workflows/Emscripten/badge.svg)](https://github.com/nCine/nCine-libraries/actions?workflow=Emscripten)

# nCine-libraries
CMake scripts to build nCine dependency libraries for MSVC and OS X

## Information
This repository contains the scripts to easily compile the libraries needed by the nCine when building on Windows using MSVC or when building frameworks on OS X.

### Libraries
- libwebp
- zlib
- libpng
- GLEW
- GLFW
- SDL2
- libogg
- libvorbis
- OpenAL-soft
- Lua

## Build
To compile the libraries on Windows:

```
"%programfiles%/CMake/bin/cmake.exe" -HnCine-libraries -BnCine-libraries-build
```

To compile the libraries on OS X:

```
/Applications/CMake/Contents/bin/cmake -HnCine-libraries -BnCine-libraries-build
```
