I log all seamless requests and allow to collect statistics over them for following analysis.

Public API and Key Messages

- startAfresh - create new default instance which clean all logs in past
- start - turn on logging by installing requests interception meta links into Seamless code
- stop - turn off logging. It removes all installed meta links
- collectStatistics - returns statistics instance for communication analysis

Internal Representation and Key Implementation Points.

    Instance Variables
	outgoingLink:		<Metalink>
	incomingLink:		<Metalink>
	isRunning:		<Boolean>	
	requests:		<OrderedCollection of <SeamlessRequest>>


    Implementation Points