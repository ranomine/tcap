Class {
	#name : #TCAPActiveTransactionState,
	#superclass : #TCAPTransactionState,
	#category : #'TCAP-Core-State'
}

{ #category : #accessing }
TCAPActiveTransactionState class >> label [
	^ #active
]

{ #category : #indications }
TCAPActiveTransactionState >> receivedContinue: aMessage [ 
	self flag: #unchecked.
	transaction dialogue indicationTrContinue: aMessage
]

{ #category : #indications }
TCAPActiveTransactionState >> receivedPAbort: aMessage [ 
	self flag: #unchecked.
	
	transaction dialogue indicationTrPAbort: aMessage.
	transaction stop
]

{ #category : #indications }
TCAPActiveTransactionState >> receivedUAbort: aMessage [
	self flag: #unchecked.
	transaction dialogue indicationTrUAbort: aMessage.
	transaction stop
]

{ #category : #requests }
TCAPActiveTransactionState >> requestTrContinue: continue [
	"that is a copy from TCAPInitiationReceivedTransactionState"
	continue
		at: 'otid' put: transaction id;
		at: 'dtid' put: transaction remoteTransactionId.
	transaction switchState: #active.
	transaction sendPayload: continue asTCMessage 

]

{ #category : #requests }
TCAPActiveTransactionState >> requestTrEnd: aDictionary [ 
	self flag: #unchecked.
	aDictionary 
		ifNotNil: [ self endTransaction: aDictionary ]
		ifNil: [ transaction stop ]

]
