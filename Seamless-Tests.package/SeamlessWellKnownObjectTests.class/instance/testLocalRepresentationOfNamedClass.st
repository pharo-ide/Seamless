tests
testLocalRepresentationOfNamedClass

	| wellKnownObject localObject |
	[:materializer | 
		wellKnownObject := SeamlessWellKnownObject named: Point name.
		
		localObject := wellKnownObject prepareLocalSubstitutionIn: #network with: materializer.
		
		localObject should be: Point.
		materializer should receive skip: Point
	] runWithMocks 