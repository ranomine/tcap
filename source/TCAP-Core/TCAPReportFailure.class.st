"
This is the intention revealing class name for TCAP operation sent class 2
"
Class {
	#name : #TCAPReportFailure,
	#superclass : #TCAPOperationSentClass,
	#category : #'TCAP-Core-Message'
}

{ #category : #'as yet unclassified' }
TCAPReportFailure class >> classNumber [
	^ 2
]

{ #category : #'as yet unclassified' }
TCAPReportFailure class >> receivedError: anError invocation: anInvocation [ 
	"we do not notify errors"
]

{ #category : #'as yet unclassified' }
TCAPReportFailure class >> receivedReturnLast: aResultLast invocation: aInvocation [ 
	aInvocation 
		notifyReturnLast: aResultLast;
		cancelTimer;
		startRejectTimer;
		waitForReject
]
