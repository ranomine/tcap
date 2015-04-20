Class {
	#name : #TCAPInvalidEntityMessage,
	#superclass : #TCAPEntityMessage,
	#category : #'TCAP-Core-Model'
}

{ #category : #'as yet unclassified' }
TCAPInvalidEntityMessage >> handleSyntaxError [
	(TCAPFullAbort new
		otid: (map at: 'otid' ifAbsent: [ nil ] );
		dtid: (map at: 'dtid' ifAbsent: [ nil ] );
		cause: TCAPDialoguePAbort unrecognizedMessageType  ) signal
]

{ #category : #'as yet unclassified' }
TCAPInvalidEntityMessage >> hasField: aString [
	^ false
]
