I execute given valuable object (block or message sends) and return result to sender.
There are four cases:
	- evaluation completes successfully. I return SeamlessReturnValueResult with message answer.
	- evaluation signals exception. I return it as SeamlessThrowExceptionResult with SeamlessRemoteException which includes signalled exception info. 
	- evaluation attempts to execute non local return.  I return SeamlessNonLocalReturnResult with target home context and returned value. 
	- evaluation signals  Halt or Nortification. I pass it locally. They will not returned to sender.

Look it comments.

    Instance Variables
	evaluable:		<MessageSend or: BlockClosure>