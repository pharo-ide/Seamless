Class {
	#name : #SeamlessNetworkTests,
	#superclass : #TestCase,
	#instVars : [
		'network'
	],
	#category : 'Seamless-Tests'
}

{ #category : #running }
SeamlessNetworkTests >> setUp [
	super setUp.
	
	network := SeamlessNetwork new
]

{ #category : #tests }
SeamlessNetworkTests >> testAddingDefaultTransferStrategyWithPriority [

	| actual |
	network transferByDefaultStrategy: #criteria priority: 200.
	
	actual := network transferStrategies anyOne.
	
	actual should beInstanceOf: SeamlessDefaultTransferStrategy.
	actual where criteria should be: #criteria.
	actual where priority should be: 200
]

{ #category : #tests }
SeamlessNetworkTests >> testAddingDefaultTransferStrategyWithSmartMessage [

	| actual |
	network transferByDefaultStrategy: #criteria.
	
	actual := network transferStrategies anyOne.
	
	actual should beInstanceOf: SeamlessDefaultTransferStrategy.
	actual where criteria should be: #criteria
]

{ #category : #tests }
SeamlessNetworkTests >> testAddingTransferStrategyByDeepCopyWithSmartMessage [

	| actual |
	network transferByDeepCopy: #criteria.
	
	actual := network transferStrategies anyOne.
	
	actual should beInstanceOf: SeamlessTransferByDeepCopyStrategy.
	actual where criteria should be: #criteria
]

{ #category : #tests }
SeamlessNetworkTests >> testAddingTransferStrategyByReferenceWithCacheWithSmartMessage [

	| actual |
	network transferByReference: #criteria withCacheFor: #messageSelectors.
	
	actual := network transferStrategies anyOne.
	
	actual should beInstanceOf: SeamlessTransferByReferenceStrategy.
	actual where criteria should be: #criteria.
	actual where cachedMessages should be: #messageSelectors
]

{ #category : #tests }
SeamlessNetworkTests >> testAddingTransferStrategyByReferenceWithSmartMessage [

	| actual |
	network transferByReference: #criteria.
	
	actual := network transferStrategies anyOne.
	
	actual should beInstanceOf: SeamlessTransferByReferenceStrategy.
	actual where criteria should be: #criteria
]

{ #category : #tests }
SeamlessNetworkTests >> testAddingTransferStrategyByReferencedCopyWithSmartMessage [

	| actual |
	network transferByReferencedCopy: #criteria.
	
	actual := network transferStrategies anyOne.
	
	actual should beInstanceOf: SeamlessTransferByReferencedCopyStrategy.
	actual where criteria should be: #criteria
]

{ #category : #tests }
SeamlessNetworkTests >> testAddingTransferStrategyByValueWithSmartMessage [

	| actual |
	network transferByValue: #criteria.
	
	actual := network transferStrategies anyOne.
	
	actual should beInstanceOf: SeamlessTransferByValueStrategy.
	actual where criteria should be: #criteria
]

{ #category : #tests }
SeamlessNetworkTests >> testCreateDeliveryForResultWhenThereIsConfiguredTimeout [

	| delivery |
	network requestProcessingTimeout: 10 seconds.
	
	delivery := network createDeliveryForResultFrom: #remotePeer.
	
	delivery should beInstanceOf: SeamlessRequestResultTimelyDelivery.
	delivery senderPeer should be: #remotePeer.
	delivery maxTime should equal: 10 seconds
]

{ #category : #tests }
SeamlessNetworkTests >> testCreateDeliveryForResultWhenThereIsDefaultTimeout [

	| delivery current |
	current := SeamlessNetwork defaultRequestProcessingTimeout.
	[SeamlessNetwork defaultRequestProcessingTimeout: 1000 seconds.
	delivery := network createDeliveryForResultFrom: #remotePeer.
	
	delivery should beInstanceOf: SeamlessRequestResultTimelyDelivery.
	delivery maxTime should equal: 1000 seconds] 
		ensure: [ SeamlessNetwork defaultRequestProcessingTimeout: current ]
]

{ #category : #tests }
SeamlessNetworkTests >> testCreateDeliveryForResultWhenThereIsNoTimeout [

	| delivery |
	network requestProcessingTimeout: nil.
	
	delivery := network createDeliveryForResultFrom: #remotePeer.
	
	delivery should beInstanceOf: SeamlessRequestResultDelivery.
	delivery senderPeer should be: #remotePeer
]

{ #category : #tests }
SeamlessNetworkTests >> testGettingObjectForReference [

	| actual distributedObjects |
	distributedObjects := Mock new.
	network distributedObjects: distributedObjects.
	
	(distributedObjects stub at: #reference ifAbsentUseProxy: Any) willReturn: #object.
	
	actual := network objectFor: #reference.
	
	actual should be: #object
]

{ #category : #tests }
SeamlessNetworkTests >> testGettingObjectForReferenceToMissingLocalObject [

	| actual reference |
	reference := SeamlessObjectReference id: #testId peerId: network localPeer id.

	actual := network objectFor: reference.
	
	actual should beInstanceOf: SeamlessMissingObject.
	actual reference should be: reference
]

{ #category : #tests }
SeamlessNetworkTests >> testGettingProxyForReferenceToNewRemoteObject [

	| actual distributedObjects reference |
	distributedObjects := Mock new.
	reference := Mock new.
	network distributedObjects: distributedObjects.
	
	(distributedObjects stub at: reference ifAbsentUseProxy: Any) 
		will: [:ref :proxyBlock | proxyBlock value ].
	reference stub createProxy willReturn: #proxy.
	
	actual := network objectFor: reference.
	
	actual should be: #proxy
]

{ #category : #tests }
SeamlessNetworkTests >> testGettingReferenceForObject [

	| actual distributedObjects |
	distributedObjects := Mock new.
	network distributedObjects: distributedObjects.
	
	(distributedObjects stub referenceFor: #object ifNewUse: Arg creationBlock) 
		willReturn: #reference.
	
	actual := network referenceFor: #object.
	
	actual should be: #reference.
	Arg creationBlock where value should beInstanceOf: SeamlessObjectReference
]

{ #category : #tests }
SeamlessNetworkTests >> testGettingTransferStrategyWhenItExistsForGivenObject [

	[:strategy1 :strategy2 |
		network addTransferStrategy: strategy1; addTransferStrategy: strategy2.
		
		(strategy1 stub isAppliedTo: #object) willReturn: false.
		(strategy2 stub isAppliedTo: #object) willReturn: true.
		
		(network transferStrategyFor: #object) should be: strategy2
	] runWithMocks 
]

{ #category : #tests }
SeamlessNetworkTests >> testGettingTransferStrategyWhenItExistsForGivenObjectButObjectNotAllowIt [

	| actual |
	[:strategy :object |
		network addTransferStrategy: strategy.
		(strategy stub isAppliedTo: object) willReturn: true.
		object stub isOnlyDefaultTransferStrategyAllowed willReturn: true.
		
		actual := network transferStrategyFor: object.
		
		actual should beReturnedFrom: [ object seamlessDefaultTransferStrategy ]
	] runWithMocks 
]

{ #category : #tests }
SeamlessNetworkTests >> testGettingTransferStrategyWhenItNotSpecifiedForGivenObject [

	| actual object |
	object := Mock new.
		
	actual := network transferStrategyFor: object.
		
	actual should beReturnedFrom: [object seamlessDefaultTransferStrategy]
]

{ #category : #tests }
SeamlessNetworkTests >> testHasDefaultRequestProcessingTimeoutByDefault [

	network requestProcessingTimeout should equal: SeamlessNetwork defaultRequestProcessingTimeout
]

{ #category : #tests }
SeamlessNetworkTests >> testHasEmptyTransferStrategiesByDefault [

	network transferStrategies should be isEmpty
]

{ #category : #tests }
SeamlessNetworkTests >> testIdentifyingConnection [

	| sentRequest |
	[:connection :context |		
		network localPeer id: #localPeerId.
		[ (network identifyLocalPeerOn: connection) should be: #remotePeerId ]
			should strictly satisfy: 
		[connection createIdentificationContext willReturn: context.
		(context sendRequest: Any) will: [ :arg | sentRequest := arg. #remotePeerId ] ].
	
		sentRequest should beInstanceOf: SeamlessPeerIdentificationRequest.
		sentRequest peerId should be: #localPeerId
	 ] runWithMocks 
]

{ #category : #tests }
SeamlessNetworkTests >> testProcessingData [

	[ :request |
		[ network process: request receivedFrom: #remotePeer]
			should strictly satisfy: 
		[ request executeFor: #remotePeer ]
	 ] runWithMocks 
]

{ #category : #tests }
SeamlessNetworkTests >> testReceivingObject [

	| result |
	[:transport :transporter :connection |
		connection stub remotePeer willReturn: #remotePeer.
		network transport: transport.
		(transport stub newTransporterFor: network toTransferBy: #remotePeer) willReturn: transporter.
		
		result := network receiveObjectBy: connection.
		
		result should beReturnedFrom: [transporter receiveObjectBy: connection]		
	] runWithMocks 
]

{ #category : #tests }
SeamlessNetworkTests >> testRemoveDistributedObject [

	network distributedObjects stub.
	
	network removeDistributedObject: #object.
	
	network distributedObjects should receive remove: #object
]

{ #category : #tests }
SeamlessNetworkTests >> testRemoveLastRemotePeerShouldCleanDistributedObjects [

	network distributedObjects stub.
	
	network removeRemotePeer: #peer.
		
	network distributedObjects should receive clear
]

{ #category : #tests }
SeamlessNetworkTests >> testRemoveRemotePeerShouldCleanDistributedObjects [

	network distributedObjects stub.
	
	network removeRemotePeer: #peer.
		
	network distributedObjects should receive removeObjectsDistributedBy: #peer
]

{ #category : #tests }
SeamlessNetworkTests >> testRemoveRemotePeerShouldCleanObjectsWhichPeerDistributes [

	network distributedObjects stub.
	
	network removeRemotePeer: #peer.
		
	network distributedObjects should receive removeObjectsDistributedBy: #peer
]

{ #category : #tests }
SeamlessNetworkTests >> testSendingObject [
	
	[:transporterClass :transporter :connection |
		network transport: transporterClass.
		connection stub remotePeer willReturn: #receiverPeer.
		(transporterClass stub newTransporterFor: network toTransferBy:  #receiverPeer) 
			willReturn: transporter.
		
		network sendObject: #object by: connection.
		 
		transporter should receive sendObject: #object by: connection
	] runWithMocks 
]

{ #category : #tests }
SeamlessNetworkTests >> testShouldFollowDefaultRequestProcessingTimeoutChangesWhenInstanceIsNotConfigured [

	| current |
	network requestProcessingTimeout should equal: SeamlessNetwork defaultRequestProcessingTimeout.
	current := SeamlessNetwork defaultRequestProcessingTimeout.
	[ 
		SeamlessNetwork defaultRequestProcessingTimeout: 1000 seconds.
		network requestProcessingTimeout should equal: SeamlessNetwork defaultRequestProcessingTimeout.
	] ensure: [ SeamlessNetwork defaultRequestProcessingTimeout: current ]
]

{ #category : #tests }
SeamlessNetworkTests >> testStrategiesShouldBeInDeclarationOrderWhenNoPriorityWasSpecified [

	| actual strategy1 strategy2 |
	strategy1 := SeamlessTransferByValueStrategy new.
	network addTransferStrategy: strategy1.

	strategy2 := SeamlessTransferByValueStrategy new.
	network addTransferStrategy: strategy2.
	
	actual := network transferStrategies.
	
	actual first should be: strategy1.
	actual last should be: strategy2
]

{ #category : #tests }
SeamlessNetworkTests >> testStrategiesShouldBeSortedByPriorityFromHighToLowDirection [

	| actual strategy1 strategy2 |
	strategy1 := SeamlessTransferByValueStrategy new.
	network addTransferStrategy: strategy1 priority: 10.

	strategy2 := SeamlessTransferByValueStrategy new.
	network addTransferStrategy: strategy2 priority: 100.
	
	actual := network transferStrategies.
	
	actual first should be: strategy2.
	actual last should be: strategy1
]
