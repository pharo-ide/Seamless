*Seamless
printForSeamlessLog
	^String streamContents: [ :s | 
		s 
			<< self class name;
			<< $(;
			<< self hash;
			<< ')>>'
	]