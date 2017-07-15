I am root of SeamlessRequest contexts.
My subclasses represents specific kind of request sender contexts. They should implement method 
	return: aSeamlessRequestResult to: senderPeer
which returns request result to sender. 
For details look at subclasses comments.

Returned results should be subclasses of SeamlessRequestResult. See it comments

Public API and Key Messages

- return: aSeamlessRequestResult to: senderPeer
- returnValue: aObject to: senderPeer
	it returns anObject to sender as SeamlessReturnValueResult
