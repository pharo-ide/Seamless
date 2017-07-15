tests
testGettingRemoteObjectAsDeepCopyWhichReferencesProxyToClientObject
 
	| result remoteObject localPoint remoteObjectProxy wrapperProxy |
	remoteObject := OrderedCollection with: 1@2.
	localPoint := 3@4.
	serverSideNetwork transferByDeepCopy: (Identical to: remoteObject).
	serverSideNetwork transferByReference: (Instance of: Point).
	clientSideNetwork transferByReference: (Instance of: Point).
	remoteObjectProxy := self prepareClientProxyForServerObject: remoteObject.
	wrapperProxy := self prepareClientProxyForServerObject: {remoteObject}.
	
	self forkAndWait: [
		remoteObjectProxy add: localPoint.
		result := wrapperProxy asLocalObject first].

	result should beInstanceOf: OrderedCollection.
	result first should beInstanceOf: Point.
	result first should equal: 1@2.
	result last should be: localPoint.