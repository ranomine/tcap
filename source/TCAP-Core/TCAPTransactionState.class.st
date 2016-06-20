"
The sublasses model 5 states of the transaction.

- Idle
- Init Sent (IS)
- Init Received (IR)
- Active

and Stopped.

See Q.774 page 20 (description) and 21 for a state diagram.
"
Class {
	#name : #TCAPTransactionState,
	#superclass : #Object,
	#instVars : [
		'transaction'
	],
	#category : #'TCAP-Core-State'
}

{ #category : #dispatching }
TCAPTransactionState class >> dispatchAddTo: aFactory [
	^ aFactory 
		transactionStateClassAt: self label 
		put: self
]

{ #category : #accessing }
TCAPTransactionState >> dialogueHandler [
	^ transaction dialogueHandler
]

{ #category : #requests }
TCAPTransactionState >> endTransaction: end [

	end at: 'dtid' put: transaction remoteTransactionId.
	transaction sendPayload: end asTCMessage.
	transaction stop
]

{ #category : #requests }
TCAPTransactionState >> localAbort [
	transaction dialogue indicationTrPAbort: nil.
	transaction stop
]

{ #category : #indications }
TCAPTransactionState >> receivedEnd: aDictionary [ 
	transaction dialogue indicationTrEnd: aDictionary.
	transaction stop
]

{ #category : #requests }
TCAPTransactionState >> requestTrPAbort: aPAbort [
	transaction pAbort: aPAbort
]

{ #category : #requests }
TCAPTransactionState >> requestTrUAbort: aDictionary [
	self uAbort: aDictionary
]

{ #category : #accessing }
TCAPTransactionState >> transaction: aTransaction [
	transaction := aTransaction 
]

{ #category : #accessing }
TCAPTransactionState >> transactionCoordinator [
	^ transaction transactionCoordinator
]

{ #category : #requests }
TCAPTransactionState >> uAbort: anObject [
	transaction basicAbort: anObject 
]
