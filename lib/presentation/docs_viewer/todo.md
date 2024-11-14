#

## Navigation

1. Navigation uses a loader to load the subdirectories of the given relative.
2. Displays the subdirectories and children in an accordion.

   > Retains the name of each subdirectory, the relative path and its subdirectory.

3. The accordion uses the relative path of the selected subdirectory for navigation.

## Todo

- [x] Create a class to load the subdirectories of the given path.
- [x] Create an accordion widget.
- [x] Implement the navigation logic.
- [x] Markdown `< ![ERROR] icons`
- [x] Fix Block quote Rich text errors
- [x] The scrolling is not smooth
- [x] TOC customisations
- [x] Links Logic (Navigation) and customisation.
- [x] LatEx customisation (Fix table errors)
- [x] Directory Reader and builder - Retrieve the folder structure by path.
- [x] Fix Reader sorting

## Special Components

- [ ] Breadcrumbs
- [x] Accordion
- [x] TOC

> These special components.

## Flow Chart

```mermaid
flowchart LR
Navigation -->
Viewer --> Body
```
