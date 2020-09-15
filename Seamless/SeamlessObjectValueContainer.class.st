"
I am special container for objects which should be transferred by value forcibly.

I supply special default strategy to mark my content to be transferred by value. 

Internal Representation and Key Implementation Points.

    Instance Variables
	content:		<Object>
"
Class {
	#name : #SeamlessObjectValueContainer,
	#superclass : #SeamlessTransferObject,
	#instVars : [
		'content'
	],
	#category : 'Seamless-Core'
}

{ #category : #'instance creation' }
SeamlessObjectValueContainer class >> with: anObject [
	^self new 
		content: anObject
]

{ #category : #accessing }
SeamlessObjectValueContainer >> content [
	^ content
]

{ #category : #accessing }
SeamlessObjectValueContainer >> content: anObject [
	content := anObject
]

{ #category : #transfer }
SeamlessObjectValueContainer >> prepareValueForTransferBy: aSeamlessTransporter [
	"Container is always substituted by content while transferred over network.
	it also commands transporter to transfer content by value"
	
	super prepareValueForTransferBy: aSeamlessTransporter.
	
	^content
]

{ #category : #transfer }
SeamlessObjectValueContainer >> prepareValueTransferBy: aSeamlessTransporter [
	
	aSeamlessTransporter transferByValue: content
]
