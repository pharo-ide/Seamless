*Seamless-Tests
testDestroyingShouldSignalUnexpectedProblemsDuringRemoteSideNotifications

	| unexpectedProblem |
	unexpectedProblem := Error new.
	(peer stub sendDataPacket: Any) willRaise: unexpectedProblem.
		
	[peer destroy] should raise: unexpectedProblem.
		
	network should not receive cleanDestroyedPeer: Any