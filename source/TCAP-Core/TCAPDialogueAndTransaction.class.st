Class {
	#name : #TCAPDialogueAndTransaction,
	#superclass : #Object,
	#instVars : [
		'id',
		'dialogue',
		'transaction',
		'container',
		'mutex'
	],
	#category : #'TCAP-Core-Model'
}

{ #category : #accessing }
TCAPDialogueAndTransaction >> allocateId [
	^id := container idPool nextIdByteArray 
]

{ #category : #accessing }
TCAPDialogueAndTransaction >> allocateId: aNumber [
	id := aNumber 
		ifNotNil: [ (container idPool allocate: aNumber) asByteArray ] 
		ifNil: [ container idPool nextIdByteArray  ] 
]

{ #category : #accessing }
TCAPDialogueAndTransaction >> asn1Context [
	^ container asn1Context
]

{ #category : #accessing }
TCAPDialogueAndTransaction >> asn1Model [
	^ self asn1Context asn1Model
]

{ #category : #accessing }
TCAPDialogueAndTransaction >> container [
	^ container
]

{ #category : #accessing }
TCAPDialogueAndTransaction >> container: aDialogueHandler [
	container := aDialogueHandler 
]

{ #category : #synchronization }
TCAPDialogueAndTransaction >> critical: aBlock [
	^ mutex critical: aBlock 
]

{ #category : #accessing }
TCAPDialogueAndTransaction >> deallocateId [
	container idPool freeByteArray: id
]

{ #category : #accessing }
TCAPDialogueAndTransaction >> dialogue [
	^ dialogue
]

{ #category : #accessing }
TCAPDialogueAndTransaction >> dialogueHandler [
	^ container dialogueHandler
]

{ #category : #accessing }
TCAPDialogueAndTransaction >> factory [
	^ self asn1Context factory
]

{ #category : #accessing }
TCAPDialogueAndTransaction >> id [
	^ id
]

{ #category : #accessing }
TCAPDialogueAndTransaction >> id: aString [ 
	id := aString
]

{ #category : #initialization }
TCAPDialogueAndTransaction >> initialize [
	super initialize.
	mutex := Mutex new
]

{ #category : #accessing }
TCAPDialogueAndTransaction >> initializeFrom: anObjectFactory [ 
	dialogue := anObjectFactory newDialogue
		container: self.
	transaction := anObjectFactory newTransaction 
		container: self 
]

{ #category : #indications }
TCAPDialogueAndTransaction >> notifyDialogueCreated: aDialogue [ 
	container notifyDialogueCreated: aDialogue
]

{ #category : #accessing }
TCAPDialogueAndTransaction >> register [
	container addDialogueAndTransaction: self
]

{ #category : #accessing }
TCAPDialogueAndTransaction >> transaction [
	^ transaction
]

{ #category : #accessing }
TCAPDialogueAndTransaction >> transaction: aTransaction [ 
	transaction := aTransaction
]

{ #category : #accessing }
TCAPDialogueAndTransaction >> transactionCoordinator [
	^ container transactionCoordinator 
]

{ #category : #accessing }
TCAPDialogueAndTransaction >> unregister [
	container removeDialogueAndTransaction: self
]
