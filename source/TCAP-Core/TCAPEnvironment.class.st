"
This is the abstract superclass of the TCAPDialoge and the TCAPtransaction. 

Any TCAPServiceEndPoint creates a dialog and transaction for every dialog started.  See TCAPDialogueAndTransaction.

Both model the currect state independently, see  hierarchies

TCAPDialogueState
TCAPTransactionState

"
Class {
	#name : #TCAPEnvironment,
	#superclass : #Object,
	#instVars : [
		'container',
		'state'
	],
	#category : #'TCAP-Core-Model'
}

{ #category : #accessing }
TCAPEnvironment >> allocateId [
	^container allocateId
]

{ #category : #accessing }
TCAPEnvironment >> allocateId: aNumber [
	container allocateId: aNumber
]

{ #category : #accessing }
TCAPEnvironment >> asn1Context [
	^ container asn1Context
]

{ #category : #accessing }
TCAPEnvironment >> asn1Model [
	^ self asn1Context model
]

{ #category : #actions }
TCAPEnvironment >> asn1TypeNamed: aString [ 
	^ self asn1Model typeNamed: aString
]

{ #category : #accessing }
TCAPEnvironment >> container [
	^ container
]

{ #category : #accessing }
TCAPEnvironment >> container: aContainer [
	container := aContainer
]

{ #category : #synchronization }
TCAPEnvironment >> critical: aBlock [
	^ container critical: aBlock
]

{ #category : #accessing }
TCAPEnvironment >> factory [
	^ container factory
]

{ #category : #logging }
TCAPEnvironment >> formatForLogging [
	^String streamContents: [:stream |
		stream nextPutAll: self class printString;
			nextPut: $(;
			nextPutAll: 'id=';
			nextPutAll: (self id isNil ifTrue: ['nil'] ifFalse: [self id hex]);
			nextPut: $)].
]

{ #category : #accessing }
TCAPEnvironment >> id [
	^ container id
]

{ #category : #accessing }
TCAPEnvironment >> id: aString [ 
	container id: aString
]

{ #category : #notifying }
TCAPEnvironment >> indicationTrEnd: aMessage [
	self subclassResponsibility
]

{ #category : #creating }
TCAPEnvironment >> newAbortMessage [
	^ self newValue: TCAPAbortMessage 
]

{ #category : #creating }
TCAPEnvironment >> newBeginMessage [
	"^ self newValue: TCAPBeginMessage "
	^ self factory newBeginMessage
]

{ #category : #creating }
TCAPEnvironment >> newContinueMessage [
	^ self newValue: TCAPContinueMessage 
]

{ #category : #creating }
TCAPEnvironment >> newEndMessage [
	^ self newValue: TCAPEndMessage 
]

{ #category : #creating }
TCAPEnvironment >> newPAbort [
	^ self newValue: TCAPDialoguePAbort 
]

{ #category : #'instance creation' }
TCAPEnvironment >> newState: aSymbol [
	self subclassResponsibility
]

{ #category : #creating }
TCAPEnvironment >> newUAbort [
	"^ self newValue: TCAPDialogueUAbort "
	^ self factory newDialogueUAbort
]

{ #category : #actions }
TCAPEnvironment >> newValue: aClass [
	^ aClass newIn: self asn1Model
]

{ #category : #actions }
TCAPEnvironment >> nextState: aState [
	state := aState
]

{ #category : #notifying }
TCAPEnvironment >> notifyAfterMessage: aMessage [
	self subclassResponsibility
]

{ #category : #notifying }
TCAPEnvironment >> notifyBeforeMessage: aMessage [
	self subclassResponsibility
]

{ #category : #accessing }
TCAPEnvironment >> state [
	^ state ifNil: [ 
		self switchState: #idle. state ]
]

{ #category : #actions }
TCAPEnvironment >> switchState: aSymbol [
	self nextState: (self newState: aSymbol).
]

{ #category : #synchronization }
TCAPEnvironment >> synchronizedDo: aBlock [
	^ self critical: aBlock
]

{ #category : #accessing }
TCAPEnvironment >> transactionCoordinator [
	^ container transactionCoordinator
]
