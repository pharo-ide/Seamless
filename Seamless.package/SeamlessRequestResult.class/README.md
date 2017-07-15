My subclasses represent result of SeamlessRequest execution. 
Result can not be just returned value because it can be raised error or more special cases like non local return. On sender side they should be resolved differently.
My subclasses should implement #returnValue method for this. For example:
	- SeamlessReturnValueResult just returns given value 
	- SeamlessThrowExceptionResult signals given exception (which could be catched during request execution on remote side)

I also include statistics information about how many bytes was used to transfer me over network by special deliver request (transferredBytes)
	
Public API and Key Messages

- returnValue

Internal Representation and Key Implementation Points.

    Instance Variables
	transferredBytes:		<Integer>