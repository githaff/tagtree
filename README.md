# The Tagged One

The Tagged One (hereinafter 'ttone') is a simple tool for keeping
tagged data in a directory tree structure with help of hardlinks.

The main dedication is to keep files in the directory organised
tags-subtags structure. So if you have book 'Mathematical basics of
physics' you can put it both into 'math' and 'physics' folders. Then
ttone will find identical files and replace them with hard links. Only
one actual copy of book will be kept.

The main advantages over other file-tagging frameworks are:

1. you are not bound to certain OS, DE or file manager which will show
you needed tags. All you need to go is hardlink-compatible filesystem;
2. once tag tree is initialised you can operate with tagged files like
with absolutely ordinary files structure: creating directories (which
will be interpreted as tags and subtags), placing and moving files
between different tags, copying to different storages. The only thing
you need is to once in a while update ttone structure;
3. selected viewable tags will stay that way until you will manually
choose to hide them (while in other tagging systems normally you have
to look amongst all possible tags whether they are currently needed or
not).


## Structure

All meta information is stored in '.ttone' directory. It is organised
in following way:

```
.ttone/
+ meta
+ storage
| + <file-0>
| + <file-1>
| + <file-2>
| + <file-3>
| + ...
+ config
```

Here 'meta' file contains info about each file under ttone control (its
tags, description if there is such and else) and each tag (tag class,
description if there is such and other). This file is organised in
form of sqlite database.

Files 'file-n' are just files. It is the base in which all files are
stored. The names are hashsums.


## Commands

**init** - initialize ttone in current directory. All files will be
automaitcly registered and tags for each directory will be created.

**update [PATH]** - update ttone state. Register all changes (newly
added and removed files/tags). Optionally path to update may be
passed. In this case only files and tags placed there will be
rechecked in tag tree.

**reveal TAG|TAG_EXPR** - create directory TAG in current path which
will contain all files that correspond to specified tag expression. It
also will reveal all subtags so

`$ ttone reveal books`

will create directory 'book' with all subtags like 'datasheets',
'languages' etc.

To reveal only certain subtags you can specify full directory/tag path
of subtag:

`$ ttone reveal TAG/SUBTAG`

For instance

```
$ ttone reveal books/datasheets
$ ttone reveal books/languages
```

will show only 'datasheets' and 'languages' in directory 'books'
without other subtags like 'fiction' or 'math'.

Binary expression also can be used in place of tag name. In this case
option --as NAME must also be used to specify desired name for
revealed tag. For example to reveal tag 'literature' which will
contain both 'fiction' and 'fantasy' one can use:

`$ ttone reveal --as literature fiction -a fantasy`

You can see full description of binary operations with tags in section
'Tag expressions'.

Note that this way of revealing created through expressions tags isn't
permanent, it will be terminated after first 'ttone hide' on this
tag. To use permanent expression-originated tags one can use 'alias'
command. It is also possible to use 'create' in case new tag must
contain only current slice of files that satisfy specified tag
expression.

Options:
* --as NAME  Reveal tag with specified pseudonym


**hide TAG** - apposite to 'reveal' command. Deletes tag directory but
not complitely - it can be restored with 'reveal' again any time.

**alias ALIAS_NAME TAG_EXPR** - create an alias for a tag
expression. Created aliased tag will be all the time equivalen to
expression (with periodical 'update' command calls of course). For
example if you have file-1.txt in tag-1 and file-2.txt in tag-2 then
after

`$ ttone alias tag-new tag-1 -a tag-2`

created tag-new will contain both tag-1 and tag-2. In case you will
place new file file-3.txt into tag-1 after update it will appear also
in tag-new. Placed in tag-new file will be labeled as both tag-1 and
tag-2.

**create TAG_NAME [TAG_EXPR]** - create new tag based on specified tag
expression. Unlike 'alias' command 'create' will permanently create
absolutly ordinary tag which will contain all files that satisfy tag
expression. In comparison with 'alias' if you have file-1.txt in tag-1
and file-2.txt in tag-2 then after

`$ ttone create tag-new tag-1 -a tag-2`

you will have also both file-1.txt and file-2.txt in created tag-new
tag. But if you will add file-3.txt to tag-1 it will not appear at
tag-new.

Tag expression can be ommitted. In this case simple empty tag TAG_NAME
will be created. Which is equivalent to simple `mkdir TAG_NAME`
followed by `ttone update`.

**destroy TAG...** - fully destroy specified tag. It will not be
possible to resurrect it with 'reveal' afterwords. Files that was
stored only in deleted tag will be deleted from ttone completly.  More
than one tag can be passed for destruction. Destruction of tag means
also destruction of all subtags if they are not parented by some other
tag (or in top-level).

**config VARIABLE VALUE** - customize ttone by setting up configurable
value.

Options:
* --global - change global tatree options instead of local to
particular ttone instance.

**show [TAG]** - show info about specified tag (subtags, files owned,
date of creation).

Options:
* --all - print all available info
* --files - print all files contained in this tag

**help [COMMAND]** - show this help. If command specified - print help
for it.


## Tag expressions

Tag expressions can be used for applying boolean operations on tags as
sets of files. For each basic operation there is two crutial moments:
whilch files will be shown in created that way tag and to which tags
file will be placed if it will be created at this expression tag.

### Basic operations:

**-a** - AND. Show files which are present both in tag-1 and
tag-2. When added file will be placed both into tag-1 and tag-2.

**-o** - OR. Show files which are present in tag-1 or in tag-2. Added
file will be placed both into tag-1 and tag-2.

**-n** - NOT. Show files which are present anywhere but in
tag-1. Added file will be placed in all other tags except tag-1.

**-w** - WITHOUT. [boolean subtraction. TODO: must be
overchecked]. Same as OR NOT. Will show files that belong to tag-1 but
not belong to tag-2. Added file will be added to tag-1.


## Basic usage

Initialise ttone structure in current path:

`$ ttone init`

Update tone structure according to the current directory content:

`$ ttone update`

Hide tag:

`$ ttone hide TAG`

This will delete directory <tag>. Files of this tag will still be
there but you will see them only in .all directory if it exists. This
tag directory can be re-created again with next command.

Show tag:

`$ ttone reveal TAG`


## Configuration

Ttone configuration is presented in several levels: global
(/etc/ttone.conf), user (~/.config/ttone/config) and ttone instance
(<ttone-dir>/.ttone/config).
