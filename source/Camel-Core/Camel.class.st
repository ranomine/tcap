Class {
	#name : #Camel,
	#superclass : #ASN1,
	#classInstVars : [
		'current'
	],
	#category : #'Camel-Core'
}

{ #category : #'as yet unclassified' }
Camel class >> current [
	^ current ifNil: [ 
		current := self new ]
]

{ #category : #'as yet unclassified' }
Camel class >> reset [
	current := nil
]

{ #category : #'as yet unclassified' }
Camel class >> rootModuleNames [
	^ #(
		'TC-Notation-Extensions' 
		'TCAPMessages'
		'SS-Operations' 
		'MAP-DialogueInformation' 
		'MAP-ApplicationContexts'
		'TCAP-Tools'
		'CAP-classes'
	)
]

{ #category : #'as yet unclassified' }
Camel >> defaultModuleLoader [
	^ ASN1LibraryModuleManager new
		library: CamelModuleLibrary 
]

{ #category : #'as yet unclassified' }
Camel >> rootModuleNames [ 
	^ self class rootModuleNames 
]
