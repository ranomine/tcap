"
timer is used for two destinct timers:

1) the invokation timer. If an invokation takes to long, it will be aborted.
2) reject timer. After receiving a return value, we go into a ""wait for reject"" state so that the user level can still reject the invoke. 
"
Class {
	#name : #ROSInvocation,
	#superclass : #ROSMessage,
	#instVars : [
		'operation',
		'returnBlock',
		'returnLastBlock',
		'errorBlock',
		'rejectBlock',
		'messageBlock',
		'operationClass',
		'state',
		'timer',
		'lcancelBlock',
		'defaultHandler',
		'dialogue'
	],
	#category : #'ROS-Core'
}

{ #category : #accessing }
ROSInvocation class >> asn1TypeName [
	^ 'Invoke'
]

{ #category : #testing }
ROSInvocation class >> isAsn1ModelClass [
	^ true
]

{ #category : #'instance creation' }
ROSInvocation class >> operation: anOperation [ 
	^ self new
		operation: anOperation
]

{ #category : #'instance creation' }
ROSInvocation class >> operationObject: anOperationObject [ 
	^ self new
		operation: (ROSOperation on: anOperationObject)
]

{ #category : #'instance creation' }
ROSInvocation class >> operationObject: aROSOperationObject  argument: anASN1Dictionary [ 
	^ self new
		operation: (ROSOperation on: aROSOperationObject);
		argument: anASN1Dictionary
]

{ #category : #accessing }
ROSInvocation class >> rosMessageType [
	^ 'invoke'
]

{ #category : #accessing }
ROSInvocation >> argumentType [
	^ self operation argumentType 
]

{ #category : #timer }
ROSInvocation >> cancelTimer [
	timer ifNotNil: [
		timer cancel ]
]

{ #category : #converting }
ROSInvocation >> decodeArgument: aTaggedValue [ 
	^ ASN1 
		read: aTaggedValue 
		usingType: (self operation argumentType).

]

{ #category : #accessing }
ROSInvocation >> defaultHandler: aBlock [
	defaultHandler := aBlock
]

{ #category : #'invocation state' }
ROSInvocation >> defaultInvocationStateClasses [
	^ { #idle -> ROSIdle .
		#operationSent -> ROSOperationSent .
		#waitForReject -> ROSWaitForReject 
	    } asDictionary
]

{ #category : #accessing }
ROSInvocation >> dialogue:	aDialogue [
	dialogue := aDialogue
]

{ #category : #dispatching }
ROSInvocation >> dispatchTo: aDialogue [ 
	aDialogue newRemoteInvocation: self.
	"if the invokeID is invalid, we reject"
	(self invokeId between: -128 and: 127) ifFalse:  [ 
		self returnReject: 2r00000001 type: 'general'.	
		^aDialogue requestTcContinue.
	].
	"if the invoke has a not-known operation, we need to reject it"
	operation ifNil: [ self returnReject: 2r00000001.  
					^aDialogue requestTcContinue. ].
				
	
]

{ #category : #accessing }
ROSInvocation >> errorNamed: aString [
	^ self operation errorNamed: aString
]

{ #category : #initialization }
ROSInvocation >> initialize [
	super initialize.
	operationClass := TCAPReportSuccessAndFailure.
]

{ #category : #accessing }
ROSInvocation >> initializeFromDialogue: aDialogue [
	| searchForOperation  |
	dialogue := aDialogue.
	aDialogue hasApplicationContext 
		ifFalse: [ aDialogue guessAppplicationContextFromOperationCode: self operationCode ].
	"we expect the dialogue to abort any action if no applicationContext can be found so we 
	just proceed"
	searchForOperation := aDialogue applicationContext operationWithCode: self operationCode.
	searchForOperation ifNil: [  ^self "the invocation will be rejected later" ].
	operation := ROSOperation on: searchForOperation.  
		
	operation hasArgumentType ifTrue: [  
		self privAt: 'argument' put: (operation decodeArgument: (self privAt: 'argument')) ]
]

{ #category : #timer }
ROSInvocation >> invocationTimerExpired [
	self notifyLCancel.
	self switchToIdle.
]

{ #category : #accessing }
ROSInvocation >> invokeArgument: anObject [
	operation invokeArgument: anObject on: self 
]

{ #category : #actions }
ROSInvocation >> invokeHandler: aBlock with: anObject [
	self invokeHandler: aBlock with: anObject with: nil 
]

{ #category : #actions }
ROSInvocation >> invokeHandler: aBlock with: anObject with: anotherObject [
	dialogue synchronizedDo: [ 
		(aBlock ifNil: [ defaultHandler ]) ifNotNil: [ :handler |
			handler cull: anObject cull: anotherObject] 
		
	]
]

{ #category : #'as yet unclassified' }
ROSInvocation >> isIdle [
	^self state class == ROSIdle.
]

{ #category : #accessing }
ROSInvocation >> linkedTo: anInvoke [
	self linkedId: anInvoke invokeId.
]

{ #category : #accessing }
ROSInvocation >> newArgumentValue [
	^ self argumentType newValue
]

{ #category : #accessing }
ROSInvocation >> newArgumentValue: anObject [
	^ self operation argumentType newValue: anObject
]

{ #category : #'invocation state' }
ROSInvocation >> newInvocationState: aSymbol [
	^ (self defaultInvocationStateClasses at: aSymbol) new
]

{ #category : #'as yet unclassified' }
ROSInvocation >> newMessage: aClass [

	^ (self asn1TypeNamed: aClass asn1TypeName) newValue  
		invokeId: self invokeId;
		invocation: self

]

{ #category : #accessing }
ROSInvocation >> newResultValue [
	^ self operation newResultValue 
]

{ #category : #'invocation state' }
ROSInvocation >> newState: aSymbol [
	^ self newInvocationState: aSymbol.
]

{ #category : #'invocation state' }
ROSInvocation >> nextState: aState [
	state := aState
]

{ #category : #accessing }
ROSInvocation >> normalizedOperationName [
	self flag: #todo.
	^ (self operationName copyWithout: $-) asSymbol asMutator.
]

{ #category : #'as yet unclassified' }
ROSInvocation >> notifyError: anError [
	self invokeHandler: errorBlock with: anError
]

{ #category : #'as yet unclassified' }
ROSInvocation >> notifyError: anError parameter: anObject [
	self invokeHandler: errorBlock with: anError with: anObject 
]

{ #category : #'as yet unclassified' }
ROSInvocation >> notifyLCancel [
	self invokeHandler: lcancelBlock with: nil 
]

{ #category : #'as yet unclassified' }
ROSInvocation >> notifyReject: aReject [
	self invokeHandler: rejectBlock with: aReject
]

{ #category : #'as yet unclassified' }
ROSInvocation >> notifyReturn: anObject [
	self invokeHandler: returnBlock with: anObject 
]

{ #category : #'as yet unclassified' }
ROSInvocation >> notifyReturnLast: anObject [
	self invokeHandler: returnLastBlock with: anObject 

]

{ #category : #'as yet unclassified' }
ROSInvocation >> onError: aBlock [
	errorBlock := aBlock
]

{ #category : #'as yet unclassified' }
ROSInvocation >> onLCancel: aBlock [
	lcancelBlock  := aBlock
]

{ #category : #'as yet unclassified' }
ROSInvocation >> onMessage: aBlock [
	messageBlock := aBlock
]

{ #category : #'as yet unclassified' }
ROSInvocation >> onReject: aBlock [
	rejectBlock := aBlock
]

{ #category : #'as yet unclassified' }
ROSInvocation >> onReturn: aBlock [
	returnBlock := aBlock
]

{ #category : #'as yet unclassified' }
ROSInvocation >> onReturnLast: aBlock [
	returnLastBlock := aBlock
]

{ #category : #accessing }
ROSInvocation >> opcodeNumber: aNumber [
	(self expandFieldNamed: 'opcode') 
		privAt: 'local' 
		put: aNumber.
]

{ #category : #accessing }
ROSInvocation >> operation [
	^ operation

]

{ #category : #accessing }
ROSInvocation >> operation: aROSOperation [
	operation := aROSOperation
]

{ #category : #accessing }
ROSInvocation >> operationClass: aClass [ 
	operationClass := aClass isNumber 
		ifTrue: [ TCAPOperationSentClass withNumber: aClass ]
		ifFalse: [  aClass ] 
]

{ #category : #accessing }
ROSInvocation >> operationCode [
	| opcode |
	opcode := self at: 'opcode' ifAbsent: [ ^nil ].
	^ opcode at: 'local' ifAbsent: [opcode at: 'global' ifAbsent: nil ]
]

{ #category : #accessing }
ROSInvocation >> operationName [
	^ operation name
]

{ #category : #received }
ROSInvocation >> receivedError: aError [ 
	operationClass receivedError: aError invocation: self   
]

{ #category : #received }
ROSInvocation >> receivedReject: aReject [ 
	self switchToIdle.
	self notifyReject: aReject.
	
]

{ #category : #received }
ROSInvocation >> receivedReturnLast: aResultLast [ 
	operationClass receivedReturnLast: aResultLast invocation: self  
]

{ #category : #timer }
ROSInvocation >> rejectExpireTime [
	^ 10
]

{ #category : #timer }
ROSInvocation >> rejectTimerExpired [
	self switchToIdle.
]

{ #category : #'as yet unclassified' }
ROSInvocation >> returnError: errorType parameter: error [
	"construct an envelope ros error object with the error as a parameter.
	Assign the error code from type information"
	| rosError |

	rosError := self newMessage: ROSError.
	
	error ifNotNil: [ 
		 rosError setParameter: error ].

	rosError errorCode: (errorType attributeAt: 'errorCode').

	self sendMessage: rosError 
]

{ #category : #'as yet unclassified' }
ROSInvocation >> returnErrorNamed: aString [

	self returnError: (self errorNamed: aString) parameter: nil
]

{ #category : #'as yet unclassified' }
ROSInvocation >> returnErrorNamed: aString using: aBlock [
	| errorType  error |

	errorType := type  asn1TypeNamed: aString. 
	error := ( errorType attributeAt: 'ParameterType' ) newValue.
	aBlock value: error.
	
	self returnError:  errorType parameter: error.
]

{ #category : #'as yet unclassified' }
ROSInvocation >> returnReject: problemCode [
	| rosReject |

	rosReject :=  self newMessage: ROSReject.
	
	rosReject problemCode: problemCode.
	self sendMessage: rosReject
 
]

{ #category : #'as yet unclassified' }
ROSInvocation >> returnReject: problemCode type: aString [
	| rosReject |

	rosReject :=  self newMessage: ROSReject.
	rosReject problemCode: problemCode type: aString.
	self sendMessage: rosReject
 
]

{ #category : #'as yet unclassified' }
ROSInvocation >> returnResult: aDictionary [
	^ self sendMessage: (
		(self newMessage: ROSResult)
			result: aDictionary)
 
]

{ #category : #'as yet unclassified' }
ROSInvocation >> returnResultLast: aResult [
	self sendMessage: (
		(self newMessage: ROSResultLast)
			result: aResult)
 
]

{ #category : #'as yet unclassified' }
ROSInvocation >> returnResultLastUsing: aBlock [
	| result |
	result := self newResultValue.
	aBlock value: result.
	self returnResultLast: result.
 
]

{ #category : #'as yet unclassified' }
ROSInvocation >> returnResultUsing: aBlock [
	| result |
	result := self newResultValue.
	aBlock value: result.
	self returnResult: result.
]

{ #category : #'as yet unclassified' }
ROSInvocation >> sendMessage: aMessage [
	messageBlock ifNotNil: [ 
		messageBlock value: aMessage ]
]

{ #category : #accessing }
ROSInvocation >> setArgument: aParameter [
	self removeKey: 'argument' ifAbsent: [].
 	(self expandFieldNamed: 'argument') contents: aParameter
]

{ #category : #timer }
ROSInvocation >> startInvocationTimer: aDuration [
	aDuration ifNil: [ ^self ].

	timer := OsmoTimeScheduler 
		scheduleIn: aDuration 
		block: [ self invocationTimerExpired  ]
]

{ #category : #timer }
ROSInvocation >> startRejectTimer [
	timer := OsmoTimeScheduler 
		scheduleInSeconds: self rejectExpireTime 
		block: [ self rejectTimerExpired  ]
]

{ #category : #'invocation state' }
ROSInvocation >> state [
	^ state ifNil: [ 
		self switchState: #idle ]
]

{ #category : #'invocation state' }
ROSInvocation >> switchState: aSymbol [
	self nextState: (self newState: aSymbol).
]

{ #category : #'invocation state' }
ROSInvocation >> switchToIdle [
	self cancelTimer.
	self switchState: #idle.
	self flag: #TBD. "later we need to recycle ids correctly, not free them immediatly but keep them blocked for a while"
	"dialogue freeInvokeId: self invokeId." "for now we never free IDs"
]

{ #category : #'invocation state' }
ROSInvocation >> switchToOperationSent [
	self switchState: #operationSent.
]

{ #category : #'invocation state' }
ROSInvocation >> switchToWaitForReject [
	self switchState: #waitForReject.
	self startRejectTimer.
]
