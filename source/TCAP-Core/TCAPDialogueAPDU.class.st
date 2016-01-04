Class {
	#name : #TCAPDialogueAPDU,
	#superclass : #ASN1TaggedValue,
	#instVars : [
		'applicationContextName',
		'userInformation'
	],
	#category : #'TCAP-Core-Message'
}

{ #category : #converting }
TCAPDialogueAPDU >> asDialoguePdu [
self halt.
	^ (self asn1TypeNamed: 'DialoguePDU') newValue 
		at: self pduType put: self;
		yourself
]

{ #category : #converting }
TCAPDialogueAPDU >> asDialoguePduIn: aFactory [
	^ aFactory newDialoguePDU: self
]

{ #category : #converting }
TCAPDialogueAPDU >> asExternalValue [
self halt.
	^ (self asDialoguePdu asExternalValue: (self asn1TypeNamed: 'dialogue-as-id'))
		type: (self asn1TypeNamed: 'DialoguePortion')
]

{ #category : #accessing }
TCAPDialogueAPDU >> pduType [
	self subclassResponsibility 
]

{ #category : #accessing }
TCAPDialogueAPDU >> userInformation [
	^ userInformation
]

{ #category : #accessing }
TCAPDialogueAPDU >> userInformation: anObject [
	self value at: 'user-information' put: anObject
]
