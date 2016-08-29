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

{ #category : #received }
TCAPReportFailure class >> receivedError: anError invocation: anInvocation [ 
	
	anInvocation switchToIdle.
]

{ #category : #received }
TCAPReportFailure class >> receivedReturnLast: aResultLast invocation: aInvocation [ 
	aInvocation 
		cancelTimer;
		notifyReturnLast: aResultLast;
		switchToIdle.
]
