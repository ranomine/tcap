"
I benchmark the decoding of various TCAP messages using the TCAPEntityMessage
"
Class {
	#name : #TCAPEntityMessageBenchmark,
	#superclass : #Object,
	#category : #'TCAP-Benchmark'
}

{ #category : #'as yet unclassified' }
TCAPEntityMessageBenchmark class >> runAndCreatePlotFile [
	ASN1CurrentContext default: (ASN1Context new
		model: TCAPTestModel instance;
		factory: TCAPObjectFactory new).
	'benchmark' asFileReference writeStreamDo: [ :str |
		str
			truncate;
			nextPutAll: 'YVALUE=';
			nextPutAll: [
				TCAPEntityMessageBenchmark new miniTCAPOnlyBench: 10000 ] timeToRun asMilliSeconds printString ]
]

{ #category : #'as yet unclassified' }
TCAPEntityMessageBenchmark >> miniTCAPOnlyBench: rounds [
	| tcapBegin tcapContinue tcapEnd tcapAbort |
	tcapBegin := self tcapBeginData.
	tcapContinue := self tcapContinueData.
	tcapEnd := self tcapEndData.
	tcapAbort := self tcapAbortData.

	1 to: rounds do: [:each |
		| decoded |
		decoded := TCAPEntityMessage fromByteArray: tcapBegin.
		decoded := TCAPEntityMessage fromByteArray: tcapContinue.
		decoded := TCAPEntityMessage fromByteArray: tcapEnd.
		decoded := TCAPEntityMessage fromByteArray: tcapAbort.
	].
]

{ #category : #'as yet unclassified' }
TCAPEntityMessageBenchmark >> tcapAbortData [
	"Abort with dialogueResponse"
	^ #[103 46 73 4 12 134 1 2 107 38 40 36 6 7 0 17 134 5 1 1 1 160 25 97 23 161 9 6 7 4 0 0 1 21 3 3 162 3 2 1 1 163 5 161 3 2 1 2]
]

{ #category : #'as yet unclassified' }
TCAPEntityMessageBenchmark >> tcapBeginData [
	"SRIForSMv2"
	^ #[98 72 72 4 5 74 167 66 107 30 40 28 6 7 0 17 134 5 1 1 1 160 17 96 15 128 2 7 128 161 9 6 7 4 0 0 1 0 20 2 108 32 161 30 2 1 1 2 1 45 48 22 128 8 145 38 24 130 146 55 16 243 129 1 1 130 7 145 38 24 1 148 24 246]
]

{ #category : #'as yet unclassified' }
TCAPEntityMessageBenchmark >> tcapContinueData [
	"InsertSubscriberdata v3 acn"
	^ #[101 96 72 4 72 36 59 34 73 4 35 130 144 184 107 38 40 36 6 7 0 17 134 5 1 1 1 160 25 97 23 161 9 6 7 4 0 0 1 0 1 3 162 3 2 1 0 163 5 161 3 2 1 0 108 42 161 40 2 1 1 2 1 7 48 32 129 8 145 38 24 130 65 97 4 241 130 1 10 131 1 0 164 3 4 1 31 166 9 4 1 17 4 1 33 4 1 34]
]

{ #category : #'as yet unclassified' }
TCAPEntityMessageBenchmark >> tcapEndData [
	"ReturnError for MSG gateway context v2"
	^ #[100 70 73 4 5 74 147 67 107 38 40 36 6 7 0 17 134 5 1 1 1 160 25 97 23 161 9 6 7 4 0 0 1 0 20 2 162 3 2 1 0 163 5 161 3 2 1 0 108 22 163 6 2 1 1 2 1 27 161 12 2 1 1 2 1 63 48 4 3 2 2 80]
]
