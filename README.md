 # Meownvelope #

# Who you're working with #

* Emma Taylor
* Jake Olsen
* Nico San Esteban
* Steven Kertes Jr
* Treston Fallavollita

# What you're creating #

Meownvelope is a savings application that tracks and helps decide what your savings split should be, all while maintaining it for you.
We plan to incorpurate an intuitive savings technique of using envelopes to organize paper money by creating digital cateogories that users can place currency into.

# What is the goal? #

The Goal of our application is to help younger adults branch into starting their personal savings making it easy and seamless, all while adding some fun and creativity into it.

# Who you're doing it for, your audience? #

Our Target Audience / Demographic consists of:

* Young adults  (18-30)
* College Students
* Persons interested in financial growth
* Cat Lovers
* Anyone interested in low maintenance savings

# Why you're doing this, the impact or change you hope to make? #

Starting to save as a young adult can seem daunting to many. With so many complicated apps that expect you to have a certain level of knowledge about starting savings, it can be stressful to start building your future. With Meowvenlope, our main principle is to make starting savings as easy as possible by dumbing down definitions and tasks that may be presumed as difficult to an easy comprehension so that anyone can start building their future.

# Main Logo #

![Alt text](./images/Cat_Cash_Logo.png)

Designed by Nico San Esteban

# Technology #

Tools: 

* BitBucket
* Jira
* VS Code
* Slack
* OpenAI

Languages: 

* Python
* Flutter/Dart

Backend tools:

* Flask
* MySQL
* Docker
* Portainer

# Features #

### Website Development ###

Creating an initial website with basic information.

* As a user that enjoys more additional information,  I want a website so I can have an interactive page to contact support and see information about Meownvelope.

### Picking envelope categories ###

Creating an initial envolope that represents spending categories.

* As a user who has a hard time limiting digital spending, I want to create envelopes that will store digital bills and represent my different spending categories to visualize where my money will go each month.
* As a user with a significant partner, I would like to be able to have collaborative envelopes so my partner and I can budget together.

### Track money ###

Peering into your investment amount and showing money breakdown.

* As a user who prefers visual representations, I would like visual elements like pie charts so that I can better understand the distribution of my savings.
* As a user who needs budgeting to be approachable, I want to link my bank account to the app so that I can streamline my planning and keep it up to date with my income and expenses.

## Moving/Spending ##

Having the ability to move and spend the saved up amount.

* As a user who deals with inconsistent expenses each month I want to be able to move money between envelopes to take into account for unexpected expenses.
* As a user who struggles to keep up with repeated payments, I want the ability to add recurring payments for subscriptions and repeat purchases.

### Monthly summary ###

Summary of each month displaying a graph of monthly spending.

* As a user who get's overwhelmed by too many statistics, I want a friendly monthly overview so I can get a brief summary of my spending habits.
* As a user who lacks the motivation to save money, I would like cat themed encouragement in the form of daily saving streaks and badges, so that I can feel more inspired to save.

### AI Assistant ###

Having a personal AI assistent to help establish goals, answer questions, and make the application easy to navigate.

* As a user that struggles to navigate finance, I want a chat bot AI Assistant so I can receive guidance navigating the Meownvelope application and have my basic financial questions answered.
* As a user that has difficulty making financial plans, I want a built in AI Assistant that can analyze my past user data so that I can receive personalized recommendations to help plan for the future.

# Sprint 1 Review #
**Treston**: Created the backend server environment to host the teams webpage. Designed and implemented the apps local storage database.
- `Jira Task | SCRUM-82 | "Implement - Server Setup, SSH, Docker, Portainer, Flask"`
  - Jira Task: [SCRUM-28](https://cs3398-ewoks-s26.atlassian.net/browse/SCRUM-82?atlOrigin=eyJpIjoiNGZmODdiYzA1NmQxNGQ4MGExNmFiZDZiZjkwN2E2OTEiLCJwIjoiaiJ9)
  - BitBucket Branch: [SCRUM-82-server-setup](https://bitbucket.org/cs3398-ewoks-s26/meownvelope/branch/SCRUM-82-server-setup)
- `Jira Task | SCRUM-96 | "Design - Hive Data Model"`
  - Jira Task: [SCRUM-96](https://cs3398-ewoks-s26.atlassian.net/browse/SCRUM-96?atlOrigin=eyJpIjoiNjljZDc1Nzk3MWI0NDBlNWI1MjQyNzBiY2ExNTU4M2EiLCJwIjoiaiJ9)
  - BitBucket Branch: [SCRUM-96-design-hive-data-model](https://bitbucket.org/cs3398-ewoks-s26/meownvelope/branch/SCRUM-96-design-hive-data-model)
  - `Jira Subtask | SCRUM-102 | "Define Hive Schema and Business Rules"`
    - Jira Subtask: [SCRUM-102](https://cs3398-ewoks-s26.atlassian.net/browse/SCRUM-102?atlOrigin=eyJpIjoiMjkxMGE1MTk2MmViNDhlNjk2ZWVmZGI3NTQ4ODc1NDIiLCJwIjoiaiJ9)
    - BitBucket Branch: [SCRUM-102-define-hive-schema](https://bitbucket.org/cs3398-ewoks-s26/meownvelope/branch/SCRUM-102-define-hive-schema)
- `Jira Task | SCRUM-104 | "Implementation: Hive Setup and Repository"`
  - Jira Task: [SCRUM-104](https://cs3398-ewoks-s26.atlassian.net/browse/SCRUM-104?atlOrigin=eyJpIjoiZTM2Njk3ZTIxZmU1NGIxNGFmNjg4M2VhOTc5NDE5MDUiLCJwIjoiaiJ9)
  - BitBucket Branch: [feature/SCRUM-104-hive-flutter-initialization](https://bitbucket.org/cs3398-ewoks-s26/meownvelope/branch/feature/SCRUM-104-hive-flutter-initialization)
  - `Jira Subtask | SCRUM-103 | "Initialize Flutter Repo"`
    - Jira Subtask: [SCRUM-103](https://cs3398-ewoks-s26.atlassian.net/browse/SCRUM-103?atlOrigin=eyJpIjoiMjE1NWY4NTU0MDQxNDIyYTkzYzJhMmQ1YWJlOGJkMDYiLCJwIjoiaiJ9)
    - BitBucket Branch: [feature/SCRUM-103-initialize-flutter-repo](https://bitbucket.org/cs3398-ewoks-s26/meownvelope/branch/feature/SCRUM-103-initialize-flutter-repo)
  - `Jira Subtask | SCRUM-105 | "3A: Hive Setup and Core Repository Methods"`
    - Jira Subtask: [SCRUM-105](https://cs3398-ewoks-s26.atlassian.net/browse/SCRUM-105?atlOrigin=eyJpIjoiYjZmNmZmMTJhODQ2NGE3NmE0MDcwZDNhZTU3YTczOWEiLCJwIjoiaiJ9)
    - BitBucket Branch: [feature/SCRUM-105-3a-hive-setup](https://bitbucket.org/cs3398-ewoks-s26/meownvelope/branch/feature/SCRUM-105-3a-hive-setup)
- `Jira Task | SCRUM-170 | "Fix: Remake Hive Data Structure to Classes instead of Maps"`
  - Jira Task: [SCRUM-170](https://cs3398-ewoks-s26.atlassian.net/browse/SCRUM-170?atlOrigin=eyJpIjoiYTliZjJjYzIyZWYxNGE2NmFiYjQ2ZDRmNGNlMDY4OTciLCJwIjoiaiJ9)
  - BitBucket Branch: [hotfix/SCRUM-170-remake-hive-data-structure](https://bitbucket.org/cs3398-ewoks-s26/meownvelope/branch/hotfix/SCRUM-170-remake-hive-data-structure)
- `Jira Task | SCRUM-169 | "Implementation: HiveDatabase Automatic Index Finder"`
  - Jira Task: [SCRUM-169](https://cs3398-ewoks-s26.atlassian.net/browse/SCRUM-169?atlOrigin=eyJpIjoiMTcxNmI2OTg3ODM1NGNkYzhlOTE3MGFiM2VjZThjY2EiLCJwIjoiaiJ9)
  - BitBucket Branch: [feature/SCRUM-169-display-order-finder](https://bitbucket.org/cs3398-ewoks-s26/meownvelope/branch/feature/SCRUM-169-display-order-finder)
- `Jira Task | SCRUM-161 | "Fix Documentation"`
  - Jira Task: [SCRUM-161](https://cs3398-ewoks-s26.atlassian.net/browse/SCRUM-161?atlOrigin=eyJpIjoiZmU4NTk0NjMyODM2NGY4YjkzNjY1YTgyYmUxOGEzN2UiLCJwIjoiaiJ9)
  - BitBucket Branch: [SCRUM-161-fix-documentation](https://bitbucket.org/cs3398-ewoks-s26/meownvelope/branch/SCRUM-161-fix-documentation)


  **Emma**: Collaborated with Nico on the UI design for the web app, tested functionality of the website, performed unit tests on hive database and envelope creation.

- `Jira Task | SCRUM-122 | "Basic UI design for the mobile app"`
  - Jira Task: [SCRUM-122](https://cs3398-ewoks-s26.atlassian.net/jira/software/projects/SCRUM/boards/1?selectedIssue=SCRUM-122)
  - BitBucket Branch: [design/SCRUM-122-app-design](https://bitbucket.org/cs3398-ewoks-s26/meownvelope/branch/design/SCRUM-122-app-design)
  - Pull Request: [PR #12](https://bitbucket.org/cs3398-ewoks-s26/meownvelope/pull-requests/12)

- `Jira Task | SCRUM-92 | "Unit Testing: Envelope Validation and HiveDatabase"`
  - Jira Task: [SCRUM-92](https://cs3398-ewoks-s26.atlassian.net/jira/software/projects/SCRUM/boards/1?selectedIssue=SCRUM-92)
  - BitBucket Branch: [SCRUM-92-unit-tests](https://bitbucket.org/cs3398-ewoks-s26/meownvelope/branch/SCRUM-92-unit-tests)
  - Pull Request: [PR #31](https://bitbucket.org/cs3398-ewoks-s26/meownvelope/pull-requests/31)

- `Jira Task | SCRUM-89 | "Unit Testing: Flask Route and Contact Endpoint Tests"`
  - Jira Task: [SCRUM-89](https://cs3398-ewoks-s26.atlassian.net/jira/software/projects/SCRUM/boards/1?selectedIssue=SCRUM-89)
  - BitBucket Branch: [SCRUM-89-unit-tests](https://bitbucket.org/cs3398-ewoks-s26/meownvelope/branch/SCRUM-89-unit-tests)
  - Pull Request: [PR #32](https://bitbucket.org/cs3398-ewoks-s26/meownvelope/pull-requests/32)

**Steven Kertes**: Designed the website page in Figma. Implemented the HTML and CSS of the website page. Implemented the Envelope Creation Page.
- `Jira Task | SCRUM-76 | "Design: Website UI/UX Mockup"`
  - Jira Task: [SCRUM-76](https://cs3398-ewoks-s26.atlassian.net/browse/SCRUM-76?atlOrigin=eyJpIjoiZTY5OGNjYWEyMWNhNDVmNjg2NWNkNmI4Njg3MTdhYzMiLCJwIjoiaiJ9)
  - BitBucket Branch: [feature/SCRUM-76-design-website-ui-ux-mockup](https://bitbucket.org/cs3398-ewoks-s26/meownvelope/branch/feature/SCRUM-76-design-website-ui-ux-mockup)
  - `Jira Subtask | SCRUM-77 | "1A: Sketch Low-Fidelity Wireframes | Included in SCRUM-76"`
    - Jira Subtask: [SCRUM-77](https://cs3398-ewoks-s26.atlassian.net/browse/SCRUM-77?atlOrigin=eyJpIjoiZGUzNzA1ZGY1ODE2NDkzYWFlOWM3YzBkODc4NWMwOWEiLCJwIjoiaiJ9)
    - BitBucket Branch: [feature/SCRUM-76-design-website-ui-ux-mockup](https://bitbucket.org/cs3398-ewoks-s26/meownvelope/branch/feature/SCRUM-76-design-website-ui-ux-mockup)
  - `Jira Subtask | SCRUM-78 | "1B: Build High-Fidelity Mockup" | Included in SCRUM-76`
    - Jira Subtask: [SCRUM-78](https://cs3398-ewoks-s26.atlassian.net/browse/SCRUM-78?atlOrigin=eyJpIjoiMGM0NTlmZDE2NGUyNGM2NTlmMDk1OGRlNWYzNmI3M2YiLCJwIjoiaiJ9)
    - BitBucket Branch: [feature/SCRUM-76-design-website-ui-ux-mockup](https://bitbucket.org/cs3398-ewoks-s26/meownvelope/branch/feature/SCRUM-76-design-website-ui-ux-mockup)
- `Jira Task | SCRUM-86 | "Implementation: HTML/CSS Templates"`
  - Jira Task: [SCRUM-86](https://cs3398-ewoks-s26.atlassian.net/browse/SCRUM-86?atlOrigin=eyJpIjoiMmY2NWMyNGFkMWE3NDY3ZjlmZDdlMTkyODExZGQxYjIiLCJwIjoiaiJ9)
  - BitBucket Branch: [feature/SCRUM-86-implementation-html-css-templat](https://bitbucket.org/cs3398-ewoks-s26/meownvelope/branch/feature/SCRUM-86-implementation-html-css-templat)
  - `Jira Subtask | SCRUM-87 | "5A: Build the 4-Page Jinja2 Templates | Included in SCRUM-86"`
    - Jira Subtask: [SCRUM-87](https://cs3398-ewoks-s26.atlassian.net/browse/SCRUM-87?atlOrigin=eyJpIjoiNWU0YWRhZWZjZjBlNDc3MGJhMmM4ZWFjMDg5MmNkOGYiLCJwIjoiaiJ9)
    - BitBucket Branch: [feature/SCRUM-86-implementation-html-css-templat](https://bitbucket.org/cs3398-ewoks-s26/meownvelope/branch/feature/SCRUM-86-implementation-html-css-templat)
  - `Jira Subtask | SCRUM-88 | "5B: Build the Contact Form and Wire to Flask" | Included in SCRUM-86`
    - Jira Subtask: [SCRUM-88](https://cs3398-ewoks-s26.atlassian.net/browse/SCRUM-88?atlOrigin=eyJpIjoiYjJlZWI3MWU5ZDAyNDllZDlhZTdkMjk2NGFjNzNkMWUiLCJwIjoiaiJ9)
    - BitBucket Branch: [feature/SCRUM-86-implementation-html-css-templat](https://bitbucket.org/cs3398-ewoks-s26/meownvelope/branch/feature/SCRUM-86-implementation-html-css-templat)
- `Jira Task | SCRUM-172 | "Fix typos in webapp html & CSS"`
  - Jira Task: [SCRUM-172](https://cs3398-ewoks-s26.atlassian.net/browse/SCRUM-172?atlOrigin=eyJpIjoiMjY2YWUwNzFlYzk2NGM2N2I4OTgyMjI5NDMyMGZiZGYiLCJwIjoiaiJ9)
  - BitBucket Branch: [SCRUM-172-fix-typos-in-webapp-html](https://bitbucket.org/cs3398-ewoks-s26/meownvelope/branch/SCRUM-172-fix-typos-in-webapp-html)
- `Jira Task | SCRUM-171 | "Fix Envelope_creation_page location & comments"`
  - Jira Task: [SCRUM-171](https://cs3398-ewoks-s26.atlassian.net/browse/SCRUM-171?atlOrigin=eyJpIjoiN2I1YWEyZmUzMDRiNDRiODkwNzA0NDE0MTRlMDk3ZDMiLCJwIjoiaiJ9)
  - BitBucket Branch: [bugfix/SCRUM-171-fix-envelope_creation_page-loc](https://bitbucket.org/cs3398-ewoks-s26/meownvelope/branch/bugfix/SCRUM-171-fix-envelope_creation_page-loc)
- `Jira Task | SCRUM-168 | "Implementation: Envelope creating page"`
  - Jira Task: [SCRUM-168](https://cs3398-ewoks-s26.atlassian.net/browse/SCRUM-168?atlOrigin=eyJpIjoiYjVhYWU3ZTc3MjdkNDgwNmFmN2RkM2UzNTJiMzgyZjMiLCJwIjoiaiJ9)
  - BitBucket Branch: [feature/SCRUM-168-implementation-envelope-creati](https://bitbucket.org/cs3398-ewoks-s26/meownvelope/branch/feature/SCRUM-168-implementation-envelope-creati)

# Sprint 2 Next Steps #

**Features**
  - Design and implement the transferring money page
  - Design and implement the transfer functionality
  - Design and implement the log history page
  - Design and implement the navigation bar
  - Design the streaks and badges definitions
  - Design and implement the streaks and badges page
  - Design and implement the unlock pop up
  - Design and implement the Hive setup bage and streak storage
  - Design and implement the import funds page
  - Design and implement the fill envelopes page
  - Design and implement the on tap envelopes pop up
**Bugs**
  - Home page: App adjusting to keyboard and the container sizes overlapping

