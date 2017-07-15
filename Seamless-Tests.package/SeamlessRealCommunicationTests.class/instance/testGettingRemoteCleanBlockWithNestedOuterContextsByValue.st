tests
testGettingRemoteCleanBlockWithNestedOuterContextsByValue
	| remoteBlock localBlock |
	[remoteBlock := self prepareClientProxyForServerObject: [ 1 + 2 ] ] value.

	self forkAndWait: [
		localBlock := remoteBlock asLocalObject
	]. 
 
	localBlock should beKindOf: BlockClosure.
	
	localBlock outerContext should beInstanceOf: Context.
	localBlock outerContext outerContext should beInstanceOf: Context.
	localBlock outerContext sender should be: nil.
	localBlock value should be: 3.
	localBlock home should be: localBlock outerContext outerMostContext.