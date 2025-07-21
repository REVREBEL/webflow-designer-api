/**
 * @file This file contains a set of wrapper functions for interacting with the
 * Webflow Designer API, specifically focusing on the Variables API.
 * These functions are designed to be used within a React application.
 *
 * It's assumed that the Webflow Designer API (`webflow`) is available globally
 * in the context where this code runs (i.e., inside a Webflow Designer Extension).
 */

// In a real project, you would install `@webflow/designer-api` and import types.
// For example: import type { VariableCollection, ColorVariable, SizeValue } from '@webflow/designer-api';
// For now, we'll use `any` as a placeholder.
type VariableCollection = any;
type Variable = any;
type SizeValue = { unit: string; value: number };
type CustomValue = { type: 'custom'; value: string };

// --- General & Utility Functions ---

/**
 * Checks if the app has the necessary permissions to perform design-related actions.
 * @returns {Promise<boolean>} True if the action can be performed.
 */
export const canDesign = async (): Promise<boolean> => {
  try {
    const capabilities = await webflow.canForAppMode([
      webflow.appModes.canDesign,
      webflow.appModes.canEdit,
    ]);
    if (!capabilities.canDesign) {
      await webflow.notify({
        type: 'Error',
        message: 'Action requires design mode. Ensure you are on the Main Branch and in design mode.',
      });
    }
    return capabilities.canDesign;
  } catch (error) {
    console.error('Error checking capabilities:', error);
    await webflow.notify({ type: 'Error', message: 'Could not verify permissions.' });
    return false;
  }
};

/**
 * Sets the text content of the currently selected element.
 * @param {string} text - The text to set.
 */
export const setTextOnSelectedElement = async (text: string) => {
  const el = await webflow.getSelectedElement();
  // Use a type guard to ensure the element has the `setTextContent` method.
  // This is necessary because `AnyElement` can be a Component, which doesn't have this method.
  if (el && 'setTextContent' in el && typeof el.setTextContent === 'function') {
    await el.setTextContent(text);
  } else {
    await webflow.notify({ type: 'Error', message: 'Please select an element that can contain text.' });
  }
};


// --- Variable Collection Functions ---

/**
 * Retrieves all variable collections for the site.
 * @returns {Promise<VariableCollection[]>} A promise that resolves to an array of variable collections.
 *
 */
export const getAllVariableCollections = async (): Promise<VariableCollection[]> => {
  try {
    const collections = await webflow.getAllVariableCollections();
    await webflow.notify({ type: 'Info', message: `Found ${collections.length} collections.` });
    return collections;
  } catch (error) {
    console.error('Error getting all variable collections:', error);
    await webflow.notify({ type: 'Error', message: 'Could not fetch variable collections.' });
    return [];
  }
};

/**
 * Retrieves a variable collection by its ID.
 * @param {string} collectionId - The ID of the variable collection.
 * @returns {Promise<VariableCollection | null>} The collection or null if not found.
 */
export const getVariableCollectionById = async (collectionId: string): Promise<VariableCollection | null> => {
  try {
    const collection = await webflow.getVariableCollectionById(collectionId);
    if (!collection) {
      await webflow.notify({ type: 'Warning', message: `Collection with ID ${collectionId} not found.` });
    }
    return collection;
  } catch (error) {
    console.error(`Error getting variable collection by ID ${collectionId}:`, error);
    await webflow.notify({ type: 'Error', message: 'Could not fetch the specified collection.' });
    return null;
  }
};

/**
 * Retrieves the default variable collection for the site.
 * @returns {Promise<VariableCollection | null>} The default collection or null if not found.
 */
export const getDefaultVariableCollection = async (): Promise<VariableCollection | null> => {
  try {
    const collection = await webflow.getDefaultVariableCollection();
    if (!collection) {
      await webflow.notify({ type: 'Warning', message: 'Default variable collection not found.' });
    }
    return collection;
  } catch (error) {
    console.error('Error getting default variable collection:', error);
    await webflow.notify({ type: 'Error', message: 'Could not fetch the default collection.' });
    return null;
  }
};

/**
 * Retrieves the name of a variable collection.
 * @param {VariableCollection} collection - The collection to get the name of.
 * @returns {Promise<string | null>} The name of the collection or null on failure.
 */
export const getCollectionName = async (collection: VariableCollection): Promise<string | null> => {
  if (!collection) return null;
  try {
    return await collection.getName();
  } catch (error) {
    console.error('Error getting collection name:', error);
    await webflow.notify({ type: 'Error', message: 'Could not get collection name.' });
    return null;
  }
};

// --- Variable Functions ---

/**
 * A generic variable creation handler to reduce boilerplate code.
 * @param collection - The collection to add the variable to.
 * @param name - The name of the new variable.
 * @param value - The value of the variable.
 * @param createFn - The specific creation function on the collection object (e.g., 'createColorVariable').
 * @param typeName - The user-friendly name of the variable type (e.g., 'Color').
 * @returns The newly created variable or null on failure.
 */
async function createVariable<T>(
  collection: VariableCollection,
  name: string,
  value: any,
  createFn: 'createColorVariable' | 'createSizeVariable' | 'createNumberVariable' | 'createFontFamilyVariable' | 'createPercentageVariable',
  typeName: string
): Promise<T | null> {
  if (!collection) {
    await webflow.notify({ type: 'Error', message: 'A valid collection is required to create a variable.' });
    return null;
  }
  try {
    const variable = await collection[createFn](name, value);
    await webflow.notify({ type: 'Success', message: `${typeName} variable "${name}" created.` });
    return variable;
  } catch (error) {
    console.error(`Error creating ${typeName.toLowerCase()} variable "${name}":`, error);
    await webflow.notify({ type: 'Error', message: `Failed to create ${typeName.toLowerCase()} variable "${name}".` });
    return null;
  }
}

export const createColorVariable = (collection: VariableCollection, name: string, value: string | Variable | CustomValue) =>
  createVariable<Variable>(collection, name, value, 'createColorVariable', 'Color');

export const createSizeVariable = (collection: VariableCollection, name: string, value: SizeValue | Variable | CustomValue) =>
  createVariable<Variable>(collection, name, value, 'createSizeVariable', 'Size');

export const createNumberVariable = (collection: VariableCollection, name: string, value: number | Variable | CustomValue) =>
  createVariable<Variable>(collection, name, value, 'createNumberVariable', 'Number');

export const createFontFamilyVariable = (collection: VariableCollection, name: string, value: string | Variable | CustomValue) =>
  createVariable<Variable>(collection, name, value, 'createFontFamilyVariable', 'Font Family');

export const createPercentageVariable = (collection: VariableCollection, name: string, value: number | Variable | CustomValue) =>
  createVariable<Variable>(collection, name, value, 'createPercentageVariable', 'Percentage');

/**
 * Retrieves all variables from a specific collection.
 * @param {VariableCollection} collection - The collection to get variables from.
 * @returns {Promise<Variable[]>} An array of variables.
 */
export const getAllVariablesFromCollection = async (collection: VariableCollection): Promise<Variable[]> => {
  if (!collection) {
    await webflow.notify({ type: 'Error', message: 'A valid collection is required to get variables.' });
    return [];
  }
  try {
    return await collection.getAllVariables();
  } catch (error) {
    console.error('Error getting all variables from collection:', error);
    await webflow.notify({ type: 'Error', message: 'Could not fetch variables from the collection.' });
    return [];
  }
};

/**
 * Retrieves a variable from a collection by its name.
 * @param {VariableCollection} collection - The collection to search in.
 * @param {string} name - The name of the variable.
 * @returns {Promise<Variable | null>} The variable or null if not found.
 */
export const getVariableFromCollectionByName = async (collection: VariableCollection, name: string): Promise<Variable | null> => {
  if (!collection) return null;
  try {
    const variable = await collection.getVariableByName(name);
    if (!variable) {
      await webflow.notify({ type: 'Info', message: `Variable "${name}" not found in this collection.` });
    }
    return variable;
  } catch (error) {
    console.error(`Error getting variable by name "${name}":`, error);
    await webflow.notify({ type: 'Error', message: 'Could not fetch the specified variable.' });
    return null;
  }
};

/**
 * Retrieves a variable from a collection by its ID.
 * @param {VariableCollection} collection - The collection to search in.
 * @param {string} id - The ID of the variable.
 * @returns {Promise<Variable | null>} The variable or null if not found.
 */
export const getVariableFromCollectionById = async (collection: VariableCollection, id: string): Promise<Variable | null> => {
  if (!collection) return null;
  try {
    return await collection.getVariable(id);
  } catch (error) {
    console.error(`Error getting variable by ID "${id}":`, error);
    await webflow.notify({ type: 'Error', message: 'Could not fetch the specified variable.' });
    return null;
  }
};

/**
 * Renames a variable.
 * @param {Variable} variable - The variable to rename.
 * @param {string} newName - The new name for the variable.
 */
export const renameVariable = async (variable: Variable, newName: string): Promise<void> => {
  if (!variable) return;
  try {
    const oldName = await variable.getName();
    await variable.setName(newName);
    await webflow.notify({ type: 'Success', message: `Renamed variable "${oldName}" to "${newName}".` });
  } catch (error) {
    console.error(`Error renaming variable to "${newName}":`, error);
    await webflow.notify({ type: 'Error', message: 'Failed to rename variable.' });
  }
};

/**
 * Sets the value of a variable.
 * @param {Variable} variable - The variable to update.
 * @param {any} value - The new value to set. The type depends on the variable type.
 */
export const setVariableValue = async (variable: Variable, value: any): Promise<void> => {
  if (!variable) return;
  try {
    await variable.set(value);
    const name = await variable.getName();
    await webflow.notify({ type: 'Success', message: `Updated value for variable "${name}".` });
  } catch (error) {
    console.error('Error setting variable value:', error);
    await webflow.notify({ type: 'Error', message: 'Failed to set variable value.' });
  }
};

/**
 * Applies a variable to a CSS property of a style.
 * @param {string} styleName - The name of the style to modify.
 * @param {string} property - The CSS property to set (e.g., 'font-size', 'color').
 * @param {Variable} variable - The variable to apply.
 */

export const applyVariableToStyle = async (styleName: string, property: string, variable: Variable): Promise<void> => {
  if (!variable) return;
  try {
    const style = await webflow.getStyleByName(styleName);
    if (!style) {
      await webflow.notify({ type: 'Error', message: `Style "${styleName}" not found.` });
      return;
    }
    await style.setProperties({ [property]: variable });
    await webflow.notify({ type: 'Success', message: `Applied variable to ${property} of style "${styleName}".` });
  } catch (error) {
    console.error(`Error applying variable to style "${styleName}":`, error);
    await webflow.notify({ type: 'Error', message: 'Failed to apply variable to style.' });
  }
};
