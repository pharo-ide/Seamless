tests
testGettingRemoteNotCleanBlockByValueShouldPassOuterContextsAsValueButItSenderAsReference
	| remoteBlock localBlock transferredBlock |
	transferredBlock := [ true ifFalse: [^self]. 1 + 2 ].
	transferredBlock should not be isClean.	
	remoteBlock := self prepareClientProxyForServerObject: transferredBlock.
	
	self forkAndWait: [
		localBlock := remoteBlock asLocalObject
	]. 
 
	localBlock should beKindOf: BlockClosure.
	localBlock outerContext should beInstanceOf: Context.
	localBlock outerContext sender should beInstanceOf: SeamlessProxy.
	localBlock home should be: localBlock outerContext outerMostContext.