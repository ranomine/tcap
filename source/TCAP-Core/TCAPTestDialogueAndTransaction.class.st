Class {
	#name : #TCAPTestDialogueAndTransaction,
	#superclass : #TCAPDialogueAndTransaction,
	#category : #'TCAP-Core-Tests-Model'
}

{ #category : #'as yet unclassified' }
TCAPTestDialogueAndTransaction >> dialogueClass [
	^ TCAPTestDialogue
]

{ #category : #'as yet unclassified' }
TCAPTestDialogueAndTransaction >> transactionClass [
	^ TCAPTestTransaction
]
