Class {
	#name : #SeamlessObjectReferenceTests,
	#superclass : #SeamlessObjectReferenceTestCase,
	#category : 'Seamless-Tests'
}

{ #category : #running }
SeamlessObjectReferenceTests >> referenceClass [
	^SeamlessObjectReference
]

{ #category : #tests }
SeamlessObjectReferenceTests >> testFillingMessagesCache [

	reference cacheMessage: #someMessage with: #result.
	 
	reference messagesCache should include: #result at: #someMessage
]

{ #category : #tests }
SeamlessObjectReferenceTests >> testLoadingRealObject [

	[ :requestContext |
		
		peer stub createSyncRequestContext willReturn: requestContext.
		(requestContext stub sendRequest: Arg request) willReturn: #result.
		
		(reference loadObject: #proxy) should be: #result.
	
		Arg request should beInstanceOf: SeamlessLoadObjectRequest.
		Arg request objectProxy should be: #proxy.
	 ] runWithMocks 
]

{ #category : #tests }
SeamlessObjectReferenceTests >> testLoadingRealObjectAsDeepCopy [

	[ :requestContext |
		
		peer stub createSyncRequestContext willReturn: requestContext.
		(requestContext stub sendRequest: Arg request) willReturn: #result.
		
		(reference loadDeepCopy: #proxy) should be: #result.
	
		Arg request should beInstanceOf: SeamlessLoadDeepCopyRequest.
		Arg request objectProxy should be: #proxy.
	 ] runWithMocks 
]

{ #category : #tests }
SeamlessObjectReferenceTests >> testPerformAndCacheRemoteMessage [

	| messageSend |
	[ :requestContext |
		messageSend := MessageSend receiver: #receiver selector: #selector.		
		peer stub createSyncRequestContext willReturn: requestContext.
		(requestContext stub sendMessage: messageSend) willReturn: #result.
		
		(reference performAndCacheRemoteMessage: messageSend) should be: #result.	
		reference messagesCache should include: #result at: #selector.
		
	 ] runWithMocks 
]

{ #category : #tests }
SeamlessObjectReferenceTests >> testPerformAndCacheRemoteMessageWhenItCached [

	reference cacheMessage: #someMessage with: #result.
	
	(reference performAndCacheRemoteMessage: (Message selector: #someMessage)) should be: #result
]

{ #category : #tests }
SeamlessObjectReferenceTests >> testPerformRemoteMessage [

	[ :requestContext |
		peer stub createSyncRequestContext willReturn: requestContext.
		(requestContext stub sendMessage: #messageSend) willReturn: #result.
		
		(reference performRemoteMessage: #messageSend) should be: #result.			
	
	 ] runWithMocks 
]

{ #category : #tests }
SeamlessObjectReferenceTests >> testPerformRemoteMessageWhenItCached [

	reference cacheMessage: #someMessage with: #result.
	
	(reference performRemoteMessage: (Message selector: #someMessage)) should be: #result
]

{ #category : #tests }
SeamlessObjectReferenceTests >> testProxyCreation [

	| proxy |
	proxy := reference createProxy.

	proxy isSeamlessProxy should be: true
]

{ #category : #tests }
SeamlessObjectReferenceTests >> testTravelingWhenAbsentCache [

	| guide |
	guide := reference travelGuide.

	guide should not be isNodeEmpty: reference.
	guide should be isNode: reference hasLastReferenceAt: 1.
	guide should not be isNode: reference hasLastReferenceAt: 0.
]

{ #category : #tests }
SeamlessObjectReferenceTests >> testTravelingWhenEmptyCache [

	| guide |
	reference messagesCache: Dictionary new.
	
	guide := reference travelGuide.

	guide should not be isNodeEmpty: reference.
	guide should be isNode: reference hasLastReferenceAt: 1
]

{ #category : #tests }
SeamlessObjectReferenceTests >> testTravelingWhenThereAreCachedMessages [

	| guide |
	reference cacheMessage: #message1 with: #result1.
	reference cacheMessage: #message2 with: #result2.
	
	guide := reference travelGuide.

	guide should not be isNodeEmpty: reference.
	guide should be isNode: reference hasLastReferenceAt: 1.
	(guide referenceOf: reference atIndex: 1) should be: reference messagesCache.
	guide replaceReferenceOf: reference at: 1 with: #newCache.
	reference messagesCache should be: #newCache
]
