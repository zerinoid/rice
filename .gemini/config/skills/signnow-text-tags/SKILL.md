---
name: signnow-text-tags
description: Guidelines and instructions for implementing simple and complex text tags in documents for automatic field extraction and invite creation in SignNow.
---

# SignNow Text Tags Integration Guide

This skill provides comprehensive guidelines and references for embedding text tags in documents (such as `.doc`, `.docx`, and `.pdf`) before uploading them to SignNow. By using text tags, you can pre-define field types, roles, validators, and size settings directly in the document body. Upon upload, SignNow extracts these tags and automatically replaces them with interactive fields.

## When to Use

Use this skill when you are generating, formatting, or programmatically compiling contracts, agreements, or forms that will be processed via the **SignNow** e-signature platform. It is particularly useful for automated workflows where you want to dynamically position fields (signatures, text inputs, dropdowns, checkboxes, etc.) and pre-assign signing roles, validators, and default values without manually editing the document in the SignNow web UI.

---

## 1. Overview of Text Tags

Text tags can be implemented in two ways:

* **Simple Text Tags:** All field details (type, requirement status, role, label, and sizing) are written entirely within the tag text in the document.
* **Complex Text Tags:** The document contains placeholder tag names (e.g., `{{tag_name}}`), and the field properties are passed programmatically in the JSON request body during upload.

### Supported File Formats
Text tags are extracted only from the following formats:
* `.doc`
* `.docx`
* `.pdf`

### API Endpoint for Extraction
To upload a document and extract either simple or complex text tags, send a multipart/form-data request to the **Upload document with tags** endpoint:

```bash
curl --request POST \
  --url https://api.signnow.com/document/fieldextract \
  --header 'Authorization: Bearer {{access_token}}' \
  --header 'file=@/path/to/FILE_NAME.pdf'
```

---

## 2. Simple Text Tags

Simple text tags use a positional syntax formatted inside double curly braces: `{{...}}`. 
Because properties are positional, they must follow a strict order.

### Positional Syntax Order
The order of properties in a simple text tag is as follows:
```text
{Type of the field}
{Required}
{Role}
{Label}
{Prefilled text}
{Text horizontal alignment}
{Text vertical alignment}
{Lock signing date}
{Height multiplier}
{Dropdown}
{Width}
{Height}
{Validator ID value}
{Radio name}
{Radio value}
{Checked}
{Link}
{Hyperlink hint}
```

* **Core Requirements:** Every tag must define at least **Field Type (`t`)**, **Required (`r`)**, and **Role (`o`)**.
* **Formatting Rules:**
  * Separate keys and values with a colon (e.g., `t:s`).
  * Separate each property block with a semicolon (e.g., `t:s;r:y;o:"Signer";`).
  * Always use **double quotes (`"`)** around string values inside the tag.
  * Semicolons and colons can have page breaks/whitespace before or after them.

---

## 3. Simple Text Tag Parameter Reference

The table below lists all supported keys, possible values, and usage constraints:

| PROPERTY | KEY | VALUES | WHEN TO USE |
| :--- | :--- | :--- | :--- |
| Field type | `t` | `s` - signature<br> `i` - initials<br>`t` - text<br>`d` - dropdown<br>`c` - checkbox<br>`f` - attachment<br>`r` - radio button<br>`h` - hyperlink<br>`cc` - text field for cc email<br>`e` - instant invite. See Invite text tags<br><br>Example: `t:s;` | Always |
| Required | `r` | `y` - required<br>`n` - optional<br><br>Example: `r:y;` | Always |
| Role | `o` | String with a role name. Allowed symbols: letters, digits, and `',.` .<br><br>Example: `o:"CEO";` | Always |
| Label | `l` | String with a field label. Allowed symbols: letters, digits, and `',./\$` .<br><br>Example: `l:"Signature";` | Only with text, dropdown, and file fields |
| Prefilled text | `p` | String with a prefilled text. Allowed symbols: letters, digits, and `',./\` .<br><br>Example: `l:"John Doe"; Signature";` | Only with text fields |
| Text horizontal alignment | `al` | `l` - left<br>`c` - center<br>`r` - right<br><br>Example: `al:c;` | Only with text fields |
| Text vertical alignment | `vl` | `t` - top<br>`m` - middle<br>`b` - bottom<br><br>Example: `vl:b;` | Only with text fields |
| Lock signing date | `lsd` | Whether to set the current date of signing by default.<br>`y` - set the default date<br>`n` - no restrictions on the date<br><br>Example: `lsd:y;` | Only with text fields |
| Height multiplier | `i` | If height = 20 and i = 3, the SignNow field is 60 points high.<br><br>Example: `i:3;` | Only with text fields |
| Dropdown | `dd` | Dropdown options separated by commas. Allowed symbols: letters, digits, and `',.` .<br><br>Example: `dd:"option1, option2, Option3";` | Only with dropdown fields |
| Width | `w` | Field width in pixels.<br><br>Example: `w:12;` | Any field type. If not indicated, the field is of the tag width. |
| Height | `h` | Field height in pixels.<br><br>Example: `h:12;` | Any field type. If not indicated, the field is of the tag height. |
| Validator ID | `v` | Use to validate filled data against certain formats. For possible values, see Data validators.<br><br>Example: `v:"13435fa6c2a17f83177fcbb5c4a9376ce85befeb";` | Only with text fields |
| Name of the radio button group | `rn` | String with a name for a group of radio buttons. Allowed symbols: letters, digits, and `',.-` .<br><br>Example: `rn:"Select your department";` | Only with radio buttons |
| Radio button value | `rv` | String with the value of a radio button. To create a group of radio buttons, create a tag for each radio button with the same group name and different values. For more information, see Radio buttons.<br><br>Allowed symbols: letters, digits, and `',.-$` . | Only with radio buttons |
| Checked | `checked` | `1` - checked<br>Any other number - unchecked<br><br>Example: `checked: 1;` | With radio buttons and checkboxes |
| Link | `lk` | Hyperlink.<br><br>Example: `lk:"https://signnow.com";`<br><br>To use a hyperlink text tag, a corresponding organization setting must be enabled. To update the settings, contact SignNow support. | Only with hyperlinks |
| Hyperlink hint | `ht` | String with a hyperlink hint that appears in the field. Allowed symbols: letters, digits, and `,.$` .<br><br>Example: `lk:"https://yourlink.com";` | Only with hyperlinks |
| CC email | `cc` | Add a CC recipient of the document.<br><br>Example: `{{t:cc;e:"j.doe@email.com";}}` | Only with cc fields |

---

## 4. Simple Text Tag Examples

### Signature Field Example
A required signature field for the "CEO" role, 100 pixels wide and 15 pixels high:
```text
{{t:s;r:y;o:"CEO";w:100;h:15;}}
```

### Dropdown Field Example
A required dropdown field for the "Client" role, prefilled with three color options:
```text
{{t:d;r:y;o:"Client";l:"Color Choice";dd:"Red,Blue,Green";w:120;h:20;}}
```

### CC Email Recipient Example
To add a CC email address directly within the document text tags:
```text
{{t:cc;e:"support@company.com";}}
```

---

## 5. Setting Up Radio Buttons

To set up a group of radio buttons where only one option can be selected at a time:
1. Assign the **same group name** (`rn`) to all tags in the group.
2. Provide a **unique value** (`rv`) to each individual button tag.
3. Keep the target role (`o`) consistent across the group.

### Radio Group Example
Create a group named "Select a color" with options "Green" and "Blue" assigned to the "Customer" role:
```text
{{t:r;r:y;o:"Customer";rn:"Select a color";rv:"Green";}}
{{t:r;r:y;o:"Customer";rn:"Select a color";rv:"Blue";}}
```

---

## 6. Invite Text Tags

Invite text tags allow you to send out signing requests immediately upon document upload, bypassing the need to call `POST /document/invite` separately.

To use instant invite tags:
1. Embed the normal field tags (e.g., signatures, text fields) for your roles.
2. Embed invite tags to bind email addresses and signing order to those roles.

### Structure of an Invite Tag
```text
{{t:e;o:"RoleName";e:"email@domain.com";order:1;}}
```
* `t:e` - specifies the field is an instant invite trigger.
* `o` - designates the target role name to bind.
* `e` - defines the recipient's email address.
* `order` - (Optional) Integer indicating the signing workflow step.

### Two-Signer Instant Invite Example
Add the fields for the roles:
```text
{{t:s;r:y;o:"Manager";}} 
{{t:s;r:y;o:"Client";}}
```
And add the corresponding invite configurations:
```text
{{t:e;o:"Manager";e:"manager@mail.com";order:1;}}
{{t:e;o:"Client";e:"client@mail.com";order:2;}}
```

---

## 7. Complex Text Tags

Complex text tags divide the configuration into two components:
1. **Placeholder Names:** Written in the document body wrapped in double curly braces (e.g., `{{contract_sig_1}}`).
2. **Tag Parameters:** Sent programmatically as a JSON array in the body of the `POST /document/fieldextract` request.

### API Request Parameter Fields

When sending the parameters array in your request body, configure the following properties for each tag name:

* **`tag_name`** (Required): The exact placeholder string used in the document (e.g., `"contract_sig_1"`).
* **`type`** (Required): The type of field. Must be one of:
  * `"signature"`, `"initials"`, `"text"`, `"checkbox"`, `"attachment"`, `"hyperlink"`, `"radio button"`, `"enumeration"` (for dropdowns).
* **`role`** (Required): The recipient role assigned to complete the field.
* **`required`** (Required): Boolean (`true` or `false`) to enforce completion.
* **`label`** (Optional): A tooltip/field descriptor. In SignNow, fields sharing the same label will auto-fill identically if one is filled.
* **`prefilled_text`** (Optional): Text loaded by default when the signer opens the document.
* **`validator_id`** (Optional): String matching a standard SignNow validator format ID.
* **`width`** (Optional): Field width in pixels.
* **`height`** (Optional): Field height in pixels.
* **`lsd`** (Optional): Lock Signing Date. Set to `"y"` to default to the signing date.
* **`enumeration_options`** (Optional): Array of string options for a dropdown field.
* **`custom_defined_option`** (Optional): Boolean (`true` or `false`) allowing signers to type a custom option inside a dropdown.
* **`radio`** (Optional): Array containing radio button objects:
  * **`value`**: The option value.
  * **`checked`**: Set to `1` to select by default, or `0` to leave unchecked.
  * **`x-offset`**: Numeric horizontal offset.
  * **`y-offset`**: Numeric vertical offset.
  * **`name`**: Group name for the radio button.
* **`name`** (Optional): Group name for radio buttons or text identifier for hyperlinks.
* **`hint`** (Optional): Hover/helper text for hyperlinks.

---

## 8. Complex Tag Examples

Below are JSON payload definitions for various complex tag configurations, which can be sent in the request array:

### Basic Text Tag
```json
{
  "tag_name": "EmployeeName",
  "role": "Employee",
  "label": "Your name",
  "required": true,
  "type": "text",
  "width": 100,
  "height": 20
}
```

### Text Tag with Date Validation
Uses a validator ID format hash to enforce a date pattern.
```json
{
  "tag_name": "BirthDate",
  "role": "Role1",
  "label": "Your date of birth",
  "required": true,
  "type": "text",
  "height": 15,
  "width": 100,
  "validator_id": "13435fa6c2a17f83177fcbb5c4a9376ce85befeb"
}
```

### Initials Tag
```json
{
  "tag_name": "ClientInitials",
  "role": "Client",
  "required": true,
  "type": "initials",
  "height": 15,
  "width": 40
}
```

### Signature Tag
```json
{
  "tag_name": "Signature",
  "role": "Client",
  "required": true,
  "type": "signature",
  "height": 15,
  "width": 200
}
```

### Dropdown Tag (Enumeration)
```json
{
  "tag_name": "Citizenship",
  "role": "Client",
  "label": "Your citizenship",
  "required": true,
  "type": "enumeration",
  "height": 15,
  "width": 100,
  "custom_defined_option": false,
  "enumeration_options": [
    "US",
    "Non-US"
  ]
}
```

### Attachment Tag
```json
{
  "tag_name": "Photo",
  "role": "Client",
  "label": "Your photo",
  "required": true,
  "type": "attachment",
  "width": 100,
  "height": 20
}
```

### Checkbox Tag
```json
{
  "tag_name": "ConsentCheckbox",
  "role": "Client",
  "required": true,
  "type": "checkbox",
  "height": 12,
  "width": 12,
  "checked": 1
}
```

### Radio Button Tag
Grouping multiple coordinates under a single radio button tag using the nested `radio` array:
```json
{
  "tag_name": "Citizenship",
  "role": "Employee",
  "required": true,
  "x": 36,
  "y": 246,
  "width": 340,
  "height": 13,
  "radio": [
    {
      "x": 36,
      "y": 246,
      "width": 13,
      "height": 13,
      "checked": 0,
      "value": "Yes",
      "x-offset": 0,
      "y-offset": 0
    },
    {
      "x": 36,
      "y": 246,
      "width": 13,
      "height": 13,
      "checked": 1,
      "value": "No",
      "x-offset": 0,
      "y-offset": 14
    }
  ],
  "name": "Citizenship",
  "type": "radiobutton"
}
```

### Hyperlink Tag
> [!NOTE]
> A corresponding organization setting must be enabled to use a hyperlink text tag. To update this setting, contact SignNow support.

```json
{
  "tag_name": "URL",
  "role": "Client",
  "type": "hyperlink",
  "name": "hyperlink_unique_id",
  "required": true,
  "width": 118,
  "height": 33,
  "link": "https://google.com",
  "label": "Website link",
  "hint": "https://yourwebsite.com"
}
```

---

## 9. Workflow: Send an Invite to Sign with Complex Text Tags

Follow these steps to upload a document and instantly configure fields using complex tags.

### Step 1: Create a Document containing Tag Placeholders
Create your source document (PDF or Word) and place the tag names inside double curly braces where the fields should appear:
```text
Name: {{employee name}}
Date: {{date}}
Signature: {{signature}}
```

### Step 2: Define the Tag Property Array
Prepare the JSON parameters array mapping to the tag names embedded in the document:
```json
[
  {
    "tag_name": "employee name",
    "role": "employee",
    "label": "name",
    "required": true,
    "type": "text",
    "width": 100,
    "height": 15
  },
  {
    "tag_name": "date",
    "role": "employee",
    "label": "date",
    "required": true,
    "type": "text",
    "width": 100,
    "height": 15,
    "validator_id": "059b068ef8ee5cc27e09ba79af58f9e805b7c2b3"
  },
  {
    "tag_name": "signature",
    "role": "employee",
    "label": "signature",
    "required": true,
    "type": "signature",
    "width": 100,
    "height": 30
  }
]
```

### Step 3: Upload the Document and Extract Tags
Send a `POST` request to `/document/fieldextract` with the file and the JSON array passed as a string inside the `Tags` form field:

```bash
curl --request POST \
  --url https://api.signnow.com/document/fieldextract \
  --header 'Accept: application/json' \
  --header 'Authorization: Bearer {{access_token}}' \
  --header 'Content-Type: multipart/form-data' \
  --form file=@/path/to/your/file.pdf \
  --form 'Tags="[
    {
      \"tag_name\": \"employee name\",
      \"role\": \"employee\",
      \"label\": \"name\",
      \"required\": true,
      \"type\": \"text\",
      \"width\": 100,
      \"height\": 15
    },
    {
      \"tag_name\": \"date\",
      \"role\": \"employee\",
      \"label\": \"date\",
      \"required\": true,
      \"type\": \"text\",
      \"width\": 100,
      \"height\": 15,
      \"validator_id\": \"059b068ef8ee5cc27e09ba79af58f9e805b7c2b3\"
    },
    {
      \"tag_name\": \"signature\",
      \"role\": \"employee\",
      \"label\": \"signature\",
      \"required\": true,
      \"type\": \"signature\",
      \"width\": 100,
      \"height\": 30
    }
  ]"'
```
