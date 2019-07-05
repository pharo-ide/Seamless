Class {
	#name : #SeamlessRequestTestCase,
	#superclass : #TestCase,
	#instVars : [
		'request',
		'context'
	],
	#category : 'Seamless-Tests'
}

{ #category : #testing }
SeamlessRequestTestCase class >> isAbstract [
	^self == SeamlessRequestTestCase
]

{ #category : #running }
SeamlessRequestTestCase >> requestClass [
	
	self subclassResponsibility 
]

{ #category : #running }
SeamlessRequestTestCase >> setUp [
	super setUp.
	
	context := Mock new.
	
	request := self requestClass new.
	request context: context.
]

{ #category : #tests }
SeamlessRequestTestCase >> testHasDefaultContext [

	request := self requestClass new.
	request context should be: SeamlessRequestContext default
]

{ #category : #tests }
SeamlessRequestTestCase >> testIncomingRequestCheck [

	(context stub isKindOf: SeamlessRequestSendingContext) willReturn: true.
	
	request should not be isIncoming.
	
	(context stub isKindOf: SeamlessRequestSendingContext) willReturn: false.
	
	request should be isIncoming.
]

{ #category : #tests }
SeamlessRequestTestCase >> testOutgoingRequestCheck [

	(context stub isKindOf: SeamlessRequestSendingContext) willReturn: true.
	
	request should be isOutgoing.
	
	(context stub isKindOf: SeamlessRequestSendingContext) willReturn: false.
	
	request should not be isOutgoing.
]

{ #category : #tests }
SeamlessRequestTestCase >> testShouldAllowOnlyDefaultTransferStrategy [

	request should be isOnlyDefaultTransferStrategyAllowed
]

{ #category : #tests }
SeamlessRequestTestCase >> testShouldBePassedByValue [

	request seamlessDefaultTransferStrategy should be: SeamlessTransferStrategy defaultByValue 
]
