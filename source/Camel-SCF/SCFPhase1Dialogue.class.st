"
I am a gsmSCF vor Camel Phase 1.
"
Class {
	#name : #SCFPhase1Dialogue,
	#superclass : #SCFCamelDialogue,
	#instVars : [
		'scf'
	],
	#category : #'Camel-SCF-Core'
}

{ #category : #creation }
SCFPhase1Dialogue >> dispatchInvocation: anInvocation [
	| selector |
	self flag: #todo. "Share this with HLRDialogue?"
	selector := anInvocation normalizedOperationName.

	"Abort the entire dialogue in case we don't know the invocation."
	(self respondsTo: selector)
		ifFalse: [^self requestTcUAbort: (self uAbortCause: 0)].

	self perform: anInvocation normalizedOperationName with: anInvocation.
]

{ #category : #'CAP-gsmSSF-gsmSCF' }
SCFPhase1Dialogue >> initialDPV1: anInvocation [
	"Release the call.."
	self requestTcInvokeNamed: 'releaseCallV1' parameters: 2r10000000 asByteArray hex class: 1 timeout: 500.
	self requestTcEnd: false.
]

{ #category : #creation }
SCFPhase1Dialogue >> initialize [
	super initialize.

	self onInvoke: [:invocation |
		self dispatchInvocation: invocation].
]

{ #category : #creation }
SCFPhase1Dialogue >> scf: aScf [
	scf := aScf.
]
