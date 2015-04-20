Class {
	#name : #TCAPProtocolAbortMessage,
	#superclass : #TCAPEntityMessage,
	#category : #'TCAP-Core-Model'
}

{ #category : #'as yet unclassified' }
TCAPProtocolAbortMessage >> dispatchTo: aTransaction [
	aTransaction receivedPAbort: self
]

{ #category : #'as yet unclassified' }
TCAPProtocolAbortMessage >> handleUnassignedTransaction [
	self discard
]

{ #category : #validating }
TCAPProtocolAbortMessage >> validateProtocolVersion [
	
]

{ #category : #validating }
TCAPProtocolAbortMessage >> validateSyntax [ 
	super validateSyntax.
	self validateDtidSyntax
]
