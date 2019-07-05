"
I represent remote exception which returned to local side as result of remote message send.
I only contain string presentation of original error as my messageText. 

I can be created by 
	SeamlessRemoteException for: originalException
"
Class {
	#name : #SeamlessRemoteException,
	#superclass : #Error,
	#category : 'Seamless-Core'
}

{ #category : #'instance creation' }
SeamlessRemoteException class >> for: anException [

	^self new 	
		messageText: anException printString
]

{ #category : #accessing }
SeamlessRemoteException >> seamlessDefaultTransferStrategy [ 
	^SeamlessTransferStrategy defaultByValue
]
