Class {
	#name : #SeamlessObjectTransporterTests,
	#superclass : #TestCase,
	#instVars : [
		'transporter',
		'network',
		'connection'
	],
	#category : 'Seamless-Tests'
}

{ #category : #running }
SeamlessObjectTransporterTests >> setUp [
	| transferBuffer |
	super setUp.
	
	network := SeamlessNetwork new.
	transporter := SeamlessRequestTransporter default 
		newTransporterFor: network toTransferBy: (SeamlessRemotePeer new id: UUID new).
	
	connection := Mock new.
	transferBuffer := ByteArray new: 10000.
	connection stub inputStream will: [ transferBuffer readStream].
	connection stub outputStream will: [ transferBuffer writeStream].
]

{ #category : #tests }
SeamlessObjectTransporterTests >> testTransferAndReceiveObjectWithOneReference [

	| transferedObject |
	
	network transferByReference: (Identical to: #value).
	transporter sendRequest: (SeamlessRequestStub with: #key -> #value) by: connection.
	transferedObject := transporter receiveRequestBy: connection.
	
	transferedObject should beInstanceOf: SeamlessRequestStub.
	transferedObject content should beInstanceOf: Association.
	transferedObject content key should equal: #key.
	transferedObject content value should equal: #value
]

{ #category : #tests }
SeamlessObjectTransporterTests >> testTransferAndReceiveObjectWithOneReferencedCopy [

	| transferedObject |
	
	network transferByReferencedCopy: (Identical to: #value).
	transporter sendRequest: (SeamlessRequestStub with: #key -> #value) by: connection.
	transferedObject := transporter receiveRequestBy: connection.
	
	transferedObject should beInstanceOf: SeamlessRequestStub.
	transferedObject content should beInstanceOf: Association.
	transferedObject content key should equal: #key.
	transferedObject content value should equal: #value
]

{ #category : #tests }
SeamlessObjectTransporterTests >> testTransferAndReceiveObjectWithOneReferencedCopyAndValueObject [

	| transferedObject |
	
	network transferByReferencedCopy: (Identical to: #value).
	network transferByValue: (Instance of: Point).
	network transferByValue: (Instance of: Array).
	transporter sendRequest: (SeamlessRequestStub with: {#value. 10@20}) by: connection.
	transferedObject := transporter receiveRequestBy: connection.
	
	transferedObject should beInstanceOf: SeamlessRequestStub.
	transferedObject content should equal: { #value. 10@20 }
]

{ #category : #tests }
SeamlessObjectTransporterTests >> testTransferAndReceiveObjectWithTwoSameReferences [

	| transferedObject |
	
	network transferByReference: (Identical to: #value).
	network transferByValue: (Instance of: Array).
	transporter sendRequest: (SeamlessRequestStub with: {#value. #value}) by: connection.
	transferedObject := transporter receiveRequestBy: connection.
	
	transferedObject should beInstanceOf: SeamlessRequestStub.
	transferedObject content should equal: {#value. #value}
]
