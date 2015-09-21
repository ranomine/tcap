Class {
	#name : #TCAPModelConfiguration,
	#superclass : #ASN1ModelConfiguration,
	#category : #'TCAP-Core-Model'
}

{ #category : #'as yet unclassified' }
TCAPModelConfiguration >> mappings [
	^ super mappings
		at: 'TCMessage' put: TCMessage;
		at: 'Begin' put: TCAPBeginMessage;
		at: 'Continue' put: TCAPContinueMessage;
		at: 'End' put: TCAPEndMessage;
		at: 'Abort' put: TCAPAbortMessage;
		"at: 'DialoguePortion' put: [ :type | TCAPDialoguePortion new type:type;  oid: (type asn1TypeNamed: 'dialogue-as-id')];"
		at: 'DialoguePDU' put: TCAPDialoguePDU;
		at: 'AARQ-apdu' put: TCAPDialogueRequest;
		at: 'AARE-apdu' put: TCAPDialogueResponse;
		at: 'ABRT-apdu' put: TCAPDialogueUAbort;
		at: 'P-AbortCause' put: TCAPDialoguePAbort;
		at: 'Component' put: ROS;
		at: 'Invoke' put: ROSInvocation;
		at: 'ReturnResult' put: ROSResultLast;
		at: 'ReturnError' put: ROSError;
		at: 'Reject' put: ROSReject;
		at: 'ROS' put: ROS;
		yourself
		
		
]
