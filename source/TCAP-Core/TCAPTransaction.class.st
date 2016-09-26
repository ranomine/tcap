Class {
	#name : #TCAPTransaction,
	#superclass : #TCAPEnvironment,
	#instVars : [
		'address',
		'remoteAddress',
		'remoteTransactionId'
	],
	#category : #'TCAP-Core-Model'
}

{ #category : #requests }
TCAPTransaction >> abortWithReason: anASN1Dictionary [ 
	self state abortWithReason: anASN1Dictionary 
]

{ #category : #accessing }
TCAPTransaction >> address [
	^ address 
]

{ #category : #accessing }
TCAPTransaction >> address: anAddress [
	address := anAddress 
]

{ #category : #requests }
TCAPTransaction >> basicAbort: abort [
	| tcMessage |
	self remoteTransactionId ifNotNil: [  
		abort at: 'dtid' put: self remoteTransactionId ].
	tcMessage := self factory newValueForTypeNamed: 'TCMessage'.
	self flag: #needsRedesign.
	"expandFieldName will create an object for the abort we are setting.
	Needs a way to set a predefined value"
	(tcMessage expandFieldNamed: 'abort') value: abort.
	self sendPayload: tcMessage.
	self stop.
]

{ #category : #accessing }
TCAPTransaction >> dialogue [
	^ container dialogue
]

{ #category : #accessing }
TCAPTransaction >> dialogueHandler [
	^ container dialogueHandler
]

{ #category : #indications }
TCAPTransaction >> indicationTrBegin: aBegin userData:  aDictionary [
	self state indicationTrBegin: aDictionary userData: aDictionary
	

]

{ #category : #indications }
TCAPTransaction >> indicationTrEnd: anASN1Dictionary [ 
	container transactionCoordinator indicationTrEnd: self  userData: anASN1Dictionary 
]

{ #category : #requests }
TCAPTransaction >> localAbort [
	self state localAbort
]

{ #category : #accessing }
TCAPTransaction >> newState: aSymbol [
	^ self factory newTransactionState: aSymbol.
]

{ #category : #actions }
TCAPTransaction >> nextState: aState [ 
	aState transaction: self.
	super nextState: aState
]

{ #category : #notifying }
TCAPTransaction >> notifyAfterMessage: aMessage [ 
	self dialogue notifyAfterMessage: aMessage 
]

{ #category : #notifying }
TCAPTransaction >> notifyBeforeMessage: aMessage [ 
	self dialogue notifyBeforeMessage: aMessage
]

{ #category : #requests }
TCAPTransaction >> pAbort: aPAbort [
	self basicAbort: (aPAbort asAbortIn: self factory)
]

{ #category : #indications }
TCAPTransaction >> receivedAbort: aDictionary [ 
	self state receivedAbort: aDictionary
]

{ #category : #indications }
TCAPTransaction >> receivedBegin: aMessage [
	self state receivedBegin:aMessage
]

{ #category : #indications }
TCAPTransaction >> receivedContinue: aMessage [
	self state receivedContinue: aMessage
]

{ #category : #indications }
TCAPTransaction >> receivedEnd: anASN1Dictionary [ 
	self state receivedEnd: anASN1Dictionary 
]

{ #category : #accessing }
TCAPTransaction >> receivedPAbort: aMessage [ 
	self state receivedPAbort: aMessage
]

{ #category : #accessing }
TCAPTransaction >> receivedUAbort: aMessage [ 
	self state receivedUAbort: aMessage
]

{ #category : #accessing }
TCAPTransaction >> remoteAddress [
	^ remoteAddress
]

{ #category : #accessing }
TCAPTransaction >> remoteAddress: anObject [
	remoteAddress := anObject
]

{ #category : #accessing }
TCAPTransaction >> remoteTransactionId [
	^ remoteTransactionId
]

{ #category : #accessing }
TCAPTransaction >> remoteTransactionId: anObject [
	remoteTransactionId := anObject
]

{ #category : #requests }
TCAPTransaction >> requestPreArrangedEndWithUserData: anObject [
	self state requestPreArrangedEndWithUserData: anObject
]

{ #category : #requests }
TCAPTransaction >> requestTrBegin: anASN1Dictionary [ 
	self state requestTrBegin: anASN1Dictionary 
]

{ #category : #requests }
TCAPTransaction >> requestTrContinue: aDictionary [
	self state requestTrContinue: aDictionary
]

{ #category : #requests }
TCAPTransaction >> requestTrEnd: aDictionary [
	self state requestTrEnd: aDictionary
]

{ #category : #requests }
TCAPTransaction >> requestTrPAbort: aPAbort [
	self state requestTrPAbort: aPAbort
]

{ #category : #requests }
TCAPTransaction >> requestTrUAbort: anObject [
	self state requestTrUAbort: anObject 
]

{ #category : #sending }
TCAPTransaction >> sendPayload: aValue [
	self transactionCoordinator 
		sendPayload: aValue
		to: remoteAddress 
		from: address
]

{ #category : #actions }
TCAPTransaction >> stop [
	self switchState: #stopped.
	container transactionCoordinator removeTransaction: self.
]
