"
I special kind of proxy for Seamless to detect meta messages which are sent by tools or inside internal Seamless behaviour. I am used to create safe real proxy for Seamless (which is my superclass).

To study meta messages I use SeamlessProxyWithoutTricks which is stub proxy implementation subclassed from Object. 
 
Internal Representation and Key Implementation Points.

    Instance Variables
	learning:		<GHLearning>
"
Class {
	#name : #SeamlessLearningProxy,
	#superclass : #SeamlessProxy,
	#instVars : [
		'learning'
	],
	#category : 'Seamless-Proxy'
}

{ #category : #'as yet unclassified' }
SeamlessLearningProxy >> ghostBehaviour [
	^learning
]

{ #category : #'as yet unclassified' }
SeamlessLearningProxy >> seamlessReference: aSeamlessObjectReference [
	super seamlessReference: aSeamlessObjectReference.
	
	learning := GHLearning by: SeamlessProxyWithoutTricks
]
