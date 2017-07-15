tests
testGettingRemoteFormByValue
 
	| remoteClass remoteEnv form |
	 
	self forkAndWait: [
		remoteEnv := clientSideNetwork environmentAt: self serverAddress.
		Rectangle systemIcon unhibernate.
		remoteClass := remoteEnv at: #Rectangle.
		form := remoteClass systemIcon asLocalObject].

	form should beInstanceOf: Form.
	form bits should beInstanceOf: Bitmap 