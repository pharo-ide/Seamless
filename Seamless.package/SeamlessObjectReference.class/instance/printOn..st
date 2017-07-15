printing
printOn: aStream

	| referenceName |
	referenceName := 'an ObjectReference'.
	senderPeer ifNotNil: [ 
		referenceName := senderPeer class = BasysLocalPeer ifTrue: [ 'an LocalReference' ] ifFalse: [ 'an RemoteReference' ]].
	
	aStream << referenceName << $( << id asString << ')'.