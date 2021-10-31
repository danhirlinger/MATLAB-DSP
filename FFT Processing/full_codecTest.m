% full_codecTest.m

originalFile = 'AcGtr.wav';
bitrate = 128000;
codedFile = 'AcGtr.codec';
decodedFile = 'output.wav';
decodedFile = full_codec(originalFile,bitrate,decodedFile,codedFile);