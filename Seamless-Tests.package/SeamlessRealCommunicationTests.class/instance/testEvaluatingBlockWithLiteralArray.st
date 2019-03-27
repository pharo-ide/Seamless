tests
testEvaluatingBlockWithLiteralArray
	| remotePeer result |
	remotePeer := self connectToServerPeer.
	"In case of complex literal arrays inside method/block 
	it should be forcible transfered by deep copy
	because it is integral part of method"
	serverSideNetwork transferByReference: (Kind of: Array). 
	
	self forkAndWait: [
		result := remotePeer evaluate: [ #(1 2 3) isSeamlessProxy ].
	]. 
 
	result should be: false