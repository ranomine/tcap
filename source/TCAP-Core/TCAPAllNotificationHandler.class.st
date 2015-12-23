Class {
	#name : #TCAPAllNotificationHandler,
	#superclass : #TCAPNotificationHandler,
	#category : #'TCAP-Core-Handler'
}

{ #category : #notifications }
TCAPAllNotificationHandler >> afterBeginMessageReceived: aBeginMessage [ 

]

{ #category : #notifications }
TCAPAllNotificationHandler >> afterContinueMessageReceived: aContinueMessage [ 

]

{ #category : #notifications }
TCAPAllNotificationHandler >> afterEndMessageReceived: aEndMessage [ 

]

{ #category : #notifications }
TCAPAllNotificationHandler >> afterMessageReceived: anAfterMessageReceived [ 
	anAfterMessageReceived dispatchTo: self
]

{ #category : #notifications }
TCAPAllNotificationHandler >> afterPAbortMessageReceived: aMessage [ 

]

{ #category : #notifications }
TCAPAllNotificationHandler >> afterUAbortMessageReceived: aMessage [ 

]

{ #category : #notifications }
TCAPAllNotificationHandler >> beforeBeginMessageReceived: aBeforeMessageReceived [ 
	
]

{ #category : #notifications }
TCAPAllNotificationHandler >> beforeContinueMessageReceived: aContinueMessage [ 

]

{ #category : #notifications }
TCAPAllNotificationHandler >> beforeEndMessageReceived: aEndMessage [ 

]

{ #category : #notifications }
TCAPAllNotificationHandler >> beforeMessageReceived: aBeforeMessageReceived [ 
	aBeforeMessageReceived dispatchTo: self
]

{ #category : #notifications }
TCAPAllNotificationHandler >> beforePAbortMessageReceived: aMessage [ 

]

{ #category : #notifications }
TCAPAllNotificationHandler >> beforeUAbortMessageReceived: aMessage [ 

]

{ #category : #notifications }
TCAPAllNotificationHandler >> beginMessageReceived: aBeginMessage [ 

]

{ #category : #notifications }
TCAPAllNotificationHandler >> dialogueBeginReceived: aBeginReceived [ 
	
]

{ #category : #notifications }
TCAPAllNotificationHandler >> dialogueContinueReceived: aContinueReceived [ 
	
]

{ #category : #notifications }
TCAPAllNotificationHandler >> dialogueCreated: aDialogueCreated [

]

{ #category : #notifications }
TCAPAllNotificationHandler >> dialogueEndReceived: aEndReceived [ 
	
]

{ #category : #notifications }
TCAPAllNotificationHandler >> dialoguePAbortReceived: aPAbortReceived [ 
	
]

{ #category : #notifications }
TCAPAllNotificationHandler >> dialogueReceived: dialogueCreated [
	dialogueCreated dialogue addHandler: self
]

{ #category : #notifications }
TCAPAllNotificationHandler >> dialogueTerminated: dialogueTerminated [
	
]

{ #category : #notifications }
TCAPAllNotificationHandler >> dialogueUAbortReceived: aUAbortReceived [ 
	
]

{ #category : #notifications }
TCAPAllNotificationHandler >> invocationReceived: aInvocationReceived [ 
	
]

{ #category : #registering }
TCAPAllNotificationHandler >> registerAtDialogue: anAnnouncer [
	anAnnouncer when: TCAPBeginReceived send: #dialogueBeginReceived: to: self.
	anAnnouncer when: TCAPContinueReceived send: #dialogueContinueReceived: to: self.
	anAnnouncer when: TCAPEndReceived send: #dialogueEndReceived: to: self.
	anAnnouncer when: TCAPProtocolAbortReceived send: #dialoguePAbortReceived: to: self.
	anAnnouncer when: TCAPUserAbortReceived send: #dialogueUAbortReceived: to: self.
	anAnnouncer when: TCAPInvocationReceived send: #invocationReceived: to: self.
	anAnnouncer when: TCAPBeforeMessageReceived send: #beforeMessageReceived: to: self. 
	anAnnouncer when: TCAPAfterMessageReceived send: #afterMessageReceived: to: self.
]

{ #category : #registering }
TCAPAllNotificationHandler >> registerAtServicePoint: anAnnouncer [
	anAnnouncer when: TCAPDialogueCreated send: #dialogueCreated: to: self.
	anAnnouncer when: TCAPDialogueReceived send: #dialogueReceived: to: self.
	anAnnouncer when: TCAPDialogueTerminated send: #dialogueTerminated: to: self
]
