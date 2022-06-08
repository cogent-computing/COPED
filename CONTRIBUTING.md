# Contributing to CoPED

We would love your input! We want to make contributing to this project as easy and transparent as possible, whether it's:

- Reporting a bug
- Discussing the current state of the code
- Submitting a fix
- Proposing new features
- Becoming a maintainer

## What do I need to know to help?

If you are looking to help to with a code contribution our project uses *Python* and the *Django* framework, while data in CoPED is gathered using the *Scrapy* library. See the resource links below to find out more.

If you don't feel ready to make a code contribution yet, no problem! You can also help by raising or fixing [documentation issues](https://github.com/cogent-computing/COPED/labels/documentation) or [design issues](https://github.com/cogent-computing/COPED/labels/design) that we have.

## Starting points

If you are interested in making a code contribution and would like to learn more about the technologies that we use, check out the list below.

- [Python tutorial](https://docs.python.org/3/tutorial/)
- [Django framework tutorial](https://developer.mozilla.org/en-US/docs/Learn/Server-side/Django)
- [Scrapy documentation](https://docs.scrapy.org/en/latest/)

## Any contributions you make will be under the GPLv3 Software License

In short, when you submit code changes, your submissions are understood to be under the same [GPLv3 license that covers the project](./LICENSE.md). Feel free to contact the maintainers if that's a concern.

## Report bugs using Github's issues

We use GitHub issues to track public bugs. Report a bug by [opening a new issue](https://github.com/cogent-computing/COPED/issues); it's that easy!

## Write bug reports with detail, background, and sample code

Some great advice on writing bug reports can be found in [this blog post](https://marker.io/blog/write-bug-report).

**Great Bug Reports** tend to have:

- A quick summary and/or background
- Steps to reproduce
  - Be specific!
  - Give sample code if you can.
- What you expected would happen
- What actually happens
- Notes (possibly including why you think this might be happening, or stuff you tried that didn't work)

Developers *love* thorough bug reports.

## Use a Consistent Coding Style

The CoPED codebase uses the [black](https://black.readthedocs.io/en/stable/) Python formatting conventions. Please install and use black for formatting your own contributions.

## How do I make a code contribution?

Never made an open source contribution before? Wondering how contributions work in our project? Here's a quick rundown.

1. [Find or create an issue](https://github.com/cogent-computing/COPED/issues) that you are interested in addressing, or a feature that you would like to add.
2. [Fork the repository](https://docs.github.com/en/get-started/quickstart/fork-a-repo) associated with the issue to your local GitHub account. This means that you will have a copy of the repository under `your-GitHub-username/repository-name`.
3. [Clone the repository](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository) to your local machine using `git clone https://github.com/cogent-computing/COPED.git`.
4. [Create a new branch](https://git-scm.com/book/en/v2/Git-Branching-Branches-in-a-Nutshell) for your fix using `git checkout -b branch-name-here`.
5. Make the appropriate changes for the issue you are trying to address or the feature that you want to add.
6. Use `git add insert-paths-of-changed-files-here` to add the file contents of the changed files to the "snapshot" git uses to manage the state of the project, also known as the index.
7. Use `git commit -m "Insert a short message of the changes made here"` to store the contents of the index with a descriptive message.
8. Push the changes to the remote repository using `git push origin branch-name-here`.
9. [Submit a pull request](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request) to the upstream repository.
    - Title the pull request with a short description of the changes made and the issue or bug number associated with your change. For example, you can title an issue like so "Added more log outputting to resolve #4352".
    - In the description of the pull request, explain the changes that you made, any issues you think exist with the pull request you made, and any questions you have for the maintainer. It's OK if your pull request is not perfect (no pull request is), the reviewer will be able to help you fix any problems and improve it!
10. Wait for the pull request to be reviewed by a maintainer.
11. Make changes to the pull request if the reviewing maintainer recommends them.
12. Celebrate your success after your pull request is merged!

## Where can I go for help?

If you need help, you can ask questions on the [CoPED discussions page](https://github.com/cogent-computing/COPED/discussions).

## What does the Code of Conduct mean for me?

Our [Code of Conduct](./CODE-OF-CONDUCT.md) means that you are responsible for treating everyone on the project with respect and courtesy regardless of their identity. If you are the victim of any inappropriate behavior or comments as described in our Code of Conduct, we are here for you and will do the best to ensure that the abuser is reprimanded appropriately, per our code.
