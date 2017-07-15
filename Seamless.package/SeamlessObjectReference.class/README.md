I represent reference to distributed object inside Seamless network.
I transfered by value between Seamless peers.

"senderPeer" variable contains BasysPeer instance from which I was received. It can be not peer which originally created me.
When network decides to transfer object by reference it creates me. It asks object #createSeamlessReference and then set up it variables. Objects can override this message to return different types of references. 

On local side my peer will be BasysLocalPeer instance . On remote side my peer will be BasysRemotePeer instance which sent me.
My peerId is always id of my owner peer which created me. So it can be not equal to "peer id" because I can be transfered between many network peers and "peer" variable will always contain sender peer instance.

My id is unique only inside my owner peer. But pair "id and peerId" is globally unique. I use it to implement equality and hash.

I can be asked for proxy representation of remote object which I reference to. By default it is classic transparent proxy (SeamlessProxy) which  delegates all message sends to me. And I resend all them to my remote peer. 
Subclasses can override this behaviour and implement more specific representations of remote objects.

Public API and Key Messages

- createProxy
- isSeamlessReference 
- performRemoteMessage: aMessage

    Instance Variables
	id:		<Object>
	ownerPeerId:		<Object>
	senderPeer:		<BasysPeer>