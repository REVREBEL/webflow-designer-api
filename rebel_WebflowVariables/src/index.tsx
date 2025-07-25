import React, { useState, useEffect } from 'react';
import ReactDOM from 'react-dom/client';
import * as webflowApi from './webflow-api';

// Define a simple type for our state, using `any` as per the API module
type VariableCollection = any;
// Define a more specific type for storing collection info in our state.
interface CollectionInfo {
  id: string;
  name: string;
}
// Define an interface for our new form's state and errors.
interface ShadeGeneratorForm {
  baseVariableName: string;
  baseColor: string;
  darkerShades: string;
  lighterShades: string;
  colorPercentage: string;
  // A special key for combined errors
  shades: string;
}

const App: React.FC = () => {
  const [canPerformActions, setCanPerformActions] = useState<boolean>(false);
  const [collections, setCollections] = useState<CollectionInfo[]>([]);
  const [selectedCollection, setSelectedCollection] = useState<CollectionInfo | null>(null);
  const [message, setMessage] = useState<string>('Welcome to the Rebel Webflow Variables App!');

  // State for the new shade generator form
  const [formState, setFormState] = useState<Omit<ShadeGeneratorForm, 'shades'>>({
    baseVariableName: '',
    baseColor: '#146EF5', // Default to Webflow Blue
    darkerShades: '3',
    lighterShades: '3',
    colorPercentage: '10',
  });
  const [errors, setErrors] = useState<Partial<ShadeGeneratorForm>>({});
  const [isSubmitting, setIsSubmitting] = useState<boolean>(false);

  // Check for design capabilities when the app loads
  useEffect(() => {
    const initializeApp = async () => {
      // Set the extension size to large for more space
      await webflowApi.setExtensionSize('large');

      const can = await webflowApi.canDesign();
      setCanPerformActions(can);
      if (!can) {
        setMessage('App is in read-only mode. Switch to Design Mode to enable actions.');
      }
    };
    initializeApp();
  }, []);

  const handleAddText = async () => {
    if (!canPerformActions) return;
    await webflowApi.setTextOnSelectedElement('Hello from React!');
    setMessage('Text added to selected element.');
  };

  const handleFetchCollections = async () => {
    if (!canPerformActions) return;
    setMessage('Fetching collections...');
    const fetchedCollections = await webflowApi.getAllVariableCollections();

    // Map over the raw collections and fetch the name for each one.
    // This creates an array of objects with both id and name, as requested.
    const collectionsWithData = await Promise.all(
      fetchedCollections.map(async (collection: VariableCollection) => {
        try {
          // The collection object from the API has a `getName` method.
          const name = await collection.getName();
          return { id: collection.id, name: name || `Unnamed Collection (ID: ${collection.id})` };
        } catch (error) {
          console.error(`Failed to get name for collection ${collection.id}`, error);
          return { id: collection.id, name: `Error loading name (ID: ${collection.id})` };
        }
      })
    );

    setCollections(collectionsWithData);
    setMessage(`Fetched ${collectionsWithData.length} variable collections.`);
  };

  const handleSelectCollection = (collection: CollectionInfo) => {
    setSelectedCollection(collection);
    setErrors({}); // Clear errors when a new collection is selected
    setMessage(`Selected collection: "${collection.name}"`);
  };

  // A simple example of creating a variable
  const handleCreateVariable = async () => {
    if (!canPerformActions) return;
    const defaultCollection = await webflowApi.getDefaultVariableCollection();
    if (defaultCollection) {
      const newColor = `#${Math.floor(Math.random() * 16777215)
        .toString(16)
        .padStart(6, '0')}`;
      await webflowApi.createColorVariable(defaultCollection, 'My New Color', newColor);
      setMessage(`Created new color variable in the default collection.`);
    } else {
      setMessage('Could not find a default collection to add a variable to.');
    }
  };

  const handleFormChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setFormState((prevState) => ({
      ...prevState,
      [name]: value,
    }));
  };

  const validateAndSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    const newErrors: Partial<ShadeGeneratorForm> = {};

    // --- Validation Logic ---
    if (!formState.baseVariableName.trim()) {
      newErrors.baseVariableName = 'Variable name is required.';
    }
    if (!/^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$/.test(formState.baseColor)) {
      newErrors.baseColor = 'Please enter a valid HEX color (e.g., #RRGGBB).';
    }

    const numDarker = parseInt(formState.darkerShades, 10);
    const numLighter = parseInt(formState.lighterShades, 10);

    if (isNaN(numDarker) || isNaN(numLighter) || numDarker < 0 || numLighter < 0) {
      newErrors.shades = 'Shade counts must be zero or a positive number.';
    } else if (numDarker + numLighter > 10) {
      newErrors.shades = 'Total number of shades cannot exceed 10.';
    } else if (numDarker + numLighter === 0) {
      newErrors.shades = 'You must generate at least one shade.';
    }

    const perc = parseInt(formState.colorPercentage, 10);
    if (isNaN(perc) || perc < 1 || perc > 100) {
      newErrors.colorPercentage = 'Percentage must be a number between 1 and 100.';
    }

    setErrors(newErrors);

    // --- Submission Logic ---
    if (Object.keys(newErrors).length === 0) {
      if (!selectedCollection) {
        setMessage('Error: No collection selected.');
        return;
      }
      setIsSubmitting(true);
      setMessage('Generating variables...');

      try {
        const numDarker = parseInt(formState.darkerShades, 10);
        const numLighter = parseInt(formState.lighterShades, 10);
        const perc = parseInt(formState.colorPercentage, 10);

        const success = await webflowApi.createColorShadeVariables(
          selectedCollection.id,
          formState.baseVariableName,
          formState.baseColor,
          numDarker,
          numLighter,
          perc
        );

        if (success) {
          setMessage(`Successfully created shades for ${formState.baseVariableName}.`);
        } else {
          setMessage('Variable creation failed. Check the console for details.');
        }
      } finally {
        setIsSubmitting(false);
      }
    } else {
      setMessage('Please correct the errors in the form.');
    }
  };

  // Inline styles for cleaner JSX
  const formRowStyle = { display: 'flex', flexDirection: 'column', marginBottom: '12px' };
  const errorStyle = { color: 'red', fontSize: '0.8rem', marginTop: '4px' };

  return (
    <div>
      <h4>{message}</h4>
      <button onClick={handleAddText} disabled={!canPerformActions}>
        Add Text to Element
      </button>
      <button onClick={handleFetchCollections} disabled={!canPerformActions}>
        Fetch Variable Collections
      </button>
      <button onClick={handleCreateVariable} disabled={!canPerformActions}>
        Create New Color Variable
      </button>
      <hr />
      <h5>Variable Collections:</h5>
      {collections.length > 0 ? (
        <ul>
          {collections.map((collection) => {
            const isSelected = selectedCollection?.id === collection.id;
            return (
              <li
                key={collection.id}
                style={{ display: 'flex', alignItems: 'center', gap: '10px', marginBottom: '5px' }}
              >
                <span style={{ flexGrow: 1 }}>{collection.name}</span>
                <button onClick={() => handleSelectCollection(collection)} disabled={isSelected || !canPerformActions}>
                  {isSelected ? '✓ Selected' : 'Select'}
                </button>
              </li>
            );
          })}
        </ul>
      ) : (
        <p>No collections loaded yet.</p>
      )}
      {selectedCollection && (
        <div>
          <hr />
          <h5>Generate Color Shades in "{selectedCollection.name}"</h5>
          <form onSubmit={validateAndSubmit} noValidate>
            <div style={formRowStyle}>
              <label htmlFor="baseVariableName">1. New Base Color Variable Name</label>
              <input type="text" id="baseVariableName" name="baseVariableName" value={formState.baseVariableName} onChange={handleFormChange} required />
              {errors.baseVariableName && <span style={errorStyle}>{errors.baseVariableName}</span>}
            </div>

            <div style={formRowStyle}>
              <label htmlFor="baseColor">2. Base Color (HEX Format)</label>
              <input type="text" id="baseColor" name="baseColor" value={formState.baseColor} onChange={handleFormChange} required />
              {errors.baseColor && <span style={errorStyle}>{errors.baseColor}</span>}
            </div>

            <div style={{ display: 'flex', gap: '20px' }}>
              <div style={formRowStyle}>
                <label htmlFor="darkerShades">3. Shades Darker</label>
                <input type="number" id="darkerShades" name="darkerShades" value={formState.darkerShades} onChange={handleFormChange} min="0" required />
              </div>
              <div style={formRowStyle}>
                <label htmlFor="lighterShades">4. Shades Lighter</label>
                <input type="number" id="lighterShades" name="lighterShades" value={formState.lighterShades} onChange={handleFormChange} min="0" required />
              </div>
            </div>
            {errors.shades && <span style={{...errorStyle, marginTop: '-8px', marginBottom: '12px', display: 'block'}}>{errors.shades}</span>}

            <div style={formRowStyle}>
              <label htmlFor="colorPercentage">5. Percent Step</label>
              <input
                type="number"
                id="colorPercentage"
                name="colorPercentage"
                value={formState.colorPercentage}
                onChange={handleFormChange}
                min="1"
                max="100"
                required
              />
              {errors.colorPercentage && <span style={errorStyle}>{errors.colorPercentage}</span>}
            </div>

            <button type="submit" disabled={!canPerformActions || isSubmitting}>
              {isSubmitting ? 'Generating...' : 'Generate Variables'}
            </button>
          </form>
        </div>
      )}
    </div>
  );
};

const rootElement = document.getElementById('root');
if (rootElement) {
  const root = ReactDOM.createRoot(rootElement);
  root.render(
    <React.StrictMode>
      <App />
    </React.StrictMode>
  );
}
