Class {
	#name : #TCAPInitiationSentMissingDialoguePortionQuirkState,
	#superclass : #TCAPInitiationSentDialogueState,
	#category : #'TCAP-Core-Quirks'
}

{ #category : #'as yet unclassified' }
TCAPInitiationSentMissingDialoguePortionQuirkState >> dialogueMatchesMessage: aMessage do: aBlock [
	"do not abort dialogue if dialogue portion is missing and the dialogue
	has an application context set"
	aBlock value
]
