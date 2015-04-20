Class {
	#name : #TCAPOperationSentClass,
	#superclass : #Object,
	#category : #'TCAP-Core-Model'
}

{ #category : #'as yet unclassified' }
TCAPOperationSentClass class >> terminate [
	self cancelTimer
]

{ #category : #'as yet unclassified' }
TCAPOperationSentClass class >> withNumber: aNumber [
	^ self allSubclasses 
		detect: [ :each | each classNumber = aNumber ]
]
