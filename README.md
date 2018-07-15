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
