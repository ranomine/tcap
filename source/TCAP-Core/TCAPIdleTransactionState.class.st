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

{ #category : #'as yet unclassified' }
TCAPIdleTransactionState >> requestTrBegin: begin [ 

	begin at: 'otid' put: transaction id.
	transaction switchState: #initiationSent.
	transaction sendPayload: begin asTCMessage.
	^ transaction

]
