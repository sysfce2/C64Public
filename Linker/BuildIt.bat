rem Run tests
java -DZbdd6502.trace=true -jar ..\..\BDD6502\target\BDD6502-1.0.9-SNAPSHOT-jar-with-dependencies.jar --monochrome --plugin pretty --plugin html:target/cucumber --plugin json:target/report1.json --glue macros --glue TestGlue features
IF ERRORLEVEL 1 goto error

rem Remove outputs
del /q bin\Linker.prg bin\Linker.cmp.prg

rem Copy our main example chunks files
copy /y ChunkData.a _ChunkData.a
copy /y Chunks.a _Chunks.a

rem Assemble the linked code and data
..\acme.exe --lib ..\ -v4 --msvc Linker.a

if not exist bin\Linker.prg goto error

rem ... and compress the result
..\bin\LZMPi.exe -c64mbu bin\Linker.prg bin\Linker.cmp.prg 2061

goto end
:error

echo Error!
exit -1
:end
