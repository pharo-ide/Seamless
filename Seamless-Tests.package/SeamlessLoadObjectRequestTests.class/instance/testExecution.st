tests
testExecution

	| objectReference |

	objectReference := Mock new.	
	request objectProxy: objectReference.
	objectReference stub asLocalObject willReturn: #localObjectForReference.
	context stub returnValue: Arg container to: #senderPeer.
			
	request executeFor: #senderPeer.
	
	Arg container should beInstanceOf: SeamlessObjectValueContainer.
	Arg container where content should be: #localObjectForReference