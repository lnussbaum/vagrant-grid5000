# Vagrant Grid5000 Example Box

Vagrant providers each require a custom provider-specific box format.
This folder shows the example contents of a box for the `grid5000` provider.
To turn this into a box:

```
$ tar cvzf grid5000.box ./metadata.json ./Vagrantfile
```

This box works by using Vagrant's built-in Vagrantfile merging to setup
defaults for Grid5000. These defaults can easily be overwritten by higher-level
Vagrantfiles (such as project root Vagrantfiles).
