I am root of Seamless requests hierarchy which are sent between network peers.

My subclasses should implement method #executeFor: senderPeer.
My context is logical presentation of sender context which allow return results to it. Look at SeamlessRequestContext comments

I also include statistics information about how many bytes was used to transfer me and my result (ownBytes and resultBytes)

Public API and Key Messages

- executeFor: senderContext
 
    Instance Variables
	context:		<SeamlessRequestContext>
	ownBytes:	<Integer>
	resultBytes:	<Integer>