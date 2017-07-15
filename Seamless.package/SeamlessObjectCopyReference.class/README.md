I represent reference to copy of distributed object. On remote side I represent my object with copy and when this copy is transferred back to owner it will be original object.
For now changes on copy on remote side will be not synchronized with original owner object

Internal Representation and Key Implementation Points.

    Instance Variables
	objectCopy:		<Object>