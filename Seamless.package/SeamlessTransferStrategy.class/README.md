I am root of transfer strategies hierarchy.

My subclasses should implement method
	perpareTransferOf: anObject by: aSeamlessObjectTransporter
to prepare object transfer by transporter instance. They can command transporter to transfer particular object by reference or value. If no command was applied object will be transfered by value.

Any object can define default strategy by overriding #seamlessDefaultTransferStrategy method. 
For example Object supplies SeamlessTransferByReferenceStrategy. But numbers and strings return SeamlessTransferByValueStrategy.
This default strategies has no state and defined as singleton in my class variables DefaultByValue, DefaultByReference. Users can use it by 
	SeamlessTransferStrategy defaultByValue 
	SeamlessTransferStrategy defaultByReference

SeamlessNetwork allows overriding default strategies on network level. You can add strategy to network for specific set objects. This set of objects is specified by criteria. It can be any object which understands message #matches: .  
When I have no criteria I can not be applied to any object. Default strategies are not checked for this.

Public API and Key Messages

- prepareTransferOf: anObject by: aSeamlessObjectTransporter
- isAppliedTo: anObject

You can instantiate me with criteria using StateSpecs api: 
	SeamlessTransferByValue for: (Instance of: Point)
 
Internal Representation and Key Implementation Points.

    Instance Variables
	criteria:		<Object>	which understands #matches: message. It can be StateSpecs objects