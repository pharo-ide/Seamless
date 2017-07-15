tests
testGettingRemoteObjectWithDeepCopyReferenceAndNormalOne
 
	| result proxy |	
	serverSideNetwork transferByDeepCopy: (Instance of: Rectangle).
	serverSideNetwork transferByReference: (Instance of: Point).
	proxy := self prepareClientProxyForServerObject: { 0@0 corner: 2@3. 4@5 }.
	
	self forkAndWait: [
		result := proxy asLocalObject].

	result should beInstanceOf: Array.
	result first origin should beInstanceOf: Point.
	result first corner should beInstanceOf: Point.
	result last should beInstanceOf: SeamlessProxy