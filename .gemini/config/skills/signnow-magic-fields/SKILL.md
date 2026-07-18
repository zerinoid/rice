---
name: signnow-magic-fields
description: Guidelines and instructions for enabling, assigning, and troubleshooting automatically applied Magic Fields in SignNow.
---

# Automatically Apply Magic Fields in SignNow

This skill provides comprehensive instructions on how to use SignNow’s Magic Fields feature to scan documents and automatically detect and place fillable fields (Name, Date, and Signature). 

## When to Use

Use this skill when you are generating or preparing contracts, agreements, and forms that will be uploaded and sent for execution using the **SignNow** e-signature platform. This feature is particularly useful for standard document layouts containing clear text cues (like "Name:", "Date:", and "Signature:") where automatic placement saves significant setup time.

---

## 1. What Are Magic Fields?

Magic Fields is an intelligent automation feature in SignNow that scans your document for common field labels and automatically overlays corresponding fillable fields where they are needed.

* **Supported Cues:** Words like `Name:`, `Date:`, or `Signature:` are automatically recognized.
* **Benefits:** Accelerates document preparation, reduces manual drag-and-drop actions, and ensures consistency and accuracy in field placement.

---

## 2. Supported Field Types and Limitations

Before using Magic Fields, keep the following capabilities and limitations in mind:

### Supported Fields
* **Name** (Text field)
* **Date** (Date-specific field)
* **Signature** (Signature field)

### Limitations
* **Unsupported Fields:** Magic Fields **cannot** automatically detect or place checkboxes, radio buttons, attachments, dropdowns, or formulas. These must be added manually from the toolbar.
* **Sizing:** The initial size of auto-suggested fields is fixed and cannot be customized during the automatic placement process (though properties can be edited post-placement).

---

## 3. How to Enable Magic Fields

To trigger automatic field detection on a document:

1. **Open the Document:** Navigate to your document in SignNow and open it in editing mode.
2. **Access Options:** At the top of the interface, click the **More Options** icon (three-dot menu `...`).
3. **Trigger Detection:** Select **Automatically Suggest and Apply Fields** from the dropdown menu.
4. **Review Detection:** A pop-up window will display a summary of the detected fields (e.g., *"2 text fields, 1 signature field"*).

---

## 4. Assigning Detected Fields to Signing Roles

Once fields are detected, you must assign them to the correct recipients to ensure a smooth signing workflow.

1. In the detection summary pop-up window, locate the **recipient/role dropdown**.
2. Select the signing role (e.g., `Recipient 1`) that should complete these fields.
3. Click **Import Fields** to apply the placement and assignment.
4. *(Optional)* For documents with multiple signers, click on any individual field in the editor afterwards to change its role assignment.

---

## 5. Editing and Adjusting Fields

After importing, you can fine-tune the auto-placed fields to match your document's requirements:

* **Field Properties:** Click any applied field to open the properties panel on the right. From here, you can:
  * Reassign the field to a different role.
  * Make the field mandatory (Required) or optional.
  * Define data validation rules.
* **Additional Fields:** Use the drag-and-drop toolbar on the left to manually place complex fields (such as checkboxes or dropdowns) that Magic Fields did not detect.

---

## 6. Troubleshooting Common Issues

If Magic Fields does not locate or place your fields correctly, check the following:

| Issue | Potential Cause | Solution |
| :--- | :--- | :--- |
| **Missing Fields** | Non-standard labels used. | Ensure your document uses clear, standard text labels like `Name:`, `Date:`, or `Signature:`. |
| **Fields Not Supported** | Trying to detect complex fields. | Checkboxes, radio buttons, and attachments are not supported; drag and drop them manually from the toolbar. |
| **Poor OCR Detection** | Low document resolution or image quality. | Re-upload the document using a high-quality PDF/Word version with clear, selectable text. |
