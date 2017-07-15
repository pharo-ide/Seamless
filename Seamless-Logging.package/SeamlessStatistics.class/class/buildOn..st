as yet unclassified
buildOn: requests

	| stat |
	stat := self new.
	stat 
		countAllAs: 'requests';
		countDifferent: [ :r | r receiver ] as: 'instances' for: (Kind of: SeamlessMessageSendRequest);
		countFunction: [ :r | r transferredBytes ] as: 'bytes';
		countFunction: [ :r | r ownBytes ] as: 'own';
		countFunction: [ :r | r resultBytes ] as: 'result';
		countAllSuch: #isOutgoing as: 'outgoing';
		countAllSuch: #isIncoming as: 'incoming'.
	stat 
		dimension: [ :r | r class ] named: 'requests';
		for: (Kind of: SeamlessMessageSendRequest) with: [ 
			stat 
				dimension: [ :r | r receiver nameForSeamlessStatistics ] named: 'classes';
				with: [ 
					stat ignoreMetrics: #('incoming' 'outgoing').
					stat dimension: [ :r | r selector ] named: 'msgs'].
			stat
				dimension: [ :r | r selector ] named: 'msgs';
				with: [ 	
					stat dimension: [ :r | r receiver nameForSeamlessStatistics ] named: 'classes']
		].
	
	stat accumulateAll: requests.
	^stat