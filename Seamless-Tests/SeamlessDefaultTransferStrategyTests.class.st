Class {
	#name : #SeamlessDefaultTransferStrategyTests,
	#superclass : #SeamlessTransferStrategyTestCase,
	#category : 'Seamless-Tests'
}

{ #category : #running }
SeamlessDefaultTransferStrategyTests >> setUp [
	super setUp.
	
	strategy := SeamlessDefaultTransferStrategy new
]

{ #category : #tests }
SeamlessDefaultTransferStrategyTests >> testTransferPreparation [

	| transferObject object defaultStrategy |
	object := Mock new.
	defaultStrategy := Mock new.
	object stub seamlessDefaultTransferStrategy willReturn: defaultStrategy.
	
	transferObject := strategy prepareTransferObjectFor: object by: transporter.
	
	transferObject should beReturnedFrom: [ 
		defaultStrategy prepareTransferObjectFor: object by: transporter]
	
]
