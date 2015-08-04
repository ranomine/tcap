Class {
	#name : #TCAPIdleTransactionState,
	#superclass : #TCAPTransactionState,
	#category : #'TCAP-Core-State'
}

{ #category : #accessing }
TCAPIdleTransactionState class >> label [
	^ #idle
]

{ #category : #indications }
TCAPIdleTransactionState >> receivedBegin: aMessage [
	self flag: #unchecked.
	transaction remoteTransactionId: aMessage otid. 
		
	transaction switchState: #initiationReceived.
	transaction dialogue indicationTrBegin: aMessage
		

]

{ #category : #requests }
TCAPIdleTransactionState >> requestTrBegin: begin [ 

	begin at: 'otid' put: transaction id.
	transaction switchState: #initiationSent.
	transaction sendPayload: begin asTCMessage.
	^ transaction

]

{ #category : #'requests - for testing' }
TCAPIdleTransactionState >> requestTrContinue: continue [
	"we send a continue without having send a begin first. dtid is not registered"
	continue
		at: 'otid' put: transaction id;
		at: 'dtid' put: transaction container container idPool basicNextId. "the next possible ID is unassigned now"
	transaction switchState: #active.
	transaction sendPayload:  continue asTCMessage 
]
