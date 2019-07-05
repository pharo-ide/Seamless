Class {
	#name : #SeamlessTransferByGlobalNameStrategyTests,
	#superclass : #SeamlessTransferStrategyTestCase,
	#category : 'Seamless-Tests'
}

{ #category : #running }
SeamlessTransferByGlobalNameStrategyTests >> setUp [
	super setUp.
	
	strategy := SeamlessTransferByGlobalNameStrategy new
]

{ #category : #tests }
SeamlessTransferByGlobalNameStrategyTests >> testTransferPreparation [

	| global transferObject |
	global := Mock new.
	global stub name willReturn: #globalName.
	
	transferObject := strategy prepareTransferObjectFor: global by: transporter.
	
	transferObject should beInstanceOf: SeamlessWellKnownObject.
	transferObject name should be: #globalName
]
