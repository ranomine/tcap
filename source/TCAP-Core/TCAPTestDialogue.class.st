Class {
	#name : #TCAPTestDialogue,
	#superclass : #TCAPDialogue,
	#category : #'TCAP-Core-Tests-Model'
}

{ #category : #accessing }
TCAPTestDialogue >> addLocalInvocationWithId: aNumber [ 
	 | invocation |
	invocation := ROSInvocation new 
		parent: self;
		type: (self asn1TypeNamed: 'Invoke');
		id: 2.
	localInvocations add: invocation.
	^ invocation
]
