tests
testExecutingReflectiveRemoteExecuteMethodWithProxyMethod
 
	| remoteSmalltalk remoteString actual localResult method |
	method := String class lookupSelector: #name. 
	method seamlessDefaultTransferStrategy should be: SeamlessTransferStrategy defaultByReference.
	
	localResult := String withArgs: #() executeMethod: method.
	localResult should equal: String name.
		
	self forkAndWait: [
		remoteSmalltalk := clientSideNetwork environmentAt: self serverAddress.
		remoteString := remoteSmalltalk at: #String.
		actual := remoteString withArgs: #() executeMethod: method.
	].

	actual should equal: 'String'.