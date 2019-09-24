tests
testExecution

	| objectReference |

	objectReference := Mock new.	
	request objectProxy: objectReference.
	objectReference stub asLocalDeepCopy willReturn: #localObjectForReference.
	context stub returnValue: Arg container to: #senderPeer.
			
	request executeFor: #senderPeer.
	
	Arg container should beInstanceOf: SeamlessDeepCopyContainer.
	Arg container where content should be: #localObjectForReference