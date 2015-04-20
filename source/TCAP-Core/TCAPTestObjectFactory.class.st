Class {
	#name : #TCAPTestObjectFactory,
	#superclass : #TCAPObjectFactory,
	#category : #'TCAP-Core-Tests-Model'
}

{ #category : #'as yet unclassified' }
TCAPTestObjectFactory >> dialogueAndTransactionClass [ 
	^ TCAPTestDialogueAndTransaction 
]

{ #category : #'as yet unclassified' }
TCAPTestObjectFactory >> dialogueClass [ 
	^ TCAPTestDialogue 
]

{ #category : #'as yet unclassified' }
TCAPTestObjectFactory >> dialogueHandlerClass [
	^ TCAPTestDialogueHandler  
]

{ #category : #'as yet unclassified' }
TCAPTestObjectFactory >> idPoolClass [
	^ TCAPTestIdPool 
]

{ #category : #'as yet unclassified' }
TCAPTestObjectFactory >> transactionClass [ 
	^ TCAPTestTransaction 
]

{ #category : #'as yet unclassified' }
TCAPTestObjectFactory >> transactionCoordinatorClass [ 
	^ TCAPTestTransactionCoordinator 
]
