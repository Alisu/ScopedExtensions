"
A package can define several extensions. Each extension contains methods for classes possibly external to the defining package. These methods are visible from the defining package and the packages that import the defining extensions.

To create an extension use the extension template:

Extension 
	named: #MyFirstExtension 
	packageNamed: #MyPackage.
	
The name of the protocols are class names. The methods in a protocol 'MyClass' of MyFirstExtension are extension methods for the class Myclass.
"
Class {
	#name : #Extension,
	#superclass : #Object,
	#instVars : [
		'name',
		'extensionMethods',
		'scopedSelectors',
		'comment',
		'package',
		'importingPackages'
	],
	#classInstVars : [
		'packageExtensionMapping'
	],
	#category : #'ScopedExtensions-Core'
}

{ #category : #'instance-creation' }
Extension class >> named: aString package: aRPackage [
	| newInstance | 
	newInstance := self new
		initializeWithName: aString package: aRPackage;
		yourself.
	aRPackage addExtension: newInstance.
	^ newInstance
]

{ #category : #'instance-creation' }
Extension class >> named: aString packageNamed: aPackageName [
	
	^ self named: aString package: (RPackageOrganizer default ensureExistAndRegisterPackageNamed: aPackageName)
]

{ #category : #importing }
Extension >> addImporter: aPackage [
	importingPackages add: aPackage.
]

{ #category : #private }
Extension >> addMethod: aCompiledMethod inBehavior: aClass [ 
	(extensionMethods at: aClass ifAbsentPut: [ Set new ]) add: aCompiledMethod.
	aClass addSelectorSilently: aCompiledMethod selector withMethod: aCompiledMethod 
]

{ #category : #accessing }
Extension >> category: aString [

	self assert: self package name = aString
]

{ #category : #accessing }
Extension >> comment [
	^ comment ifNil: [ comment := '' ]
]

{ #category : #accessing }
Extension >> comment: aString [ 
	comment := aString
]

{ #category : #compilation }
Extension >> compileExtension: sourceString inBehavior: aBehavior [ 
	^ self compileExtension: sourceString inBehavior: aBehavior requestor: nil
]

{ #category : #compilation }
Extension >> compileExtension: sourceString inBehavior: aBehavior requestor: requestor [
	"Compile a new extension method whose source is sourceString in behavior aBehavior"
	| method |
	method := self compiler
		source: sourceString;
		requestor: requestor;
		class: aBehavior;
		package: package;
		failBlock:  [ ^nil ];
		compile.
		
	self flag: #clean.
	"	self 
			logMethodSource: (requestor ifNotNil: [ :r | r text ] ifNil: [ text ])
			forMethod: method
			inCategory: category 
			withStamp: changeStamp."
		
	"self 
		addAndClassifySelector: method selector 
		withMethod: method 
		inProtocol: category 
		notifying: requestor."
			
	"self instanceSide 
		noteCompilationOf: method selector 
		meta: self isClassSide."
	self addMethod: method inBehavior: aBehavior.
	^ method
]

{ #category : #private }
Extension >> compiler [
	^ ExtensionCompiler extension: self
]

{ #category : #testing }
Extension >> definesMethodNamed: aSymbol inBehavior: aBehavior [
	^ (extensionMethods at: aBehavior ifAbsent: [ ^ false ]) anySatisfy: [ :method | method selector = aSymbol ]
]

{ #category : #'as yet unclassified' }
Extension >> dependentPackagesDo: aBlock [
	aBlock value: package.
	importingPackages do: aBlock
]

{ #category : #private }
Extension >> ensureSelectorForMethod: aMethodNode [
	^ scopedSelectors 
		detect: [ :each | each wrappedSymbol = aMethodNode selector ]
		ifNone: [ scopedSelectors add: (ScopedSelector wrappedSelector: aMethodNode selector) ]
]

{ #category : #initialization }
Extension >> initializeWithName: aString package: aRPackage [
	name := aString asSymbol.
	package := aRPackage.
	extensionMethods := Dictionary new.
	scopedSelectors := Set new.
	importingPackages := Set new.
	Smalltalk globals at: name put: self
]

{ #category : #accessing }
Extension >> instanceSide [

	^ self
]

{ #category : #importing }
Extension >> isImportedBy: aRPackage [ 
	^ importingPackages includes: aRPackage 
]

{ #category : #accessing }
Extension >> methodNamed: aSymbol fromBehavior: aBehavior ifPresent: presentBlock ifAbsent: absentBlock [
	
	| method |
	method := (aBehavior lookupSelector: aSymbol)
		ifNil: [ ^ absentBlock value ].
	1halt.
	^ self methodNamed: aSymbol inBehavior: method origin ifPresent: presentBlock
]

{ #category : #accessing }
Extension >> methodNamed: aSymbol inBehavior: aBehavior ifPresent: presentBlock [ 
	^ extensionMethods 
		at: aBehavior 
		ifPresent: [ :extension | 
			extension 
				detect: [ :method | method selector wrappedSymbol = aSymbol ] 
				ifFound: [ :method | presentBlock cull: method ] ]
]

{ #category : #accessing }
Extension >> methods [
	^ extensionMethods flatCollect: [ :each | each ] as: OrderedCollection
]

{ #category : #accessing }
Extension >> name [
	^ name
]

{ #category : #accessing }
Extension >> package [
	^ package
]

{ #category : #printing }
Extension >> printOn: aStream [
	aStream << name
]

{ #category : #accessing }
Extension >> removeMethodNamed: aSymbol fromBehavior: aBehavior [ 
	extensionMethods at: aBehavior ifPresent: [ :methods | 
		| method |
		method := methods detect: [ :each | each selector wrappedSymbol = aSymbol ].
		methods remove: method.
		method methodClass removeSelectorSilently: method selector ].
	extensionMethods associations 
		detect: [ :assoc | assoc key ~~ aBehavior and: [ assoc value anySatisfy: [ :method | 
			method selector wrappedSymbol = aSymbol ] ] ]
		ifNone: [ scopedSelectors removeAllSuchThat: [ :each | each wrappedSymbol = aSymbol ] ].
	self dependentPackagesDo: [ :each | each recompileSendersOf: { aSymbol } ]
]

{ #category : #accessing }
Extension >> scopedSelectors [
	^ scopedSelectors
]

{ #category : #accessing }
Extension >> selectors [
	^ scopedSelectors collect: [ :each | each wrappedSymbol ]
]
