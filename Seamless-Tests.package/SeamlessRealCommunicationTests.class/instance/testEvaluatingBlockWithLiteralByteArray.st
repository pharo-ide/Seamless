tests
testEvaluatingBlockWithLiteralByteArray
	| remotePeer result |
	remotePeer := self connectToServerPeer.
	"In case of literal bytearray inside method/block 
	it should be forcible transfered by value
	because it is integral part of method"
	serverSideNetwork transferByReference: (Kind of: ByteArray). 
	
	self forkAndWait: [
		result := remotePeer evaluate: [ #[1 2 3] isSeamlessProxy ].
	]. 
 
	result should be: false