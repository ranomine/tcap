"
This is the intention revealing class name for TCAP operation sent class 3
"
Class {
	#name : #TCAPReportSuccess,
	#superclass : #TCAPOperationSentClass,
	#category : #'TCAP-Core-Message'
}

{ #category : #'as yet unclassified' }
TCAPReportSuccess class >> classNumber [
	^ 3
]

{ #category : #'as yet unclassified' }
TCAPReportSuccess class >> receivedReturnLast: aResultLast invocation: aInvocation [ 
	aInvocation 
		notifyReturnLast: aResultLast;
		cancelTimer;
		startRejectTimer;
		waitForReject
]
