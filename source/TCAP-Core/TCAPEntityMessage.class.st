Class {
	#name : #TCAPEntityMessage,
	#superclass : #ASN1AdaptiveTypeObject,
	#category : #'TCAP-Core-Model'
}

{ #category : #'as yet unclassified' }
TCAPEntityMessage class >> asn1Context [
	^ ASN1CurrentContext value
]

{ #category : #'as yet unclassified' }
TCAPEntityMessage class >> forTaggedValue: aTaggedValue [ 
	^ self withType: (self messageTypeOf: aTaggedValue)
		
]

{ #category : #'as yet unclassified' }
TCAPEntityMessage class >> fromByteArray: aByteArray [
	| ctx |
	ctx := self asn1Context.
	^ ASN1 
			read: (TCAPBinaryMessage on: aByteArray)  taggedValue 
			usingType:  (ctx model typeNamed: 'TCMessage')
			inContext: ctx model
			skipErrors: false
			as: TCMessage
			reader: (ASN1ReadVisitor new objectFactory: ctx factory)
]

{ #category : #'as yet unclassified' }
TCAPEntityMessage class >> fromSCCP: aByteArray [
	^ self fromByteArray: ( SCCPUDT parseFrom: aByteArray ) data
]

{ #category : #'as yet unclassified' }
TCAPEntityMessage class >> messageTypeOf: aTaggedValue [ 
	^ [ (self tcapModule pdu elementWithTag: aTaggedValue tag) key ]
		on: NotFound
		do: [ :err | TCAPMessageTypeUnknown signal ]
]

{ #category : #'as yet unclassified' }
TCAPEntityMessage class >> tcapModule [
	^ self asn1Model moduleNamed: 'TCAPMessages'
]

{ #category : #'as yet unclassified' }
TCAPEntityMessage class >> withType: aString [
	^ (self subclasses 
		detect: [ :each | each type = aString ]
		ifNone: [ TCAPMessageTypeUnknown signal: aString ,' is not a valid message identifier'])
			new 
]

{ #category : #'as yet unclassified' }
TCAPEntityMessage >> abortLocalTransaction [
	"Abort scenario (5) from Q.774 p. 30/32 "
	"if a local transaction is available abort it. If none is available docontent 
	nothing"
	(TCAPLocalAbort new dtid: (map at: 'dtid' ifAbsent: [ nil ]) ) signal
]

{ #category : #'as yet unclassified' }
TCAPEntityMessage >> abortRemoteTransactionCause: aPAbort [ 
	"Abort scenario (4) from Q.774 p. 30/32 "
	"if an otid is found and it is valid try to send an abort message to the remote side"
	[self validateOtidSyntax.
	"otid has valid syntax. sent abort with badlyFormattedTransactionPortion = 2"
	(TCAPRemoteAbort otid: self otid cause: aPAbort) signal ]
		on: TCAPSyntaxError 
		do: [ :err | "do nothing. discard message" ].
	TCAPProcessingAborted signal
]

{ #category : #converting }
TCAPEntityMessage >> asTCMessage [
	| tcType |
	tcType := self asn1TypeNamed: 'TCMessage'.
	^ tcType newValue
		at: self class type
		put: ((tcType elementAt: self class type) newValue: self);
		yourself

]

{ #category : #'as yet unclassified' }
TCAPEntityMessage >> checkIdRange: aString [
	(aString notNil and: [ aString byteSize between: 1 and: 4 ]) ifFalse: [ 
		TCAPInvalidRange signal ]
	
]

{ #category : #accessing }
TCAPEntityMessage >> components [
	^ self at: 'components' ifAbsent: [ nil ]
]

{ #category : #accessing }
TCAPEntityMessage >> dialoguePortion [
	^ self at: 'dialoguePortion' ifAbsent: [ nil ]
]

{ #category : #'as yet unclassified' }
TCAPEntityMessage >> discard [
	"Abort scenario (3) from Q.774 p. 30/32 "
	"do nothing. discard message"
	TCAPProcessingAborted signal
]

{ #category : #accessing }
TCAPEntityMessage >> dtid [
	^ self at: 'dtid' ifAbsent: [ nil ]
]

{ #category : #converting }
TCAPEntityMessage >> entityMessage [
	self halt.
	^ self 
]

{ #category : #testing }
TCAPEntityMessage >> hasComponents [
	^ self components notNil and: [ self components size > 0 ]
]

{ #category : #testing }
TCAPEntityMessage >> hasDialoguePortion [
	^ self dialoguePortion notNil
]

{ #category : #accessing }
TCAPEntityMessage >> messageType [
	^ self class type
]

{ #category : #accessing }
TCAPEntityMessage >> otid [
	^ self at: 'otid' ifAbsent: [ nil ]
]

{ #category : #converting }
TCAPEntityMessage >> realMessage [
	^ self 
]

{ #category : #accessing }
TCAPEntityMessage >> rosMessages [
	^ (self components ifNil: [ #() ])
		collect: #message
]

{ #category : #accessing }
TCAPEntityMessage >> setMap: aDictionary [
	aDictionary ifNil: [ Error signal: 'cannot use nil as map' ].
	map := aDictionary
]

{ #category : #'as yet unclassified' }
TCAPEntityMessage >> transactionIn: aTransactionCoordinator [
	^ (aTransactionCoordinator transactionWithId: self dtid basicValue) ifNil: [  ^ self handleUnassignedTransaction  ].
]

{ #category : #validating }
TCAPEntityMessage >> validate [
	[ self validateSyntax ]
		on: TCAPSyntaxError 
		do: [ :err | 
			self handleSyntaxError.
			TCAPProcessingAborted signal ]
]

{ #category : #'as yet unclassified' }
TCAPEntityMessage >> validateDtidSyntax [
	self checkIdRange: self dtid
]

{ #category : #'as yet unclassified' }
TCAPEntityMessage >> validateOtidSyntax [
	self checkIdRange: self otid
]

{ #category : #validating }
TCAPEntityMessage >> validateProtocolVersion [
	self hasDialoguePortion ifTrue: [  
		((self dialoguePortion soleValue value basicAt: 'protocol-version') bitEquals: #( 'version1' ) ) 
			ifFalse: [ TCAPWrongProtocolVersion signal ] ]
]

{ #category : #validating }
TCAPEntityMessage >> validateSyntax [
	[ self validateProtocolVersion ]
		on: TCAPSyntaxError 
		do: [ :err | 
			self handleSyntaxError.
			TCAPProcessingAborted signal ]
]
