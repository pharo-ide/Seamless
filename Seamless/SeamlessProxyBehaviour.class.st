"
I am behaviour for real Proxy implementation based on Ghost. I just delegate all intercepted messages to proxy seamless reference
"
Class {
	#name : #SeamlessProxyBehaviour,
	#superclass : #GHGhostBehaviour,
	#classInstVars : [
		'default'
	],
	#category : 'Seamless-Proxy'
}

{ #category : #accessing }
SeamlessProxyBehaviour class >> default [
	^default ifNil: [ default := self new ]
]

{ #category : #accessing }
SeamlessProxyBehaviour >> currentMetaLevel [
	^GHMetaLevel standard
]

{ #category : #'message interception' }
SeamlessProxyBehaviour >> send: aMessage to: aSeamlessProxy [
	
	^aSeamlessProxy performRemoteMessage: aMessage
]
