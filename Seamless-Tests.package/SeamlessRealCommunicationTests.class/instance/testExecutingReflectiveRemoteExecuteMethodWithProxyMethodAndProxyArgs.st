tests
testExecutingReflectiveRemoteExecuteMethodWithProxyMethodAndProxyArgs
 
	| remoteSmalltalk remoteString actual args localResult method |
	args := Array with: 2 with: $s.
	args seamlessDefaultTransferStrategy should be: SeamlessTransferStrategy defaultByReference.
	method := (String class lookupSelector: #new:withAll:).
	method seamlessDefaultTransferStrategy should be: SeamlessTransferStrategy defaultByReference.
	
	localResult := String withArgs: args executeMethod: method.
	localResult should equal: 'ss'.
	
	self forkAndWait: [
		remoteSmalltalk := clientSideNetwork environmentAt: self serverAddress.
		remoteString := remoteSmalltalk at: #String.
		actual := remoteString withArgs: args executeMethod: method].

	actual should equal: 'ss'.