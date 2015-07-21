Class {
	#name : #Q787CommonTodo,
	#superclass : #Q787CommonSpecTest,
	#category : #'Q787-TestSpec'
}

{ #category : #tests }
Q787CommonTodo >> test1_1_1_1 [
		self assert: false
]

{ #category : #tests }
Q787CommonTodo >> test1_1_1_2 [
		self assert: false
]

{ #category : #tests }
Q787CommonTodo >> test1_1_3_2_1s1 [
		self assert: false
]

{ #category : #tests }
Q787CommonTodo >> test1_1_3_2_1s2 [
		self assert: false
]

{ #category : #tests }
Q787CommonTodo >> test2_1_1_1_4 [
		self assert: false
]

{ #category : #tests }
Q787CommonTodo >> test2_1_1_2_1 [
		self assert: false
]

{ #category : #tests }
Q787CommonTodo >> test2_1_1_2_2 [
		self assert: false
]

{ #category : #tests }
Q787CommonTodo >> test2_1_1_3_1 [
		self assert: false
]

{ #category : #tests }
Q787CommonTodo >> test2_1_1_3_2 [
		self assert: false
]

{ #category : #tests }
Q787CommonTodo >> test2_1_1_4_1 [
		self assert: false
]

{ #category : #tests }
Q787CommonTodo >> test2_1_2_1_1 [
		self assert: false
]

{ #category : #tests }
Q787CommonTodo >> test2_1_2_1_2 [
		self assert: false
]

{ #category : #tests }
Q787CommonTodo >> test2_1_2_1_3 [
		self assert: false
]

{ #category : #tests }
Q787CommonTodo >> test2_1_2_1_4 [
		self assert: false
]

{ #category : #tests }
Q787CommonTodo >> test2_1_2_2_1 [
		self assert: false
]

{ #category : #tests }
Q787CommonTodo >> test2_1_2_2_2 [
		self assert: false
]

{ #category : #tests }
Q787CommonTodo >> test2_1_5_1_1 [
		self assert: false
]

{ #category : #tests }
Q787CommonTodo >> test2_1_5_1_2 [
		self assert: false
]

{ #category : #tests }
Q787CommonTodo >> test2_1_5_2_1 [
		self assert: false
]

{ #category : #tests }
Q787CommonTodo >> test2_1_6 [
		self assert: false
]

{ #category : #tests }
Q787CommonTodo >> test2_1_9_1_1 [
		self assert: false
]

{ #category : #tests }
Q787CommonTodo >> test2_1_9_1_2 [
		self assert: false
]

{ #category : #tests }
Q787CommonTodo >> test2_1_9_1_3 [
	| env dialogue |
	env := self given: #shouldCreateTestEnvironment.
	
	env servicePointA onDialogue: [ :dialog |
		dialog onBegin: [  
			dialog requestTcEnd: false ]].
	dialogue := env servicePointB newDialogue.	
	dialogue 
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: '0.4.0.0.1.0.14.3'.
	
	self assert: env servicePointA didSendMessage.
	self checkBegin: env servicePointB sentPackets first.
	self checkEnd: env servicePointA sentPackets first.

]

{ #category : #tests }
Q787CommonTodo >> test2_1_9_2_1 [
		self assert: false
]

{ #category : #tests }
Q787CommonTodo >> test2_1_9_2_2 [
		self assert: false
]

{ #category : #tests }
Q787CommonTodo >> test2_1_9_3 [
		self assert: false
]

{ #category : #tests }
Q787CommonTodo >> test2_1_9_4 [
		self assert: false
]

{ #category : #tests }
Q787CommonTodo >> test2_1_9_5_1 [
		self assert: false
]

{ #category : #tests }
Q787CommonTodo >> test2_1_9_5_2 [
		self assert: false
]

{ #category : #tests }
Q787CommonTodo >> test2_1_9_5_4 [
		self assert: false
]

{ #category : #tests }
Q787CommonTodo >> test2_1_9_6 [
		self assert: false
]

{ #category : #tests }
Q787CommonTodo >> test2_1_9_7_1 [
		self assert: false
]

{ #category : #tests }
Q787CommonTodo >> test2_1_9_7_2 [
		self assert: false
]

{ #category : #tests }
Q787CommonTodo >> test2_2_2_5_2 [
		self assert: false
]

{ #category : #tests }
Q787CommonTodo >> test2_3_4_1 [
		self assert: false
]

{ #category : #tests }
Q787CommonTodo >> test2_3_4_2 [
		self assert: false
]

{ #category : #tests }
Q787CommonTodo >> test2_3_4_3 [
		self assert: false
]

{ #category : #tests }
Q787CommonTodo >> test2_3_4_5 [
		self assert: false
]

{ #category : #tests }
Q787CommonTodo >> test2_3_4_6 [
		self assert: false
]

{ #category : #tests }
Q787CommonTodo >> test2_3_4_7 [
		self assert: false
]

{ #category : #tests }
Q787CommonTodo >> test2_3_4_8 [
		self assert: false
]
