Class {
	#name : #SeamlessRequestContextTestCase,
	#superclass : #TestCase,
	#instVars : [
		'context'
	],
	#category : 'Seamless-Tests'
}

{ #category : #testing }
SeamlessRequestContextTestCase class >> isAbstract [
	^self == SeamlessRequestContextTestCase 
]

{ #category : #running }
SeamlessRequestContextTestCase >> contextClass [
	self subclassResponsibility 
]

{ #category : #running }
SeamlessRequestContextTestCase >> setUp [
	super setUp.
		
	context := self contextClass new
]

{ #category : #tests }
SeamlessRequestContextTestCase >> testShouldOnlyAllowDefaultTransferStrategy [

	context should be isOnlyDefaultTransferStrategyAllowed
]
