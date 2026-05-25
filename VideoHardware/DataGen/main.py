import sys


def writeSample(file, inSample):
    theSample = int(inSample) + 0x80
    theSample = max(theSample, 0)
    theSample = min(theSample, 0xff)
    val = bytes([theSample])
    file.write(val)


if __name__ == '__main__':
    testdataFile = open(sys.argv[1], "wb")
    stepPerSample = float(sys.argv[2])
    numSamples = int(sys.argv[3])
    numCycles = int(sys.argv[4])
    numEndSamples = int(sys.argv[5])

    while numCycles > 0:
        numCycles -= 1
        sample = 0

        cnt = numSamples
        while cnt > 0:
            sample += stepPerSample
            writeSample(testdataFile, sample)
            cnt -= 1

        cnt = numSamples
        while cnt > 0:
            sample -= stepPerSample
            writeSample(testdataFile, sample)
            cnt -= 1

        sample = 0
        writeSample(testdataFile, sample)

        cnt = numSamples
        while cnt > 0:
            sample -= stepPerSample
            writeSample(testdataFile, sample)
            cnt -= 1

        cnt = numSamples
        while cnt > 0:
            sample += stepPerSample
            writeSample(testdataFile, sample)
            cnt -= 1

        sample = 0
        writeSample(testdataFile, sample)

    # Then write the end
    while numEndSamples > 0:
        writeSample(testdataFile, 0)
        numEndSamples -= 1

    testdataFile.close()
