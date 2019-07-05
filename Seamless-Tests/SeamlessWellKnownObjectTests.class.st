Class {
	#name : #SeamlessWellKnownObjectTests,
	#superclass : #TestCase,
	#category : 'Seamless-Tests'
}

{ #category : #tests }
SeamlessWellKnownObjectTests >> testLocalRepresentationOfNamedClass [

	| wellKnownObject localObject |
	[:materializer | 
		wellKnownObject := SeamlessWellKnownObject named: Point name.
		
		localObject := wellKnownObject prepareLocalSubstitutionIn: #network with: materializer.
		
		localObject should be: Point.
		materializer should receive skip: Point
	] runWithMocks 
]

{ #category : #tests }
SeamlessWellKnownObjectTests >> testLocalRepresentationOfNamedGlobalWhichIsNotClass [

	| wellKnownObject localObject |
	[:materializer | 
		wellKnownObject := SeamlessWellKnownObject named: #Smalltalk.
		
		localObject := wellKnownObject prepareLocalSubstitutionIn: #network with: materializer.
		
		localObject should be: Smalltalk.
		materializer should receive skip: Smalltalk
	] runWithMocks 
]

{ #category : #tests }
SeamlessWellKnownObjectTests >> testLocalRepresentationOfUnknownGlobal [

	| wellKnownObject localObject |
	[:materializer | 
		wellKnownObject := SeamlessWellKnownObject named: #NameOfNonExistingGlobal.
		
		localObject := wellKnownObject prepareLocalSubstitutionIn: #network with: materializer.
		
		localObject should beInstanceOf: SeamlessMissingGlobal.
		localObject name should equal: #NameOfNonExistingGlobal.
		materializer should receive skip: localObject
	] runWithMocks 
]
