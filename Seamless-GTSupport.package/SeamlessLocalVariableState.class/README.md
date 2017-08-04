I represent local state of SeamlessRemoteWorkspaceVariable. 
You can create my instances using: 
	SeamlessLocalVariableState of: aSeamlessRemoteWorkspaceVariable.

I am always transferred by value and cache locally all modification of variable or updates of variable value from remote side of remote variable.	
When there is connection with remote side of variable I perform remote messages to update state of variable on remote side.
For write operation I perform asinchronous message send to update client.
 
Internal Representation and Key Implementation Points.

    Instance Variables
	remoteVariable:		<SeamlessRemoteWorkspaceVariable>
	value:		<Object>