Class {
	#name : #SeamlessTransportTests,
	#superclass : #TestCase,
	#instVars : [
		'network',
		'connection',
		'transport'
	],
	#category : #'Seamless-Tests'
}

{ #category : #helpers }
SeamlessTransportTests >> methodWithPragmaForTransfer [
	<example>
	^1+3
]

{ #category : #running }
SeamlessTransportTests >> setUp [
	| transferBuffer peer |
	super setUp.
	
	network := SeamlessNetwork new.
	peer := network newRemotePeer.
	peer ensureIdentity: #testRemotePeer.
	connection := peer newConnection.
	transferBuffer := ByteArray new: 10000.
	connection stub inputStream will: [ transferBuffer readStream].
	connection stub outputStream will: [ transferBuffer writeStream].
	
	transport := SeamlessTransport default.
]

{ #category : #helpers }
SeamlessTransportTests >> simpleMethodForTransfer [
	^1+3
]

{ #category : #tests }
SeamlessTransportTests >> testTransferAndReceiveCompiledMethod [

	| transferedObject method expected actual |
	method := self class >> #simpleMethodForTransfer.
	expected := self withArgs: #() executeMethod: method.
	
	network transferByValue: (Identical to: method).
	transport sendObject: (SeamlessRequestStub with: method) to: connection.
	transferedObject := transport receiveObjectFrom: connection.
	
	actual := self withArgs: #() executeMethod: transferedObject content.
	actual should equal: expected.
]

{ #category : #tests }
SeamlessTransportTests >> testTransferAndReceiveCompiledMethodWithPragma [

	| transferedObject method expected actual |
	method := self class >> #methodWithPragmaForTransfer.
	method should be hasProperties.
	method should be hasPragmaNamed: #example.
	expected := self withArgs: #() executeMethod: method.
	
	network transferByValue: (Identical to: method).
	transport sendObject: (SeamlessRequestStub with: method) to: connection.
	transferedObject := transport receiveObjectFrom: connection.
	
	transferedObject content should be hasProperties.	
	transferedObject content should be hasPragmaNamed: #example.
	actual := self withArgs: #() executeMethod: transferedObject content.
	actual should equal: expected.
]

{ #category : #tests }
SeamlessTransportTests >> testTransferAndReceiveObjectWithOneReference [

	| transferedObject |
	
	network transferByReference: (Identical to: #value).
	transport sendObject: (SeamlessRequestStub with: #key -> #value) to: connection.
	transferedObject := transport receiveObjectFrom: connection.
	
	transferedObject should beInstanceOf: SeamlessRequestStub.
	transferedObject content should beInstanceOf: Association.
	transferedObject content key should equal: #key.
	transferedObject content value should equal: #value
]

{ #category : #tests }
SeamlessTransportTests >> testTransferAndReceiveObjectWithOneReferencedCopy [

	| transferedObject |
	
	network transferByReferencedCopy: (Identical to: #value).
	transport sendObject: (SeamlessRequestStub with: #key -> #value) to: connection.
	transferedObject := transport receiveObjectFrom: connection.
	
	transferedObject should beInstanceOf: SeamlessRequestStub.
	transferedObject content should beInstanceOf: Association.
	transferedObject content key should equal: #key.
	transferedObject content value should equal: #value
]

{ #category : #tests }
SeamlessTransportTests >> testTransferAndReceiveObjectWithOneReferencedCopyAndValueObject [

	| transferedObject |
	
	network transferByReferencedCopy: (Identical to: #value).
	network transferByValue: (Instance of: Point).
	network transferByValue: (Instance of: Array).
	transport sendObject: (SeamlessRequestStub with: {#value. 10@20}) to: connection.
	transferedObject := transport receiveObjectFrom: connection.
	
	transferedObject should beInstanceOf: SeamlessRequestStub.
	transferedObject content should equal: { #value. 10@20 }
]

{ #category : #tests }
SeamlessTransportTests >> testTransferAndReceiveObjectWithTwoSameReferences [

	| transferedObject |
	
	network transferByReference: (Identical to: #value).
	network transferByValue: (Instance of: Array).
	transport sendObject: (SeamlessRequestStub with: {#value. #value}) to: connection.
	transferedObject := transport receiveObjectFrom: connection.
	
	transferedObject should beInstanceOf: SeamlessRequestStub.
	transferedObject content should equal: {#value. #value}
]
