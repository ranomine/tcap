Class {
	#name : #TCAPRemoteAbort,
	#superclass : #TCAPTransactionAbort,
	#instVars : [
		'otid',
		'cause'
	],
	#category : #'TCAP-Core-Exception'
}

{ #category : #'instance creation' }
TCAPRemoteAbort class >> otid: aString cause: aPAbort [ 
	^ self new
		otid: aString;
		cause: aPAbort
]

{ #category : #accessing }
TCAPRemoteAbort >> cause [
	^ cause
]

{ #category : #accessing }
TCAPRemoteAbort >> cause: anObject [
	cause := anObject
]

{ #category : #accessing }
TCAPRemoteAbort >> otid [
	^ otid
]

{ #category : #accessing }
TCAPRemoteAbort >> otid: anObject [
	otid := anObject
]
