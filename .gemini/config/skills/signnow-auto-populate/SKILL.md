---
name: signnow-auto-populate
description: Guidelines and instructions for configuring auto-populate, Magic Fields, and Smart Fields in SignNow.
---

# Auto-Populate Fields in SignNow

Streamline your document workflows and eliminate repetitive data entry by using SignNow’s auto-populate features. This ensures information entered once by a signer is automatically filled across all matching fields.

## When to Use

Use this skill when preparing, designing, or generating contracts and templates that will be uploaded and sent through the **SignNow** e-signature platform. It helps format field labels and metadata correctly to ensure a seamless signing experience.

---

## 1. Understanding Auto-Populate Fields

When multiple fields share the exact same label (e.g., `'Full name'`), SignNow links them. Entering a value in one field instantly propagates it to all other fields with that identical label.

> [!NOTE]
> This feature reduces data inconsistency and enhances the completion speed of legal agreements, tax forms, and onboarding paperwork.

---

## 2. Setting Up Auto-Populate Fields

To link fields for automatic population:
1. Drag and drop fillable fields into your document.
2. In the Form Field Editor, assign **identical labels** to fields that must share the same data.

> [!IMPORTANT]
> Field labels must match exactly. Spacing and capitalization are case-sensitive (e.g., `'Full name'` and `'Full Name'` will not link).

### Example
If a signer's name is required in three different locations, label each of the three fields exactly as `Full name`. When the signer completes the first field, the others will populate automatically when clicked.

---

## 3. Signature & Date Field Autofill Behavior

Signature and date fields utilize a streamlined autofill behavior by default:

* **Signature Fields:** After a signer creates or uploads their signature for the first time, SignNow saves it. Subsequent signature fields in the same or future documents will pre-populate with this signature (editable by the signer at any time).
* **Date Fields:** Clicking a date field pre-fills it with the current date, though signers can select a different date using the calendar pop-up.

---

## 4. Using Auto-Populate on Mobile Devices

Mobile auto-populate must be enabled by the recipient/signer:
1. Access the SignNow mobile app settings.
2. Toggle the **Auto-Populate Fields** option to **ON**.
3. As the signer progresses, entering data in one labeled field automatically updates matching fields.

---

## 5. Automatically Detecting Fields (Magic Fields)

The **Magic Fields** feature uses AI to detect and place standard fields (e.g., Name, Date, Signature) based on document text context.

1. Open your document in editing mode.
2. Click the **menu button** (three dots in the toolbar).
3. Select **Automatically Suggest and Apply Fields**.
4. Review the detected fields in the pop-up and assign them to respective signing roles.

---

## 6. Advanced Auto-Fill using Smart Fields

**Smart Fields** (Pre-filled Text) allow you to pre-populate document data from external sources (e.g., databases, spreadsheets) before sending.

### Methods of Deployment
* **Bulk Invite (CSV Import):** Add Smart Fields to your template. Prepare a CSV file where the column headers match your Smart Field labels. Upload the CSV to populate and send personalized copies to multiple signers at once.
* **Signing Links:** Generate a link with embedded URL query parameters representing the Smart Field labels and values, allowing users to access a pre-filled form.

---

## 7. Best Practices

* **Maintain Label Consistency:** Standardize field labels across your organization's templates to ensure auto-populate works consistently.
* **Leverage Magic Fields for Standard Forms:** Use Magic Fields on simple templates to drastically reduce manual setup times.
* **Pre-Verify with Preview:** Always preview and test the document/template workflow before sending to verify label mappings and auto-population behaviors.
* **Inform Signers:** Add a brief instruction or email note letting signers know that identical fields will auto-populate to save them time.
