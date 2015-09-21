Class {
	#name : #TCAPEnvironment,
	#superclass : #Object,
	#instVars : [
		'container'
	],
	#category : #'TCAP-Core-Model'
}

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

{ #category : #accessing }
TCAPEnvironment >> externalValue: anObject [
	^ anObject asExternalValueIn: self factory
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

{ #category : #creating }
TCAPEnvironment >> newAbortMessage [
self halt.
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

{ #category : #creating }
TCAPEnvironment >> newUAbort [
	"^ self newValue: TCAPDialogueUAbort "
	^ self factory newDialogueUAbort
]

{ #category : #actions }
TCAPEnvironment >> newValue: aClass [
	^ aClass newIn: self asn1Model
]

{ #category : #'as yet unclassified' }
TCAPEnvironment >> newValueNamed: aString [
	^ (self asn1Model typeNamed: aString) newValue
]

{ #category : #actions }
TCAPEnvironment >> switchState: aSymbol [
	self nextState: (self newState: aSymbol).
]
