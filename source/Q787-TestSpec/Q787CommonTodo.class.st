Class {
	#name : #Q787CommonTodo,
	#superclass : #Q787CommonSpecTest,
	#category : #'Q787-TestSpec'
}

{ #category : #tests }
Q787CommonTodo >> test1_1_1_1 [
	"Unidirectional: Sending page 6"
	self assert: false.
	self flag: #TBD.
	"CHECK A: WAS THE UNIDIRECTIONAL MESSAGE CORRECTLY SENT FROM SP A? "
	"CHECK B: WAS THE TSL STATE MACHINE ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A?"
]

{ #category : #tests }
Q787CommonTodo >> test1_1_1_2 [
	"Unidirectional: Receiving page 7"
	self assert: false.
	self flag: #TBD.
	"CHECK A: WAS THE UNIDIRECTIONAL MESSAGE CORRECTLY RECEIVED AT SP A? "
	"CHECK B: WAS THE TSL STATE MACHINE ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A?"
]

{ #category : #tests }
Q787CommonTodo >> test1_1_3_2_1s1 [
	"Value variations: Transaction ID; length is one octet. Page 58"
	self assert: false.
	self flag: #TBD.
	
	"CHECK A: WAS THE BEGIN MESSAGE CORRECTLY RECEIVED AT SP A AND PASSED TO THE TR-USER? "
	"CHECK B: WAS AN END MESSAGE CORRECTLY SENT BY SP A? "
	"CHECK C: WAS THE DTID IN THE END MESSAGE THE SAME AS THE OTID IN THE BEGIN MESSAGE? "
	"CHECK D: WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A?"
]

{ #category : #tests }
Q787CommonTodo >> test1_1_3_2_1s2 [
	"Value variations: Transaction ID: Length is four octets. Page 60"
	self assert: false.
	self flag: #TBD.
	
	"CHECK A: WAS THE BEGIN MESSAGE CORRECTLY RECEIVED AT SP A AND PASSED TO THE TR-USER? "
	"CHECK B: WAS AN END MESSAGE CORRECTLY SENT BY SP A? "
	"CHECK C: WAS THE DTID IN THE END MESSAGE THE SAME AS THE OTID IN THE BEGIN MESSAGE? "
	"CHECK D: WERE TSL STATE MACHINES ASSOCIATED WITH THIS TRANSACTION LEFT IN THE IDLE STATE AT SP A?"
]

{ #category : #tests }
Q787CommonTodo >> test2_1_2_1_4 [
	"Invoke linked components. Page 143"
		self assert: false
		
	"CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFOR MATION PASSED TO TC-USER BY SP A? "
	"CHECK B: WAS A LINKED INVOKE COMPONENT WITH CORRECT INFORMATION SENT BY SP A? "
	"CHECK C: WAS THE LINKED ID THE SAME AS THE ORIGINAL INVOKE ID SENT BY SP B? "
	"CHECK D: WAS THE RETURN ERROR COMPONENT WITH CORRECT INFORMATION PASSED TO TC-USER BY SP A? "
	"CHECK E: WAS THE RETURN RESULT-LAST COMPONENT WITH CORRECT INFORMATION SENT BY SP A? "
	"CHECK F: WAS THE INVOKE ID IN THE RETURN RESULT-LAST COMPONENT THE SAME AS THE ONE IN THE 
		ORIGINAL INVOKE COMPONENT SENT BY SP B ? CHECK G: WAS THE INVOCATION STATE MACHINE IDLE AT SP A?"
]

{ #category : #tests }
Q787CommonTodo >> test2_1_2_2_1 [
	"Invoke linked components. Page 146"
	self assert: false
	
	"CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION SENT BY SP A? "
	"CHECK B: WAS A LINKED INVOKE COMPONENT WITH CORRECT INFORMATION PASSED TO TC-USER BY SP A? "
	"CHECK C: WAS THE INVOCATION STATE MACHINE IDLE AT SP A?"
]

{ #category : #tests }
Q787CommonTodo >> test2_1_2_2_2 [
	"Invoke linked components. Page 148"
	self assert: false
	
	"CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION PASSED TO TC-USER BY SP A? "
	"CHECK B: WAS A LINKED INVOKE COMPONENT WITH CORRECT INFORMATION SENT BY SP A? "
	"CHECK C: WAS THE LINKED ID THE SAME AS THE ORIGINAL INVOKE ID SENT BY SP B? "
	"CHECK D: WAS THE INVOCATION STATE MACHINE IDLE AT SP A?"
]

{ #category : #tests }
Q787CommonTodo >> test2_1_5_1_1 [
	"starts like 2.1.1.3.1, but return not-last followed by resturn last"
	
	"p 190. result-last vs. result-no-last is not modelled by ROS. ==> Backlog"
	
	| env dialogue invocation called           |
	env := self given: #shouldCreateTestEnvironment.
	
	self flag: #TBD.  
	
	env servicePointB
		onDialogue: [ :dialog |
			 dialog 
				onInvoke: [ : inv | 
					inv returnResultUsing: [ :result | result add: self exampleResult ].
					dialog requestTcContinue.
					inv returnResultLastUsing: [ :result | result add: self exampleResult ].
					dialog requestTcContinue ]].
	dialogue := env servicePointA newDialogue.	
	invocation :=dialogue requestTcInvokeNamed: 'sendAuthenticationInfoV2' parameters:  '123456789' asByteArray class: TCAPReportSuccess timeout: 500.
	invocation onReturnLast: [ :result |  called := true ].
	
	dialogue 
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: '0.4.0.0.1.0.14.2'.
		
	"CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION SENT BY SP A? "
	"CHECK B: WAS THE RETURN RESULT NOT-LAST COMPONENT WITH CORRECT INFORM ATION PASSED TO TC-USER BY SP A? "
	"CHECK C: WAS THE INVOCATION STATE MACHINE IDLE AT SP A?"
	
]

{ #category : #tests }
Q787CommonTodo >> test2_1_5_1_2 [
	"p 192 result-last vs. result-no-last is not modelled by ROS. ==> Backlog"
	self flag: #TBD.  
	self assert: false.
	
	"CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION PASSED TO TC-USER BY SP A? "
	"CHECK B: WAS THE RETURN RESULT NOT-LAST COMPONENT WITH CORRECT INFORMATION SENT BY SP A?  "
]

{ #category : #tests }
Q787CommonTodo >> test2_1_5_2_1 [
	"p 194 result-last vs. result-no-last is not modelled by ROS. ==> Backlog"
	self flag: #TBD.  
	self assert: false.
	
	"CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION SENT BY SP A? "
	"CHECK B: WAS THE RETURN RESULT NOT-LAST COMPONENT WITH CORRECT INFORMATION PASSED TO TC-USER BY SP A? " 	"CHECK C: WAS THE INVOCATION STATE MACHINE IDLE AT SP A ?"
]

{ #category : #tests }
Q787CommonTodo >> test2_1_6 [
	

	"CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION SENT BY SP A? "
	"CHECK B: WAS THE REJECT COMPONENT WITH CORRECT INFORMATION SENT BY SP A? "
	"CHECK C: WAS THE COMPONENT FLOW AS SHOWN ABOVE? "
	"CHECK D: WAS THE INVOCATION STATE MACHINE IDLE AT SP A?"
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
