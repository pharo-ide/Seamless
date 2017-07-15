api
receiveObjectBy: aBasysConnection
	| object in sizeSize size buffer compressionType compressionStream |
	in := aBasysConnection inputStream.
	in binary.
	
	compressionType := in next.
	sizeSize := in next.
	size := (in next: sizeSize) asInteger.
	buffer := in next: size.
	
	compressionType = 1 ifTrue: [ 
		compressionStream := GZipReadStream on: buffer readStream.
		buffer := compressionStream contents].
	
	object := self receiveObjectFrom: buffer readStream.	
	object ownBytes: size.
	
	^object