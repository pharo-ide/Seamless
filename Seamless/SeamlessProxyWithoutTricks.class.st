"
I am stub proxy implementation for Seamless to study and debug real meta messages which can be sent to real Seamless proxies.
I just subclass from Behaviour and override DNU message. So I am not really transparent proxy.
But I delegate all message sends to my reference object which resend all them to our remote peer. 

    Instance Variables
	reference:		<SeamlessObjectReference>
"
Class {
	#name : #SeamlessProxyWithoutTricks,
	#superclass : #Object,
	#instVars : [
		'reference'
	],
	#category : 'Seamless-Proxy'
}

{ #category : #'instance creation' }
SeamlessProxyWithoutTricks class >> for: aSeamlessObjectReference [ 

	^self new 
		reference: aSeamlessObjectReference 
]

{ #category : #'reflective operations' }
SeamlessProxyWithoutTricks >> at: keyObject [

	^self performRemoteMessage: (Message selector: #at: argument: keyObject)
]

{ #category : #'reflective operations' }
SeamlessProxyWithoutTricks >> doesNotUnderstand: aMessage [

	^self performRemoteMessage: aMessage
]

{ #category : #testing }
SeamlessProxyWithoutTricks >> isSeamlessProxy [
	^true
]

{ #category : #accessing }
SeamlessProxyWithoutTricks >> reference [
	^ reference
]

{ #category : #accessing }
SeamlessProxyWithoutTricks >> reference: anObject [
	reference := anObject
]

{ #category : #accessing }
SeamlessProxyWithoutTricks >> seamlessReference [
	^ reference
]
