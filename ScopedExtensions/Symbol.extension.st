Extension { #name : #Symbol }

{ #category : #'*ScopedExtensions' }
Symbol >> notUnderstoodBy: receiver withMessage: aMessage [
	| exception resumeValue signalerContext |
	signalerContext := thisContext sender sender.
	"Extension allInstancesDo: [ :extension | 
		extension 
			methodNamed: self
			fromBehavior: receiver class 
			ifPresent: [ :method | 
				signalerContext method package import: extension.
				^ receiver perform: method selector withArguments: aMessage arguments ] 
			ifAbsent: [  ] ]."
	(exception := MessageNotUnderstood new)
		message: aMessage;
		receiver: receiver.
	resumeValue := exception signalIn: signalerContext.
	^ exception reachedDefaultHandler
		ifTrue: [ aMessage sentTo: self ]
		ifFalse: [ resumeValue ]
]

{ #category : #'*ScopedExtensions' }
Symbol >> retryFor: anObject withMessage: aMessage [

	^ anObject doesNotUnderstand: aMessage
]
