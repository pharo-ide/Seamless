I represent well known global object by name. I used to represent globals (classes) on remote side as existing globals with same name.
 
I override normal object serialization to provide more compact binary format.
So I implement custom writeTostBodyWith: method instead of walking by my vars with travel guide. And in binary form I am just a string
	
Internal Representation and Key Implementation Points.

    Instance Variables
	name:		<String>