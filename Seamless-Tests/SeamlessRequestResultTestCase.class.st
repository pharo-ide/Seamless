Class {
	#name : #SeamlessRequestResultTestCase,
	#superclass : #TestCase,
	#instVars : [
		'result'
	],
	#category : 'Seamless-Tests'
}

{ #category : #testing }
SeamlessRequestResultTestCase class >> isAbstract [
	^self == SeamlessRequestResultTestCase
]

{ #category : #tests }
SeamlessRequestResultTestCase >> testHasTransferByValueStrategyByDefault [

	result seamlessDefaultTransferStrategy should be: SeamlessTransferStrategy defaultByValue
]

{ #category : #tests }
SeamlessRequestResultTestCase >> testShouldOnlyAllowDefaultTransferStraegy [

	result should be isOnlyDefaultTransferStrategyAllowed
]
