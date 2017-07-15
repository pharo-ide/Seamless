helpers
evaluateRecursiveBlockWithNonLocalReturn: resultObject by: aRemotePeer

	^aRemotePeer evaluate: [
		aRemotePeer evaluate: [
			(1 to: 10) do: [ :i | i = 5 ifTrue: [ ^resultObject ] ]  ]
	]