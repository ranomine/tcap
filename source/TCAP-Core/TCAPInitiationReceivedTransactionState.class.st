Class {
	#name : #TCAPInitiationReceivedTransactionState,
	#superclass : #TCAPTransactionState,
	#category : #'TCAP-Core-State'
}

{ #category : #accessing }
TCAPInitiationReceivedTransactionState class >> label [
	^ #initiationReceived
]

{ #category : #requests }
TCAPInitiationReceivedTransactionState >> requestTrContinue: continue [

	continue
		at: 'otid' put: transaction id;
		at: 'dtid' put: transaction remoteTransactionId.
	transaction switchState: #active.
	transaction sendPayload:  continue asTCMessage 

]

{ #category : #requests }
TCAPInitiationReceivedTransactionState >> requestTrEnd: end [
	"if this is a prearranged end aDictionary is nil and the transaction will
	be terminated locally only. Otherwise pending components are sent 
	with an end message "
	self flag: #unchecked.
	end 
		ifNotNil: [  self endTransaction: end ]
		ifNil: [ transaction stop ]
]
