Class {
	#name : #SeamlessDefaultRequestContextTests,
	#superclass : #SeamlessRequestContextTestCase,
	#category : 'Seamless-Tests'
}

{ #category : #running }
SeamlessDefaultRequestContextTests >> contextClass [
	^SeamlessDefaultRequestContext 
]

{ #category : #tests }
SeamlessDefaultRequestContextTests >> testDefaultTransferStrategy [

	context seamlessDefaultTransferStrategy should be: SeamlessTransferStrategy defaultByValue 
]

{ #category : #tests }
SeamlessDefaultRequestContextTests >> testReturningResultShouldDoNothing [
	
	context return: Any to: Any
]
