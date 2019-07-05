Class {
	#name : #SeamlessTransferByValueStrategyTests,
	#superclass : #SeamlessTransferStrategyTestCase,
	#category : 'Seamless-Tests'
}

{ #category : #running }
SeamlessTransferByValueStrategyTests >> setUp [
	super setUp.
	
	strategy := SeamlessTransferByValueStrategy new
]

{ #category : #tests }
SeamlessTransferByValueStrategyTests >> testTransferPreparation [

	| object transferObject |
	object := Mock new.
	
	transferObject := strategy prepareTransferObjectFor: object by: transporter.
	
	transferObject should beReturnedFrom: [object prepareValueForTransferBy: transporter]
]
