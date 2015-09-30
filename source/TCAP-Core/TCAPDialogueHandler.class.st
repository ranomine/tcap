Class {
	#name : #TCAPDialogueHandler,
	#superclass : #Object,
	#instVars : [
		'serviceEndPoint',
		'asn1Model'
	],
	#category : #'TCAP-Core-Model'
}

{ #category : #accessing }
TCAPDialogueHandler >> asn1Model [
	^ asn1Model ifNil: [
		asn1Model := self container asn1Model ]
]

{ #category : #testing }
TCAPDialogueHandler >> checkDialoguePortion: anASN1ValueProxy [ 
	^ true
]

{ #category : #accessing }
TCAPDialogueHandler >> dialogueHandler [
	^ self
]

{ #category : #indications }
TCAPDialogueHandler >> indicationTcEnd: aDialogue componentsPresent: aBoolean [
	serviceEndPoint user indicationTcEnd: aDialogue componentsPresent: aBoolean
]

{ #category : #indications }
TCAPDialogueHandler >> indicationTrEnd: aTransaction userData: aDictionary [ 
	<tcapMethod>
	aTransaction dialogue indicationTrEnd: aDictionary

]

{ #category : #accessing }
TCAPDialogueHandler >> newDialogue [
	^ self newDialogueWithId: nil
]

{ #category : #accessing }
TCAPDialogueHandler >> newDialogueWithId: aNumber [
	^ serviceEndPoint newDialogueWithId: aNumber

]

{ #category : #accessing }
TCAPDialogueHandler >> removeDialogue: aDialogue. [
	serviceEndPoint removeDialogueAndTransaction: aDialogue container
]

{ #category : #removing }
TCAPDialogueHandler >> removeDialogueAndTransaction: aDialogueAndTransaction [ 
	serviceEndPoint removeDialogueAndTransaction: aDialogueAndTransaction 
]

{ #category : #accessing }
TCAPDialogueHandler >> serviceEndPoint: aServiceEndPoint [ 
	serviceEndPoint := aServiceEndPoint
]

{ #category : #accessing }
TCAPDialogueHandler >> transactionCoordinator [
	^ serviceEndPoint transactionCoordinator 
]

{ #category : #accessing }
TCAPDialogueHandler >> userInfoFrom: aAsn1Dictionary [
	aAsn1Dictionary 
		at: 'dialoguePortion'
		ifPresent: [ :dict | 
			dict 
				at: 'user-information' 
				ifPresent: [ :info | ^ info  ] ].
	^ nil
]
