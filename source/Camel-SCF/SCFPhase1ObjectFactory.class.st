Class {
	#name : #SCFPhase1ObjectFactory,
	#superclass : #TCAPObjectFactory,
	#instVars : [
		'scf'
	],
	#category : #'Camel-SCF-Core'
}

{ #category : #'as yet unclassified' }
SCFPhase1ObjectFactory >> dialogueClass [
	^SCFPhase1Dialogue
]

{ #category : #'as yet unclassified' }
SCFPhase1ObjectFactory >> newDialogue [
	^super newDialogue
		scf: scf;
		yourself.
]

{ #category : #'as yet unclassified' }
SCFPhase1ObjectFactory >> scf: aScf [
	scf := aScf
]
