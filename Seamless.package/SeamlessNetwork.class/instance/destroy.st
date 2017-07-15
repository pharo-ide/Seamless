controlling
destroy
	"This methods supposed to be used when you really want to destroy local peer network and release all resources without thinking that they can be in use on remote peers.
	Special request will be send to all connected peers to notify them. Then all connections and distributed objects will be cleaned.
	Maybe it should be general #close method. But for now it is separate method (network #close only close peers with existing connections).
	When peer is destroying it removes itself from network. That's why we need to enumeration on copy"
	remotePeers copy do: [ :each |	each destroy]