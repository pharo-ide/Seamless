tests
testExecutingReflectiveRemotePerformMethodWithProxyArgumentsForInternalSelector
 
	| args remoteSmalltalk remoteString actual localResult |
	args := Array with: 2 with: $s.
	args seamlessDefaultTransferStrategy should be: SeamlessTransferStrategy defaultByReference.
	
	localResult := String perform: #perform:withArguments: withArguments: {#new:withAll:. args }.
	localResult should equal: 'ss'.	
		
	self forkAndWait: [
		remoteSmalltalk := clientSideNetwork environmentAt: self serverAddress.
		remoteString := remoteSmalltalk at: #String.
		
		actual := remoteString perform: #perform:withArguments: withArguments: {#new:withAll:. args }
	].

	actual isSeamlessProxy should be: false.
	actual should equal: 'ss'.