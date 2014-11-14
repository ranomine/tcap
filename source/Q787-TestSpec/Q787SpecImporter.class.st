Class {
	#name : #Q787SpecImporter,
	#superclass : #Object,
	#instVars : [
		'filename'
	],
	#category : #'Q787-TestSpec'
}

{ #category : #'as yet unclassified' }
Q787SpecImporter class >> allPages [
	^ Character newPage split: self fileContents
]

{ #category : #'as yet unclassified' }
Q787SpecImporter class >> fileNamed: aFilename [
	^ self new
		filename: aFilename
]

{ #category : #'as yet unclassified' }
Q787SpecImporter >> allPages [
	^ Character newPage split: self fileContents
]

{ #category : #'as yet unclassified' }
Q787SpecImporter >> fileContents [
	^ filename asFileReference readStream contentsOfEntireFile
]

{ #category : #'as yet unclassified' }
Q787SpecImporter >> filename: aString [
	filename := aString
]

{ #category : #'as yet unclassified' }
Q787SpecImporter >> generate [
	self pagesDict keysAndValuesDo:[ :number :page | | cls testMethod descMethod |
		cls := self testClassForPage: page.
		testMethod := 'test', number, '
		self assert: false'.
		cls compile: testMethod classified: 'tests'.
		descMethod := 'spec', number, '
		self flag: #needsToBeChecked.
		^ ', page printString.
		cls compile: descMethod classified: 'spec'.
		"Transcript show: descMethod; cr."
		 ]
]

{ #category : #'as yet unclassified' }
Q787SpecImporter >> mapping [
	^ Dictionary new
		at: '.' put: '_';
		at: '(' put: 'b';
		at: ')' put: '';
		at: ' ' put: 's';
		yourself
]

{ #category : #'as yet unclassified' }
Q787SpecImporter >> pagesDict [
	| pagesDict number |
	pagesDict := Dictionary new.
	self testPages do: [ :page | | existing |
		number := self testNumberOf: page.
		existing := pagesDict at: number ifAbsent: [ '' ].
		pagesDict
			at: number 
			put: (existing, page) ].
	^pagesDict
]

{ #category : #'as yet unclassified' }
Q787SpecImporter >> testClassForPage: aString [
	| matches |
	matches := ('TYPE OF TEST\: ([\w\s]+)' asRegex 
		search: aString;
		subexpression: 2)
			allRegexMatches: 'VAT|CPT'.
	^ (matches size = 2)
		ifTrue: [ Q787CommonSpecTest  ]
		ifFalse: [ 
			(matches includes: 'VAT')
				ifTrue: [ Q787ValidationTest  ]
				ifFalse: [ Q787CompatibilityTest  ]] 
]

{ #category : #'as yet unclassified' }
Q787SpecImporter >> testNumberOf: aString [
	^ (('TEST NUMBER\:\s(\S+(\s\d)?)' asRegex 
		search: aString;
		subexpression: 2)
			copyWithRegex: '\([^)]+\)' matchesReplacedWith: '')
				copyWithRegex: '\D' matchesTranslatedUsing: [ :input|
					self mapping 
						at: input
						ifAbsent: [  'x' ]]
]

{ #category : #'as yet unclassified' }
Q787SpecImporter >> testNumbers [
	self pagesDict keysAndValuesDo:[ :number :page |
		Transcript show: 'test page for test ', (self testClassForPage: page) asString; cr ]
]

{ #category : #'as yet unclassified' }
Q787SpecImporter >> testPages [
	^ self allPages
		select: [ :each| each beginsWith: 'TEST NUMBER' ]
]
