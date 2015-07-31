Class {
	#name : #TCAPTransactionCoordinator,
	#superclass : #TCAPObject,
	#instVars : [
		'container',
		'messageType',
		'tcapPdu'
	],
	#category : #'TCAP-Core-Model'
}

{ #category : #'as yet unclassified' }
TCAPTransactionCoordinator class >> on: aNetworkService [
	^ self new 
		initializeWith: aNetworkService
]

{ #category : #'as yet unclassified' }
TCAPTransactionCoordinator >> abortWithNewTransaction: anOtid cause: aPAbort [
	(TCAPRemoteAbort new
		otid: anOtid;
		cause: aPAbort) signal
]

{ #category : #accessing }
TCAPTransactionCoordinator >> asn1 [
	^ ASN1
]

{ #category : #accessing }
TCAPTransactionCoordinator >> asn1Context [
	^ asn1Context ifNil: [ 
		asn1Context := container asn1Context ]
]

{ #category : #accessing }
TCAPTransactionCoordinator >> asn1Model [
	^ self asn1Context model 
]

{ #category : #accessing }
TCAPTransactionCoordinator >> asn1TypeNamed: aString [
	^ self asn1Model typeNamed: aString
]

{ #category : #accessing }
TCAPTransactionCoordinator >> container: aServiceEndPoint [ 
	container := aServiceEndPoint
]

{ #category : #accessing }
TCAPTransactionCoordinator >> createBasicTransaction [
	^ container 
		basicNewDialogueAndTransaction 
		register 
		transaction
]

{ #category : #'as yet unclassified' }
TCAPTransactionCoordinator >> decodeBinaryMessageFrom: aByteArray [
	^ [ (TCAPBinaryMessage on: aByteArray) taggedValue; yourself ]
		on: ASN1TaggedValueError 
		do: [ :readError |
			"reading tagged values has failed. Try to recover as much data as necessary
			 to send back a response to the sender" 
			self 
				recoverAndAbort: readError taggedValues 
				cause: TCAPDialoguePAbort incorrectTransactionPortion ]
]

{ #category : #'as yet unclassified' }
TCAPTransactionCoordinator >> decodeEntityMessageFrom: aByteArray [ 
	| message |
	^ [ 
		message := self decodeTCMessageFrom: aByteArray.
		message validateSyntax.
		message realEntityMessage ]
		on: TCAPSyntaxError 
		do: [ :err | 
			message realEntityMessage handleSyntaxError ]
]

{ #category : #'as yet unclassified' }
TCAPTransactionCoordinator >> decodeTCMessageFrom: aByteArray [ 
	"decode binary message to know the type of the entity message. Decode the binary
	message into an entity message. In case of an abort there are two cases u-abort and
	p-abort. We call realMessage to get the most specific class of entity message there is"
	| binaryMessage |
	binaryMessage := (self decodeBinaryMessageFrom: aByteArray).
	^ [	
		(ASN1 
			read: binaryMessage taggedValue
			usingType:  self messageType
			inContext: self asn1Model
			skipErrors: false
			as: self messageClass
			reader: self newASN1Reader)]
		on: ASN1StructureError 
		do: [ :err | 
			(self recoveryRead: binaryMessage taggedValue) handleSyntaxError ]
]

{ #category : #'as yet unclassified' }
TCAPTransactionCoordinator >> deriveId: aString from: aDictionary [
	^ [ aDictionary at: aString ]
		on: Error
		do: [ :err | nil ]
]

{ #category : #accessing }
TCAPTransactionCoordinator >> dialogueHandler [
	^ container dialogueHandler
]

{ #category : #'as yet unclassified' }
TCAPTransactionCoordinator >> discard [
	"Abort scenario (3) from Q.774 p. 30/32 "
	"do nothing. discard message"
	TCAPProcessingAborted signal
]

{ #category : #requests }
TCAPTransactionCoordinator >> encodePayload: aDictionary [
	 ^ self asn1Model resolveOidsWhile: [ 
			self asn1
				encodeToByteArray: aDictionary
				usingType: self tcapPdu ].	
]

{ #category : #accessing }
TCAPTransactionCoordinator >> factory [
	^ factory ifNil: [
		factory := container factory ]
]

{ #category : #'as yet unclassified' }
TCAPTransactionCoordinator >> fullAbortOtid: anOtid dtid: aDtid cause: aPAbort [
	"Abort scenario (2) from Q.774 p. 30/32 "
	"Otid derivable?"
	anOtid ifNil: [ self discard ].
	"Dtid assigned? Dtid needs to be present and an transaction with that dtid must exist"
	(self transactionWithId: aDtid)
		ifNotNil: [ :transaction | 
			transaction remoteTransactionId: anOtid.
			"abort the local transaction"
			transaction pAbort: (transaction newPAbort value: aPAbort value).
			transaction localAbort ]
		ifNil: [ 
			(self transactionWithRemoteId: anOtid)
				ifNotNil: [ : tx | tx pAbort: aPAbort ]
				ifNil: [  
					"create a helper transaction that can be aborted"
					self abortWithNewTransaction: anOtid cause: aPAbort ]].
	TCAPProcessingAborted signal
]

{ #category : #'as yet unclassified' }
TCAPTransactionCoordinator >> indicationTrEnd: aTransaction userData: anASN1Dictionary [ 
	container dialogueHandler indicationTrEnd: aTransaction userData: anASN1Dictionary 
]

{ #category : #'as yet unclassified' }
TCAPTransactionCoordinator >> initializeWith: aNetworkService [
	aNetworkService onUnitData: [ :receiver :sender :data |
		self receive: data from: sender to: receiver  ]
]

{ #category : #accessing }
TCAPTransactionCoordinator >> messageClass [
	 ^ TCMessage
]

{ #category : #accessing }
TCAPTransactionCoordinator >> messageType [
	 ^ messageType ifNil: [
		messageType := self asn1TypeNamed: 'TCMessage' ]
]

{ #category : #'as yet unclassified' }
TCAPTransactionCoordinator >> messageTypeOf: aTaggedValue [ 
	^ (self tcapModule pdu elementWithTag: aTaggedValue tag) key
]

{ #category : #accessing }
TCAPTransactionCoordinator >> newASN1Reader [
	^ ASN1ReadVisitor new
		objectFactory: self factory 
]

{ #category : #accessing }
TCAPTransactionCoordinator >> newTransaction [
	^ container newTransaction
]

{ #category : #indications }
TCAPTransactionCoordinator >> notifyDialogueCreated: aDialogue [ 
	container notifyDialogueCreated: aDialogue
]

{ #category : #indications }
TCAPTransactionCoordinator >> notifyDialogueReceived: aDialogue [ 
	container notifyDialogueReceived: aDialogue
]

{ #category : #indications }
TCAPTransactionCoordinator >> receive: aByteArray from: aSender to: aReceiver [
	| message |
	"decode incoming bytes to an tcap entity message (being, continue, abort, end)"
	self 
		withAbortHandlersDo: [ 
			message := self withCurrentContextDo: [ self decodeEntityMessageFrom: aByteArray ].
			self receiveEntityMessage: message from: aSender to: aReceiver  ] 
		from: aSender 
		to: aReceiver

]

{ #category : #indications }
TCAPTransactionCoordinator >> receiveEntityMessage: message from: aSender to: aReceiver [
	| transaction |
		"notify handlers about the message received. No transaction/dialogue created by now"
	transaction := self 
		transactionForMessage: message
		sender: aSender 
		receiver: aReceiver.
	transaction notifyBeforeMessage: message.
	message dispatchTo: transaction.
	transaction notifyAfterMessage: message
]

{ #category : #'as yet unclassified' }
TCAPTransactionCoordinator >> receiveSelectorFor: aString [
	^  (String streamContents: [:stream|
		stream 
			nextPutAll: 'received';
			nextPutAll: aString capitalized;
			nextPutAll: ':components:']) asSymbol .
]

{ #category : #indications }
TCAPTransactionCoordinator >> receiveTCMessage: message from: aSender to: aReceiver [
	self 
		receiveEntityMessage: message realEntityMessage
		from: aSender 
		to: aReceiver 
]

{ #category : #'as yet unclassified' }
TCAPTransactionCoordinator >> recoverAndAbort: aTaggedValue cause: aNumber [
	| partial |
	"parsing of the structure has failed. We parse again and ignore errors while parsing. From
	the partial object we parse we try to deduct enough information to send back an abort 
	message to the sender."
	
	aTaggedValue isError ifFalse: [  
		partial := self recoveryRead: aTaggedValue ].

	self 
		fullAbortOtid: (self deriveId: 'otid' from: partial)
		dtid: (self deriveId: 'dtid' from: partial)
		cause: aNumber
]

{ #category : #'as yet unclassified' }
TCAPTransactionCoordinator >> recoveryRead: aTaggedValue [ 
	| message |
	message := (ASN1
		read: aTaggedValue 
		usingType: self tcapModule pdu
		inContext: self asn1Model 
		skipErrors: true
		as: self messageClass
		reader: self newASN1Reader) entityMessage.
	"((message hasField: 'otid') and: [ (message at: 'otid') isNil ]) ifTrue: [  "
		message basicAt: 'otid' put:  (ASN1 octetStringFrom: aTaggedValue withTagNumber: 8) "]".
	"((message hasField: 'dtid') and: [ (message at: 'dtid') isNil ]) ifTrue: [  "
		message basicAt: 'dtid' put: (ASN1 octetStringFrom: aTaggedValue withTagNumber: 9) "]".
	^ message
]

{ #category : #accessing }
TCAPTransactionCoordinator >> removeTransaction: aTransaction [ 
	container removeDialogueAndTransaction: aTransaction container 
]

{ #category : #requests }
TCAPTransactionCoordinator >> requestTrBegin: aTransaction destinationAddress: aDestinationAddress originatingAddress: anOriginatingAddress userData: aDictionary [ 
	^ aTransaction 
		address: anOriginatingAddress;
		remoteAddress: aDestinationAddress;
		requestTrBegin: aDictionary 
]

{ #category : #requests }
TCAPTransactionCoordinator >> requestTrContinue: aDictionary transaction: aTransaction [ 
	aTransaction requestTrContinue: aDictionary
]

{ #category : #requests }
TCAPTransactionCoordinator >> requestTrEnd: aDictionary transaction: aTransaction [ 
	aTransaction requestTrEnd: aDictionary.

]

{ #category : #requests }
TCAPTransactionCoordinator >> requestTrPAbort: aNumber transaction: aTransaction [ 
	aTransaction requestTrPAbort: aNumber.
	aTransaction stop.
]

{ #category : #requests }
TCAPTransactionCoordinator >> requestTrUAbort: anObject transaction: aTransaction [  
	aTransaction 
		requestTrUAbort: anObject;
		stop
]

{ #category : #requests }
TCAPTransactionCoordinator >> sendPayload: aDictionary to: aDestinationAddress from: anOriginatingAddress [
	container networkService 
		sendUnitData: (self encodePayload: aDictionary)
		to: aDestinationAddress  
		from: anOriginatingAddress  
]

{ #category : #accessing }
TCAPTransactionCoordinator >> serviceEndPoint [
	^ container
]

{ #category : #accessing }
TCAPTransactionCoordinator >> tcapPdu [
	^ tcapPdu ifNil: [ 
		tcapPdu := self tcapModule pdu ]
]

{ #category : #accessing }
TCAPTransactionCoordinator >> transactionCoordinator [
	^ self
]

{ #category : #'as yet unclassified' }
TCAPTransactionCoordinator >> transactionForMessage: aMessage sender: aSender receiver: aReceiver [
	^ [ (aMessage transactionIn: self)
			address: aReceiver;
			remoteAddress: aSender ]
		on: TCAPResourceLimitExceeded 
		do: [ :limit |
			limit transaction 
				address: aReceiver;
				remoteAddress: aSender;
				pAbort: (limit transaction newPAbort value: TCAPDialoguePAbort resourceLimitation);
				stop. 
				TCAPProcessingAborted signal ].
]

{ #category : #accessing }
TCAPTransactionCoordinator >> transactionWithId: aString [ 
	^ container transactionWithId: aString
]

{ #category : #'as yet unclassified' }
TCAPTransactionCoordinator >> transactionWithRemoteId: aString [ 
	^ container transactionWithRemoteId: aString 
]

{ #category : #indications }
TCAPTransactionCoordinator >> withAbortHandlersDo: aBlock from: aSender to: aReceiver [
	"decode incoming bytes to an tcap entity message (being, continue, abort, end)"
	[[[
		aBlock
			on: TCAPFullAbort
			do: [ :basic |
				"transaction known to both sides. Abort remote and local"
				self fullAbortOtid: basic otid dtid: basic dtid cause:  basic cause ]]
			on:  TCAPRemoteAbort
			do: [ :abort | | tx |
				"only the remote transaction is known and aborted"
				tx := self createBasicTransaction.
				tx address: aReceiver;
					remoteAddress: aSender;
					remoteTransactionId: abort otid;
					pAbort: (tx newPAbort value: abort cause value) ]]
			on: TCAPLocalAbort
			do: [ :ab | 
				"Abort scenario (5) from Q.774 p. 30/32 "
				"if a local transaction is available abort it. If none is available docontent nothing"
				(self transactionWithId: ab dtid) ifNotNil: [ :tn | tn abortWithReason: nil ]]]
			on: TCAPProcessingAborted
			do: [ :err | "nothing can be done...discard the message " ]
]
