Class {
	#name : #SeamlessTransferStrategyTestCase,
	#superclass : #TestCase,
	#instVars : [
		'strategy',
		'transporter'
	],
	#category : 'Seamless-Tests'
}

{ #category : #testing }
SeamlessTransferStrategyTestCase class >> isAbstract [
	^self == SeamlessTransferStrategyTestCase 
]

{ #category : #running }
SeamlessTransferStrategyTestCase >> setUp [
	super setUp.
	
	transporter := Mock new.
]

{ #category : #tests }
SeamlessTransferStrategyTestCase >> testAppliedToObject [

	| criteria |
	criteria := Mock new.
	(criteria stub matches: #object1) willReturn: true.
	(criteria stub matches: #object2) willReturn: false.
	
	strategy criteria: criteria.
	
	(strategy isAppliedTo: #object1) should be: true.
	(strategy isAppliedTo: #object2) should be: false.
	
]

{ #category : #tests }
SeamlessTransferStrategyTestCase >> testNotAppliedToAnyObjectWhenCriteriaAbsent [

	strategy criteria: nil.
	
	(strategy isAppliedTo: Any) should be: false
	
]
