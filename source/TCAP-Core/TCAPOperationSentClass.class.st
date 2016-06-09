Class {
	#name : #TCAPOperationSentClass,
	#superclass : #Object,
	#category : #'TCAP-Core-Message'
}

{ #category : #'as yet unclassified' }
TCAPOperationSentClass class >> terminate [
	self isThisEverCalled.
	"#cancelTimer is defined on the invoke...  "
	self cancelTimer
]

{ #category : #'as yet unclassified' }
TCAPOperationSentClass class >> withNumber: aNumber [
	^ self allSubclasses 
		detect: [ :each | each classNumber = aNumber ]
]
