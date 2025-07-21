import React, { useState, useEffect } from 'react';
import ReactDOM from 'react-dom/client';
import * as webflowApi from './webflow-api';

// Define a simple type for our state, using `any` as per the API module
type VariableCollection = any;

const App: React.FC = () => {
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
    if (!canPerformActions) return;
    const fetchedCollections = await webflowApi.getAllVariableCollections();
    setCollections(fetchedCollections);
    setMessage(`Fetched ${fetchedCollections.length} variable collections.`);
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
          {collections.map((collection) => (
            <li key={collection.id}>{collection.name || collection.id}</li>
          ))}
        </ul>
      ) : (
        <p>No collections loaded yet.</p>
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
