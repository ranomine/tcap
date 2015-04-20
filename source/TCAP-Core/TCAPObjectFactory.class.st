Class {
	#name : #TCAPObjectFactory,
	#superclass : #ASN1ObjectFactory,
	#instVars : [
		'activeDialogueStateClass',
		'stateClasses',
		'dialogueStateClasses',
		'transactionStateClasses'
	],
	#classInstVars : [
		'defaultStateClasses',
		'defaultDialogueStateClasses',
		'defaultTransactionStateClasses'
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
	^ TCAPAbortMessage newIn: self
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
	^ (TCAPDialoguePDU newIn: self)
		at: aPdu pduType put: aPdu;
		yourself
		
]

{ #category : #accessing }
TCAPObjectFactory >> newDialoguePortion: aDialoguePDU [ 
	^  (TCAPDialoguePortion newIn: self)
		oid: (self typeNamed: aDialoguePDU oidName);
		value: aDialoguePDU 
		
]

{ #category : #accessing }
TCAPObjectFactory >> newDialogueRequest [
	^ (TCAPDialogueRequest newIn: self)
		at: 'protocol-version' put: '1';
		yourself
]

{ #category : #accessing }
TCAPObjectFactory >> newDialogueResponse [
	^ (TCAPDialogueResponse newIn: self)
		at: 'protocol-version' put: '1';
		yourself
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
