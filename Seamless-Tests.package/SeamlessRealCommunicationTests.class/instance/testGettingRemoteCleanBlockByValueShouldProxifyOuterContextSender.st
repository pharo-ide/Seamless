tests
testGettingRemoteCleanBlockByValueShouldProxifyOuterContextSender
	| remoteBlock localBlock transferredBlock |
	transferredBlock := [ 1 + 2 ].
	remoteBlock := self prepareClientProxyForServerObject: transferredBlock.
	
	self forkAndWait: [
		localBlock := remoteBlock asLocalObject
	]. 
 
	localBlock should beKindOf: BlockClosure.
	localBlock outerContext should beInstanceOf: Context.
	localBlock outerContext sender should beInstanceOf: SeamlessProxy.
	localBlock home should be: localBlock outerContext outerMostContext.