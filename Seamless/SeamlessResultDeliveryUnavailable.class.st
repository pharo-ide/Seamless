"
I represent an error when request result can't be delivered.

Delivery requires a ready connection with senderPeer. When it does not exist or become lost I notify clients about this problem.

I am signalled by SeamlessRequestResultDelivery and subclasses during #waitResult logic.
"
Class {
	#name : #SeamlessResultDeliveryUnavailable,
	#superclass : #Error,
	#category : #'Seamless-Requests'
}
