import sys

args = sys.argv[1:]

if len(args) <= 1 or args[0] == "-?" or args[0].startswith("-h") or args[0].startswith("--h"):
    print("-pp <value> : Set the processor port")
    print("-b <address> <filename> [skip bytes] [length bytes] : Copy binary data to address, from filename, "
          "with optional skip bytes from start and length")
    print("-sa <address> <value> : Set the address with the value")
    print("-sr <address> : Start the code the the address, by using an RTS instruction")
    exit(-1)

i = 0

chunkData = open("_ChunkData.a", "w")
chunks = open("_Chunks.a", "w")

labelNum = 0

while i < len(args):
    if args[i] == "-pp":
        i += 1
        chunks.write("+MSetPP " + args[i] + "\n")
        i += 1
    elif args[i] == "-b":
        i += 1
        address = args[i]
        i += 1
        filename = args[i]
        i += 1
        skip = ""
        length = ""
        if i < len(args) and args[i][0] != '-':
            skip = args[i]
            i += 1
        if i < len(args) and args[i][0] != '-':
            length = args[i]
            i += 1
        chunkData.write("chunk" + str(labelNum) + "\n")
        chunkData.write("!bin \"" + filename + "\"," + length + "," + skip + "\n")
        chunkData.write("chunkEnd" + str(labelNum) + "\n")

        chunks.write("+MCopy_FromSizeDest " + "chunk" + str(labelNum) + " , " + "chunkEnd" + str(labelNum) + " - " +
                     "chunk" + str(labelNum) + " , " + address + "\n")
        labelNum += 1
    elif args[i] == "-sr":
        i += 1
        chunks.write("+MStartWithRts " + args[i] + "\n")
        i += 1
    elif args[i] == "-sa":
        i += 1
        address = args[i]
        i += 1
        value = args[i]
        chunks.write("+MSetAddr " + value + " , " + address + "\n")
        i += 1
    else:
        print("Unknown option:", args[i])
        exit(-1)

chunkData.close()
chunks.close()
