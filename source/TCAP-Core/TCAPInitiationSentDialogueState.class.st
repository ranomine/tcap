"
Init Sent (IS): A begin message has been send: an indication from the peer entity wether the transaction has been established or not is awaited.
"
Class {
	#name : #TCAPInitiationSentDialogueState,
	#superclass : #TCAPDialogueState,
	#category : #'TCAP-Core-State'
}

{ #category : #accessing }
TCAPInitiationSentDialogueState class >> label [
	^ #initiationSent
]

{ #category : #'as yet unclassified' }
TCAPInitiationSentDialogueState >> dialogueMatchesMessage: aMessage do: aBlock [
	"if not both are present or not then signal a p-abort"
	(aMessage hasDialoguePortion xor: dialogue hasApplicationContext) 
		ifTrue: [
			dialogue indicationTcPAbort: nil.
			^ self ].
	aBlock value

]

{ #category : #indications }
TCAPInitiationSentDialogueState >> indicationTrContinue: aMessage [ 
	self flag: #unchecked.
	(aMessage hasDialoguePortion xor: dialogue hasApplicationContext) not
		ifTrue: [ 
			dialogue switchState: #active.
			dialogue indicationTcContinue: aMessage.
			dialogue processComponentsOf: aMessage  ]
		ifFalse: [ dialogue notifyPAbort: nil.
				dialogue transaction  
					requestTrUAbort: dialogue newPAbort serviceProvider.
				dialogue terminate ].
]

{ #category : #indications }
TCAPInitiationSentDialogueState >> indicationTrEnd: aMessage [ 
	"Q.774 p. 45"
	|  dialoguePortion |
	
	self dialogueMatchesMessage: aMessage do:  [ 
		"present case"
		(aMessage hasDialoguePortion) 
			ifTrue: [ 
				dialoguePortion := aMessage dialoguePortion.
				(dialoguePortion value pduType = 'dialogueResponse') 
				ifTrue: [
					dialogue indicationTcEnd: aMessage. "end needs to be signaled before the components are processed"
					aMessage hasComponents ifTrue: [
						dialogue processComponentsOf: aMessage ] ]
				ifFalse: [  ^ dialogue abortAbnormal  ] ]
		"absent case"
		ifFalse: [ 
			dialogue indicationTcEnd: aMessage. "end needs to be signaled before the components are processed"
			aMessage hasComponents ifTrue: [
				dialogue processComponentsOf: aMessage ] ] ]
]

{ #category : #'as yet unclassified' }
TCAPInitiationSentDialogueState >> indicationTrPAbort: anObject [ 
	self flag: #unchecked.
	dialogue notifyPAbort: anObject 
]

{ #category : #indications }
TCAPInitiationSentDialogueState >> indicationTrUAbort: anObject [
	self flag: #unchecked.
	dialogue notifyUAbort: anObject.
	"U-abort in initiation sent should terminate, see Q774, page 36"
	dialogue terminate.
]

{ #category : #requests }
TCAPInitiationSentDialogueState >> requestTcEnd: aTerminationBoolean [
	"Q.774 p. 45" 
	self endDialogue: true
]

{ #category : #requests }
TCAPInitiationSentDialogueState >> requestTcUAbort: anAbort [
	| apdu |
	dialogue hasApplicationContext ifTrue: [ 
		apdu := anAbort ifNil: [ dialogue newUAbort serviceUser ] ].
	dialogue transaction requestTrUAbort: (apdu asAbortIn: self factory) .
	dialogue terminate.
]
