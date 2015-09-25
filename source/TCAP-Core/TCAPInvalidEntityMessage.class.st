Class {
	#name : #TCAPInvalidEntityMessage,
	#superclass : #TCAPEntityMessage,
	#category : #'TCAP-Core-Model'
}

{ #category : #accessing }
TCAPInvalidEntityMessage >> at: key put: anObject [
	self privAt: key put: anObject
]

{ #category : #'error handling' }
TCAPInvalidEntityMessage >> handleSyntaxError [
	(TCAPFullAbort new
		otid: (map at: 'otid' ifAbsent: [ nil ] );
		dtid: (map at: 'dtid' ifAbsent: [ nil ] );
		cause: TCAPDialoguePAbort unrecognizedMessageType  ) signal
]

{ #category : #testing }
TCAPInvalidEntityMessage >> hasField: aString [
	^ true
]
