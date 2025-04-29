# Restaurant Menu API - Technical Challenge

This repository contains the development of the proposed challenge, following good software delivery practices: automated testing, code coverage, clear commit history, and a focus on maintainability and scalability.

Below is the step-by-step process that guided the development:

## Development Process

### [Level 1] Initial Setup and Basic Structure

1. I used `docker run` to generate the project since I don't have Ruby installed natively.
2. Ran `rails new --api --devcontainer --skip-kamal restaurant_menu` to create a Rails API project ready for containerized development.
3. Added RSpec as it was mentioned in the job description as the required testing framework.
4. Generated the scaffold for the `Menu` model:
   ```bash
   rails g scaffold menu availability:integer name:string description:text signed_chef:string day_period:integer --test-framework rspec --api
   ```
5. Generated the scaffold for the `MenuItem` model:
   ```bash
   rails g scaffold menu_item menu:belongs_to description:text lact_free:boolean gluten_free:boolean name:string --test-framework rspec --api
   ```git config --global user.email "you@example.com"
6. Fixed the pending tests for the `Menu` model, adding tests for valid and invalid attributes and creating individual test cases for each presence validation.
7. Started making more granular commits to keep a clearer development history.
8. The `scaffold` command automatically created the routes for the resources by adding `resources` directives to `routes.rb`.
9. Added FactoryBot to generate test data more efficiently.
10. Generated factories:
    ```bash
    rails generate factory_bot:model menu availability:integer name:string description:text signed_chef:string day_period:integer
    rails generate factory_bot:model menu_item menu:belongs_to description:text lact_free:boolean gluten_free:boolean name:string
    ```
11. Added unit tests for the models to cover validation behavior.
12. Finished RSpec configuration.

### [Level 2] Adding Restaurants and Associations

13. Generated the scaffold for the `Restaurant` model:
    ```bash
    rails g scaffold restaurant name:string address:text --test-framework rspec --api
    ```
14. Added new associations between `Menu` and `Restaurant`.
15. Fixed existing tests to accommodate the new `Restaurant` association.
16. Handled pending tests for `Restaurant` and added validation tests.
17. Added restaurant validation checks in the `Menu` model tests.
18. Added uniqueness validation tests for `MenuItem`.
19. Created the join model `MenuMenuItem`:
    ```bash
    rails g model menu_menu_item menu:belongs_to menu_item:belongs_to
    ```
20. Added a migration to adjust the association so that `MenuItem` belongs to `Restaurant` instead of `Menu`.
21. Implemented a data migration to prevent orphaned `MenuItems` when changing associations.
22. Adapted tests to match the new association structure.
23. Added tests to validate that a `Menu` can have multiple `MenuItems` and that `MenuItems` can belong to multiple `Menus`.
24. Added Faker to generate unique names and more efficient test data.
25. Implemented filtering on `Menu` and `MenuItem` based on their associations.  
    _I preferred filtering over nested routes since it's an API and easier to maintain and adapt for multiple use cases._
26. Added use cases to validate the filtering behavior.

### [Level 3] Import Feature and Final Improvements

27. Since the JSON provided is an array of restaurants, I added an import endpoint in the `RestaurantController`.
28. Created an import service as a PORO (Plain Old Ruby Object) to handle the import logic.
29. Added a `price` attribute to the `MenuMenuItem` join model.
30. Added file existence and format checks to the import endpoint.
31. Adjusted model validations to fit imported JSON data.
32. Decided to wrap the entire import process in a single database transaction, ensuring that no partial data would be saved if the JSON structure is invalid.
33. Updated `MenuItem` name validation to be scoped to the `Restaurant` only, allowing different restaurants to sell items with the same name.
34. Added dependent destruction for associations to avoid orphaned records.
35. Added a validation to ensure a `MenuItem` is associated only once with the same `Menu`.
36. Handled exceptions so that even if the import fails, the service iterates through all menu items and generates detailed logs for the user to fix the issues.
37. Moved file handling responsibility to the controller to maintain a clear separation of concerns.
38. Updated service output to match project requirements.
39. Changed the import logs to return hashes, making the output more API-friendly.
40. Added SimpleCov to check code coverage.
41. Added tests to fully cover the import service behavior.
42. Added tests to cover the restaurant import endpoint.
43. Created Rake task to acess the service directly

---

## Using the Import Feature

You can import restaurant data from a JSON file into the system either using the Rake task or through the API endpoint.

### 1. Rake Task

To use the Rake task for importing restaurants:

```bash
bundle exec rake import:restaurants_by_file[file_path]
```

- Replace `file_path` with the path to your JSON file.
- Example:

```bash
bundle exec rake import:restaurants_by_file['spec/fixtures/files/restaurant_data.json']
```

The task will:
- Parse the JSON file.
- Call the `RestaurantImportService`.
- Print error messages if any.
- Print the logs of menu item creation or validation issues.

---

### 2. API Endpoint

You can also upload a JSON file through the API:

**Endpoint:**

```http
POST /restaurants/import
Content-Type: multipart/form-data
```

**Form-Data:**

| Key  | Type   | Description           |
|----- | ------ | ---------------------- |
| file | File   | JSON file containing restaurant data |

**Responses:**
- `200 OK` — Successfully imported restaurants and menu items.
- `400 Bad Request` — Missing file, unsupported file type, invalid JSON structure, or validation errors (detailed logs will be included in the response).
