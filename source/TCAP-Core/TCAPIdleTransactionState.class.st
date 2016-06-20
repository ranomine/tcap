"
Idle: No state machine exists

"
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
TCAPIdleTransactionState >> requestTrAbort: abort [ 
	"we send aboty without having send a begin first. dtid is not registered"
	abort
		at: 'dtid' put: transaction container container idPool basicNextId asByteArray. "the next possible ID is unassigned now"
	transaction switchState: #active.
	transaction sendPayload:  abort asTCMessage 
]

{ #category : #requests }
TCAPIdleTransactionState >> requestTrBegin: begin [ 

	begin at: 'otid' put: transaction id.
	transaction switchState: #initiationSent.
	transaction sendPayload: begin asTCMessage.
	^ transaction

]

{ #category : #requests }
TCAPIdleTransactionState >> requestTrContinue: continue [
	"we send a continue without having send a begin first. dtid is not registered"
	continue
		at: 'otid' put: transaction id;
		at: 'dtid' put: transaction container container idPool basicNextId asByteArray. "the next possible ID is unassigned now"
	transaction switchState: #active.
	transaction sendPayload:  continue asTCMessage 
]

{ #category : #requests }
TCAPIdleTransactionState >> requestTrEnd: end [ 
	"we send end without having send a begin first. dtid is not registered"
	end
		at: 'dtid' put: transaction container container idPool basicNextId asByteArray. "the next possible ID is unassigned now"
	transaction switchState: #active.
	transaction sendPayload:  end asTCMessage 
]
