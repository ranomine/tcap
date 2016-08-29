"
This is the intention revealing class name for TCAP operation sent class 1
"
Class {
	#name : #TCAPReportSuccessAndFailure,
	#superclass : #TCAPOperationSentClass,
	#category : #'TCAP-Core-Message'
}

{ #category : #'as yet unclassified' }
TCAPReportSuccessAndFailure class >> classNumber [
	^ 1
]

{ #category : #received }
TCAPReportSuccessAndFailure class >> receivedError: anError invocation: anInvocation [ 
	anInvocation 
		cancelTimer; "cancel invokation timer"
		switchToWaitForReject;
		notifyError: anError;
		switchToIdle
		
]

{ #category : #received }
TCAPReportSuccessAndFailure class >> receivedReturn: aResult invocation: aInvocation [
	aInvocation 
		notifyReturn: aResult.
]

{ #category : #received }
TCAPReportSuccessAndFailure class >> receivedReturnLast: aResultLast invocation: aInvocation [ 
	aInvocation
		cancelTimer; "cancel invokation timer"
		switchToWaitForReject;
		notifyReturnLast: aResultLast;
		switchToIdle
]
