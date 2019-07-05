Class {
	#name : #SeamlessRemoteScriptPresentation,
	#superclass : #GLMPharoScriptPresentation,
	#instVars : [
		'remotePeer'
	],
	#category : 'Seamless-GTSupport'
}

{ #category : #'instance creation' }
SeamlessRemoteScriptPresentation class >> remotePeer: aRemotePeer [
	^self new 
		remotePeer: aRemotePeer
]

{ #category : #accessing }
SeamlessRemoteScriptPresentation >> remotePeer [
	^ remotePeer
]

{ #category : #accessing }
SeamlessRemoteScriptPresentation >> remotePeer: anObject [
	remotePeer := anObject
]

{ #category : #rendering }
SeamlessRemoteScriptPresentation >> renderGlamorouslyOn: aRenderer [
	self registerAnnouncements.
	^ SeamlessRemoteScriptRenderer render: self from: aRenderer
]
