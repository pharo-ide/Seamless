I am stub proxy implementation for Seamless to study and debug real meta messages which can be sent to real Seamless proxies.
I just subclass from Behaviour and override DNU message. So I am not really transparent proxy.
But I delegate all message sends to my reference object which resend all them to our remote peer. 

    Instance Variables
	reference:		<SeamlessObjectReference>