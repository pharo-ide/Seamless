tests
testGettingRemoteObjectWithDeepCopyReferenceWhenFirstItAppearsInsideAnotherRoute
 
	| result proxy target |
	
	serverSideNetwork transferByDeepCopy: (Instance of: Rectangle).
	serverSideNetwork transferByValue: (Instance of: Array).
	target := 0@0 corner: 2@3.
	proxy := self prepareClientProxyForServerObject: { { target }. target }.
	
	self forkAndWait: [
		result := proxy asLocalObject].

	result should beInstanceOf: Array.
	result first should beInstanceOf: Array.
	result last should beInstanceOf: Rectangle.
	result last origin should beInstanceOf: Point.
	result last corner should beInstanceOf: Point.
	result first first should be: result last