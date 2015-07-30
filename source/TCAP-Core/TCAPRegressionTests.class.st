Class {
	#name : #TCAPRegressionTests,
	#superclass : #TCAPTestCase,
	#category : #'TCAP-Core-Tests'
}

{ #category : #tests }
TCAPRegressionTests >> testIssue1366 [
	|  env dialogue invocation |
	env := self newTestEnvironment. 
	env localAddressIs: #HLR.
	env remoteAddressIs: #AUC.
	env connect.
	
	dialogue := env servicePointA newDialogueWithIdString: #[1 0 9 151].
	dialogue applicationContextName: '0.4.0.0.1.0.27.3' .
	dialogue switchState: #initiationSent.
	invocation := dialogue addLocalInvocationWithId: 2.
	invocation operation: (ROSOperation on: 'readyForSMV2' asAsn1Type) .
	env injectTcapA: #[100 64 73 4 1 0 9 151 107 42 40 40 6 7 0 17 134 5 1 1 1 160 29 97 27 128 2 7 128 161 9 6 7 4 0 0 1 0 24 2 162 3 2 1 0 163 5 161 3 2 1 0 108 12 162 10 2 1 2 48 5 2 1 66 48 0].

]
