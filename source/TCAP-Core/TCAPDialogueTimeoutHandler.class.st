Class {
	#name : #TCAPDialogueTimeoutHandler,
	#superclass : #TCAPAllNotificationHandler,
	#instVars : [
		'dialogues',
		'timeout',
		'monitor'
	],
	#category : #'TCAP-Core-Handler'
}

{ #category : #'instance creation' }
TCAPDialogueTimeoutHandler class >> registerAt: aServiceEndPoint [ 
	^ self new
		registerAt: aServiceEndPoint 
]

{ #category : #'as yet unclassified' }
TCAPDialogueTimeoutHandler >> abortDialogue: aDialogue [
	self flag: #needsRedesign.
	"what should be done here. For now we just do a local abort"
	self logInfo: 'dialogue ', aDialogue asString, ' has been inactive for ', self timeout asString,'. Dialogue is terminated...'  area: #tcap. 
	aDialogue terminate
]

{ #category : #'as yet unclassified' }
TCAPDialogueTimeoutHandler >> addDialogue: aDialogue [ 
	monitor critical: [  
		dialogues 
			at: aDialogue 
			put: (self timeForDialogue: aDialogue) ]
]

{ #category : #handling }
TCAPDialogueTimeoutHandler >> dialogueBeginReceived: aBeginReceived [
	super dialogueBeginReceived: aBeginReceived.
	self markAsActive: aBeginReceived dialogue

]

{ #category : #handling }
TCAPDialogueTimeoutHandler >> dialogueContinueReceived: aContinueReceived [
	super dialogueContinueReceived: aContinueReceived.
	self markAsActive: aContinueReceived dialogue
]

{ #category : #handling }
TCAPDialogueTimeoutHandler >> dialogueCreated: dialogueCreated [
	super dialogueCreated: dialogueCreated.
	"start monitoring dialogue"
	self addDialogue: dialogueCreated dialogue
]

{ #category : #handling }
TCAPDialogueTimeoutHandler >> dialogueTerminated: dialogueTerminated [
	super dialogueTerminated: dialogueTerminated.
	"stop monitoring dialogue"
	self removeDialogue: dialogueTerminated dialogue
]

{ #category : #testing }
TCAPDialogueTimeoutHandler >> hasActiveDialogues [
	^ dialogues notEmpty
]

{ #category : #initialize }
TCAPDialogueTimeoutHandler >> initialize [
	super initialize.
	dialogues := IdentityDictionary new.
	timeout := Duration hours: 1.
	monitor := Semaphore forMutualExclusion.
]

{ #category : #handling }
TCAPDialogueTimeoutHandler >> invocationReceived: anInvocationReceived [
	super invocationReceived: anInvocationReceived.
	self markAsActive: anInvocationReceived dialogue
]

{ #category : #'as yet unclassified' }
TCAPDialogueTimeoutHandler >> markAsActive: aDialogue [ 
	dialogues 
		at: aDialogue
		ifPresent: [ :timer | timer cancel ].
	monitor critical: [  
		dialogues 
			at: aDialogue 
			put: (self timeForDialogue: aDialogue) ]
]

{ #category : #removing }
TCAPDialogueTimeoutHandler >> removeDialogue: aDialogue [
	
	monitor critical: [ dialogues removeKey: aDialogue ]
]

{ #category : #accessing }
TCAPDialogueTimeoutHandler >> timeForDialogue: aDialogue [
	^ TimerScheduler instance 
		scheduleIn: self timeout asDuration
		block: [ self abortDialogue: aDialogue ]
]

{ #category : #accessing }
TCAPDialogueTimeoutHandler >> timeout [
	^ timeout
]

{ #category : #accessing }
TCAPDialogueTimeoutHandler >> timeout: anObject [
	timeout := anObject
]
