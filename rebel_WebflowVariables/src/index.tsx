import React from "react";
import ReactDOM from "react-dom/client";

const App: React.FC = () => {
  const addText = async () => {
    // Get the current selected Element
    const el = await webflow.getSelectedElement();

    // If text content can be set, update it!
    if (el && el.textContent) {
      await el.setTextContent("hello world!");
    } else {
      alert("Please select a text element");
    }
  };

  return (
    <div>
      <h1>Welcome to My React App!</h1>
      <p>This is a basic React application.</p>
      <button onClick={addText}> Add text </button>
    </div>
  );
};



document.getElementById("lorem").onsubmit = async (event) => {
  
  // Prevent the default form submission behavior, which would reload the page
  event.preventDefault()

  // Get the currently selected element in the Designer
  const el = await webflow.getSelectedElement()

  // Check if an element was returned, and the element can contain text content
  if (el && el.textContent) {
    // If we found the element and it has the ability to update the text content,
    // replace it with some placeholder text
    el.setTextContent(
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do " +
      "eiusmod tempor incididunt ut labore et dolore magna aliqua."
    )
  } else { // If an element isn't selected, or an element doesn't have text content, notify the user
    await webflow.notify({ type: 'Error', message: "Please select an element that contains text." })
  }
}


const root = ReactDOM.createRoot(
  document.getElementById("root") as HTMLElement
);
root.render(<App />);