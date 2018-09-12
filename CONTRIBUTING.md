# How to contribute

## Git workflow

The adopted workflow is a slightly modified version of the
[GitHub Flow](https://guides.github.com/introduction/flow/):

Development starts from the `dev` branch. The `master` and `test` branches are
locked: you can't push to them and should generally not care about them. They're
only used for deployment purposes.

#### Developer workflow

- checkout and pull the `dev` branch
- make a feature branch for the feature you wish to develop (if possible, the
  name of the feature branch should match the key or the jira issue/story
  associated with it)
- commit your work on the feature branch and push it to the remote
- make a pull request on `dev`
- if needed, re-align your feature branch with `dev`
- ask a reviewer to review and merge the pull request

**Note**: reviewing PR takes a lot of time and drains brain energy. Before
asking for a PR to be reviewed make sure there are no obvious faults.

#### Reviewer workflow

- the feature works as expected (according the user story, or to other
  requirements)
- the code is decent
- there are unit tests for the feature
- there are e2e tests for the feature
- all test pass
- linting passes

## Commit Message Format

Each commit message consists of a **header** and an optional **body**,
separated by an empty line.

#### Header

Format: `[type][jira-key]: subject`.

**type** must have one of the following values:

* **feat**: a new feature
* **fix**: a bug fix
* **docs**: documentation only changes
* **style**: changes that do not affect the meaning of the code (white-space,
  formatting, missing semi-colons, etc)
* **refactor**: a code change that neither fixes a bug nor adds a feature
* **perf**: a code change that improves performance
* **test**: adding missing tests
* **chore**: changes to the build process or auxiliary tools and libraries such
  as documentation generation

**jira-key** is optional.

**subject** is a succinct description of the change and:

* uses the imperative, present tense: "change" not "changed" nor "changes"
* doesn't capitalize the first letter
* has no dot (.) at the end

#### Body

Just as in the **subject**, use the imperative, present tense: "change" not
"changed" nor "changes". The body should include the motivation for the change
and contrast this with previous behavior.

#### Example

```
[chore][DOC-1]: dev environment setup

Add linter, add base dependencies.
```
