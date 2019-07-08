"
A scoped selector is a lookup key that can be used for method lookup. The selectors of the methods defined in extensions are scoped selectors. This permits extension methods to be local tocertains methods.
"
Class {
	#name : #ScopedSelector,
	#superclass : #AbstractSelector,
	#instVars : [
		'wrappedSelector',
		'behaviors'
	],
	#category : #'ScopedExtensions-Core'
}

{ #category : #'as yet unclassified' }
ScopedSelector class >> wrappedSelector: aString [ 
	^ self new
		initializeWithSelector: aString;
		yourself
]

{ #category : #accessing }
ScopedSelector >> addBehavior: aBehavior [ 
	behaviors add: aBehavior
]

{ #category : #accessing }
ScopedSelector >> includesBehavior: aBehavior [
	^ behaviors includes: aBehavior
]

{ #category : #initialization }
ScopedSelector >> initializeWithSelector: aSelector [
	wrappedSelector := aSelector.
	behaviors := Set new.
]

{ #category : #'handling DNU' }
ScopedSelector >> notUnderstoodBy: receiver withMessage: aMessage [
	^ receiver perform: wrappedSelector withArguments: aMessage arguments
]

{ #category : #accessing }
ScopedSelector >> wrappedSymbol [
	^ wrappedSelector
]
