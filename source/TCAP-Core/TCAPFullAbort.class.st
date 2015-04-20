Class {
	#name : #TCAPFullAbort,
	#superclass : #TCAPTransactionAbort,
	#instVars : [
		'otid',
		'dtid',
		'cause'
	],
	#category : #'TCAP-Core-Exception'
}

{ #category : #'instance-creation' }
TCAPFullAbort class >> otid: aOtid dtid: aDtid cause: aPAbort [ 
	^ self new
		otid: aOtid;
		dtid: aDtid;
		cause: aPAbort
]

{ #category : #accessing }
TCAPFullAbort >> cause [
	^ cause
]

{ #category : #accessing }
TCAPFullAbort >> cause: anObject [
	cause := anObject
]

{ #category : #accessing }
TCAPFullAbort >> dtid [
	^ dtid
]

{ #category : #accessing }
TCAPFullAbort >> dtid: anObject [
	dtid := anObject
]

{ #category : #accessing }
TCAPFullAbort >> otid [
	^ otid
]

{ #category : #accessing }
TCAPFullAbort >> otid: anObject [
	otid := anObject
]
