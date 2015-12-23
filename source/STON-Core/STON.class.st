"
STON implements serialization and materialization using the Smalltalk Object Notation format.
 
S y n t a x

	value
	  primitive-value
	  object-value
	  reference
	  nil
	primitive-value
	  number
	  true
	  false
	  symbol
	  string
	object-value
	  object
	  map
	  list
	object
	  classname map
	  classname list
	reference
	  @ int-index-previous-object-value
	map
	  {}
	  { members }
	members
	  pair
	  pair , members
	pair
	  string : value
	  symbol : value
	  number : value
	list
	  []
	  [ elements ]
	elements
	  value 
	  value , elements
	string
	  ''
	  ' chars '
	chars
	  char
	  char chars
	char
	  any-printable-ASCII-character-
	    except-'-""-or-\
	  \'
	  \""
	  \\
	  \/
	  \b
	  \f
	  \n
	  \r
	  \t
	  \u four-hex-digits
	symbol
	  # chars-limited
	  # ' chars '
	chars-limited
	  char-limited
	  char-limited chars-limited
	char-limited
	  a-z A-Z 0-9 - _ . /
	classname
	  uppercase-alpha-char alphanumeric-char
	number
	  int
	  int frac
	  int exp
	  int frac exp
	int
	  digit
	  digit1-9 digits 
	  - digit
	  - digit1-9 digits
	frac
	  . digits
	exp
	  e digits
	digits
	  digit
	  digit digits
	e
	  e
	  e+
	  e-
	  E
	  E+
	  E-

"
Class {
	#name : #STON,
	#superclass : #Object,
	#category : #'STON-Core'
}

{ #category : #accessing }
STON class >> associationClass [
	^ Association
]

{ #category : #accessing }
STON class >> classNameKey [
	^ #className
]

{ #category : #convencience }
STON class >> fromStream: readStream [
	^ (self reader on: readStream) next
]

{ #category : #convencience }
STON class >> fromStreamWithComments: readStream [
	^ (self reader on: (STONCStyleCommentsSkipStream on: readStream)) next
]

{ #category : #convencience }
STON class >> fromString: string [
	^ self fromStream: string readStream
]

{ #category : #convencience }
STON class >> fromStringWithComments: string [
	^ self fromStreamWithComments: string readStream
]

{ #category : #accessing }
STON class >> jsonWriter [
	^ STONWriter new
		  jsonMode: true;
		  yourself
]

{ #category : #accessing }
STON class >> listClass [
	^ Array
]

{ #category : #accessing }
STON class >> mapClass [
	^ Dictionary
]

{ #category : #convencience }
STON class >> put: object asJsonOnStream: stream [
	(self jsonWriter on: stream) nextPut: object
]

{ #category : #convencience }
STON class >> put: object asJsonOnStreamPretty: stream [
	(self jsonWriter on: stream)
		prettyPrint: true; 
		nextPut: object
]

{ #category : #convencience }
STON class >> put: object onStream: stream [
	(self writer on: stream) nextPut: object
]

{ #category : #convencience }
STON class >> put: object onStreamPretty: stream [
	(self writer on: stream)
		prettyPrint: true; 
		nextPut: object
]

{ #category : #accessing }
STON class >> reader [
	^ STONReader new
]

{ #category : #convencience }
STON class >> toJsonString: object [
	^ String streamContents: [ :stream |
		self put: object asJsonOnStream: stream ]
]

{ #category : #convencience }
STON class >> toJsonStringPretty: object [
	^ String streamContents: [ :stream |
		self put: object asJsonOnStreamPretty: stream ]
]

{ #category : #convencience }
STON class >> toString: object [
	^ String streamContents: [ :stream |
		self put: object onStream: stream ]
]

{ #category : #convencience }
STON class >> toStringPretty: object [
	^ String streamContents: [ :stream |
		self put: object onStreamPretty: stream ]
]

{ #category : #accessing }
STON class >> writer [
	^ STONWriter new
]
