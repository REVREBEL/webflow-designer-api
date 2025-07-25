

import React, { useState, useEffect } from 'react';
import ReactDOM from 'react-dom/client';
import * as webflowApi from './webflow-api';


// Define a simple type for our state, using `any` as per the API module
type VariableCollection = any;

  const [canPerformActions, setCanPerformActions] = useState<boolean>(false);
  const [collections, setCollections] = useState<VariableCollection[]>([]);
  const [message, setMessage] = useState<string>('Welcome to the Rebel Webflow Variables App!');

  // Check for design capabilities when the app loads
  useEffect(() => {
    const checkCapabilities = async () => {
      const can = await webflowApi.canDesign();
      setCanPerformActions(can);
      if (!can) {
        setMessage('App is in read-only mode. Switch to Design Mode to enable actions.');
      }
    };
    checkCapabilities();
  }, []);

  const handleAddText = async () => {
    if (!canPerformActions) return;
    await webflowApi.setTextOnSelectedElement('Hello from React!');
    setMessage('Text added to selected element.');
  };

  const handleFetchCollections = async () => {
    const fetchedCollections = await webflowApi.getAllVariableCollections();
    setCollections(





const root = ReactDOM.createRoot(document.getElementById("root") as HTMLElement);
root.render(<App />);

/**
Get all variable collections
Retrieves all variable collections for a site.
Syntax
webflow.getAllVariableCollections()

Returns
Promise<Array<VariableCollection>>

A Promise that resolves to an array of variable collection objects.

returns an array of collection objects
 [
     {
         "id": "collection-4a393cee-14d6-d927-f2af-44169031a25b",
    },
     {
         "id": "collection-4a393cee-14d6-d927-f2af-44169031a49c",
     }
]
 */

const collections = await webflow.getAllVariableCollections();


// Create a variable
const variable = await collection?.createColorVariable('primary', 'red')

// Get all variables
const variables = await collection?.getAllVariables()

// Get a variable collection by ID
// Retrieves a variable collection by its ID.
// Parameters
// collectionId: string - The ID of the variable collection to retrieve.
// Returns
// Promise<VariableCollection>

// The a promise that resolves to a variable collection object.
// returns a collection object
// {
//     "id": "collection-4a393cee-14d6-d927-f2af-44169031a25b",
// }

const variableCollectionById = await  webflow.getVariableCollectionById(collectionId: string)


// Get collection name

// Retrieves the name of the variable collection.

// Syntax
// collection.getName(): Promise<string>

// Returns
// Promise< string>

// A Promise that resolves to a string of the Variable Collection’s name

// Get Collection
const defaultVariableCollection = await webflow.getDefaultVariableCollection();

// Get Collection Name
const collectionName = await defaultVariableCollection?.getName()
console.log(collectionName)




//Creating a variable
// Variables belong to a collection. To create a variable, you need to get the collection first.

const collection = await webflow.getVariableCollectionById("Your Collection ID")


// Each variable type has its own creation function. Below are the available variable types and how to create them:

// Accepted Formats for Value	        Examples
// Color name	                        collection.createColorVariable("primary", "red");
// RGB Hex	                            collection.createColorVariable("primary", "#ffcc11");
// RGBA Hex	                          collection.createColorVariable("primary", "#fffcc11");

collection.createColorVariable(name: string, value: string | ColorVariable | CustomValue): Promise<ColorVariable>


// Get the default variable collection
const collection = await webflow.getDefaultVariableCollection();
// Create primary brand color variable
const primaryColor = await collection.createColorVariable("primary-brand", "#0066FF");
// Create aliases that reference the primary color
const buttonColor = await collection.createColorVariable("button-primary", primaryColor);
const linkColor = await collection.createColorVariable("link-color", primaryColor);
// When primaryColor changes, buttonColor and linkColor will automatically update
await primaryColor.set("#FF0066");

//Selecting variables

// Get Default Collection
const collection = await webflow.getDefaultVariableCollection()
// Get variable by ID
const variableById = await collection?.getVariable('id-123')
// Get Variable by Name
const variableByName = await collection?.getVariableByName('Space Cadet')


//Renaming variables

// Get Collection
const collection = await webflow.getDefaultVariableCollection()
if (collection) {
  // Get variable and reset name
  const variable = await collection.getVariableByName("Space Cadet")
  await variable?.setName('Our awesome bg color')
}

//Setting variable values

// Get Collection
const collection = await webflow.getDefaultVariableCollection()
// Get Variable
const variable = await collection?.getVariable('id-123')
// Check Variable type and set color
if (variable?.type === "Color") await variable.set("#fffcc11");


//Applying variables to styles

// Get collection
const collection = await webflow.getDefaultVariableCollection()
// Get Style and desired variable
const style = await webflow.getStyleByName(styleName)
const variable = await collection?.getVariablebyName(variableName)
// Check variable type and set property
if (variable?.type === 'Size') await style?.setProperties({ "font-size": variable})


//Using functions in variables


// Webflow supports these CSS functions in variables:

//Function	    Purpose	                                  Example
//calc()	      Perform mathematical calculations	        calc(100vh - var(--header-height))
//clamp()	      Create fluid values with min/max bounds	  clamp(1rem, 5vw, 3rem)
//min()	        Use the smallest of multiple values	      min(50%, 300px)
//max()	        Use the largest of multiple values	      max(100px, 20%)
//color-mix()	  Blend colors together	                    color-mix(in srgb, var(--primary) 75%, white)



//Using functions with custom values
//When using functions, you can reference other variables using the var() syntax. This allows you to create dynamic relationships between your design tokens. To dynamically get this syntax, you can use the getBinding() method on a variable.

variable.set({
  type: "custom",
  value: "calc(var(--spacing-base) * 2)"
});


//Create a custom value

// Get collection
const collection = await webflow.getDefaultVariableCollection()
// Create a Color Variable
const colorVariable = await collection.createColorVariable("blue-500", "#146EF5")
// Get the binding for the variable
const binding = await colorVariable.getBinding()
// Create a Color Variable with a custom value
await colorVariable.set({
    type: "custom",
    value: `color-mix(in srgb, ${binding}, white 75%)`
});


//Set a custom value
variable.set({
    type: "custom",
    value: "clamp(1rem, 2vw, 2rem)"
});


//Create number variable
/** 
Syntax
collection.createNumberVariable(name: string, value: number | NumberVariable | CustomValue): Promise<NumberVariable>

Parameters
name : string - Name of the variable
value: number | NumberVariable | CustomValue - Value of the variable.
Returns
Promise<NumberVariable>

A Promise that resolves to a NumberVariable object.
*/

// Get Collection
const collection = await webflow.getDefaultVariableCollection()
// Create Number Variable of 50
const myNumberVariable = await collection?.createNumberVariable("small", 50)
console.log(myNumberVariable)
// Create a Number Variable with a Custom Value
const myCustomNumberVariable = await collection?.createNumberVariable("h1-font-size", {
  type: "custom",
  value: "clamp(1, 2, 2)",
})
console.log(myCustomNumberVariable)




/**
Create color variable

collection.createColorVariable(name, value)
Create a color variable with a name and value for the variable.

Once created, you can set color variables for: Text colors, Background colors, Border and text stroke colors, and Gradient color stops

Syntax
collection.createColorVariable(name: string, value: string | ColorVariable | CustomValue): Promise<ColorVariable>

Parameters
name : string - Name of the variable
value: string | ColorVariable | CustomValue - Value of the variable. Value can be a string in one of four formats:
Color Name
Color RGB hex value
Color RGBA hex value
Custom value
Returns
Promise<ColorVariable>

*/


// Get Collection
const collection = await webflow.getDefaultVariableCollection()
// Create Color Variable with a HEX Codre
const myColorVariable = await collection?.createColorVariable("primary", "#ffcc11")
console.log(myColorVariable)



/**
Create font family variable

Copy page

collection.createFontFamilyVariable(name, value)
Create a Font Family variable with a name for the variable, and name for the Font Family.

Syntax
collection.createFontFamilyVariable(name: string, value: string | FontFamilyVariable | CustomValue): Promise<FontFamilyVariable>

Parameters
name : string - Name of the variable
value: string | FontFamilyVariable | CustomValue - Font Name
Returns
Promise<FontFamilyVariable>

A Promise that resolves to a FontFamilyVariable object
*/


// Get Collection
const collection = await webflow.getDefaultVariableCollection()
// Create Font Family Variable with a Font Family Name
const myFontFamilyVariable = await collection?.createFontFamilyVariable("Default Font", "Inter")
console.log(myFontFamilyVariable)




/**
Create size variable

Copy page

collection.createSizeVariable(name, value)
Create a Size variable with a name for the variable, and size value.

Once created, you can set size variables for:

Margin and padding — top, bottom, left, right
Position — top, bottom, left, right
Column and row gaps for display settings and Quick Stack
Height and width dimensions (including min and max)
Grid column and row sizes
Typography — font size, line height, letter spacing
Border radius and width
Filter and backdrop filter blur radius
Syntax
collection.createSizeVariable(name: string, value: SizeValue | SizeVariable | CustomValue): Promise<SizeVariable>

Size Units
Parameters
name : string - Name of the variable
value: SizeValue | SizeVariable | CustomValue - Object with the unit and value of the size. {unit: SizeUnit, value: number} Additionally, you can pass a SizeVariable to create a referenced variable or CustomValue to create a variable with a custom value.
SizeUnit : string - Any of the following units "px" | "em" | "rem" | "vh" | "vw" | "dvh" | "dvw" | "lvh" | "lvw" | "svh" | "svw" | "vmax" | "vmin" | "ch"
Returns
Promise<SizeVariable>

A Promise that resolves to a SizeVariable object
*/


// Get Collection
const collection = await webflow.getDefaultVariableCollection()
// Create Size Variable with a Size Value
const mySizeVariable = await collection?.createSizeVariable("Defualt Padding", { unit: "px", value: 50 })
console.log(mySizeVariable)
// Create a Size Variable with a Custom Value
const myCustomSizeVariable = await collection?.createSizeVariable("h1-font-size", {
  type: "custom",
  value: "clamp(1rem, 2vw, 2rem)",
})
console.log(myCustomSizeVariable)



/**
Create percentage variable

collection.createPercentageVariable(name, value)
Create a percentage variable with a name and value for the variable.

Syntax
collection.createPercentageVariable(name: string, value: number | PercentageVariable | CustomValue): Promise<PercentageVariable>

Parameters
name : string - Name of the variable
value: number | PercentageVariable | CustomValue - Value of the variable.
Returns
Promise<PercentageVariable>

A Promise that resolves to a PercentageVariable object.
 */


// Get Collection
const collection = await webflow.getDefaultVariableCollection()

// Create Percentage Variable of 50 Percent
const myPercentageVariable = await collection?.createPercentageVariable("50%", 50)
console.log(myPercentageVariable)


/**
Get all variables

Copy page

collection.getAllVariables()
Get all variables in a collection

Syntax
collection.getAllVariables(): Promise<Array<Variable>>

Returns
Promise<Variable>

A Promise that resolves to an array of Variable objects

 */



/**
Get variable by name

Copy page

collection.getVariableByName(name)
Retrieve a variable by its name.

Syntax
collection.getVariableByName(name: string): Promise<null | Variable>>

Parameters
name : string - Name of the variable you’d like to retrieve
Returns
Promise< Variable | null>

A Promise that resolves to a Variable object, or null if not found
 */

// Get Collection
const collection = await webflow.getDefaultVariableCollection()

// Get Variable by Name
const variableByName = await collection?.getVariableByName('Space Cadet')
console.log(variableByName)


/**
Get variable by ID

Copy page

collection.getVariable(id)
Retrieve a variable by its ID.

Syntax
collection.getVariable(id: VariableId): Promise<null | Variable>

Parameters
ID : string - ID of the variable you’d like to retrieve
Returns
Promise<Variable | null>

A promise that resolves to a Variable object, or null if not found
 */


// Get Collection
const collection = await webflow.getDefaultVariableCollection()

// Get variable by ID
const variableById = await collection?.getVariable('id-123')
console.log(variableById)