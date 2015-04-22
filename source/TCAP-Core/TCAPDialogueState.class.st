Class {
	#name : #TCAPDialogueState,
	#superclass : #Object,
	#instVars : [
		'dialogue'
	],
	#category : #'TCAP-Core-State'
}

{ #category : #dispatching }
TCAPDialogueState class >> dispatchAddTo: aFactory [
	^ aFactory 
		dialogueStateClassAt: self label 
		put: self
]

{ #category : #'as yet unclassified' }
TCAPDialogueState >> dialogue: aDialogue [
	dialogue := aDialogue
]

{ #category : #requests }
TCAPDialogueState >> endDialogue: aTerminationBoolean [
	"if aTerminationBoolean is true the dialogue has to be terminated locally without any 
	further sends."
	aTerminationBoolean 
		ifTrue: [ 
			dialogue transaction requestTrEnd: nil ]
		ifFalse: [ | end |
			end := dialogue newEndMessage.
			dialogue addPendingMessagesTo: end.
			dialogue transaction requestTrEnd: end].
	dialogue terminate
]

{ #category : #accessing }
TCAPDialogueState >> factory [
	^ dialogue factory
]
