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
Q787CommonTodo >> test2_1_2_2_1 [
	"TimeOut Invoke linked components. Page 146"
	self assert: false
	
	"CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION SENT BY SP A? "
	"CHECK B: WAS A LINKED INVOKE COMPONENT WITH CORRECT INFORMATION PASSED TO TC-USER BY SP A? "
	"CHECK C: WAS THE INVOCATION STATE MACHINE IDLE AT SP A?"
]

{ #category : #tests }
Q787CommonTodo >> test2_1_2_2_2 [
	"Timeout Invoke linked components. Page 148"
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
	
	| env dialogue invocation called begin   continue  componentPortion invokeComponent invokeID opcode parameter sequence rejectComponent problemCode |
	
	self flag: #TBD. "We need to first fix the error cases: sending a return=result=last with unknown ID should lead to reject"
	
	env := self given: #shouldCreateTestEnvironment.
	
	env servicePointB
		onDialogue: [ :dialog |
			 dialog 
				onInvoke: [ : inv | 
					inv returnResultLastUsing: [ :result | result add: self exampleResult ].
					dialog requestTcContinue ]].
	dialogue := env servicePointA newDialogue.	
	invocation :=dialogue requestTcInvokeNamed: 'sendAuthenticationInfoV2' parameters:  '123456789' asByteArray class: TCAPReportSuccessAndFailure timeout: 500.
	dialogue requestTCUCancel: invocation invokeId.
	invocation onReturnLast: [ :result |  called := true ].
	
	dialogue 
		requestTcBeginDestinationAddress:  self destinationAddress
		originatingAddress:  self originatingAddress
		applicationContextName: '0.4.0.0.1.0.14.2'.
	
	"CHECK A: WAS THE INVOKE COMPONENT WITH CORRECT INFORMATION SENT BY SP A? "
	begin := self checkBegin: env servicePointA sentPackets first.	
	
	componentPortion := begin encodedValue elements third.
	self assert: componentPortion tagByteValue =2r01101100.
	invokeComponent :=  componentPortion elements first.
	self assert:  invokeComponent tagByteValue = 2r10100001.
 	invokeID := invokeComponent elements first.
	self assert: invokeID tagByteValue = 2r00000010.
	self assert: invokeID contents byteSize = 1.
	opcode := invokeComponent elements second.
	self assert: opcode tagByteValue = 2r00000010.
	self assert: opcode contents asInteger  =  56. "in this case it is 56"
	self assert: opcode contents byteSize = 1.
	parameter := invokeComponent elements third.
	self assert: parameter contents asString = '123456789'.


	"CHECK B: WAS THE REJECT COMPONENT WITH CORRECT INFORMATION SENT BY SP A? "

	self assert:  env servicePointA sentPackets size = 2.
	continue := self checkContinue: env servicePointA sentPackets last.
	componentPortion := continue encodedValue elements fourth. 
	rejectComponent :=  componentPortion elements first.
	self assert:  rejectComponent tagByteValue = 2r10100100. "REJECT"
	
	invokeID := rejectComponent elements first.
	self assert: invokeID tagByteValue = 2r00000010.
	self assert: invokeID contents byteSize = 1.
	
	problemCode := rejectComponent elements second.
	self assert: problemCode tagByteValue = 2r10000001.  "INVOKE"
	self assert: problemCode contents asInteger  = 1. "unrecognized operation"
	self assert: problemCode contents byteSize = 1.


	"CHECK C: WAS THE COMPONENT FLOW AS SHOWN ABOVE? "
	"only check needed: return last was send by A"
	
	continue := self checkContinue: env servicePointB sentPackets first.
	self assert: called == true.
	componentPortion := continue encodedValue elements last.
	self assert: componentPortion tagByteValue =2r01101100.
	invokeComponent :=  componentPortion elements first.
	invokeID := invokeComponent elements first.
	self assert: invokeID tagByteValue = 2r00000010.
	self assert: invokeID contents byteSize = 1.
	sequence := invokeComponent elements second.
	self assert: sequence tagByteValue = 2r110000.

	opcode := (continue message find: 'opcode') encodeToByteArray.
	self assert: opcode first = 2r00000010.
	self assert: opcode second = 1.
	self assert: opcode third = 56.
	
	"CHECK D: WAS THE INVOCATION STATE MACHINE IDLE AT SP A?"
	env servicePointA isIdle. "when it is idle there are no invocations, either"
	
	

	
	


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
