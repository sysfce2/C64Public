A simple linker to facilitate the copying of data to various memory locations and with various processor port options. Configurable data and code chunks are executed entirely from the stack area.
Generally it is a good idea to specifiy data to be copied into colour RAM or IO space first, so it can be copied from the start of BASIC RAM, then specify data to be placed under colour/IO/ROMs.

Assemble the example display screen code: ..\acme.exe --lib ..\ -v4 --msvc DisplayScreen.a

The linker data and configuration are stored in files "_ChunkData.a" and "_Chunks.a"
These can be edited directly, or updated via the command line tool Python.py
For example: Linker.py -pp ProcessorPortDefault -b COLOURRAM ../CharPack/colours.bin -sa VIC2BorderColour VIC2Colour_White -b $800 bin\DisplayScreen.prg 2 -b "VIC2_Bank3 + VIC2MemorySetup_CharsSize" ../CharPack/screen.bin -b VIC2_Bank3 ../CharPack/chars.bin -pp ProcessorPortAllRAMWithIO -sr $800

The linked data can be assembled with: ..\acme.exe --lib ..\ -v4 --msvc Linker.a
The output "Linker.prg" can then be compressed, for example: ..\bin\LZMPi.exe -c64mbu bin\Linker.prg bin\Linker.cmp.prg 2061

