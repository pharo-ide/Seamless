tests
testLocalRepresentationOfNamedGlobalWhichIsNotClass

	| wellKnownObject localObject |
	[:materializer | 
		wellKnownObject := SeamlessWellKnownObject named: #Smalltalk.
		
		localObject := wellKnownObject prepareLocalSubstitutionIn: #network with: materializer.
		
		localObject should be: Smalltalk.
		materializer should receive skip: Smalltalk
	] runWithMocks 