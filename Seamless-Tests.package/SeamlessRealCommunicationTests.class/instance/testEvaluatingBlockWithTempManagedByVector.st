tests
testEvaluatingBlockWithTempManagedByVector
	| remotePeer result |
	remotePeer := self connectToServerPeer.
	"temp variable in following example is managed by temp vector 
	according to full block closure logic.
	Temp vectors should be forcibly transferred by value as integral part of context"
	self forkAndWait: [ | temp | 
		temp := 10.
		result := remotePeer evaluate: [ temp := temp + 5].
	]. 
	result should be: 15