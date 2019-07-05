Class {
	#name : #SeamlessLoadObjectRequestTests,
	#superclass : #SeamlessRequestTestCase,
	#category : 'Seamless-Tests'
}

{ #category : #running }
SeamlessLoadObjectRequestTests >> requestClass [
	^SeamlessLoadObjectRequest 
]

{ #category : #tests }
SeamlessLoadObjectRequestTests >> testExecution [

	| objectReference |

	objectReference := Mock new.	
	request objectProxy: objectReference.
	objectReference stub asLocalObject willReturn: #localObjectForReference.
	context stub returnValue: Arg container to: #senderPeer.
			
	request executeFor: #senderPeer.
	
	Arg container should beInstanceOf: SeamlessObjectValueContainer.
	Arg container content should be: #localObjectForReference
]
