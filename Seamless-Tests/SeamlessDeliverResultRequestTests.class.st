Class {
	#name : #SeamlessDeliverResultRequestTests,
	#superclass : #SeamlessRequestTestCase,
	#category : 'Seamless-Tests'
}

{ #category : #running }
SeamlessDeliverResultRequestTests >> requestClass [
	^SeamlessDeliverResultRequest  
]

{ #category : #tests }
SeamlessDeliverResultRequestTests >> testExecution [

	request result: #result.
			
	request executeFor: #senderPeer.
	
	context should receive return: #result
]

{ #category : #tests }
SeamlessDeliverResultRequestTests >> testSettingResultTransferredBytes [

	request result: SeamlessRequestResult new.
			
	request ownBytes: #bytes.
	
	request result transferredBytes should be: #bytes
]
