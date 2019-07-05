Class {
	#name : #SeamlessThrowExceptionResultTests,
	#superclass : #SeamlessRequestResultTestCase,
	#category : 'Seamless-Tests'
}

{ #category : #tests }
SeamlessThrowExceptionResultTests >> testReturningValue [

	| error |
	error := ZeroDivide new.
	
	result := SeamlessThrowExceptionResult with: error.
	
	[result returnValue] should raise: ZeroDivide
]
