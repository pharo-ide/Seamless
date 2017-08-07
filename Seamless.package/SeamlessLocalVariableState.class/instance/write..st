accessing
write: anObject
	| writeMessage |
	self value: anObject.
	self checkConnection ifFalse: [ ^anObject].
	
	writeMessage := MessageSend receiver: remoteVariable selector: #write: argument: anObject.
	[remoteVariable remotePeer 
		sendDataPacket: (SeamlessMessageSendRequest with: writeMessage)] ifError: [  ].
	^anObject.