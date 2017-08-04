accessing
write: anObject
	| remotePeer writeMessage |
	self value: anObject.
	remotePeer := remoteVariable remotePeer.
	remotePeer isConnected ifFalse: [ ^anObject].
	
	writeMessage := MessageSend receiver: remoteVariable selector: #write: argument: anObject.
	[remoteVariable remotePeer 
		sendDataPacket: (SeamlessMessageSendRequest with: writeMessage)] ifError: [  ].
	^anObject.