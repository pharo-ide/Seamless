remote reflection
performAndCacheRemoteMessage: aMessage
	| messageSend |
	messageSend := 	MessageSend 
		receiver: self selector: aMessage selector arguments: aMessage arguments.
	
	^reference performAndCacheRemoteMessage: messageSend