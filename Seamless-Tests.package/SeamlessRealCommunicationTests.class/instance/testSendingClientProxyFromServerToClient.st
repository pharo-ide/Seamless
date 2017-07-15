tests
testSendingClientProxyFromServerToClient
	"this tests cover case when we have two network instances on same image
	and we try to send client side proxy from server to client"
	| transferedObject remoteProxy serverSidePeer clientEnv  remotePeer actualArrayOnServer remoteArrayOnServer |
	transferedObject := 'test'.
	remotePeer := self connectToServerPeer.
	remoteProxy := self prepareClientProxyForServerObject: transferedObject.
	
	self forkAndWait: [
		remotePeer establishNewConnection.
		serverSidePeer := serverSideNetwork remotePeers anyOne.
		clientEnv := serverSidePeer remoteEnvironment.
		remoteArrayOnServer := (clientEnv at: #Array) with: remoteProxy. "it will lead to request from server to client with client proxy as parameter"
		actualArrayOnServer := remoteArrayOnServer asLocalObject.
	]. 
 
	actualArrayOnServer should beInstanceOf: Array.
	actualArrayOnServer first should be: transferedObject
	