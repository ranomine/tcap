Class {
	#name : #TCAPObjectFactory,
	#superclass : #ASN1ObjectFactory,
	#instVars : [
		'dialogueStateClasses',
		'transactionStateClasses'
	],
	#category : #'TCAP-Core-Model'
}

{ #category : #'as yet unclassified' }
TCAPObjectFactory class >> defaultDialogueStateClasses [
	^ { 
		#idle -> TCAPIdleDialogueState .
		#initiationReceived -> TCAPInitiationReceivedDialogueState .
		#initiationSent -> TCAPInitiationSentDialogueState .
		#active -> TCAPActiveDialogueState .
		#stopped -> TCAPStoppedDialogueState } asDictionary
]

{ #category : #'as yet unclassified' }
TCAPObjectFactory class >> defaultTransactionStateClasses [
	^ { 
		#idle -> TCAPIdleTransactionState .
		#initiationReceived -> TCAPInitiationReceivedTransactionState .
		#initiationSent -> TCAPInitiationSentTransactionState .
		#active -> TCAPActiveTransactionState .
		#stopped -> TCAPStoppedTransactionState } asDictionary
]

{ #category : #'as yet unclassified' }
TCAPObjectFactory >> defaultIdPool [
	^ self newIdPool
		size: 16rFFFFFFFF;
		startValue: 16r1000000.
]

{ #category : #'as yet unclassified' }
TCAPObjectFactory >> dialogueAndTransactionClass [
	^ TCAPDialogueAndTransaction
]

{ #category : #'as yet unclassified' }
TCAPObjectFactory >> dialogueClass [
	^ TCAPDialogue
]

{ #category : #'as yet unclassified' }
TCAPObjectFactory >> dialogueHandlerClass [
	^ TCAPDialogueHandler  
]

{ #category : #accessing }
TCAPObjectFactory >> dialoguePortionFromApdu: anApdu [
	| dialoguePdu external  |
	dialoguePdu := self newDialoguePDU: anApdu.
	external := dialoguePdu asExternalValue: (self typeNamed: dialoguePdu oidName).
		
	^ (self typeNamed: 'DialoguePortion') newValue: external	
]

{ #category : #accessing }
TCAPObjectFactory >> dialogueStateClassAt: aSymbol put: aClass [
	^ dialogueStateClasses 
		at: aSymbol
		put: aClass
]

{ #category : #'as yet unclassified' }
TCAPObjectFactory >> idPoolClass [
	^ TCAPIdPool 
]

{ #category : #initialization }
TCAPObjectFactory >> initialize [
	super initialize.
	dialogueStateClasses := self class defaultDialogueStateClasses copy.
	transactionStateClasses := self class defaultTransactionStateClasses copy
]

{ #category : #accessing }
TCAPObjectFactory >> installStateClass: aClass [ 
	aClass dispatchAddTo: self
]

{ #category : #accessing }
TCAPObjectFactory >> newAbortMessage [

	^ self newValueForTypeNamed: 'Abort'
]

{ #category : #accessing }
TCAPObjectFactory >> newBeginMessage [
	^ TCAPBeginMessage newIn: self
]

{ #category : #accessing }
TCAPObjectFactory >> newContinueMessage [
	^ TCAPContinueMessage newIn: self
]

{ #category : #'as yet unclassified' }
TCAPObjectFactory >> newDialogue [
	^ self dialogueClass new
]

{ #category : #'as yet unclassified' }
TCAPObjectFactory >> newDialogueAndTransaction [
	^ self dialogueAndTransactionClass new
		initializeFrom: self
]

{ #category : #'as yet unclassified' }
TCAPObjectFactory >> newDialogueHandler [
	^ self dialogueHandlerClass new
]

{ #category : #accessing }
TCAPObjectFactory >> newDialoguePAbort [
	^ TCAPDialoguePAbort newIn: self
]

{ #category : #accessing }
TCAPObjectFactory >> newDialoguePDU [
	^ TCAPDialoguePDU newIn: self
		
]

{ #category : #accessing }
TCAPObjectFactory >> newDialoguePDU: aPdu [
	| pduValue |
	pduValue := (self typeNamed: TCAPDialoguePDU asn1TypeName) newValue.
	^ pduValue 
		privAt: aPdu pduType put: aPdu;
		yourself		
]

{ #category : #accessing }
TCAPObjectFactory >> newDialogueRequest [

	^ ((self typeNamed: TCAPDialogueRequest asn1TypeName) newValue)
		at: 'protocol-version' put: #( version1 );
		yourself.
]

{ #category : #accessing }
TCAPObjectFactory >> newDialogueResponse [
	| dialogueResponse |
	dialogueResponse := (self typeNamed: 'AARE-apdu') newValue.
	dialogueResponse value
		at: 'protocol-version' put: #( version1 ).
	^ dialogueResponse
]

{ #category : #accessing }
TCAPObjectFactory >> newDialogueState: aSymbol [
	^ (dialogueStateClasses at: aSymbol) new
]

{ #category : #accessing }
TCAPObjectFactory >> newDialogueUAbort [
	^ TCAPDialogueUAbort newIn: self
]

{ #category : #accessing }
TCAPObjectFactory >> newEndMessage [
	^ TCAPEndMessage newIn: self
]

{ #category : #accessing }
TCAPObjectFactory >> newExternalValue: anObject oid: anOid [ 
	^ anObject asExternalValue: anOid
]

{ #category : #'as yet unclassified' }
TCAPObjectFactory >> newIdPool [
	^ self idPoolClass new
]

{ #category : #accessing }
TCAPObjectFactory >> newROSError [
	^ ROSError newIn: self
]

{ #category : #accessing }
TCAPObjectFactory >> newROSInvocation [
self halt.
	^ ROSInvocation newIn: self
]

{ #category : #accessing }
TCAPObjectFactory >> newROSReject [
	^ ROSReject newIn: self
]

{ #category : #accessing }
TCAPObjectFactory >> newROSResultLast [
	^ ROSResultLast newIn: self
]

{ #category : #accessing }
TCAPObjectFactory >> newTCMessage [
	^ TCMessage newIn: self
]

{ #category : #'as yet unclassified' }
TCAPObjectFactory >> newTransaction [
	^ self transactionClass new
]

{ #category : #'as yet unclassified' }
TCAPObjectFactory >> newTransactionCoordinator [
	^ self transactionCoordinatorClass new
]

{ #category : #accessing }
TCAPObjectFactory >> newTransactionState: aSymbol [
	^ (transactionStateClasses at: aSymbol) new
]

{ #category : #'as yet unclassified' }
TCAPObjectFactory >> transactionClass [
	^ TCAPTransaction
]

{ #category : #'as yet unclassified' }
TCAPObjectFactory >> transactionCoordinatorClass [
	^ TCAPTransactionCoordinator 
]

{ #category : #accessing }
TCAPObjectFactory >> transactionStateClassAt: aSymbol put: aClass [
	^ transactionStateClasses 
		at: aSymbol
		put: aClass
]
