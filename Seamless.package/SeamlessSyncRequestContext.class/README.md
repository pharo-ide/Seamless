I am request context which implements synchronous request sending when senders are waiting result from receiver peer.
To implement this behaviour I fork actual request sending and wait signal from resultWaiter semaphore. I am transfered by reference to receiver peer as part of sent request. On receiver side request executed and result is returned to me by "backward" remote message. I receive #return: message which stores argument as result and signal resultWaiter semaphore. Signal resumes original sender process which continue execution with received value.

During request execution receiver peer will keep reference to me. It can be used to retrieved information on receiver side about my sender process. 
 
Internal Representation and Key Implementation Points.

    Instance Variables
	result:		<SeamlessRequestResult>
	resultWaiter:		<Semaphore>
	senderProcess:		<Process>