Class {
	#name : #LogAreaTcap,
	#superclass : #LogArea,
	#category : #'TCAP-Core'
}

{ #category : #accessing }
LogAreaTcap class >> areaDescription [
	^'IPA related'

]

{ #category : #accessing }
LogAreaTcap class >> areaName [
	^ #tcap
]

{ #category : #accessing }
LogAreaTcap class >> default [
	^(self new)
	    enabled: true;
	    minLevel: LogLevel debug;
	    yourself

]
