"
I am strategy which transfer objects by value. By default It means that shallow copy of me will be sent between peers.
But I ask object itself to prepare value transfer and object can command transporter how to transfer specific internal state. For example OrderedCollection implement such method: 

	OrderedCollection>>prepareValueTransferBy: aSeamlessObjectTransporter
		aSeamlessObjectTransporter transferAsValue: array	

I have default instance:
	SeamlessTransferStrategy defaultByValue
"
Class {
	#name : #SeamlessTransferByValueStrategy,
	#superclass : #SeamlessTransferStrategy,
	#category : 'Seamless-Transport'
}

{ #category : #operations }
SeamlessTransferByValueStrategy >> prepareTransferObjectFor: anObject by: anObjectTransporter [
	"By default transporter transfer given object by value. So we don't need to do anything here.
	But we allow objects to specify default meaning of value transfer. 
	For example Object do nothing.	
	But OrderedCollection marks internal array to be transfered as value too"
	
	^anObject prepareValueForTransferBy: anObjectTransporter
]
