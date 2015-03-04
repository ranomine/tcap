Class {
	#name : #ROSTest,
	#superclass : #TestCase,
	#category : #'ROS-Core-Tests'
}

{ #category : #'as yet unclassified' }
ROSTest >> shouldNotTriggerDefaultHandlerIfSpecificHandlerPresent [
	| falseTriggered triggered |
	triggered := false.
	falseTriggered := false.
	self shouldnt: [ 
		ROSInvocation new
			onError: [ triggered := true ];
			defaultHandler: [ falseTriggered := true ];
			notifyError: 'error' ] raise: Error. 
	self assert: triggered.
	self deny: falseTriggered 
		
		
]

{ #category : #'as yet unclassified' }
ROSTest >> shouldTriggerDefaultHandlerIfPresent [
	| triggered |
	triggered := false.
	self shouldnt: [ 
		ROSInvocation new
			defaultHandler: [ triggered := true ];
			notifyError: 'error' ] raise: Error. 
	self assert: triggered
		
		
]

{ #category : #'as yet unclassified' }
ROSTest >> shouldntFailOnMissingHandler [
	self shouldnt: [ 
		ROSInvocation new notifyError: 'error' ] raise: Error.
	
		
		
]
