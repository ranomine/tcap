Class {
	#name : #TCAPProtocolAbortMessage,
	#superclass : #TCAPEntityMessage,
	#category : #'TCAP-Core-Message'
}

{ #category : #'as yet unclassified' }
TCAPProtocolAbortMessage >> dispatchTo: aTransaction [
	aTransaction receivedPAbort: self
]

{ #category : #'as yet unclassified' }
TCAPProtocolAbortMessage >> handleUnassignedTransaction [
	self discard
]

{ #category : #accessing }
TCAPProtocolAbortMessage >> pAbortCause [
	^ self reason ifNotNil: [:r|
		r at: 'p-abortCause' ]
]

{ #category : #validating }
TCAPProtocolAbortMessage >> validateProtocolVersion [
	
]

{ #category : #validating }
TCAPProtocolAbortMessage >> validateSyntax [ 
	super validateSyntax.
	self validateDtidSyntax
]
