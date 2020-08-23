Class {
	#name : #SeamlessRealCommunicationTests,
	#superclass : #BasysRealCommunicationTestCase,
	#category : 'Seamless-Tests'
}

{ #category : #helpers }
SeamlessRealCommunicationTests >> calculateFirstRectAreaByNonLocalReturn: rectanglesArray from: remotePeer [ 

	| sendingContext |
	sendingContext := remotePeer createSyncRequestContext.
	
	^sendingContext sendMessage: (MessageSend 
			receiver: rectanglesArray selector: #do: arguments: {[ :each | ^each area ]})
]

{ #category : #helpers }
SeamlessRealCommunicationTests >> evaluateBlockWithNonLocalReturn: resultObject by: aRemotePeer [

	^aRemotePeer evaluate: [(1 to: 10) do: [ :i | i = 5 ifTrue: [ ^resultObject ] ]  ]
]

{ #category : #helpers }
SeamlessRealCommunicationTests >> evaluateRecursiveBlockWithNonLocalReturn: resultObject by: aRemotePeer [

	^aRemotePeer evaluate: [
		aRemotePeer evaluate: [
			(1 to: 10) do: [ :i | i = 5 ifTrue: [ ^resultObject ] ]  ]
	]
]

{ #category : #running }
SeamlessRealCommunicationTests >> networkClass [
	^SeamlessNetwork
]

{ #category : #helpers }
SeamlessRealCommunicationTests >> prepareClientProxyForServerObject: serverSideObject [

	| serverSideReference clientSideReference |
	serverSideNetwork transferByReference: (Identical to: serverSideObject).
	
	serverSideReference := serverSideNetwork referenceFor: serverSideObject.
	clientSideReference := serverSideReference copy.
	clientSideReference senderPeer: (clientSideNetwork remotePeerAt: self serverAddress).
	
	^clientSideNetwork objectFor: clientSideReference
]

{ #category : #running }
SeamlessRealCommunicationTests >> setUp [
	SeamlessObjectTransporter createDefault.
	super setUp.
	
	
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testClosedNetworkShouldFailAnyRemoteRequestsOnClient [
 
	| remoteEnv |
	 
	self forkAndWait: [
		remoteEnv := clientSideNetwork environmentAt: self serverAddress.
		clientSideNetwork close.
		[ remoteEnv at: #Rectangle ] should raise: BasysRemotePeerClosed
	]
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testClosedNetworkShouldHaveCleanDistributedObjects [
 	| remoteEnv |
	 
	self forkAndWait: [
		remoteEnv := clientSideNetwork environmentAt: self serverAddress.
		clientSideNetwork distributedObjects should not be isEmpty.
		serverSideNetwork distributedObjects should not be isEmpty.
		
		clientSideNetwork close.
	].
	100 milliSeconds wait. "close request is async. So we should give a time to clean objects"
	
	clientSideNetwork distributedObjects should be isEmpty.
	clientSideNetwork remotePeers should be isEmpty.
	serverSideNetwork distributedObjects should be isEmpty.
	serverSideNetwork remotePeers should be isEmpty
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testEvaluatingBlockAsynchronously [
	| remotePeer result |
	remotePeer := self connectToServerPeer.
	serverSideNetwork transferByReference: (Kind of: Point).
	
	self forkAndWait: [
		result := remotePeer evaluateAsync: [ 100 milliSeconds wait ].
	]. 
 
	result should be: remotePeer
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testEvaluatingBlockWhichAccessLocalTempWhichTransferedByReference [
	| remotePeer result rect |
	remotePeer := self connectToServerPeer.
	clientSideNetwork transferByReference: (Instance of: Rectangle).
	rect := 0@0 corner: 2@3.	
	
	self forkAndWait: [
		result := remotePeer evaluate: [ rect area ].
	]. 
 
	result should be: 6
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testEvaluatingBlockWhichCallRecursiveBlockEvaluationToSenderPeer [
	| remotePeer result |
	
	remotePeer := self connectToServerPeer.
	self forkAndWait: [		
		result := remotePeer evaluate: [ (remotePeer evaluate: [ 1 + 2 ]) + 3 ]
	]. 
 
	result should equal: 6
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testEvaluatingBlockWhichCallRecursiveBlockEvaluationToSenderPeerWithNonLocalReturn [
	| remotePeer result |
	<expectedFailure>
	self error: 'todo'.
	remotePeer := self connectToServerPeer.
	self forkAndWait: [		
		result := self evaluateRecursiveBlockWithNonLocalReturn: #result by: remotePeer.
	]. 
 
	result should be: #result
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testEvaluatingBlockWhichCallRecursiveBlockEvaluationToSenderPeerWithNonLocalReturn2 [
	| remotePeer result |
	<expectedFailure>
	self error: 'this test could crash VM. it happen if you remove tempNames from cache'.
	serverSideNetwork transferByReference: (Kind of: Context) withCacheFor: #(receiver method methodClass home tempNames).
	
	remotePeer := self connectToServerPeer.
	self forkAndWait: [		
		result := self evaluateRecursiveBlockWithNonLocalReturn: #result by: remotePeer.
	]. 
 
	result should be: #result
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testEvaluatingBlockWhichReturnsLocalSelf [
	| remotePeer result |
	remotePeer := self connectToServerPeer.
	
	self forkAndWait: [
		result := remotePeer evaluate: [ self ].
	]. 
 
	result should be: self
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testEvaluatingBlockWhichReturnsLocalSelfInstVar [
	| remotePeer result |
	<expectedFailure>
	"to make this tests green we should transfer receiver of block home by value. But it could reference network like in case of this test where network is inside inst vars. Now there is protection from wrong serialization/materialization inside SeamlessObjectTransporter which forbid transferring objects which are referenced network instance. Look at #prepareObjectForTransfer"
	remotePeer := self connectToServerPeer.
	
	self forkAndWait: [
		result := remotePeer evaluate: [ testSelector ].
	]. 
 
	result should equal: testSelector
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testEvaluatingBlockWhichReturnsResultOfRecursiveMessageToClient [
	| remotePeer result |
	remotePeer := self connectToServerPeer.
	
	self forkAndWait: [
		result := remotePeer evaluate: [ self selector ].
	]. 
 
	result should equal: testSelector
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testEvaluatingBlockWithComplexLiteralArray [
	| remotePeer result |
	remotePeer := self connectToServerPeer.
	"In case of complex literal arrays inside method/block 
	it should be forcible transfered by deep copy
	because it is integral part of method"
	serverSideNetwork transferByReference: (Kind of: Array). 
	
	self forkAndWait: [
		result := remotePeer evaluate: [ | literalArray |
			literalArray := #(#(internal array with #[1 2 3]) ).
			{literalArray first isSeamlessProxy. literalArray first last isSeamlessProxy} = { false. false}  ].
	]. 
 
	result should be: true
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testEvaluatingBlockWithGlobalsReferencesOnRemoteSide [
	| remotePeer result localResult |
	remotePeer := self connectToServerPeer.
	serverSideNetwork transferByReference: (Kind of: Point).
	
	self forkAndWait: [
		result := remotePeer evaluate: [ Point x: 10 y: 20 ].
		localResult := result asLocalObject.
	]. 
 
	result should beInstanceOf: SeamlessProxy.
	localResult should equal: 10 @ 20
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testEvaluatingBlockWithLiteralArray [
	| remotePeer result |
	remotePeer := self connectToServerPeer.
	"In case of complex literal arrays inside method/block 
	it should be forcible transfered by deep copy
	because it is integral part of method"
	serverSideNetwork transferByReference: (Kind of: Array). 
	
	self forkAndWait: [
		result := remotePeer evaluate: [ #(1 2 3) isSeamlessProxy ].
	]. 
 
	result should be: false
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testEvaluatingBlockWithLiteralByteArray [
	| remotePeer result |
	remotePeer := self connectToServerPeer.
	"In case of literal bytearray inside method/block 
	it should be forcible transfered by value
	because it is integral part of method"
	serverSideNetwork transferByReference: (Kind of: ByteArray). 
	
	self forkAndWait: [
		result := remotePeer evaluate: [ #[1 2 3] isSeamlessProxy ].
	]. 
 
	result should be: false
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testEvaluatingBlockWithNonLocalReturnOnRemoteSide [
	| remotePeer result |
	
	remotePeer := self connectToServerPeer.
	self forkAndWait: [		
		result := self evaluateBlockWithNonLocalReturn: #result by: remotePeer.
	]. 
 
	result should be: #result
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testEvaluatingBlockWithoutAnyReferencesOnRemoteSide [
	| remotePeer result |
	remotePeer := self connectToServerPeer.
	
	self forkAndWait: [
		result := remotePeer evaluate: [ 10 + 30 ].
	]. 
 
	result should equal: 40
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testEvaluatingCleanBlockTwice [
	| remotePeer result result2 |
	remotePeer := self connectToServerPeer.
	
	self forkAndWait: [
		result := remotePeer evaluate: [ 1 + 2].
		result2 := remotePeer evaluate: [ 1 + 3].
	]. 
 
	result should equal: 3.
	result2 should equal: 4
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testExecutingDoItWithGlobalReferenceOnRemoteObject [
 
	| remoteEnv remotePoint compiler result localResult |
	 
	self forkAndWait: [
		remoteEnv := clientSideNetwork environmentAt: self serverAddress.
		remotePoint := remoteEnv at: #Point.
		compiler := Point compiler
			source: '^Point x: 1 y: 3' readStream;
			context: nil;
			receiver: remotePoint.
			
		result := compiler evaluate.
		
		localResult := result asLocalObject.		
	].

	result should beInstanceOf: SeamlessProxy.
	localResult should equal: 1@3
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testExecutingReflectiveRemoteExecuteMethodWithProxyMethod [
 
	| remoteSmalltalk remoteString actual localResult method |
	method := String class lookupSelector: #name. 
	method seamlessDefaultTransferStrategy should be: SeamlessTransferStrategy defaultByReference.
	
	localResult := String withArgs: #() executeMethod: method.
	localResult should equal: String name.
		
	self forkAndWait: [
		remoteSmalltalk := clientSideNetwork environmentAt: self serverAddress.
		remoteString := remoteSmalltalk at: #String.
		actual := remoteString withArgs: #() executeMethod: method.
	].

	actual should equal: 'String'.
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testExecutingReflectiveRemoteExecuteMethodWithProxyMethodAndProxyArgs [
 
	| remoteSmalltalk remoteString actual args localResult method |
	args := Array with: 2 with: $s.
	args seamlessDefaultTransferStrategy should be: SeamlessTransferStrategy defaultByReference.
	method := (String class lookupSelector: #new:withAll:).
	method seamlessDefaultTransferStrategy should be: SeamlessTransferStrategy defaultByReference.
	
	localResult := String withArgs: args executeMethod: method.
	localResult should equal: 'ss'.
	
	self forkAndWait: [
		remoteSmalltalk := clientSideNetwork environmentAt: self serverAddress.
		remoteString := remoteSmalltalk at: #String.
		actual := remoteString withArgs: args executeMethod: method].

	actual should equal: 'ss'.
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testExecutingReflectiveRemotePerformMethodWithProxyArgumentsForInternalSelector [
 
	| args remoteSmalltalk remoteString actual localResult |
	args := Array with: 2 with: $s.
	args seamlessDefaultTransferStrategy should be: SeamlessTransferStrategy defaultByReference.
	
	localResult := String perform: #perform:withArguments: withArguments: {#new:withAll:. args }.
	localResult should equal: 'ss'.	
		
	self forkAndWait: [
		remoteSmalltalk := clientSideNetwork environmentAt: self serverAddress.
		remoteString := remoteSmalltalk at: #String.
		
		actual := remoteString perform: #perform:withArguments: withArguments: {#new:withAll:. args }
	].

	actual isSeamlessProxy should be: false.
	actual should equal: 'ss'.
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testExecutingRequestWhenConnectionCantBeEstablished [
	
	server stop.
	
	self forkAndWait: [
		[clientSideNetwork environmentAt: self serverAddress] should raise: ConnectionTimedOut
	]
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testFirstConnectionEstablishing [
 
	| remotePeer |
	remotePeer := self connectToServerPeer.
	self forkAndWait: [remotePeer openNewConnection].

	serverSideNetwork connectionCount should be: 1.
	clientSideNetwork connectionCount should be: 1
	
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testGettingArrayClassFromRemoteEnvironment [
 
	| result remoteClass remoteCollection remoteEnv |
			
	self forkAndWait: [
		remoteEnv := clientSideNetwork environmentAt: self serverAddress.
		remoteClass := remoteEnv at: #Array.
		remoteCollection := remoteClass new: 10 withAll: #testValue.
		result := remoteCollection at: 3 ifAbsent: [  ]  ].

	result should be: #testValue
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testGettingEnvironmentFromAddressWhenPassivePeerAlreadyExistsForIt [
 		
	| remoteEnv |
	self forkAndWait: [
		clientSideNetwork environmentAt: self serverAddress.
		"here serverside has passive peer which present client.
		Now we set up server to interract with client network and ask server network for the remote environment from client"
		server network: clientSideNetwork.
		remoteEnv := serverSideNetwork environmentAt: self serverAddress].

	remoteEnv isSeamlessProxy should be: true.
	serverSideNetwork remotePeers should haveSize: 1.
	serverSideNetwork remotePeers anyOne should beInstanceOf: BasysRemotePeer.
	serverSideNetwork remotePeers anyOne address should equal: self serverAddress.
	remoteEnv seamlessReference senderPeer should be: serverSideNetwork remotePeers anyOne.
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testGettingFalseClassFromRemoteEnvironment [
 
			
	| remoteEnv remoteClass |
	self forkAndWait: [
		remoteEnv := clientSideNetwork environmentAt: self serverAddress.
		remoteClass := remoteEnv at: #False].

	remoteClass should beInstanceOf: SeamlessProxy
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testGettingLargeInteger [
	| remotePeer result |
	remotePeer := self connectToServerPeer.

	self forkAndWait: [
		result := remotePeer evaluate: [ '3575740990698772000111222' asNumber ].
	]. 
 
	result should equal: 3575740990698772000111222
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testGettingLocalVariableStateWhenItHasValue [
	| remotePeer result state |
	self timeLimit: 10 minute.
	remotePeer := self connectToServerPeer.
	state := SeamlessLocalVariableState of: #remoteVar.
	state value: #varValue.
	state should not be isUnassigned.
	self forkAndWait: [ 
		result := remotePeer evaluate: [ state ].
	].
	result should beInstanceOf: SeamlessLocalVariableState.
	result value should be: #varValue.
	result remoteVariable should be isSeamlessProxy
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testGettingLocalVariableStateWhenItIsUnassigned [
	| remotePeer result state |
	self timeLimit: 10 minute.
	remotePeer := self connectToServerPeer.
	state := SeamlessLocalVariableState of: #remoteVar.
	state should be isUnassigned.
	self forkAndWait: [ 
		result := remotePeer evaluate: [ state ].
	].
	result should beInstanceOf: SeamlessLocalVariableState.
	result value should be: nil.
	result remoteVariable should be isSeamlessProxy
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testGettingMissingGlobal [
	| remotePeer result |
	remotePeer := self connectToServerPeer.

	self forkAndWait: [
		result := remotePeer evaluate: [ SeamlessMissingGlobal named: #unknownGlobalName ].
	]. 
 
	result should beInstanceOf: SeamlessMissingGlobal.
	result name should be: #unknownGlobalName
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testGettingMissingGlobalBackToClientWhereItExists [
	| remotePeer result |
	remotePeer := self connectToServerPeer.

	self forkAndWait: [
		result := remotePeer evaluate: [ SeamlessMissingGlobal named: #Point ].
	]. 
 
	result should be: Point
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testGettingMissingObjectAsPartOfAnotherObject [
	| remoteEnv point array |
	serverSideNetwork transferByReference: (Instance of: Point).
	serverSideNetwork transferByValue: (Instance of: Array).
	self forkAndWait: [
		remoteEnv := clientSideNetwork environmentAt: self serverAddress.
		point := (remoteEnv at: #Point) x: 10 y: 20.
		serverSideNetwork distributedObjects removeAt: point seamlessReference.
		
		array := (remoteEnv at: #Array) with: point.
	]. 

	array first should beInstanceOf: SeamlessMissingObject.
	array first reference should equal: point seamlessReference.
	serverSideNetwork distributedObjects should not be includesReference: point seamlessReference
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testGettingMissingObjectWhenServerLostReferencedOne [
 
	| remoteEnv actual |
	 
	self forkAndWait: [
		remoteEnv := clientSideNetwork environmentAt: self serverAddress.
		10 milliSeconds wait.
		serverSideNetwork removeDistributedObject: Smalltalk.
		serverSideNetwork distributedObjects should be isEmpty.
		actual := remoteEnv asLocalObject 
	]. 

	actual should beInstanceOf: SeamlessMissingObject.
	actual reference should equal: remoteEnv seamlessReference
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testGettingRemoteArrayByValueWhenItContentsShouldBeTransferedByReference [
 
	| remoteClass remoteCollection remoteEnv remoteRect |
	
	serverSideNetwork transferByReference: (Instance of: Rectangle).
	serverSideNetwork transferByValue: (Instance of: Array).
 
	self forkAndWait: [
		remoteEnv := clientSideNetwork environmentAt: self serverAddress.
		remoteClass := remoteEnv at: #Array.
		remoteRect := (remoteEnv at: #Rectangle) left: 0 right: 0 top: 20 bottom: 10.
		remoteCollection := remoteClass with: remoteRect ].

	remoteCollection should beInstanceOf: Array.
	remoteCollection first should beInstanceOf: SeamlessProxy 
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testGettingRemoteBlockWithGlobalsReferencesByValue [
	| remoteBlock localBlock transferedBlock |
	transferedBlock := [OrderedCollection with: 10].
	serverSideNetwork transferByReference: (Kind of: OrderedCollection).
	remoteBlock := self prepareClientProxyForServerObject: transferedBlock.
	
	self forkAndWait: [
		localBlock := remoteBlock asLocalObject
	]. 
 
	localBlock should beKindOf: BlockClosure.
	localBlock sourceNode formattedCode should equal: transferedBlock sourceNode formattedCode.
	localBlock value should equal: #(10) asOrderedCollection 
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testGettingRemoteBlockWithoutObjectReferencesByValue [
	| remoteBlock localBlock transferedBlock |
	transferedBlock := [ 1 + 2 ].
	remoteBlock := self prepareClientProxyForServerObject: transferedBlock.
	
	self forkAndWait: [
		localBlock := remoteBlock asLocalObject
	]. 
 
	localBlock should beKindOf: BlockClosure.
	localBlock sourceNode formattedCode should equal: transferedBlock sourceNode formattedCode.
	localBlock value should equal: 3
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testGettingRemoteClassBinding [
 
	| result remoteClass remoteEnv |
			
	self forkAndWait: [
		remoteEnv := clientSideNetwork environmentAt: self serverAddress.
		remoteClass := remoteEnv at: #Rectangle.
		result := remoteClass binding  ].

	result should beInstanceOf: Rectangle binding class.
	result key should equal: Rectangle binding key.
	result value should beInstanceOf: SeamlessProxy 
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testGettingRemoteCleanBlockByValueShouldProxifyOuterContextSender [
	| remoteBlock localBlock transferredBlock |
	transferredBlock := [ 1 + 2 ].
	remoteBlock := self prepareClientProxyForServerObject: transferredBlock.
	
	self forkAndWait: [
		localBlock := remoteBlock asLocalObject
	]. 
 
	localBlock should beKindOf: BlockClosure.
	localBlock outerContext should beInstanceOf: Context.
	localBlock outerContext sender should beInstanceOf: SeamlessProxy.
	localBlock home should be: localBlock outerContext outerMostContext.
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testGettingRemoteCleanBlockWithNestedOuterContextsByValue [
	| remoteBlock localBlock |
	[remoteBlock := self prepareClientProxyForServerObject: [ 1 + 2 ] ] value.

	self forkAndWait: [
		localBlock := remoteBlock asLocalObject
	]. 
 
	localBlock should beKindOf: BlockClosure.
	
	localBlock outerContext should beInstanceOf: Context.
	localBlock outerContext outerContext should beInstanceOf: Context.
	localBlock outerContext sender should be: nil.
	localBlock value should be: 3.
	localBlock home should be: localBlock outerContext outerMostContext.
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testGettingRemoteFormByValue [
 
	| remoteClass remoteEnv form |
	 
	self forkAndWait: [
		remoteEnv := clientSideNetwork environmentAt: self serverAddress.
		Rectangle systemIcon unhibernate.
		remoteClass := remoteEnv at: #Rectangle.
		form := remoteClass systemIcon asLocalObject].

	form should beInstanceOf: Form.
	form bits should beInstanceOf: Bitmap 
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testGettingRemoteNotCleanBlockByValueShouldPassOuterContextsAsValueButItSenderAsReference [
	| remoteBlock localBlock transferredBlock |
	transferredBlock := [ true ifFalse: [^self]. 1 + 2 ].
	transferredBlock should not be isClean.	
	remoteBlock := self prepareClientProxyForServerObject: transferredBlock.
	
	self forkAndWait: [
		localBlock := remoteBlock asLocalObject
	]. 
 
	localBlock should beKindOf: BlockClosure.
	localBlock outerContext should beInstanceOf: Context.
	localBlock outerContext sender should beInstanceOf: SeamlessProxy.
	localBlock home should be: localBlock outerContext outerMostContext.
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testGettingRemoteNotCleanBlockWithNestedOuterContextsByValue [
	| remoteBlock localBlock |
	[remoteBlock := self prepareClientProxyForServerObject: [true ifFalse: [^self]. 1 + 2 ] ] value.

	self forkAndWait: [
		localBlock := remoteBlock asLocalObject
	]. 
 
	localBlock should beKindOf: BlockClosure.
	localBlock outerContext should beInstanceOf: Context.
	localBlock outerContext outerContext should beInstanceOf: Context.
	localBlock outerContext outerContext sender should beInstanceOf: SeamlessProxy.
	localBlock value should be: 3.
	localBlock home should be: localBlock outerContext outerMostContext.
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testGettingRemoteObjectAsDeepCopy [
 
	| remoteEnv result remoteClass |
	
	serverSideNetwork transferByDeepCopy: (Instance of: Rectangle).
	
	self forkAndWait: [
		remoteEnv := clientSideNetwork environmentAt: self serverAddress.
		remoteClass := remoteEnv at: #Rectangle.
		result := remoteClass left: 0 right: 10 top: 0 bottom: 20].

	result should beInstanceOf: Rectangle.
	result origin should beInstanceOf: Point.
	result corner should beInstanceOf: Point.
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testGettingRemoteObjectAsDeepCopyWhichReferencesProxyToClientObject [
 
	| result remoteObject localPoint remoteObjectProxy wrapperProxy |
	remoteObject := OrderedCollection with: 1@2.
	localPoint := 3@4.
	serverSideNetwork transferByDeepCopy: (Identical to: remoteObject).
	serverSideNetwork transferByReference: (Instance of: Point).
	clientSideNetwork transferByReference: (Instance of: Point).
	remoteObjectProxy := self prepareClientProxyForServerObject: remoteObject.
	wrapperProxy := self prepareClientProxyForServerObject: {remoteObject}.
	
	self forkAndWait: [
		remoteObjectProxy add: localPoint.
		result := wrapperProxy asLocalObject first].

	result should beInstanceOf: OrderedCollection.
	result first should beInstanceOf: Point.
	result first should equal: 1@2.
	result last should be: localPoint.
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testGettingRemoteObjectAsReferencedCopy [
 
	| remoteEnv point remoteArray returnedOriginalPoint serverSideArray remoteClass |
	
	clientSideNetwork transferByReferencedCopy:  (Instance of: Point).
	point := 2@3.	
	self forkAndWait: [
		remoteEnv := clientSideNetwork environmentAt: self serverAddress.
		remoteClass := remoteEnv at: #Array.		
		remoteArray := remoteClass with: point.		
		returnedOriginalPoint := remoteArray first].

	returnedOriginalPoint should be: point.
	returnedOriginalPoint should equal: 2@3.
	serverSideArray := serverSideNetwork objectFor: remoteArray seamlessReference.
	serverSideArray first should not beInstanceOf: SeamlessProxy.
	serverSideArray first should equal: point.
	serverSideArray first should not be: point
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testGettingRemoteObjectAsReferencedCopyWhenByDefaultSuchClassesTransferredByReference [
 
	| remoteEnv point remoteArray returnedOriginalPoint serverSideArray remoteClass |
	point := 2@3.
	clientSideNetwork transferByReferencedCopy: (Identical to: point).
	clientSideNetwork transferByReference: (Kind of: Point).
	serverSideNetwork transferByReference: (Kind of: Point).
		
	self forkAndWait: [
		remoteEnv := clientSideNetwork environmentAt: self serverAddress.
		remoteClass := remoteEnv at: #Array.
		remoteArray := remoteClass with: point.
		returnedOriginalPoint := remoteArray first].

	returnedOriginalPoint should be: point.
	serverSideArray := serverSideNetwork objectFor: remoteArray seamlessReference.
	serverSideArray first should not beInstanceOf: SeamlessProxy.
	serverSideArray first should equal: point.
	serverSideArray first should not be: point
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testGettingRemoteObjectAsReferencedCopyWhenInternalIncludedReferenceHasCachedData [
 
	| remoteEnv point remoteContainer serverSideContainer remoteClass array returnedOriginalArray serverSideArray |
	
	point := 2@3.
	array := { point }.
	clientSideNetwork transferByReferencedCopy: (Identical to: array).
	clientSideNetwork transferByReference: (Identical to: point) withCacheFor: #(abs).
		
	self forkAndWait: [
		remoteEnv := clientSideNetwork environmentAt: self serverAddress.
		remoteClass := remoteEnv at: #Array.
		
		remoteContainer := remoteClass with: array.		
		returnedOriginalArray := remoteContainer first].

	returnedOriginalArray should be: array.
	returnedOriginalArray first should be: point.
	serverSideContainer := serverSideNetwork objectFor: remoteContainer seamlessReference.
	serverSideArray := serverSideContainer first.
	serverSideArray should not beInstanceOf: SeamlessProxy.
	serverSideArray first should beInstanceOf: SeamlessProxy.
	serverSideArray first seamlessReference messagesCache should includeKey: #abs
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testGettingRemoteObjectAsReferencedCopyWhenInternalObjectsShouldBeTransferredByValue [
 
	| remoteEnv point remoteContainer serverSideContainer remoteClass array returnedOriginalArray serverSideArray |
	
	point := 2@3.
	array := { point }.
	clientSideNetwork transferByReferencedCopy: (Identical to: array).
	clientSideNetwork transferByValue: (Kind of: Point).
	serverSideNetwork transferByValue: (Kind of: Point).
		
	self forkAndWait: [
		remoteEnv := clientSideNetwork environmentAt: self serverAddress.
		remoteClass := remoteEnv at: #Array.
		
		remoteContainer := remoteClass with: array.		
		returnedOriginalArray := remoteContainer first].

	returnedOriginalArray should be: array.
	returnedOriginalArray first should be: point.
	serverSideContainer := serverSideNetwork objectFor: remoteContainer seamlessReference.
	serverSideArray := serverSideContainer first.
	serverSideArray should not beInstanceOf: SeamlessProxy.
	serverSideArray first should not beInstanceOf: SeamlessProxy.
	serverSideArray first should equal: point.
	serverSideArray first should not be: point.
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testGettingRemoteObjectAsReferencedCopyWhenItHasInternalReferenceToItself [
 
	| remoteEnv remoteArray serverSideArray remoteClass child original returnedOriginal serverSideCopy |
	clientSideNetwork transferByValue:  (Instance of: SeamlessTestContainer2).
	clientSideNetwork transferByReferencedCopy:  (Instance of: SeamlessTestContainer).
	child := SeamlessTestContainer2 named: 'child' with: nil.
	original := SeamlessTestContainer named: 'root' with: child.
	child content: original.
		
	self forkAndWait: [
		remoteEnv := clientSideNetwork environmentAt: self serverAddress.
		remoteClass := remoteEnv at: #Array.		
		remoteArray := remoteClass with: original.		
		returnedOriginal := remoteArray first].

	returnedOriginal should be: original.
	returnedOriginal name should equal: 'root'.
	returnedOriginal content should beInstanceOf: SeamlessTestContainer2.
	returnedOriginal content name should equal: 'child'.
	returnedOriginal content content should be: returnedOriginal.
	serverSideArray := serverSideNetwork objectFor: remoteArray seamlessReference.
	serverSideCopy := serverSideArray first.
	serverSideCopy should not beInstanceOf: SeamlessProxy.
	serverSideCopy should not be: original.
	serverSideCopy name should equal: 'root'.
	serverSideCopy content should beInstanceOf: SeamlessTestContainer2.
	serverSideCopy content name should equal: 'child'.
	serverSideCopy content content should be: serverSideCopy
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testGettingRemoteObjectAsReferencedCopyWhenItIncludesOtherReferences [
 
	| remoteEnv point remoteContainer serverSideContainer remoteClass array returnedOriginalArray serverSideArray |
	
	point := 2@3.
	array := { point }.
	clientSideNetwork transferByReferencedCopy: (Identical to: array).
	clientSideNetwork transferByReference: (Instance of: Point).
	serverSideNetwork transferByReference: (Instance of: Point).	
		
	self forkAndWait: [
		remoteEnv := clientSideNetwork environmentAt: self serverAddress.
		remoteClass := remoteEnv at: #Array.
		remoteContainer := remoteClass with: array.
		returnedOriginalArray := remoteContainer first].

	returnedOriginalArray should be: array.
	returnedOriginalArray first should be: point.
	serverSideContainer := serverSideNetwork objectFor: remoteContainer seamlessReference.
	serverSideArray := serverSideContainer first.
	serverSideArray should not beInstanceOf: SeamlessProxy.
	serverSideArray first should beInstanceOf: SeamlessProxy.
	

]

{ #category : #tests }
SeamlessRealCommunicationTests >> testGettingRemoteObjectAsReferencedCopyWhenNextReferenceIsValue [
 
	| remoteEnv point remoteArray remoteClass returnedOriginalArray |
	serverSideNetwork transferByValue: (Instance of: Array).	
	clientSideNetwork transferByValue: (Instance of: Array).
	clientSideNetwork transferByReferencedCopy: (Instance of: Point).
	point := 2@3.	
	self forkAndWait: [.
		remoteEnv := clientSideNetwork environmentAt: self serverAddress.
		remoteClass := remoteEnv at: #Array.
		remoteArray := remoteClass with: {point. #secondValue}.		
		returnedOriginalArray := remoteArray first].

	returnedOriginalArray should beInstanceOf: Array.
	returnedOriginalArray first should be: point.
	returnedOriginalArray last should be: #secondValue
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testGettingRemoteObjectWithDeepCopyReferenceAndNormalOne [
 
	| result proxy |	
	serverSideNetwork transferByDeepCopy: (Instance of: Rectangle).
	serverSideNetwork transferByReference: (Instance of: Point).
	proxy := self prepareClientProxyForServerObject: { 0@0 corner: 2@3. 4@5 }.
	
	self forkAndWait: [
		result := proxy asLocalObject].

	result should beInstanceOf: Array.
	result first origin should beInstanceOf: Point.
	result first corner should beInstanceOf: Point.
	result last should beInstanceOf: SeamlessProxy
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testGettingRemoteObjectWithDeepCopyReferenceWhenFirstItAppearsInsideAnotherRoute [
 
	| result proxy target |
	
	serverSideNetwork transferByDeepCopy: (Instance of: Rectangle).
	serverSideNetwork transferByValue: (Instance of: Array).
	target := 0@0 corner: 2@3.
	proxy := self prepareClientProxyForServerObject: { { target }. target }.
	
	self forkAndWait: [
		result := proxy asLocalObject].

	result should beInstanceOf: Array.
	result first should beInstanceOf: Array.
	result last should beInstanceOf: Rectangle.
	result last origin should beInstanceOf: Point.
	result last corner should beInstanceOf: Point.
	result first first should be: result last
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testGettingRemoteOrderedCollectionByReference [
 
	| remoteClass remoteCollection remoteEnv |
	
	serverSideNetwork transferByReference: (Instance of: OrderedCollection).
	
	self forkAndWait: [
		remoteEnv := clientSideNetwork environmentAt: self serverAddress.
		remoteClass := remoteEnv at: #OrderedCollection.
		remoteCollection := remoteClass new: 3 withAll: #testValue ].

	remoteCollection should beInstanceOf: SeamlessProxy 
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testGettingRemoteOrderedCollectionByValueWhenItContentsPrimitiveObjects [
 
	| remoteClass remoteCollection remoteEnv |
	
	serverSideNetwork transferByValue: (Instance of: OrderedCollection).
	
	self forkAndWait: [
		remoteEnv := clientSideNetwork environmentAt: self serverAddress.
		remoteClass := remoteEnv at: #OrderedCollection.
		remoteCollection := remoteClass new: 3 withAll: #testValue ].

	remoteCollection should not be isSeamlessProxy.
	"Fuel always transfers internal array of OrderedCollection as value"
	(remoteCollection instVarNamed: 'array') should not be isSeamlessProxy.
	remoteCollection should equal: #(testValue testValue testValue)
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testGettingRemoteOrderedCollectionByValueWhenItContentsShouldBeTransferedByReference [
 
	| remoteClass remoteCollection remoteEnv remoteRect |	
	serverSideNetwork transferByReference: (Instance of: Rectangle).
	serverSideNetwork transferByValue: (Instance of: OrderedCollection).
 
	self forkAndWait: [
		remoteEnv := clientSideNetwork environmentAt: self serverAddress.
		remoteClass := remoteEnv at: #OrderedCollection.
		remoteRect := (remoteEnv at: #Rectangle) left: 0 right: 0 top: 20 bottom: 10.
		remoteCollection := remoteClass with: remoteRect ].

	remoteCollection should beInstanceOf: OrderedCollection.
	remoteCollection first should beInstanceOf: SeamlessProxy 
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testGettingRemoteSetByValueWhenItContentsShouldBeTransferedByReference [
 
	| remoteClass remoteCollection remoteEnv remoteRect |
	
	serverSideNetwork transferByReference: (Instance of: Rectangle).
	serverSideNetwork transferByValue: (Instance of: Set).
 
	self forkAndWait: [
		remoteEnv := clientSideNetwork environmentAt: self serverAddress.
		remoteClass := remoteEnv at: #Set.
		remoteRect := (remoteEnv at: #Rectangle) left: 0 right: 0 top: 20 bottom: 10.
		remoteCollection := remoteClass with: remoteRect ].

	remoteCollection should beInstanceOf: Set.
	remoteCollection anyOne should beInstanceOf: SeamlessProxy 
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testGettingSmallInteger [
	| remotePeer result |
	remotePeer := self connectToServerPeer.

	self forkAndWait: [
		result := remotePeer evaluate: [ '357574' asNumber ].
	]. 
 
	result should equal: 357574
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testGettingTrueClassFromRemoteEnvironment [
 
			
	| remoteEnv remoteClass |
	self forkAndWait: [
		remoteEnv := clientSideNetwork environmentAt: self serverAddress.
		remoteClass := remoteEnv at: #True].

	remoteClass should beInstanceOf: SeamlessProxy
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testGettingUndefinedObjectClassFromRemoteEnvironment [
 
			
	| remoteEnv remoteClass |
	self forkAndWait: [
		remoteEnv := clientSideNetwork environmentAt: self serverAddress.
		remoteClass := remoteEnv at: #UndefinedObject].

	remoteClass should beInstanceOf: SeamlessProxy
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testGettingWellKnownGlobal [
	| remotePeer result |
	remotePeer := self connectToServerPeer.
	serverSideNetwork addTransferStrategy: (SeamlessTransferByGlobalNameStrategy for: (Identical to: Point)).

	self forkAndWait: [
		result := remotePeer evaluate: [ #Point asClass  ].
	]. 
 
	result should be: Point
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testLoadingRemoteObjectByProxyAsLocalDeepCopy [
 
	| proxy result distributedObject |
	distributedObject := {10@20}.
	serverSideNetwork transferByReference: (Instance of: Point).
	proxy := self prepareClientProxyForServerObject: distributedObject.
	
	self forkAndWait: [ result := proxy asLocalDeepCopy].

	result should equal: distributedObject
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testLoadingRemoteObjectByProxyAsLocalOne [
 
	| proxy result distributedObject |
	distributedObject := #(array).
	proxy := self prepareClientProxyForServerObject: distributedObject.
	
	self forkAndWait: [ result := proxy asLocalObject].

	result should equal: distributedObject
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testMessageSelfSendShouldUnregisterContextObjectsAtTheEnd [
 
	| remotePeer sendingContext  |
	remotePeer := serverSideNetwork remotePeerAt: self serverAddress.
	
	self forkAndWait: [
		sendingContext := remotePeer createSyncRequestContext.
		sendingContext sendMessage: (MessageSend receiver: 1 selector: #+ argument: 2)].

	serverSideNetwork distributedObjects should be isEmpty
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testMessageSelfSendWithArgumentProxy [
 
	| remotePeer sendingContext result proxy |
	remotePeer := serverSideNetwork remotePeerAt: self serverAddress.
	proxy := self prepareClientProxyForServerObject: 2.
	
	self forkAndWait: [
		sendingContext := remotePeer createSyncRequestContext.
		result := sendingContext sendMessage: (MessageSend receiver: 1 selector: #+ argument: proxy)].

	result should be: 3
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testMessageSelfSendWithReceiverProxy [
 
	| remotePeer sendingContext result reference |
	remotePeer := serverSideNetwork remotePeerAt: self serverAddress.
	reference := self prepareClientProxyForServerObject: 1.
	
	self forkAndWait: [
		sendingContext := remotePeer createSyncRequestContext.
		result := sendingContext sendMessage: (MessageSend receiver: reference selector: #+ argument: 2)].

	result should be: 3
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testMessageSelfSendWithoutProxies [
 
	| remotePeer sendingContext result |
	remotePeer := serverSideNetwork remotePeerAt: self serverAddress.
	
	self forkAndWait: [
		sendingContext := remotePeer createSyncRequestContext.
		result := sendingContext sendMessage: (MessageSend receiver: 1 selector: #+ argument: 2)].

	result should be: 3
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testRemoteEnvironmentInteraction [
 
	| result remoteClass remoteCollection remoteEnv |
			
	self forkAndWait: [
		remoteEnv := clientSideNetwork environmentAt: self serverAddress.
		remoteClass := remoteEnv at: #OrderedCollection.
		remoteCollection := remoteClass new: 10 withAll: #testValue.
		result := remoteCollection at: 3 ifAbsent: [  ]  ].

	result should be: #testValue
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testRemoteMessageShouldNotDistributeLocalPeerInstance [
 	
	| remoteEnv |
	self forkAndWait: [
		remoteEnv := clientSideNetwork environmentAt: self serverAddress.
		remoteEnv at: #String].

	serverSideNetwork distributedObjects objectsToReferences should not includeKey: serverSideNetwork localPeer.
	clientSideNetwork distributedObjects objectsToReferences should not includeKey: clientSideNetwork localPeer

]

{ #category : #tests }
SeamlessRealCommunicationTests >> testRemoteMessageShouldNotDistributeRemotePeerInstance [
 	
	| remoteEnv |
	self forkAndWait: [
		remoteEnv := clientSideNetwork environmentAt: self serverAddress.
		remoteEnv at: #String].

	serverSideNetwork distributedObjects objectsToReferences should not includeKey: serverSideNetwork remotePeers anyOne.
	clientSideNetwork distributedObjects objectsToReferences should not includeKey: clientSideNetwork remotePeers anyOne

]

{ #category : #tests }
SeamlessRealCommunicationTests >> testRemoteMessageShouldUnregisterContextObjectsAtTheEnd [
 
	| remotePeer sendingContext  |
	remotePeer := self connectToServerPeer.
	
	self forkAndWait: [
		sendingContext := remotePeer createSyncRequestContext.
		sendingContext sendMessage: (MessageSend receiver: 1 selector: #+ argument: 2)].

	serverSideNetwork distributedObjects should be isEmpty.
	clientSideNetwork distributedObjects should be isEmpty.
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testRemoteMessageToRemoteCollectionWithBlockWithNonLocalReturn [
	| remotePeer result remoteArray |
	
	remotePeer := self connectToServerPeer.
	remoteArray := self prepareClientProxyForServerObject: {0@0 corner: 2@3. 0@0 corner: 1@1}.
	
	self forkAndWait: [
		result := self calculateFirstRectAreaByNonLocalReturn: remoteArray from: remotePeer
	].

	result should equal: 6
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testRemoteMessageToRemoteCollectionWithCleanBlock [
	| remotePeer sendingContext result remoteArray |
	
	remotePeer := self connectToServerPeer.
	remoteArray := self prepareClientProxyForServerObject: {0@0 corner: 1@1. 0@0 corner: 2@3}.
	
	self forkAndWait: [
		sendingContext := remotePeer createSyncRequestContext.
		result := sendingContext sendMessage: (MessageSend 
			receiver: remoteArray selector: #sum: arguments: {[ :each | each area ]})
	].

	result should equal: 1 + 6
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testRemoteMessageWhichProducesNonLocalReturn [
	"Printing contents by stream with limited size is implemented by non local return from block like [^stream contents]. 
	In this test we pass local block to remote proxy. On remote side limited stream will be created and passed as proxy to our local block. 
	When on our side we will write to much content on this stream and non local return will happen on remote side. This test show that such cases is covered by seamless"
	| remotePeer sendingContext remoteString result |
	
	remotePeer := self connectToServerPeer.
	remoteString := self prepareClientProxyForServerObject: String.
	
	self forkAndWait: [
		sendingContext := remotePeer createSyncRequestContext.
		result := sendingContext sendMessage: (MessageSend 
			receiver: remoteString selector: #streamContents:limitedTo: arguments: {
				[ :s | s nextPutAll: '12345' ]. 3})
	].

	result should equal: '123'
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testRemoteMessageWhichRaisesError [ 
	| remotePeer sendingContext error localError proxy |
	
	remotePeer := self connectToServerPeer.
	error := ZeroDivide new messageText: 'test error'.
	proxy := self prepareClientProxyForServerObject: [ error signal ].
	
	self forkAndWait: [
		sendingContext := remotePeer createSyncRequestContext.
		[sendingContext sendMessage: (MessageSend receiver: proxy selector: #value)]
			on: SeamlessRemoteException do: [:err | localError := err]].

	localError messageText should equal: error printString
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testRemoteMessageWithArgumentProxy [
 
	| remotePeer sendingContext result clientSideProxy |
	remotePeer := self connectToServerPeer.
	clientSideProxy := self prepareClientProxyForServerObject: 2.
	
	self forkAndWait: [
		sendingContext := remotePeer createSyncRequestContext.
		result := sendingContext sendMessage: (MessageSend receiver: 1 selector: #+ argument: clientSideProxy)].

	result should be: 3
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testRemoteMessageWithExplicitArgumentByDeepCopy [
 	
	| remoteEnv remoteArray createdArray remoteClass |
	clientSideNetwork transferByReference: (Kind of: Point).
	clientSideNetwork transferByReference: (Instance of: Array).
	
	self forkAndWait: [
		remoteEnv := clientSideNetwork environmentAt: self serverAddress.
		remoteClass := remoteEnv at: #Array.
		remoteArray := remoteClass with: {10@30} asTransferredByDeepCopy
	].
	
	createdArray := serverSideNetwork objectFor: remoteArray seamlessReference.
	createdArray first should beInstanceOf: Array.
	createdArray first first should beInstanceOf: Point.
	createdArray should equal: { {10@30} }
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testRemoteMessageWithExplicitArgumentByValue [
 	
	| remoteEnv remoteArray localArray |
	clientSideNetwork transferByReference: (Kind of: Point).
	
	self forkAndWait: [
		remoteEnv := clientSideNetwork environmentAt: self serverAddress.
		remoteArray := (remoteEnv at: #Array) with: (10@30) asTransferredByValue.
		localArray := remoteArray asLocalObject].

	localArray first should beInstanceOf: SeamlessProxy
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testRemoteMessageWithReceiverProxy [
 
	| remotePeer sendingContext result clientSideProxy |
	remotePeer := self connectToServerPeer.
	clientSideProxy := self prepareClientProxyForServerObject: 1.
	
	self forkAndWait: [
		sendingContext := remotePeer createSyncRequestContext.
		result := sendingContext sendMessage: (MessageSend receiver: clientSideProxy selector: #+ argument: 2)].

	result should be: 3
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testRemoteMessageWithoutProxies [
 
	| remotePeer sendingContext result |
	remotePeer := self connectToServerPeer.
	
	self forkAndWait: [
		sendingContext := remotePeer createSyncRequestContext.
		result := sendingContext sendMessage: (MessageSend receiver: 1 selector: #+ argument: 2)].

	result should be: 3
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testSelfConnectingToLocalPeer [
 
	| remotePeer |
	remotePeer := serverSideNetwork remotePeerAt: self serverAddress.
	self forkAndWait: [remotePeer openNewConnection].

	serverSideNetwork connectionCount should be: 2.
	serverSideNetwork remotePeers should haveSize: 1.
	serverSideNetwork remotePeers anyOne should beInstanceOf: BasysRemotePeer.
	serverSideNetwork remotePeers anyOne should isActive
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testSendingCachedMessageToRemoteProxy [
 
	| proxy result1 result2 rnd |
	serverSideNetwork transferByReference: (Kind of: Random) withCacheFor: #(next).

	proxy := self prepareClientProxyForServerObject: Random.
	
	self forkAndWait: [
		rnd := proxy new.
		result1 := rnd next.
		result2 := rnd next].

	result1 should be: result2
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testSendingCachedMessageToRemoteProxyShouldConvertCachedResultReferencesIntoProxy [
 
	| proxy rnd result |
	serverSideNetwork transferByReference: (Kind of: Random) withCacheFor: #(initialize). 
	"initialize returns Random instance itself. Random instance will be transferred by reference.
	It means that cached result of #initialize will transferred as reference too. 
	Right logic to prepare received references should analyze it cached messages 
	and convert internal references to proxies"
	proxy := self prepareClientProxyForServerObject: Random.
	
	self forkAndWait: [
		rnd := proxy new.
		result := rnd initialize].

	result should be: rnd
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testSendingCachedMessageToRemoteProxyShouldScanCachedResultsForTransfer [
 
	| proxy result testString |
	serverSideNetwork transferByReference: 'TEST STRING' asStateSpec. 
	serverSideNetwork transferByReference: 'test string' asStateSpec withCacheFor: #(asUppercase). 
	"When 'test string' will be transfered to client as reference it will cache uppercase version. 
	But we want 'TEST STRING' be transfered to client as reference too. 
	To achive this ObjectTransporter should scan cachedMessages of transferred references"
	proxy := self prepareClientProxyForServerObject: 'test'.
	
	self forkAndWait: [
		testString := proxy , ' string'.
		result := testString asUppercase].

	result should beInstanceOf: SeamlessProxy.
	result asLocalObject should equal: 'TEST STRING'.
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testSendingCachedMessageToRemoteProxyWhenAllConnectionsAreClosed [
 
	| proxy result rnd |
	serverSideNetwork transferByReference: (Kind of: Random) withCacheFor: #(next).

	proxy := self prepareClientProxyForServerObject: Random.
	
	self forkAndWait: [
		rnd := proxy new.
		serverSideNetwork close.
		result := rnd next].

	result should not be: nil
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testSendingClientProxyFromServerToClient [
	"this tests cover case when we have two network instances on same image
	and we try to send client side proxy from server to client"
	| transferedObject remoteProxy serverSidePeer clientEnv  remotePeer actualArrayOnServer remoteArrayOnServer |
	transferedObject := 'test'.
	remotePeer := self connectToServerPeer.
	remoteProxy := self prepareClientProxyForServerObject: transferedObject.
	
	self forkAndWait: [
		remotePeer openNewConnection.
		serverSidePeer := serverSideNetwork remotePeers anyOne.
		clientEnv := serverSidePeer remoteEnvironment.
		remoteArrayOnServer := (clientEnv at: #Array) with: remoteProxy. "it will lead to request from server to client with client proxy as parameter"
		actualArrayOnServer := remoteArrayOnServer asLocalObject.
	]. 
 
	actualArrayOnServer should beInstanceOf: Array.
	actualArrayOnServer first should be: transferedObject
	
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testSendingMessageToProxyWhichIsNotExistsAnymoreInsideClientDistributedObjects [
 
	| remoteEnv |
	 
	self forkAndWait: [
		remoteEnv := clientSideNetwork environmentAt: self serverAddress.
		10 milliSeconds wait.
		clientSideNetwork removeDistributedObject: remoteEnv.
		clientSideNetwork distributedObjects should be isEmpty.
		[ remoteEnv at: #Rectangle ] should not fail
	]
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testSendingMessageToProxyWhichIsNotExistsAnymoreInsideServerDistributedObjects [
 
	| remoteEnv |
	 
	self forkAndWait: [
		remoteEnv := clientSideNetwork environmentAt: self serverAddress.
		10 milliSeconds wait.
		serverSideNetwork removeDistributedObject: Smalltalk.
		serverSideNetwork distributedObjects should be isEmpty.
		[ remoteEnv at: #Rectangle ] should raise: SeamlessReferencedObjectIsLost 
	]
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testSendingMessageToRemoteProxy [
 
	| proxy result |	
	proxy := self prepareClientProxyForServerObject: 'test'. 
	
	self forkAndWait: [ result := proxy , ' extra'].

	result should equal: 'test extra'
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testSendingMessageToRemoteProxyWhenTwoConnectionsExist [
 
	| proxy result |	
	proxy := self prepareClientProxyForServerObject: 'test'. 
	
	self forkAndWait: [
		proxy remotePeer openNewConnection; openNewConnection.
		result := proxy , ' extra'].

	result should equal: 'test extra'
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testTwiceConnectionEstablishing [
 
	| remotePeer |
	remotePeer := self connectToServerPeer.
	self forkAndWait: [
		remotePeer openNewConnection.
		remotePeer openNewConnection].

	serverSideNetwork connectionCount should be: 2.
	clientSideNetwork connectionCount should be: 2
	
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testTwoConnectionsToServerFromDifferentLocalPeers [
 
	| remotePeerForClient1 client2Network remotePeerForClient2 |
	remotePeerForClient1 := self connectToServerPeer.
	client2Network := self networkClass new.
	remotePeerForClient2 := client2Network remotePeerAt: self serverAddress.
	self forkAndWait: [remotePeerForClient1 openNewConnection. 
			remotePeerForClient2 openNewConnection].

	serverSideNetwork connectionCount should be: 2.
	serverSideNetwork remotePeers should haveSize: 2.
	serverSideNetwork remotePeers first connectionCount should be: 1.
	serverSideNetwork remotePeers last connectionCount should be: 1.	
]

{ #category : #tests }
SeamlessRealCommunicationTests >> testTwoConnectionsToServerFromSameLocalPeer [
 
	| remotePeer |
	remotePeer := self connectToServerPeer.
	self forkAndWait: [remotePeer openNewConnection; openNewConnection].

	serverSideNetwork connectionCount should be: 2.
	clientSideNetwork connectionCount should be: 2.
	serverSideNetwork remotePeers should haveSize: 1
	
]
