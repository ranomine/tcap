Class {
	#name : #TCAPHandshakeHandler,
	#superclass : #TCAPAllNotificationHandler,
	#instVars : [
		'handshakeEnforced'
	],
	#category : #'TCAP-Core-Handler'
}

{ #category : #'as yet unclassified' }
TCAPHandshakeHandler >> afterBeginMessageReceived: anAfterBeginMessage [
	"if handshake is enabled the first message does not contain any components
	we automatically continue the message then"
	anAfterBeginMessage message components isEmptyOrNil  ifTrue: [ 
		anAfterBeginMessage dialogue requestTcContinue  ]
]

{ #category : #'as yet unclassified' }
TCAPHandshakeHandler >> beforeBeginMessageReceived: aMessageReceived [
	"if handshake is enforced the first (begin) message is not allowed to deliver components
	because trust needs to be established before treating any component."
	"not sure what P-Abort value should be delivered then"
	self flag: #needsRedesign.
	(handshakeEnforced and: [ aMessageReceived message hasComponents ]) ifTrue: [ 
		(TCAPRemoteAbort 
			otid: aMessageReceived message otid
			cause: TCAPDialoguePAbort resourceLimitation) signal  ]
]

{ #category : #initialize }
TCAPHandshakeHandler >> initialize [
	super initialize.
	handshakeEnforced := false
]

{ #category : #accessing }
TCAPHandshakeHandler >> withMandatoryHandshake [
	handshakeEnforced := true
]

{ #category : #accessing }
TCAPHandshakeHandler >> withOptionalHandshake [
	handshakeEnforced := false
]
