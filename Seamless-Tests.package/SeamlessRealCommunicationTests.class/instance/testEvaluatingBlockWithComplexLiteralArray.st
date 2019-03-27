tests
testEvaluatingBlockWithComplexLiteralArray
	| remotePeer result |
	remotePeer := self connectToServerPeer.
	"In case of complex literal arrays inside method/block 
	it should be forcible transfered by deep copy
	because it is integral part of method"
	serverSideNetwork transferByReference: (Kind of: Array). 
	
	self forkAndWait: [
		result := remotePeer evaluate: [ | literalArray |
			literalArray := #(#(internal array with #[1 2 3]) ).
			{literalArray first isSeamlessProxy. literalArray first last isSeamlessProxy} = { false. false}  ].
	]. 
 
	result should be: true