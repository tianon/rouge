	   _________  __  ______ ____ 
	  / ___/ __ \/ / / / __ `/ _ \
	 / /  / /_/ / /_/ / /_/ /  __/
	/_/   \____/\__,_/\__, /\___/ 
	                 /____/       

# about rouge

Tentatively, "rouge" stands for:

* Remote
* Origin
* Universal
* [Git][git]
* [Extricator][extricate]

More simply, it is a remote server backup system, using `git` for incremental control.

[git]: http://git-scm.org "Git Homepage"
[extricate]: http://google.com/search?q=define:extricate "Definition of Extricate"

# required CPAN modules

* `YAML::Any` (for configuration file)

# similar projects

* [rsnapshot][rsnapshot]: A remote filesystem snapshot utility, based on rsync.  Doesn't use Git, but definitely worth a mention.
* [gibak][gibak]: A backup tool based on `git`, using Git's hook system to save and restore the information Git doesn't track itself such as permissions, empty directories and optionally extended attributes and mtime fields.
* [etckeeper][etckeeper]: A collection of tools to let `/etc` be stored in a git, mercurial, darcs, or bzr repository.  It hooks into `apt` (and other package managers including `yum` and `pacman-g2`) to automatically commit changes made to `/etc` during package upgrades.  It tracks file metadata that revison control systems do not normally support, but that is important for `/etc`, such as the permissions of `/etc/shadow`.
* [git-home-history][git-home-history]: A tool based on Git that simplifies keeping track of changes you make in your home directory and provides an easy way to go back to earlier versions and see changes you made.  Also includes a GTK+ interface.
* [bup][bup]: Highly efficient file backup system based on the `git` packfile format.  Capable of doing incremental backups of virtual machine images, and backing up to a remote machine.

[rsnapshot]: http://rsnapshot.org/
[gibak]: http://eigenclass.org/hiki/gibak-backup-system-introduction
[etckeeper]: http://kitenet.net/~joey/code/etckeeper/
[git-home-history]: http://jean-francois.richard.name/ghh/
[bup]: http://github.com/apenwarr/bup
