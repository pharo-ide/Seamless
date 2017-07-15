api
sendObject: anObject by: aBasysConnection

	| bufferStream buffer bufferSizeBytes compressedBytes compressedStream compressionType |
	objectSubstitutions := IdentityDictionary new.
	
	bufferStream := (ByteArray new: 300) writeStream. 			
	self sendObject: anObject to: bufferStream.	
	buffer := bufferStream contents.
	compressionType := 0.
	buffer size > 100 ifTrue: [ 
		compressionType := 1.
		compressedBytes := (ByteArray new: (buffer size min: 100)) writeStream.
		compressedStream := GZipWriteStream on: compressedBytes.
		compressedStream nextPutAll: buffer; close.
		buffer := compressedBytes contents].
	
	anObject ownBytes: buffer size.	
	bufferSizeBytes := buffer size asByteArray.
	bufferSizeBytes size > 255 ifTrue: [ ^self error: 'Cant serialize given object. It is too big' ].
	
	
	aBasysConnection outputStream
		nextPut: compressionType;
		nextPut: bufferSizeBytes size;
		nextPutAll: bufferSizeBytes;
		nextPutAll: buffer;
		flush