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

{ #category : #'as yet unclassified' }
TCAPReportSuccessAndFailure class >> invocationTimerExpiredOn: aROSInvocation [ 
	self shouldBeImplemented.
]

{ #category : #received }
TCAPReportSuccessAndFailure class >> receivedError: anError invocation: anInvocation [ 
	anInvocation 
		notifyError: anError;
		cancelTimer;
		startRejectTimer;
		waitForReject
]

{ #category : #received }
TCAPReportSuccessAndFailure class >> receivedReturn: aResult invocation: aInvocation [
	aInvocation notifyReturn: aResult
]

{ #category : #received }
TCAPReportSuccessAndFailure class >> receivedReturnLast: aResultLast invocation: aInvocation [ 
	aInvocation 
		notifyReturnLast: aResultLast;
		cancelTimer;
		startRejectTimer;
		waitForReject
]
