accessing
returnValue
	homeContext isSeamlessProxy ifTrue: [ 
		^BlockCannotReturn result: value from: homeContext].

	homeContext return: value