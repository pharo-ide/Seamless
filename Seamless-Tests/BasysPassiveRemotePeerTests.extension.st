Extension { #name : #BasysPassiveRemotePeerTests }

{ #category : #'*Seamless-Tests' }
BasysPassiveRemotePeerTests >> testDestroyingShouldNotSendNotificationRequestWhenPeerIsDisconnected [

	peer stub isConnected willReturn: false.
	
	peer destroy.
		
	peer should not receive sendDataPacket: Any.
	network should receive cleanDestroyedPeer: peer
]
