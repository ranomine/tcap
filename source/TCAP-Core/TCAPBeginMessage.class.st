Class {
	#name : #TCAPBeginMessage,
	#superclass : #TCAPEntityMessage,
	#category : #'TCAP-Core-Message'
}

{ #category : #'initailize-release' }
TCAPBeginMessage class >> asn1TypeName [
	^ 'Begin'
]

{ #category : #'instance creation' }
TCAPBeginMessage class >> dispatchInstanceCreationOn: anObjectFactory [ 
	^ anObjectFactory newBeginMessage
]

{ #category : #'as yet unclassified' }
TCAPBeginMessage class >> isAsn1ModelClass [
	^ true
]

{ #category : #'as yet unclassified' }
TCAPBeginMessage class >> type [
	^ 'begin'
]

{ #category : #'as yet unclassified' }
TCAPBeginMessage >> dispatchTo: aTransaction [
	aTransaction receivedBegin: self
]

{ #category : #'as yet unclassified' }
TCAPBeginMessage >> handleSyntaxError [
	self abortRemoteTransactionCause: TCAPDialoguePAbort incorrectTransactionPortion
]

{ #category : #validating }
TCAPBeginMessage >> transactionIn: aTransactionCoordinator [
	| tx |
	 tx := aTransactionCoordinator createBasicTransaction.
	tx remoteTransactionId: self otid.
	aTransactionCoordinator notifyDialogueReceived: tx dialogue.
	[ tx allocateId  ]
		on: TCAPNoFreeId 
		do: [ :err |
			(TCAPResourceLimitExceeded new transaction: tx) signal ].
	^ tx
]

{ #category : #validating }
TCAPBeginMessage >> validateSyntax [ 
	super validateSyntax.
	self validateOtidSyntax
]
