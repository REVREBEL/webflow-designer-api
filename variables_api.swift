
/**
 * Retrieves values from named ranges in the "settings" sheet and sets them as script properties.
 */
function setScriptPropertiesFromSheet() {
  // Get the active spreadsheet
  var wb = SpreadsheetApp.getActiveSpreadsheet();
  //var ss = wb.getSheetByName("settings");

  // Retrieve categoryCollectionId from range named categoryCollectionId and trim white spaces
  var siteIdRange = wb.getRangeByName("siteId");
  var siteId = siteIdRange.getValue().trim();

  // Retrieve apiKey from range named apiKey and trim white spaces
  var apiKeyRange = wb.getRangeByName("apiKey");
  var apiKey = apiKeyRange.getValue().trim();

  // Retrieve categoryCollectionId from range named categoryCollectionId and trim white spaces
  var categoryCollectionIdRange = wb.getRangeByName("categoryCollectionId");
  var categoryCollectionId = categoryCollectionIdRange.getValue().trim();

  // Retrieve itemCollectionId from range named itemCollectionId and trim white spaces
  var itemCollectionIdRange = wb.getRangeByName("itemsCollectionId");
  var itemCollectionId = itemCollectionIdRange.getValue().trim();

  // Retrieve cmsLocaleId from range named cmsLocaleId and trim white spaces
  var cmsLocaleIdRange = wb.getRangeByName("cmslocaleid");
  var cmsLocaleId = cmsLocaleIdRange.getValue().trim();

  // Retrieve the API Base URL from range named apiBaseUrl and trim white spaces
  var apiBaseUrlRange = wb.getRangeByName("apiBaseUrl");
  var apiBaseUrl = apiBaseUrlRange.getValue().trim();

  // Retrieve the API Base URL from range named apiBaseUrl and trim white spaces
  var logsFolderIdRange = wb.getRangeByName("logsFolderId");
  var logsFolderId = logsFolderIdRange.getValue().trim();

  // Set the values as script properties
  clearAllScriptProperties();
  PropertiesService.getScriptProperties().setProperty('SITE_ID_FROM_SHEET', siteId);
  PropertiesService.getScriptProperties().setProperty('API_KEY_FROM_SHEET', apiKey);
  PropertiesService.getScriptProperties().setProperty('ITEM_COLLECTION_ID_FROM_SHEET', itemCollectionId);
  PropertiesService.getScriptProperties().setProperty('CATEGORY_COLLECTION_ID_FROM_SHEET', categoryCollectionId);
  PropertiesService.getScriptProperties().setProperty('CMS_LOCALE_ID_FROM_SHEET', cmsLocaleId);
  PropertiesService.getScriptProperties().setProperty('API_BASE_URL_FROM_SHEET', apiBaseUrl);
  PropertiesService.getScriptProperties().setProperty('LOGS_FOLDER_ID_FROM_SHEET', logsFolderId);

  // Set the values as script properties for category & topic names and corresponding IDs.
  var categoryItemRefMap = saveCategoryItemRefMapToProperties();
  var topicItemRefMap = saveTopicItemRefMapToProperties();

  // Confirm values are set 
  Logger.log("siteID: " + siteId);
  Logger.log("apiKey: " + apiKey);
  Logger.log("cmslocaleid: " + cmsLocaleId);
  Logger.log("categoryCollectionId: " + categoryCollectionId);
  Logger.log("itemCollectionId:" + itemCollectionId);
  Logger.log("apiBaseUrl:" + apiBaseUrl);
  Logger.log("logsFolderId:" + logsFolderId);

  Logger.log("categoryItemRefMap:" + categoryItemRefMap);
  Logger.log("topicItemRefMap:" + topicItemRefMap);

  // Call the function to save the category item reference map to script properties
}



/** 

getAllVariableCollections: async () => {
  // Get All Variable Collections
  const variableCollections = await webflow.getAllVariableCollections()
  console.log('All Variable Collections:')
  console.log(variableCollections)
}


getVariableCollectionById: async (id: string) => {
      // Get Variable Collection by ID
      const variableCollection = await webflow.getVariableCollectionById(id)
      console.log('Variable Collection:')
      console.log(variableCollection)
    }


getCollectionName: async () => {
      // Get Collection
      const defaultVariableCollection =
        await webflow.getDefaultVariableCollection()

      // Get Collection Name
      const collectionName = await defaultVariableCollection?.getName()
      console.log(collectionName)
    }

getCollectionAndVariables: async () => {
      // Fetch the default variable collection
      const defaultVariableCollection =
        await webflow.getDefaultVariableCollection()

      if (defaultVariableCollection) {
        // Print Collection ID
        console.log(
          'Default Variable Collection ID:',
          defaultVariableCollection.id,
        )

        // Fetch all variables within the default collection
        const variables = await defaultVariableCollection.getAllVariables()

        if (variables.length > 0) {
          console.log('List of Variables in Default Collection:')

          // Print variable details
          for (var i in variables) {
            console.log(
              `${i}. Variable Name: ${await variables[i].getName()}, Variable ID: ${variables[i].id}`,
            )
          }
        } else {
          console.log('No variables found in the default collection.')
        }
      } else {
        console.log('Default Variable Collection not found.')
      }
    }    
*/

/**
 
 All Variable Collections:
[
{
"id": "collection-ae8058f6-f1c1-3120-091f-9280532b42e7"
},
{
"id": "collection-401b29df-322e-60b7-9b78-55d5f6293ac2"
},
{
"id": "collection-ea1199e7-1753-7cc4-8257-56b5b7eb892f"
},
{
"id": "collection-95c00d10-cff2-f441-6e09-92d2bd2fad4e"
},
{
"id": "collection-fe859a71-982b-56b7-5ee2-455e4602c6f7"
},
{
"id": "collection-6f172999-a5c4-1a7e-bffc-05a3f079d0d0"
}
]

 */



/**
 
Default Variable Collection ID: collection-ae8058f6-f1c1-3120-091f-9280532b42e7
List of Variables in Default Collection:
0. Variable Name: Headlines/H0, Variable ID: variable-764b0685-f4f3-d76d-7fd3-a870462398f6
1. Variable Name: Headlines/H1, Variable ID: variable-cdcd8f8c-f3a8-2f8f-1f63-0b716fdc21f5
2. Variable Name: Headlines/H2, Variable ID: variable-86115e0c-4a7a-2ae7-320b-f85404f922da
3. Variable Name: Headlines/H3, Variable ID: variable-272c1fa1-d05f-a577-6f3a-d07f477cb398
4. Variable Name: Headlines/H5, Variable ID: variable-e816c278-9300-ac45-0d4a-6356116e597a
5. Variable Name: Headlines/H4, Variable ID: variable-5491d873-eccf-ec31-c2a2-d4ca36d4fa2f
6. Variable Name: Headlines/H6, Variable ID: variable-fc99d5a2-2f48-e9a8-0a15-b045e01e6d8f
7. Variable Name: Core Colors/Blue, Variable ID: variable-2bb1ebee-e63b-0624-0a6e-46ad3ae5858d
8. Variable Name: Core Colors/Purple, Variable ID: variable-9ed39609-521c-527d-bd73-788f2e52a5fb
9. Variable Name: Core Colors/Green, Variable ID: variable-44c971a7-7060-243c-bdfe-6c1a90a46fff
10. Variable Name: Core Colors/BrightBlue, Variable ID: variable-36a23712-adf5-f0e5-7383-3ada27704833
11. Variable Name: Core Colors/Red, Variable ID: variable-42a633f4-6dff-d54a-61c7-0d15351f6849
12. Variable Name: Core Colors/Orange, Variable ID: variable-ee4c7c3b-6771-a30a-44bb-89340d8e8719
13. Variable Name: Core Colors/BrightOrange, Variable ID: variable-bb86dcb6-76f9-0611-4026-990901121b84
14. Variable Name: Core Colors/Yellow, Variable ID: variable-5879c0dc-ea60-89db-c764-d5fcbed221ed
15. Variable Name: Core Colors/BrightGrey, Variable ID: variable-75543cce-a7dd-2790-061d-6c48c86ad5c3
16. Variable Name: Core Colors/Grey, Variable ID: variable-b6579755-6999-56a4-0d8c-576f7f8333b4
17. Variable Name: Core Colors/White, Variable ID: variable-52039457-e40f-7228-8240-75fd82d38a0d
18. Variable Name: Core Colors/BrightWhite, Variable ID: variable-97f4b002-c300-d880-4d66-6507db914b46
19. Variable Name: Core Colors/inherit, Variable ID: variable-850e9567-9cc7-8405-f53c-cb124d742bd5
20. Variable Name: Backgrounds/BG Blue, Variable ID: variable-0ff76190-f9f3-4c95-6ef6-097c0e4ef4b1
21. Variable Name: Backgrounds/BG Purple, Variable ID: variable-65dd83db-3cbf-dcaf-c64a-6a5b0111033c
22. Variable Name: Backgrounds/BG Green, Variable ID: variable-d2ed15ce-6939-155e-c0c2-6bde17f129e1
23. Variable Name: Backgrounds/BG BrightBlue, Variable ID: variable-1e5cd069-b50f-0bb7-ee30-8650e3a23ebb
24. Variable Name: Backgrounds/BG Red, Variable ID: variable-40953761-7601-41e0-840b-f0f38667b82c
25. Variable Name: Backgrounds/BG Orange, Variable ID: variable-10372c3a-5a9f-552e-5599-35a43dc5bdaa
26. Variable Name: Backgrounds/BG BrightOrange, Variable ID: variable-1fc0e218-d501-e14e-a97e-5a4c160b81d6
27. Variable Name: Backgrounds/BG Yellow, Variable ID: variable-638288bc-85f1-a9a0-db56-2484cd505697
28. Variable Name: Backgrounds/BG Grey, Variable ID: variable-339af5d8-aff0-9fd8-c364-6414ae0d936b
29. Variable Name: Backgrounds/BG BrightGrey, Variable ID: variable-54c12301-73bf-29a6-0f70-82a2c2f73e79
30. Variable Name: Backgrounds/BG White, Variable ID: variable-5360dd9d-a550-3bc4-bc10-cf0db4deb1a4
31. Variable Name: Backgrounds/BG BrightWhite, Variable ID: variable-51466b0c-afbd-676e-7535-780218d7c4d4

 */




getVariableById: async (id: string) => {
  // Get Collection
  const collection = await webflow.getDefaultVariableCollection()

  // Get variable by ID
  const variableById = await collection?.getVariable(id)
  console.log(variableById)
};

getVariableByName: async (name: string) => {
  // Get Collection
  const collection = await webflow.getDefaultVariableCollection()

  // Get Variable by Name
  const variableByName = (await collection?.getVariableByName(
    name,
  )) as ColorVariable
  console.log(variableByName)
};

editVariable: async () => {
  // Get Collection
  const collection = await webflow.getDefaultVariableCollection()

  if (collection) {
    // Get variable and reset name
    const variable = await collection.getVariableByName('Space Cadet')
    await variable?.setName('Our awesome bg color')
  }
};



getVariableValue: async (
  collection: VariableCollectionInfo,
  variable: VariableInfo,
) => {
  // Get selected collection and variable info
  const selCollection = await webflow.getVariableCollectionById(
    collection.id,
  )
  const selVariable = await selCollection?.getVariable(variable.id)

  // Get variable value. Include option to return custom values
  let value = await selVariable?.get({ customValues: true })

  console.log(`Raw value: ${JSON.stringify(value)}`)
  let type = selVariable?.type

  // If the variable is a custom value, return the value
  if (
    value &&
    typeof value === 'object' &&
    'type' in value &&
    value.type === 'custom'
  ) {
    value = value.value
    type = `Custom ${type}`
  }

  // If the variable is a variable reference, return the referenced variable name
  if (value && typeof value === 'object' && 'id' in value) {
    let referencedVariable = await selCollection?.getVariable(value.id)
    value = await referencedVariable?.getName()
    type = `Referenced ${type}`
  }

  console.log(`Variable Type: ${type}`)
  console.log(`Variable Value: ${value}`)

  return { value, type }
};



setVariableValue: async (name: string) => {
  // Get Collection
  const collection = await webflow.getDefaultVariableCollection()

  // Get Variable
  const variable = await collection?.getVariableByName(name)

  // Check Variable type and set color
  if (variable?.type === 'Color') await variable.set('#fffcc11')
};



getAllVariableModes: async () => {
  // Get Collection
  const collection = await webflow.getDefaultVariableCollection()

  // Get All Variable Modes
  const variableModes = await collection?.getAllVariableModes()
  console.log(variableModes)
}


getVariableModeByName: async (modeName: string) => {
  // Get Collection
  const collection = await webflow.getDefaultVariableCollection()

  // Get Variable Mode by Name
  const variableMode = await collection?.getVariableModeByName(modeName)
  console.log(variableMode)
},

  createColorVariable: async () => {
    // Get Collection
    const collection = await webflow.getDefaultVariableCollection()

    // Create Color Variable with a HEX Codre
    const myColorVariable = await collection?.createColorVariable(
      'primary',
      '#ffcc11',
    )
    console.log(myColorVariable)
  };


createCustomColorVariable: async () => {
  // Get Collection
  const collection = await webflow.getDefaultVariableCollection()

  // Create Color Variable
  const webflowBlue = await collection?.createColorVariable(
    'blue-500',
    '#146EF5',
  )

  // Get the binding to the webflowBlue variable
  const webflowBlueBinding = await webflowBlue?.getBinding()

  createCustomColorVariable: async () => {
    // Get Collection
    const collection = await webflow.getDefaultVariableCollection()

    // Create Color Variable
    const webflowBlue = await collection?.createColorVariable(
      'blue-500',
      '#146EF5',
    )

    // Get the binding to the webflowBlue variable
    const webflowBlueBinding = await webflowBlue?.getBinding()

    // Function to create a string that uses the binding and CSS color-mix function
    const colorMix = (binding, color, opacity) =>
      `color-mix(in srgb, ${binding} , ${color} ${opacity}%)`

    // Create a color variable that uses a CSS function
    const webflowBlue400 = await collection?.createColorVariable('blue-400', {
      type: 'custom',
      value: colorMix(webflowBlueBinding, '#fff', 60),
    })
    console.log(webflowBlue400)
  };


  createSizeVariable: async () => {
    // Get Collection
    const collection = await webflow.getDefaultVariableCollection()

    // Create Size Variable with a Size Value
    const mySizeVariable = await collection?.createSizeVariable(
      'Default Padding',
      { unit: 'px', value: 50 },
    )
    console.log(mySizeVariable)
  };

  createCustomSizeVariable: async () => {
    // Get Collection
    const collection = await webflow.getDefaultVariableCollection()
  };

  createFontFamilyVariable: async () => {
    // Get Collection
    const collection = await webflow.getDefaultVariableCollection()

    // Create Font Family Variable with a Font Family Name
    const myFontFamilyVariable = await collection?.createFontFamilyVariable(
      'Default Font',
      'Inter',
    )
    console.log(myFontFamilyVariable)
  };

  createPercentageVariable: async (percentage: number) => {
    // Get Collection
    const collection = await webflow.getDefaultVariableCollection()

    // Create Percentage Variable with a Percentage Value
    const myPercentageVariable = await collection?.createPercentageVariable(
      'My Percentage',
      percentage,
    )
    console.log(myPercentageVariable)
  };


.work-link-button {
  background-image: linear-gradient(85deg, rgb(28, 67, 127) 10%, rgb(94, 104, 141) 29%, rgb(239, 83, 83) 59%, rgb(240, 141, 25) 80%, rgb(250, 214, 68));
  transition-property: filter;
  transition-duration: 200ms;
  transition-timing-function: ease;
  line-height: 130%;
  background-clip: text;
  -webkit-text-fill-color: transparent;
}

.work-link-button.-wfp-active,
:where(html:not(.wf-design-mode)) .work-link-button:active {
  background-color: var(--_colors---text--text-blue);
  background-image: none;
}

.work-link-button.large {}

.work-link-buton-l {
  position: relative;
  display: flex;
  overflow: hidden;
  padding: 0.625rem 1.25rem 1.5rem 0.625rem;
  justify-content: flex-start;
  align-items: center;
  font-family: var(--_fonts---headlines--font-headline);
  color: var(--_colors---text--text-color);
  font-size: 3.75rem;
  line-height: 117%;
  font-weight: 800;
  letter-spacing: -0.01rem;
  text-decoration: none;
  text-transform: uppercase;
}

@media screen and (max-width: 991px) {
  .work-link-button {
    font-size: var(--_headlines---headlines--headline_2-5rem);
  }
}

@media screen and (max-width: 991px) {
  .work-link-button.large {
    font-size: var(--_headlines---headlines--headline_5rem);
  }
}

@media screen and (max-width: 767px) {
  .work-link-button {
    font-size: 2.25rem;
  }
}

@media screen and (max-width: 479px) {
  .work-link-button {
    margin-top: 0.625rem;
    font-size: 1.5rem;
  }
}

@media screen and (max-width: 479px) {
  .work-link-buton-l {
    padding-right: 0.5rem;
    padding-left: 0.5rem;
  }
}