Class {
	#name : #TCAPInitiationReceivedDialogueState,
	#superclass : #TCAPDialogueState,
	#category : #'TCAP-Core-State'
}

{ #category : #accessing }
TCAPInitiationReceivedDialogueState class >> label [
	^ #initiationReceived
]

{ #category : #indications }
TCAPInitiationReceivedDialogueState >> indicationTrPAbort: aDictionaryOrNumber [
	self flag: #unchecked.
	aDictionaryOrNumber ifNil: [ 
		^ dialogue indicationTcUAbort: aDictionaryOrNumber  ].
	dialogue hasApplicationContext 
		ifTrue: [  self halt ]
		ifFalse: [ 
			(aDictionaryOrNumber isNumber)
				ifTrue: [ dialogue indicationTcPAbort: aDictionaryOrNumber ] 
				ifFalse: [ dialogue indicationTcUAbort: aDictionaryOrNumber ] ]
]

{ #category : #indications }
TCAPInitiationReceivedDialogueState >> indicationTrUAbort: anObject [
	self flag: #unchecked.
	dialogue notifyUAbort: anObject 
]

{ #category : #requests }
TCAPInitiationReceivedDialogueState >> requestTcContinue [
	| continue |

	continue := dialogue newContinueMessage
		at: 'dialoguePortion' put: (dialogue externalValue: (dialogue newAcceptedDialogueResponse: nil));
		yourself.
	dialogue addComponentsTo: continue.
	dialogue switchState: #active.
	dialogue transaction requestTrContinue: continue.

]

{ #category : #requests }
TCAPInitiationReceivedDialogueState >> requestTcEnd: aTerminationBoolean [
	self flag: #unchecked.
	self endDialogue: aTerminationBoolean
]

{ #category : #requests }
TCAPInitiationReceivedDialogueState >> requestTcPAbort: aPAbort [
	self flag: #unchecked.
	dialogue transaction requestTrPAbort: aPAbort.
	dialogue terminate.
]

{ #category : #requests }
TCAPInitiationReceivedDialogueState >> requestTcUAbort: anAbortInformation [
	| abort |
	dialogue hasApplicationContext
		ifTrue: [  
			abort := ( anAbortInformation notNil  and: [ anAbortInformation isRefused ]) 
				ifTrue: [  anAbortInformation asAbort ]
				ifFalse: [ self factory newDialogueUAbort serviceUser asAbortIn: self factory ]]
		ifFalse: [ abort := nil ].
	dialogue transaction requestTrUAbort: abort.
	dialogue terminate
]
