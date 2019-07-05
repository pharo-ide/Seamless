Class {
	#name : #SeamlessReturnValueResultTests,
	#superclass : #SeamlessRequestResultTestCase,
	#category : 'Seamless-Tests'
}

{ #category : #tests }
SeamlessReturnValueResultTests >> testReturningValue [

	result := SeamlessReturnValueResult with: #returnedValue.
	
	result returnValue should be: #returnedValue
]
