tests
testGettingRemoteNotCleanBlockWithNestedOuterContextsByValue
	| remoteBlock localBlock |
	[remoteBlock := self prepareClientProxyForServerObject: [true ifFalse: [^self]. 1 + 2 ] ] value.

	self forkAndWait: [
		localBlock := remoteBlock asLocalObject
	]. 
 
	localBlock should beKindOf: BlockClosure.
	localBlock outerContext should beInstanceOf: Context.
	localBlock outerContext outerContext should beInstanceOf: Context.
	localBlock outerContext outerContext sender should beInstanceOf: SeamlessProxy.
	localBlock value should be: 3.
	localBlock home should be: localBlock outerContext outerMostContext.