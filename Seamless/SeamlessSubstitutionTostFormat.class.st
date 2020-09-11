"
I am special Tost substitution format which use Seamless network transfer strategies to prepare transfer objects which should be written on stream. 

By default it is objects themselfs. And in such cases I pass given object further to other transporter formats and not write them on stream.

In other cases it could be SeamlessObjectReference which I will write on stream instead of original objects. It is the way how transfer by reference strategy is executed
"
Class {
	#name : #SeamlessSubstitutionTostFormat,
	#superclass : #TostFormat,
	#category : 'Seamless-Transport'
}

{ #category : #'instance creation' }
SeamlessSubstitutionTostFormat class >> network: aSeamlessNetwork [
	^self new 
		network: aSeamlessNetwork
]

{ #category : #operations }
SeamlessSubstitutionTostFormat >> readObjectWith: aSeamlessTransporter [

	^aSeamlessTransporter readSeamlessSubstitution 
]

{ #category : #operations }
SeamlessSubstitutionTostFormat >> tryWriteObject: anObject with: aSeamlessTransporter [
	
	^aSeamlessTransporter tryWriteTransferObjectFor: anObject format: id
]
