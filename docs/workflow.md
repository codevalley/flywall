# Workflow for Bioscope Project

## Key Documents

### Primary Documents

1. **progress.md**
    - Purpose: Tracks current development chunk and task status
    - Create the file if it is not present (in docs folder)
    - Content:
        - Current chunk title and description
        - Completed tasks (with checkmarks)
        - In-progress tasks (with status updates)
        - Pending tasks
        - Notes on blockers or issues

2. **completed.md**
    - Purpose: Archives completed tasks and milestones
    - Create the file if it is not present (in docs folder)
    - Content: Comprehensive list of completed tasks, organized by development chunks

### Foundational Documents

1. **approach.md**
    - Purpose: Details features, user journeys, and workflows
    - Content: In-depth descriptions of app functionalities and user flows

2. **designlang.md**
    - Purpose: Defines UI/UX guidelines
    - Content: Color palette, typography, component designs, and layout conventions

3. **plan.md**
    - Purpose: Outlines development plan
    - Content: Development chunks, milestones, and task breakdowns

4. **cleanarch.md**
    - Purpose: Defines the clean architecture principles
    - Content: Description of the architecture, data sources, and providers

## Workflow Process

### Task Selection and Execution

1. Review `progress.md` to identify the current development chunk and available tasks.
2. Select a task based on priority and dependencies.
3. Before starting, review relevant sections in foundational documents:
    - `approach.md` for feature details
    - `designlang.md` for UI/UX guidelines
    - `cleanarch.md` for data layer implementation

4. Execute the task, referring to the codebase and foundational documents as needed.
5. Update `progress.md` with task status and any notes or blockers encountered.

### Code Implementation Guidelines

1. Follow the clean architecture principles outlined in `cleanarch.md`.
2. Adhere to the design language specified in `designlang.md`.
3. Implement features as described in `approach.md`.
4. Use Riverpod for state management as per the current implementation.
5. Implement proper error handling and logging.

### Testing and Quality Assurance

1. Write unit tests for new functionality.
2. Ensure UI components are responsive and follow the design language.
3. Test for edge cases and error scenarios.

### Documentation

1. Add inline comments for complex logic.
2. Update relevant documentation if the implementation differs from the original plan.

### Task Completion

1. Mark the task as completed in `progress.md`.
2. If the task completes a chunk, move the chunk details to `completed.md`.
3. Push code changes and update relevant documentation.

## Handling Blockers and Issues

1. Document any blockers or issues in `progress.md`.
2. If a blocker requires changes to the project plan or approach:
    - Note the suggested changes in the respective document under a "Suggestions" section.
    - Update `progress.md` with a reference to the suggested change.

## AI Agent Guidelines

1. Always start by reviewing `progress.md` and the current state of the project.
2. Consult foundational documents for context before implementing features.
3. Adhere strictly to the established architecture and design patterns.
4. When in doubt, refer to the existing codebase for implementation examples.
5. Communicate clearly about task progress, blockers, and completion in `progress.md`.
6. Suggest improvements or optimizations when appropriate, noting them in the relevant documents.
