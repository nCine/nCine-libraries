# nCine-libraries
CMake scripts to build nCine dependency libraries for MSVC

## Information
This repository contains the scripts to easily compile the libraries needed by the nCine when building on Windows using MSVC.

### Libraries
- libwebp
- zlib
- libpng
- GLEW
- GLFW
- libogg
- libvorbis
- OpenAL-soft

## Build
To compile the libraries:

```
"%programfiles%/CMake/bin/cmake.exe" -H. -B../nCine-libraries-build
```
