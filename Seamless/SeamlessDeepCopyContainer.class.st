"
I am special container for objects which should be transferred by deep copy strategy forcibly.

I command transporter to transfer my content by deep copy

"
Class {
	#name : #SeamlessDeepCopyContainer,
	#superclass : #SeamlessObjectValueContainer,
	#category : 'Seamless-Core'
}

{ #category : #transfer }
SeamlessDeepCopyContainer >> prepareValueTransferBy: aSeamlessTransporter [

	aSeamlessTransporter transferByDeepCopy: content
]
