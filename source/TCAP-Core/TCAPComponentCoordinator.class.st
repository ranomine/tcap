Class {
	#name : #TCAPComponentCoordinator,
	#superclass : #Object,
	#instVars : [
		'dialogue',
		'components'
	],
	#category : #'TCAP-Core-Model'
}

{ #category : #accessing }
TCAPComponentCoordinator >> addComponent: anOperation [
	components add: anOperation 
]

{ #category : #accessing }
TCAPComponentCoordinator >> dialogue [
	^dialogue
]

{ #category : #accessing }
TCAPComponentCoordinator >> dialogue: aDialogue [
	dialogue := aDialogue
]

{ #category : #accessing }
TCAPComponentCoordinator >> flushComponents [
	| col |
	col := components.
	components := OrderedCollection new.
	^ col
]

{ #category : #testing }
TCAPComponentCoordinator >> hasComponents [
	^ components notEmpty
]

{ #category : #'initialize-release' }
TCAPComponentCoordinator >> initialize [ 
	super initialize.
	components := OrderedCollection  new
]

{ #category : #accessing }
TCAPComponentCoordinator >> invocationClass [
	^ ROSInvocation 
]

{ #category : #'as yet unclassified' }
TCAPComponentCoordinator >> invocationFromName: aString [
	^ (self invocationClass type: (dialogue asn1TypeNamed: 'Invoke'))
		operation: (ROSOperation on: (dialogue operationNamed: aString))
]

{ #category : #'as yet unclassified' }
TCAPComponentCoordinator >> invocationFromOpcode: aNumber [
	^ self invocationClass 
		operationObject: (dialogue operationWithCode: aNumber)
]

{ #category : #actions }
TCAPComponentCoordinator >> processComponent: aMessage [
	aMessage dispatchTo: dialogue 

]

{ #category : #'as yet unclassified' }
TCAPComponentCoordinator >> processComponentsOf: aCollection [
	aCollection ifNotNil: [  
		aCollection do: [:each|
			self processComponent: each ] ]
]
