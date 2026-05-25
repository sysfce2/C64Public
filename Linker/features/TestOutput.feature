Feature: Test output of linker options

  This tests linker options output

  Scenario: Test options 1
    Given a Commodore 64
    And I create file "_ChunkData.a" with
    """
    ExactPage
    !fill 256,3
    ExactPageEnd
    ExactPage2
    !fill 256,1
    !fill 256,2
    ExactPage2End
    SmallData
    !by 10,11,12,13,14,15,16,17,18,19,20
    SmallDataEnd
    """
    And I create file "_Chunks.a" with
    """
    +MCopy_FromSizeDest ExactPage2 , ExactPage2End-ExactPage2 , $500
    +MCopy_FromSizeDest ExactPage , ExactPageEnd-ExactPage , $580
    +MCopy_FromSizeDest SmallData , SmallDataEnd-SmallData , $780
    +MStartWithRts SCREENRAM
    """
    And I run the command line: ..\acme.exe --lib ..\ -v4 --msvc Linker.a
    And I load prg "bin\Linker.prg"
    And I load labels "bin\Linker.map"
    When I execute the procedure at BASICEntry for no more than 3650 instructions until PC = SCREENRAM
    When I hex dump memory between $4f0 and $790
    Then property "test.BDD6502.lastHexDump" must contain string "4f0: 00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00"
    Then property "test.BDD6502.lastHexDump" must contain string "500: 01 01 01 01 01 01 01 01  01 01 01 01 01 01 01 01"
    Then property "test.BDD6502.lastHexDump" must contain string "570: 01 01 01 01 01 01 01 01  01 01 01 01 01 01 01 01"
    Then property "test.BDD6502.lastHexDump" must contain string "580: 03 03 03 03 03 03 03 03  03 03 03 03 03 03 03 03"
    Then property "test.BDD6502.lastHexDump" must contain string "670: 03 03 03 03 03 03 03 03  03 03 03 03 03 03 03 03"
    Then property "test.BDD6502.lastHexDump" must contain string "680: 02 02 02 02 02 02 02 02  02 02 02 02 02 02 02 02"
    Then property "test.BDD6502.lastHexDump" must contain string "770: 00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00"
    Then property "test.BDD6502.lastHexDump" must contain string "780: 0a 0b 0c 0d 0e 0f 10 11  12 13 14 00 00 00 00 00"



  Scenario: Test overlapping source and destination
    Given a Commodore 64
    And I create file "_ChunkData.a" with
    """
    ExactPage2
    !by 1,2,3,4,5,6
    !fill 256,1
    !fill 240,2
    !by 7,8,9,10,11,12
    !fill 12,128
    !by 7,6,5,4,3,2,1
    ExactPage2End
    """
    And I create file "_Chunks.a" with
    """
    +MCopy_FromSizeDest ExactPage2 , ExactPage2End-ExactPage2 , $900
    +MStartWithRts SCREENRAM
    """
    And I run the command line: ..\acme.exe --lib ..\ -v4 --msvc Linker.a
    And I load prg "bin\Linker.prg"
    And I load labels "bin\Linker.map"
    When I execute the procedure at BASICEntry for no more than 13650 instructions until PC = SCREENRAM
    When I hex dump memory between $900 and $b10
    Then property "test.BDD6502.lastHexDump" must contain string "900: 01 02 03 04 05 06 01 01  01 01 01 01 01 01 01 01"
    Then property "test.BDD6502.lastHexDump" must contain string "980: 01 01 01 01 01 01 01 01  01 01 01 01 01 01 01 01"
    Then property "test.BDD6502.lastHexDump" must contain string "a00: 01 01 01 01 01 01 02 02  02 02 02 02 02 02 02 02"
    Then property "test.BDD6502.lastHexDump" must contain string "a80: 02 02 02 02 02 02 02 02  02 02 02 02 02 02 02 02"
    Then property "test.BDD6502.lastHexDump" must contain string "af0: 02 02 02 02 02 02 07 08  09 0a 0b 0c 80 80 80 80"
    Then property "test.BDD6502.lastHexDump" must contain string "b00: 80 80 80 80 80 80 80 80  07 06 05 04 03 02 01 00"



  Scenario: Test processor port operation with colour RAM updates
    Given a Commodore 64
    And I create file "_ChunkData.a" with
    """
    Colours
    !by 1,2,3,4,5,6,7,8,9,10,11,12,13,14
    ColoursEnd
    Text
    !scr "Hello world!"
    TextEnd
    """
    And I create file "_Chunks.a" with
    """
    +MSetPP ProcessorPortDefault
    +MCopy_FromSizeDest Colours , ColoursEnd-Colours , COLOURRAM
    +MCopy_FromSizeDest Text , TextEnd-Text , SCREENRAM
    +MSetAddr VIC2Colour_White , VIC2BorderColour
    +MSetAddr VIC2Colour_LightBlue , VIC2ScreenColour
    +MSetAddr VIC2MemorySetupDefault | %10 , VIC2MemorySetup
    +MSetAddr CIA2PortASerialBusVICBankDefault , CIA2PortASerialBusVICBank
    +MSetAddr VIC2ScreenControlHDefault , VIC2ScreenControlH
    +MSetAddr VIC2ScreenControlVDefault , VIC2ScreenControlV
    +MStartWithRts SCREENRAM
    """
    Given C64 video display saves debug BMP images to leaf filename "target\TC-3-"
    And I run the command line: ..\acme.exe --lib ..\ -v4 --msvc Linker.a
    And I load prg "bin\Linker.prg"
    And I load labels "bin\Linker.map"
    When I execute the procedure at BASICEntry for no more than 13650 instructions until PC = SCREENRAM
    And render a C64 video display frame
    And render a C64 video display frame
    Then expect image "TestData\TC-3-000001.bmp" to be identical to "target\TC-3-000001.bmp"

