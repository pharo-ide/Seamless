I am default context of requests. They created with my single instance
	SeamlessRequestContext default
I skip any returned result from requests because I have no idea about their senders.
So my return method is just stub which is doing nothing.
I am always transfered by value between peers.

I helps to implement return method  from sync requests.  For this SeamlessMessageSendRequest is sent to sender peer to perform #return: message on sender context.
But as any message send this request will try to return "#return: message result" back to sender peer (receiver of original message). 
To stop this communication "return request" is sent with default context (which is me). So any returned result on sender will be skipped. 

This approach allows reuse SeamlessMessageSendRequest to implement request return. Instead some kind of ReturnMessageResultRequest will be needed