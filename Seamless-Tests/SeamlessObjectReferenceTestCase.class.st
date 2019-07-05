Class {
	#name : #SeamlessObjectReferenceTestCase,
	#superclass : #TestCase,
	#instVars : [
		'reference',
		'peer'
	],
	#category : 'Seamless-Tests'
}

{ #category : #testing }
SeamlessObjectReferenceTestCase class >> isAbstract [
	^self == SeamlessObjectReferenceTestCase
]

{ #category : #running }
SeamlessObjectReferenceTestCase >> referenceClass [
	self subclassResponsibility 
]

{ #category : #running }
SeamlessObjectReferenceTestCase >> setUp [
	super setUp.
	
	peer := Mock new.
	peer stub id willReturn: #peerId.
	
	reference := self referenceClass id: #referenceId peer: peer
]

{ #category : #tests }
SeamlessObjectReferenceTestCase >> testDefaultTransferStrategy [

	reference seamlessDefaultTransferStrategy should be: SeamlessTransferStrategy defaultByValue 
]

{ #category : #tests }
SeamlessObjectReferenceTestCase >> testHasNilMessagesCacheByDefault [

	reference messagesCache should be: nil
]

{ #category : #tests }
SeamlessObjectReferenceTestCase >> testShouldAllowOnlyDefaultTransferStrategy [

	reference should be isOnlyDefaultTransferStrategyAllowed
]
