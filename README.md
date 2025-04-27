[![Linux](https://github.com/nCine/nCine-libraries/workflows/Linux/badge.svg)](https://github.com/nCine/nCine-libraries/actions?workflow=Linux)
[![macOS](https://github.com/nCine/nCine-libraries/workflows/macOS/badge.svg)](https://github.com/nCine/nCine-libraries/actions?workflow=macOS)
[![Windows](https://github.com/nCine/nCine-libraries/workflows/Windows/badge.svg)](https://github.com/nCine/nCine-libraries/actions?workflow=Windows)
[![MinGW](https://github.com/nCine/nCine-libraries/workflows/MinGW/badge.svg)](https://github.com/nCine/nCine-libraries/actions?workflow=MinGW)
[![Emscripten](https://github.com/nCine/nCine-libraries/workflows/Emscripten/badge.svg)](https://github.com/nCine/nCine-libraries/actions?workflow=Emscripten)

# nCine-libraries

CMake scripts to build nCine dependency libraries for Linux, macOS, MSVC, MinGW, and Emscripten.

## Information

This repository contains the scripts to easily compile the libraries needed by the nCine on all supported platforms (except for Android).

It also contains some additional libraries that can optionally be used in nCine projects.

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
- Box2D
- libcurl

## Build

To compile the libraries on Windows:

```bash
"%programfiles%/CMake/bin/cmake.exe" -S nCine-libraries -B nCine-libraries-build
```

To compile the libraries on macOS:

```bash
/Applications/CMake/Contents/bin/cmake -S nCine-libraries -B nCine-libraries-build
```
