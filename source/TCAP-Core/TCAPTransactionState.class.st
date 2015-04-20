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

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
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
