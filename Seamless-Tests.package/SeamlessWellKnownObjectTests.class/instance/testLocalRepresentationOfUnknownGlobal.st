tests
testLocalRepresentationOfUnknownGlobal

	| wellKnownObject localObject |
	[:materializer | 
		wellKnownObject := SeamlessWellKnownObject named: #NameOfNonExistingGlobal.
		
		localObject := wellKnownObject prepareLocalSubstitutionIn: #network with: materializer.
		
		localObject should beInstanceOf: SeamlessMissingGlobal.
		localObject name should equal: #NameOfNonExistingGlobal.
		materializer should receive skip: localObject
	] runWithMocks 