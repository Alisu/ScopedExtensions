"
A fork selector is a selector that is used to resolve conflicts.
Ex: For objects sends there is no way to know the class of the receiver statically. Consequently the different metching methods may have different selectors. A fork selector is used to group all these selector to retry the lookup in case of failure.   
"
Class {
	#name : #ForkSelector,
	#superclass : #AbstractSelector,
	#instVars : [
		'wrappedSelectors'
	],
	#category : #'ScopedExtensions-Core'
}

{ #category : #accessing }
ForkSelector class >> keyword [
	^ #fork
]

{ #category : #'instance-creation' }
ForkSelector class >> wrappedSelectors: selectorCollection [ 
	^ self new
		initializeWithSelectors: selectorCollection;
		yourself
]

{ #category : #initialization }
ForkSelector >> initializeWithSelectors: selectorCollection [
	wrappedSelectors := selectorCollection
]

{ #category : #'handling DNU' }
ForkSelector >> notUnderstoodBy: receiver withMessage: aMessage [
	| selector selectorsUnderstood |
	selectorsUnderstood := receiver class allSelectors.
	wrappedSelectors 
		detect: [ :each | selectorsUnderstood includes: each ]
		ifFound: [ :it | selector := it ]
		ifNone: [ selector := self wrappedSymbol ].
	^ receiver perform: selector withArguments: aMessage arguments
]

{ #category : #initialization }
ForkSelector >> wrappedSelectors [
	^ wrappedSelectors
]

{ #category : #accessing }
ForkSelector >> wrappedSymbol [
	^ wrappedSelectors anyOne wrappedSymbol
]
