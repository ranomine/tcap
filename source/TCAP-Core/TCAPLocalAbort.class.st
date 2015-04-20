Class {
	#name : #TCAPLocalAbort,
	#superclass : #TCAPTransactionAbort,
	#instVars : [
		'dtid'
	],
	#category : #'TCAP-Core-Exception'
}

{ #category : #'instance creation' }
TCAPLocalAbort class >> otid: aString cause: aPAbort [ 
	^ self new
		otid: aString;
		cause: aPAbort
]

{ #category : #accessing }
TCAPLocalAbort >> dtid [
	^ dtid
]

{ #category : #accessing }
TCAPLocalAbort >> dtid: anObject [
	dtid := anObject
]
