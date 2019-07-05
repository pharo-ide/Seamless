Class {
	#name : #SeamlessTransferByDeepCopyStrategyTests,
	#superclass : #SeamlessTransferStrategyTestCase,
	#category : 'Seamless-Tests'
}

{ #category : #running }
SeamlessTransferByDeepCopyStrategyTests >> setUp [
	super setUp.
	
	strategy := SeamlessTransferByDeepCopyStrategy new
]

{ #category : #tests }
SeamlessTransferByDeepCopyStrategyTests >> testTransferPreparation [

	transporter := Mock new.
	
	strategy prepareTransferObjectFor: #object by: transporter.
	
	transporter should receive transferByDeepCopy: #object
]
