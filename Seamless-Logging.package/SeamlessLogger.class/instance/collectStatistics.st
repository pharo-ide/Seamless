controlling
collectStatistics

	| needsResume stat |
	needsResume := self isRunning.
	self stop.

	stat := SeamlessStatistics buildOn: requests.
	
	needsResume ifTrue: [ self start].
	^stat