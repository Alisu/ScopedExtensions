"
This class exists to avoid modifying RPackage class. It maps a RPackage with the extensions it defines and imports.
"
Class {
	#name : #RPackageExtensions,
	#superclass : #Object,
	#instVars : [
		'extensions',
		'imports',
		'package'
	],
	#classInstVars : [
		'instances'
	],
	#category : #'ScopedExtensions-Core'
}

{ #category : #'as yet unclassified' }
RPackageExtensions class >> for: aRPackage [
	^ instances at: aRPackage ifAbsentPut: [ 
		self new 
			initializeFromPackage: aRPackage; 
			yourself ]
]

{ #category : #'as yet unclassified' }
RPackageExtensions class >> initialize [
	instances := Dictionary new.
	SystemAnnouncer uniqueInstance unsubscribe: self.
	SystemAnnouncer uniqueInstance when: RPackageUnregistered send: #packageUnregistered: to: self
]

{ #category : #'as yet unclassified' }
RPackageExtensions class >> packageUnregistered: aPackageUnregisteredAnnouncement [
	(instances removeKey: aPackageUnregisteredAnnouncement package ifAbsent: [ ^ self ]) delete
]

{ #category : #declaring }
RPackageExtensions >> addExtension: anExtension [ 
	extensions add: anExtension
]

{ #category : #importing }
RPackageExtensions >> allExtensions [
	^ extensions, imports
]

{ #category : #declaring }
RPackageExtensions >> extensions [
	^ extensions
]

{ #category : #importing }
RPackageExtensions >> import: anExtension [ 
	imports add: anExtension.
	anExtension addImporter: package.
	package recompileSendersOf: anExtension selectors
]

{ #category : #importing }
RPackageExtensions >> imports [
	^ imports
]

{ #category : #initialization }
RPackageExtensions >> initialize [
	extensions := Set new.
	imports := Set new.
]

{ #category : #initialization }
RPackageExtensions >> initializeFromPackage: aRPackage [
	package := aRPackage.
	extensions := Set new.
	imports := Set new.
]

{ #category : #lookup }
RPackageExtensions >> lookupMethod: aSymbol forBehavior: aBehavior [ 
	self allExtensions do: [ :each | each methodNamed: aSymbol fromBehavior: aBehavior ifPresent: [ :it | ^ it ] ifAbsent: [ nil ] ].
]

{ #category : #importing }
RPackageExtensions >> lookupScopedSelector: aSymbol [
	| candidatesSelectors |
	candidatesSelectors := self allExtensions 
		flatCollect: [ :extension | extension scopedSelectors select: [ :scopedSelector | scopedSelector wrappedSymbol = aSymbol ] ] 
		as: OrderedCollection.
	^ candidatesSelectors size
		compareWith: 1 
		ifLesser: [ aSymbol ] 
		ifEqual: [ candidatesSelectors anyOne ] 
		ifGreater: [ ForkSelector wrappedSelectors: candidatesSelectors]
]

{ #category : #lookup }
RPackageExtensions >> lookupScopedSelector: aSymbol forBehavior: aBehavior [ 
	^ (self lookupMethod: aSymbol forBehavior: aBehavior) ifNotNil: #selector ifNil: [ aSymbol ]
]

{ #category : #removing }
RPackageExtensions >> removeExtension: anExtension [ 
	package recompileSendersOf: anExtension scopedSelectors.
	imports remove: anExtension
]
