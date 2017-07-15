I am responsible for transfer objects between Seamless peers.

I extend TostTransporter by defining appropriate format for data exchange. Particulary I use SeamlessSubstitutionTostFormat  which implements object substitution according to their transfer strategies.

I have default instance on class side with prepared formats which describe well known objects and classes.
SeamlessNetwork uses my default instance as transprot to instantiate concrete transporter instances for particular remote peer. 

	transporter newTransporterFor: aSeamlessNetwork toTransferBy: aRemotePeer

SeamlessNetwork uses me to send and receive objects from connections:

	transporter sendObject: anObject by: aBasysConnection
	transporter receiveObjectBy: aBasicConnection
	
I maintain objectSubstitutions dictionary to control how specific objects should be transferred. Transport strategies command me for this using following messages:

	 transporter transferByValue: anObject
	 transporter transfer: anObject byReference: creationBlock
	 transporter transfer: anObject byWellKnownObjectNamed:
	 transporter transferByDeepCopy: anObject

Last command activates deep copy transfer strategy for particular object. I keep them in separate dictionary objectsByDeepCopy. 
Idea that any reference from given object subgraph should be transferred by value which means that network strategies will not be used for them.

To read objects from connections substitutions are processed specifically. Loaded from stream objects are asked to create local substitutions which will be injected into materialized object graph instead of them.
 
	transporter prepareLocalSubstitutionOf: aLoadedObject with: aTostMaterialization.  

Alsow I implement optimized encoding for SeamlessObjectReference's to miminize size of objects on stream. When transferred references belongs to sender or receiver peers I encode them without ownerPeerId property.  I extract it value from participating peers. Look at methods:

- writeObjectReference: anObjectReference with: aTostSerialization
- readObjectReference: anObjectReference with: aTostMaterialization

Internal Representation and Key Implementation Points.

    Instance Variables
	network:		<SeamlessNetwork>
	remotePeer:		<BasysRemotePeer>
	objectSubstitutions:		<IdentityDictionary>
	objectsByDeepCopy:		<IdentityDictionary>