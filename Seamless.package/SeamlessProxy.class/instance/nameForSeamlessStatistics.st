remote reflection
nameForSeamlessStatistics

	| remoteName |
	remoteName := self performAndCacheRemoteMessage: (Message selector: #nameForSeamlessStatistics).
	
	^'Remote ', remoteName