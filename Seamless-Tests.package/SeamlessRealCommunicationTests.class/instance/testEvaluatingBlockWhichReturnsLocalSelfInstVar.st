tests
testEvaluatingBlockWhichReturnsLocalSelfInstVar
	| remotePeer result |
	<expectedFailure>
	"to make this tests green we should transfer receiver of block home by value. But it could reference network like in case of this test where network is inside inst vars. Now there is protection from wrong serialization/materialization inside SeamlessObjectTransporter which forbid transferring objects which are referenced network instance. Look at #prepareObjectForTransfer"
	remotePeer := self connectToServerPeer.
	
	self forkAndWait: [
		result := remotePeer evaluate: [ testSelector ].
	]. 
 
	result should equal: testSelector