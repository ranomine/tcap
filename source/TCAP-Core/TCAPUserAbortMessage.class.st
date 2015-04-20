Class {
	#name : #TCAPUserAbortMessage,
	#superclass : #TCAPEntityMessage,
	#category : #'TCAP-Core-Model'
}

{ #category : #'as yet unclassified' }
TCAPUserAbortMessage >> dispatchTo: aTransaction [
	aTransaction receivedUAbort: self
]

{ #category : #'as yet unclassified' }
TCAPUserAbortMessage >> handleSyntaxError [
self halt.
	self abortLocalTransaction
]

{ #category : #'as yet unclassified' }
TCAPUserAbortMessage >> handleUnassignedTransaction [
self halt.
	self discard
]

{ #category : #validating }
TCAPUserAbortMessage >> validateProtocolVersion [
	
]

{ #category : #validating }
TCAPUserAbortMessage >> validateSyntax [ 
	super validateSyntax.
	self validateDtidSyntax
]
