tests
testExecutionWithNotificationRaised

	[:messageSend |
		request valuable: messageSend.
		messageSend stub value willRaise: Notification.

		[request executeFor: #senderPeer] should raise: Notification
		
	] runWithMocks 