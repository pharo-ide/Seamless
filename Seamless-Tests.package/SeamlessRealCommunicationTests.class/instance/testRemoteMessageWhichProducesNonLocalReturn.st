tests
testRemoteMessageWhichProducesNonLocalReturn
	"Printing contents by stream with limited size is implemented by non local return from block like [^stream contents]. 
	In this test we pass local block to remote proxy. On remote side limited stream will be created and passed as proxy to our local block. 
	When on our side we will write to much content on this stream and non local return will happen on remote side. This test show that such cases is covered by seamless"
	| remotePeer sendingContext remoteString result |
	
	remotePeer := self connectToServerPeer.
	remoteString := self prepareClientProxyForServerObject: String.
	
	self forkAndWait: [
		sendingContext := remotePeer createSyncRequestContext.
		result := sendingContext sendMessage: (MessageSend 
			receiver: remoteString selector: #streamContents:limitedTo: arguments: {
				[ :s | s nextPutAll: '12345' ]. 3})
	].

	result should equal: '123'