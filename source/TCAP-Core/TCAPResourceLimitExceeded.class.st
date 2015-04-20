Class {
	#name : #TCAPResourceLimitExceeded,
	#superclass : #Error,
	#instVars : [
		'transaction'
	],
	#category : #'TCAP-Core-Exception'
}

{ #category : #accessing }
TCAPResourceLimitExceeded >> transaction [
	^ transaction
]

{ #category : #accessing }
TCAPResourceLimitExceeded >> transaction: anObject [
	transaction := anObject
]
