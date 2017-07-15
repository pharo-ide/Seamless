printing
printMessageForLog

	^String streamContents: [ :s | 
		s 
			<< self receiver printForSeamlessLog;
			<< '>>';
			<< self selector
	]