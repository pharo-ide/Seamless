tests
testReferenceCreation
	
	| actual |
	actual := context createSeamlessReference.
	
	actual should beInstanceOf: SeamlessRequestContextReference